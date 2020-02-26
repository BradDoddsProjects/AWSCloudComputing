//
//  Alerts.swift
//  FinalProject
//
//  Created by Bradley Dodds on 12/5/19.
//  Copyright © 2019 351. All rights reserved.
//

import Foundation
import UIKit


class Alerts: UIViewController {
    
    func signup(sender: UIViewController) {
        
        let alert = UIAlertController(title: "Success", message: "Your account has been created", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        sender.present(alert, animated: true)
    }
    
    func loginError(sender: UIViewController) {
        
        let alert = UIAlertController(title: "Error", message: "The email or password you entered is invalid", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        sender.present(alert, animated: true)
    }
    
    func signUpError(sender: UIViewController) {
        
        let alert = UIAlertController(title: "Error", message: "Please provide a valid password and username", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        sender.present(alert, animated: true)
    }
    
   
    
    
    
}//END ALERTS

//MARK: Underline textField
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

/*          HexColor String         */
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
