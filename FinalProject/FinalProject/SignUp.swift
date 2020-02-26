//
//  SignUp.swift
//  FinalProject
//
//  Created by Bradley Dodds on 12/5/19.
//  Copyright © 2019 351. All rights reserved.
//

import UIKit
import AWSMobileClient
import Foundation



class SignUp: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signUpB: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpB.layer.cornerRadius = 8
        username.setBottomBorder()
        email.setBottomBorder()
        password.setBottomBorder()
        confirmPassword.setBottomBorder()
        
        confirmPassword.addTarget(self, action: #selector(SignUp.textFieldDidChange(_:)),
        for: UIControl.Event.editingChanged)
    }
       
    
    
    
    
    @IBAction func signupButton(_ sender: Any) {
        
        let un = String(username.text!)
        let e = String(email.text!)
        let pw = String(password.text!)
        let pwconfirm = String(confirmPassword.text!)
        
        print(un)
        print(e)
        
        
        AWSMobileClient.default().signUp(username: un,
                                                password: pw,
                                                userAttributes: ["email": e]) { (signUpResult, error) in
            if let signUpResult = signUpResult {
                switch(signUpResult.signUpConfirmationState) {
                case .confirmed:
                    print("User is signed up and confirmed.")
                case .unconfirmed:
                    print("User is not confirmed and needs verification")
                    
            
                    
                    
                    
                    
                case .unknown:
                    print("Unexpected case")
                }
                
                
                //Alert on successful login
                DispatchQueue.main.async {
                    Alerts().signup(sender: self)
                    self.username.text = nil
                    self.email.text = nil
                    self.password.text = nil
                    self.confirmPassword.text = nil
                }
                
                
                
            } else if let error = error {
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
                    print("error: \(error); message: \(printableMessage)")
                    
                    
                    ///
                }
                print("\(error.localizedDescription)")
                
                //Alert on successful login
                DispatchQueue.main.async {
                    Alerts().signUpError(sender: self)
                   
                }
            }
        }
        
        
        
        
    }
    
    
    
    @IBAction func backToLogin(_ sender: Any) {
        
        print("back to login pressed")
        
       self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        let pwTextField = password.text
        let pwConfirmTextField = confirmPassword.text
        
        print(pwConfirmTextField)
        
        if(pwTextField == pwConfirmTextField) {
            
            password.textColor = UIColor.green
            confirmPassword.textColor = UIColor.green
        }
        
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let pwTextField = password.text!
        let pwConfirmTextField = confirmPassword.text!
        let bullishGreen = UIColor(hexString: "#61D090")
        
        print(pwConfirmTextField)
        
        if(pwTextField == pwConfirmTextField) {
            
            password.textColor = UIColor.green
            confirmPassword.textColor = UIColor.green
        }
    }
    
    
    


}//END VIEWCONTROLLER

