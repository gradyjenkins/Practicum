//
//  Utility.swift
//  AuthenticationApp
//
//  Created by Kyle Blazier on 3/7/17.
//  Copyright © 2017 Kyle Blazier. All rights reserved.
//

import Foundation
import KeychainAccess

let kLoginKey = "LoginKey" // Customizeable - Key to save the authentication token in the Keychain (String)
let kPhoneNumberKey = "PhoneNumberKey"
let kDeviceTokenKey = "DeviceTokenKey"
let keyChainServiceName = "com.GradyJenkins.CurrentLocationTracker" // Customizeable - Name of Keychain we are using (String)
let webserviceURL = "https://obscure-hamlet-88963.herokuapp.com" //"http://0.0.0.0:8080" // Customizeable - URL of the Webservice we are hitting
let useTouchID = false // Customizeable - Whether or not you want to use 2-factor authentication

class Utility {
    
    static let sharedInstance = Utility()
    
    lazy var keychain = Keychain(service: keyChainServiceName)
    
    // MARK: - Simplistic message logging - easily disablable from one location
    func logMessage(message: String?, dictionary: [String:Any]? = nil, sourceName: String = "") {
        print("*** Begin log statement in \(sourceName) ***")
        if let message = message {
            print(message)
        }
        if let dictionary = dictionary {
            print(dictionary)
        }
        print("*** End log statement \(sourceName) ***")
    }
    
    
    // MARK: - Get/Set device token in Keychain
    func checkForDeviceTokenFromKeychain() -> String? {
        do {
            guard let phoneNumber = try keychain.getString(kDeviceTokenKey) else {
                logMessage(message: "Could not retrieve device token from Keychain")
                return nil
            }
            logMessage(message: "Retrieved device token from Keychain")
            return phoneNumber
        } catch {
            logMessage(message: "Could not retrieve device token from Keychain")
            return nil
        }
    }
    
    func setDeviceTokenInKeychain(token: String) {
        do {
            try self.keychain.set(token, key: kDeviceTokenKey)
            logMessage(message: "Device token saved to Keychain")
        } catch {
            logMessage(message: "Could not save device token to Keychain")
        }
    }
    
    
    // MARK: - Try to fetch an auth token from the Keychain
    func checkForAuthTokenFromKeychain() -> String? {
        do {
            guard let authToken = try keychain.getString(kLoginKey) else {
                logMessage(message: "Not authenticated - could not retrieve auth token from Keychain")
                return nil
            }
            logMessage(message: "Authenticated - Retrieved auth token from Keychain")
            return authToken
        } catch {
            logMessage(message: "Not authenticated - could not retrieve auth token from Keychain")
            return nil
        }
    }
    
    
    // MARK: - Get/Set phone number in Keychain
    func checkForPhoneNumberFromKeychain() -> String? {
        do {
            guard let phoneNumber = try keychain.getString(kPhoneNumberKey) else {
                logMessage(message: "Could not retrieve phone number from Keychain")
                return nil
            }
            logMessage(message: "Retrieved phone number from Keychain")
            return phoneNumber
        } catch {
            logMessage(message: "Could not retrieve phone number from Keychain")
            return nil
        }
    }
    
    func setPhoneNumberinKeychain(phoneNum: String) {
        do {
            try self.keychain.set(phoneNum, key: kPhoneNumberKey)
            logMessage(message: "Phone number saved to Keychain")
        } catch {
            logMessage(message: "Could not save phone number to Keychain")
        }
    }
    
    
    
}

extension UIViewController {
    // MARK: - Utility function to present actionable alerts and popups
    func presentAlert(alertTitle : String?, alertMessage : String, cancelButtonTitle : String = "OK", cancelButtonAction : (()->())? = nil, okButtonTitle : String? = nil, okButtonAction : (()->())? = nil, thirdButtonTitle : String? = nil, thirdButtonAction : (()->())? = nil) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        if let okAction = okButtonTitle {
            alert.addAction(UIAlertAction(title: okAction, style: .default, handler: { (action) in
                okButtonAction?()
            }))
            
            if let thirdButton = thirdButtonTitle {
                alert.addAction(UIAlertAction(title: thirdButton, style: .default, handler: { (action) in
                    thirdButtonAction?()
                }))
            }
        }
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.cancel, handler: { (action) in
            cancelButtonAction?()
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

