//
//  ServiceManager.swift
//  AuthenticationApp
//
//  Created by Kyle Blazier on 2/1/17.
//  Copyright © 2017 Kyle Blazier. All rights reserved.
//

import Foundation
import KeychainAccess

class ServiceManager {
    
    static let sharedInstance = ServiceManager()
    
    let keychain = Keychain(service: keyChainServiceName)
    
    
    // MARK: - Generic function used to make service calls and return errors or JSON dictionaries
    func makeServiceCall(forURL url: String, method: String, addAuthToken: Bool, cachePolicy: URLRequest.CachePolicy, headers: [String:String]?, body: [String:Any]?, success: ((_ jsonDict: [String:Any]?) throws -> Void)?, failureBlock: ((_ error: String?)->Void)?) {
        
        // Form URLRequest
        guard let url = URL(string: url) else {
            // Couldn't convert to URL - return failure block
            failureBlock?(nil)
            return
        }
        
        // Form a URL Request
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.cachePolicy = cachePolicy
        
        // Add body if we have it
        if let body = body {
            let dictData = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = dictData
        }
        
        // Add content-type header value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add Authentication Token to request if required and can fetch it from Keychain
        if addAuthToken, let authToken = Utility.sharedInstance.checkForAuthTokenFromKeychain() {
            request.addValue(authToken, forHTTPHeaderField: "Authorization")
        }
        
        // Add other headers if any were passed
        if let headers = headers {
            for headerVal in headers {
                request.addValue(headerVal.value, forHTTPHeaderField: headerVal.key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                // Encountered an error
                failureBlock?(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                // No decodable response
                failureBlock?(nil)
                return
            }
            
            // Check HTTP Status Code
            guard httpResponse.statusCode == 200 else {
                
                do {
                    
                    // Try to convert the erroneous response to a dictionary
                    guard let errorDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                        failureBlock?(nil)
                        return
                    }
                    
                    // Parsed erroneous response into a dictionary - check for specific error messages
                    guard let error = errorDict["error"] as? Bool, error == true, let errorMessage = errorDict["message"] as? String else {
                        failureBlock?(nil)
                        return
                    }
                    
                    // Got an error message - return it
                    failureBlock?(errorMessage)
                    
                } catch {
                    // Unable to parse the erroneous response into a dictionary
                    failureBlock?(nil)
                }
                return
            }
            
            // Status code OK - try to parse response data into dictionary
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    // Could not parse into dictionary
                    failureBlock?(nil)
                    return
                }
                
                // Check for errors - this should not happen but one last check before returning the success dictionary
                if let error = json["error"] as? String {
                    failureBlock?(error)
                    return
                }

                // No errors and converted the response to a dictionary - return it in the success completion block
                try success?(json)
                
            } catch {
                // Unable to parse the response data into a dictionary
                failureBlock?(nil)
                return
            }
            
        }
        
        task.resume()
        
    }
    

    // MARK: - Registering a User
//    func register(registrationDict: [String:Any], successBlock: @escaping (_ currentUser: User?)->Void, failure: @escaping (_ error: String?)->Void) {
//        
//        makeServiceCall(forURL: "\(webserviceURL)/api/v1/register", method: "POST", addAuthToken: false, cachePolicy: .reloadIgnoringCacheData, headers: nil, body: registrationDict, success: { (json) in
//            
//            guard let json = json, let success = json["success"] as? Bool, success == true else {
//                failure(nil)
//                return
//            }
//            
//            // Format & store authentication token in keychain
//            guard let user = json["user"] as? [String:Any] else {
//                failure(nil)
//                return
//            }
//            
//            // Convert to User model
//            let authenticatedUser = try User(dictionary: user as [String:AnyObject])
//            
//            // Check if we have a timestamp for when the session began
//            if let sessionBegan = json["sessionStart"] as? String {
//                authenticatedUser.sessionBegan = sessionBegan
//            }
//            
//            guard let apiKey = user["api_key"] as? String, let apiSecret = user["api_secret"] as? String else {
//                failure(nil)
//                return
//            }
//            
//            let authString = "\(apiKey):\(apiSecret)"
//            
//            guard let authData = authString.data(using: .utf8) else {
//                failure(nil)
//                return
//            }
//            
//            let encodedAuthString = "Basic \(authData.base64EncodedString())"
//            
//            authenticatedUser.authToken = encodedAuthString
//            
//            if useTouchID {
//                // Try to store the value as a protected value with Touch ID / device password authentication required to access it
//                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
//                    do {
//                        try self.keychain
//                            .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
//                            .authenticationPrompt("Authenticate to allow the app to use Touch ID to log you in.")
//                            .set(encodedAuthString, key: kLoginKey)
//                        Utility.sharedInstance.logMessage(message: "Auth token saved to keychain for use with Touch ID / password")
//                    } catch {
//                        Utility.sharedInstance.logMessage(message: "Could not setup the app to use Touch ID with this keychain value - fallback to standard authentication")
//                        // Just store the value regularly in th keychain
//                        do {
//                            try self.keychain.set(encodedAuthString, key: kLoginKey)
//                            Utility.sharedInstance.logMessage(message: "Auth token saved to keychain")
//                        } catch let error {
//                            Utility.sharedInstance.logMessage(message: "Couldn't save to Keychain: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            } else {
//                // Just store the value regularly in th keychain
//                do {
//                    try self.keychain.set(encodedAuthString, key: kLoginKey)
//                    Utility.sharedInstance.logMessage(message: "Auth token saved to keychain")
//                } catch let error {
//                    Utility.sharedInstance.logMessage(message: "Couldn't save to Keychain: \(error.localizedDescription)")
//                }
//            }
//            
//            // Success - return User in completion block
//            successBlock(authenticatedUser)
//            
//        }) { (errorMessage) in
//            failure(errorMessage)
//        }
//        
//    }
//    
//    
//    // MARK: - Login a user
//    func login(registrationDict: [String:Any], successBlock: @escaping (_ currentUser: User?)->Void, failure: @escaping (_ error: String?)->Void) {
//        
//        makeServiceCall(forURL: "\(webserviceURL)/api/v1/login", method: "POST", addAuthToken: false, cachePolicy: .reloadIgnoringCacheData, headers: nil, body: registrationDict, success: { (json) in
//            
//            guard let json = json, let success = json["success"] as? Bool, success == true else {
//                failure(nil)
//                return
//            }
//            
//            // Format & store authentication token in keychain
//            guard let user = json["user"] as? [String:Any] else {
//                failure(nil)
//                return
//            }
//            
//            guard let apiKey = user["api_key"] as? String, let apiSecret = user["api_secret"] as? String else {
//                failure(nil)
//                return
//            }
//            
//            let authString = "\(apiKey):\(apiSecret)"
//            
//            guard let authData = authString.data(using: .utf8) else {
//                failure(nil)
//                return
//            }
//            
//            let encodedAuthString = "Basic \(authData.base64EncodedString())"
//            
//            if useTouchID {
//                // Try to store the value as a protected value with Touch ID / device password authentication required to access it
//                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
//                    do {
//                        try self.keychain
//                            .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
//                            .authenticationPrompt("Authenticate to allow the app to use Touch ID to log you in.")
//                            .set(encodedAuthString, key: kLoginKey)
//                        Utility.sharedInstance.logMessage(message: "Auth token saved to keychain for use with Touch ID / password")
//                    } catch {
//                        Utility.sharedInstance.logMessage(message: "Could not setup the app to use Touch ID with this keychain value - fallback to standard authentication")
//                        // Just store the value regularly in th keychain
//                        do {
//                            try self.keychain.set(encodedAuthString, key: kLoginKey)
//                            Utility.sharedInstance.logMessage(message: "Auth token saved to keychain")
//                        } catch let error {
//                            Utility.sharedInstance.logMessage(message: "Couldn't save to Keychain: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            } else {
//                // Just store the value regularly in th keychain
//                do {
//                    try self.keychain.set(encodedAuthString, key: kLoginKey)
//                    Utility.sharedInstance.logMessage(message: "Auth token saved to keychain")
//                } catch let error {
//                    Utility.sharedInstance.logMessage(message: "Couldn't save to Keychain: \(error.localizedDescription)")
//                }
//            }
//            
//            Utility.sharedInstance.logMessage(message: "Successfully logged in the user", dictionary: user)
//            
//            // Convert to User model
//            let authenticatedUser = try User(dictionary: user as [String:AnyObject])
//            authenticatedUser.authToken = encodedAuthString
//            
//            // Check if we have a timestamp for when the session began
//            if let sessionBegan = json["sessionStart"] as? String {
//                authenticatedUser.sessionBegan = sessionBegan
//            }
//            
//            // Success - return user in completion block
//            successBlock(authenticatedUser)
//            
//        }) { (errorMessage) in
//            failure(errorMessage)
//        }
//        
//    }
//    
//    
//    // MARK: - Get user details
//    func getUserDetails(successBlock: @escaping (_ currentDetails: User?)->Void, failure: @escaping (_ error: String?)->Void) {
//        
//        makeServiceCall(forURL: "\(webserviceURL)/api/v1/me", method: "POST", addAuthToken: true, cachePolicy: .reloadIgnoringCacheData, headers: nil, body: nil, success: { (json) in
//            
//            guard let responseDict = json, let success = responseDict["success"] as? Bool, success == true, let userDetails = responseDict["user"] as? [String:Any] else {
//                failure(nil)
//                return
//            }
//            
//            Utility.sharedInstance.logMessage(message: "Successfully retrieved the user details", dictionary: userDetails)
//            
//            // Convert to User model
//            let authenticatedUser = try User(dictionary: userDetails as [String:AnyObject])
//            authenticatedUser.authToken = Utility.sharedInstance.checkForAuthTokenFromKeychain()
//            
//            // Check if we have a timestamp for when the session began
//            if let sessionBegan = responseDict["sessionStart"] as? String {
//                authenticatedUser.sessionBegan = sessionBegan
//            }
//            
//            // User is authenticated - return user in completion block
//            successBlock(authenticatedUser)
//
//            
//        }) { (errorMessage) in
//            failure(errorMessage)
//        }
//        
//    }
//    
//    
//    // MARK: - Update user details
//    func updateUserDetails(valuesToUpdate: [String:Any], successBlock: @escaping (_ currentUser: User?)->Void, failure: @escaping (_ error: String?)->Void) {
//        
//        makeServiceCall(forURL: "\(webserviceURL)/api/v1/update", method: "POST", addAuthToken: true, cachePolicy: .reloadIgnoringCacheData, headers: nil, body: valuesToUpdate, success: { (json) in
//        
//            guard let json = json, let success = json["success"] as? Bool, success == true else {
//                failure(nil)
//                return
//            }
//            
//            // Format & store authentication token in keychain
//            guard let userDetails = json["user"] as? [String:Any] else {
//                failure(nil)
//                return
//            }
//            
//            Utility.sharedInstance.logMessage(message: "Successfully updated user details", dictionary: userDetails)
//            
//            // Convert to User model
//            let currentUser = try User(dictionary: userDetails as [String:AnyObject])
//            currentUser.authToken = Utility.sharedInstance.checkForAuthTokenFromKeychain()
//            
//            // Check if we have a timestamp for when the session began
//            if let sessionBegan = json["sessionStart"] as? String {
//                currentUser.sessionBegan = sessionBegan
//            }
//            
//            // Success - return user in completion block
//            successBlock(currentUser)
//
//            
//        }) { (errorMessage) in
//            failure(errorMessage)
//        }
//        
//    }
//    
//    
//    // MARK: - Logout
//    func logout() {
//        makeServiceCall(forURL: "\(webserviceURL)/api/v1/logout", method: "POST", addAuthToken: true, cachePolicy: .reloadIgnoringCacheData, headers: nil, body: nil, success: nil, failureBlock: nil)
//    }
    
    
    // MARK: - Register a device for push notifications
    func registerDeviceForNotifications(deviceDict: [String:Any], successBlock: (()->Void)? = nil, failure: ((_ error: String?)->Void)? = nil) {
        
        makeServiceCall(forURL: "\(webserviceURL)/api/v1/registerDevice", method: "POST", addAuthToken: false, cachePolicy: .reloadIgnoringCacheData, headers: nil, body: deviceDict, success: { (json) in
            
            // Check for success
            guard let json = json, let success = json["success"] as? Bool, success == true else {
                Utility.sharedInstance.logMessage(message: "Register device failure - status code 200 though", sourceName: "Service Manager")
                failure?(nil)
                return
            }
            
            Utility.sharedInstance.logMessage(message: "Register device for push notifications success", dictionary: json, sourceName: "Service Manager")
            
            // Call completion block
            successBlock?()
            
        }) { (errorMessage) in
            failure?(errorMessage)
        }
        
    }
    
    
    // MARK: - Get the tags this user is subscribed to
    func getDeviceRegistrationTags(deviceDict: [String:Any], successBlock: ((_ tags: [String:String])->Void)? = nil, failure: ((_ error: String?)->Void)? = nil) {
        
        makeServiceCall(forURL: "\(webserviceURL)/api/v1/getTags", method: "POST", addAuthToken: true, cachePolicy: .reloadIgnoringCacheData, headers: nil, body: deviceDict, success: { (json) in
            
            // Check for success
            guard let json = json, let success = json["success"] as? Bool, success == true else {
                Utility.sharedInstance.logMessage(message: "Get device tags failure - status code 200 though", sourceName: "Service Manager")
                failure?(nil)
                return
            }
            
            // Check for the tags
            guard let tags = json["tags"] as? [String:String] else {
                Utility.sharedInstance.logMessage(message: "Get device tags failure - Couldn't get tags - status code 200 though", sourceName: "Service Manager")
                failure?(nil)
                return
            }
            
            Utility.sharedInstance.logMessage(message: "Get device tags success", dictionary: json, sourceName: "Service Manager")
            
            // Call completion block
            successBlock?(tags)
            
        }) { (errorMessage) in
            failure?(errorMessage)
        }
        
    }
    
    
    // MARK: - Sending push notifications to a group of tags
    /*
     // Sample Payload
     {
     "tag_value": ["9738309376"],
     "message": "Using the secrets folder! Yay no hardcoding",
     "tag_key": "PhoneNumber"
     }
     */
    func sendNotificationsToTags(payload: [String:Any], successBlock: @escaping (_ successMessage: String?)->Void, failure: @escaping (_ error: String?)->Void) {
        
        Utility.sharedInstance.logMessage(message: "Send notification payload:", dictionary: payload, sourceName: "Service Manager")
        
        makeServiceCall(forURL: "\(webserviceURL)/api/v1/sendNotificationToTag", method: "POST", addAuthToken: true, cachePolicy: .reloadIgnoringCacheData, headers: nil, body: payload, success: { (json) in
            
            // Check for success
            guard let json = json, let recipients = json["recipients"] as? Int, recipients > 0 else {
                failure(nil)
                Utility.sharedInstance.logMessage(message: "Send notifications to tags failure - no recipients", sourceName: "Service Manager")
                return
            }
            
            // Success completion block
            successBlock(nil)
            
            Utility.sharedInstance.logMessage(message: "Successfully sent push notifications to tags", dictionary: json, sourceName: "Service Manager")
            
        }) { (errorMessage) in
            failure(errorMessage)
        }
        
    }
    
    
    // MARK: - Check if user is valid
    func checkIfValidUser(phoneNumberArray:[String], completion: @escaping (_ validUsers:[String]?)->Void) {
        
        makeServiceCall(forURL: "\(webserviceURL)/api/v1/isValidUser", method: "POST", addAuthToken: true, cachePolicy: .reloadIgnoringCacheData, headers: nil, body: ["phoneNumbers":phoneNumberArray], success: { (json) in
        
            // Check for success
            guard let json = json, let validUsers = json["validUsers"] as? [String] else {
                completion(nil)
                return
            }
            
            // Success completion block
            completion(validUsers)
            
        }) { (errorMessage) in
            completion(nil)
            Utility.sharedInstance.logMessage(message: "Check if valid user - failed with error: \(errorMessage)")
        }
        
    }
}
