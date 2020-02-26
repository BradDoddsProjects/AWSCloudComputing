//
//  ViewController.swift
//  FinalProject
//
//  Created by Bradley Dodds on 12/4/19.
//  Copyright © 2019 351. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAuthCore
import Foundation


class ViewController: UIViewController {
    
    @IBOutlet weak var loginB: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI button and textfield modifications
        loginB.layer.cornerRadius = 8
        email.setBottomBorder()
        password.setBottomBorder()
        
        checkUserState()
        
    }
       
    
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        let username = String(email.text!)
        let pw = String(password.text!)
        
        
        print("Login button pressed")
        
        AWSMobileClient.default().signIn(username: username, password: pw) { (signInResult, error) in
            if let error = error  {
                
                ////
                
                if let error = error as? AWSMobileClientError {
                    
                    
                    ////
                    let printableMessage: String
                    switch error {
                    case .aliasExists(let message): printableMessage = message
                    case .codeDeliveryFailure(let message): printableMessage = message
                    case .codeMismatch(let message): printableMessage = message
                    case .expiredCode(let message): printableMessage = message
                    case .groupExists(let message): printableMessage = message
                    case .internalError(let message): printableMessage = message
                    case .invalidLambdaResponse(let message): printableMessage = message
                    case .invalidOAuthFlow(let message): printableMessage = message
                    case .invalidParameter(let message): printableMessage = message
                    case .invalidPassword(let message): printableMessage = message
                    case .invalidUserPoolConfiguration(let message): printableMessage = message
                    case .limitExceeded(let message): printableMessage = message
                    case .mfaMethodNotFound(let message): printableMessage = message
                    case .notAuthorized(let message): printableMessage = message
                    case .passwordResetRequired(let message): printableMessage = message
                    case .resourceNotFound(let message): printableMessage = message
                    case .scopeDoesNotExist(let message): printableMessage = message
                    case .softwareTokenMFANotFound(let message): printableMessage = message
                    case .tooManyFailedAttempts(let message): printableMessage = message
                    case .tooManyRequests(let message): printableMessage = message
                    case .unexpectedLambda(let message): printableMessage = message
                    case .userLambdaValidation(let message): printableMessage = message
                    case .userNotConfirmed(let message): printableMessage = message
                    case .userNotFound(let message): printableMessage = message
                    case .usernameExists(let message): printableMessage = message
                    case .unknown(let message): printableMessage = message
                    case .notSignedIn(let message): printableMessage = message
                    case .identityIdUnavailable(let message): printableMessage = message
                    case .guestAccessNotAllowed(let message): printableMessage = message
                    case .federationProviderExists(let message): printableMessage = message
                    case .cognitoIdentityPoolNotConfigured(let message): printableMessage = message
                    case .unableToSignIn(let message): printableMessage = message
                    case .invalidState(let message): printableMessage = message
                    case .userPoolNotConfigured(let message): printableMessage = message
                    case .userCancelledSignIn(let message): printableMessage = message
                    case .badRequest(let message): printableMessage = message
                    case .expiredRefreshToken(let message): printableMessage = message
                    case .errorLoadingPage(let message): printableMessage = message
                    case .securityFailed(let message): printableMessage = message
                    case .idTokenNotIssued(let message): printableMessage = message
                    case .idTokenAndAcceessTokenNotIssued(let message): printableMessage = message
                    case .invalidConfiguration(let message): printableMessage = message
                    case .deviceNotRemembered(let message): printableMessage = message
                    }
                    //print("error: \(error); message: \(printableMessage)")
                    
                    
                    ///
                }
                
                
                //Alert on successful login
                DispatchQueue.main.async {
                    Alerts().loginError(sender: self)
                   
                }
                
                ////
                
                
                
                
            } else if let signInResult = signInResult {
                
                switch (signInResult.signInState) {
                case .signedIn:
                    print("User is signed in.")
                    let uid = AWSMobileClient.default().identityId
                    print(uid as Any)
                    print("*************************")
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "segueUserPortal", sender: nil)
                    }
                case .smsMFA:
                    print("SMS message sent to \(signInResult.codeDetails!.destination!)")
                default:
                    print("Sign In needs info which is not et supported.")
                }
                
                
                
                
                //SEGUE HERE to new view controller
                //START HERE MAKE NEW VIEWCONTROLLER
                //DECIDE WHAT THAT VIEW CONTROLLER WILL DO
                
            }
        }
        
        
    }
    
    
    
    @IBAction func signOut(_ sender: Any) {
        AWSMobileClient.default().signOut()
        AWSIdentityManager.default().credentialsProvider.clearCredentials()
        
    }
    
    
    func checkUserState() {
        
        
    AWSMobileClient.default().addUserStateListener(self) { (userState, info) in
        switch (userState) {
        case .signedOut:
            print("User signed out")
            
        case .signedIn:
            print("Active Listener: User is signed in.")
      
        case .signedOutUserPoolsTokenInvalid:
            print("need to login again.")
       
        default:
            print("unsupported")
        }
    }
    
        
    }
    
    
    


}//END VIEWCONTROLLER

