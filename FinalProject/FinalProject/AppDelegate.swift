//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Bradley Dodds on 12/4/19.
//  Copyright © 2019 351. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSCore
import AWSPinpoint
import AWSDynamoDB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pinpoint: AWSPinpoint?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Initialize the Amazon Cognito credentials provider

        
     
        //Verify backend is connected
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        AWSDDLog.sharedInstance.logLevel = .info
        
        // Initialize Pinpoint for analytics
        pinpoint = AWSPinpoint(configuration:
                AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions))
        
        
        
        
        //Check if a current user is logged in
        AWSMobileClient.default().initialize { (userState, error) in
            if let userState = userState {
                switch (userState) {
                case .guest:
                    print("user is in guest mode.")
                case .signedOut:
                    print("user signed out")
                case .signedIn:
                    print("user is signed in.")
                case .signedOutUserPoolsTokenInvalid:
                    print("need to login again.")
                case .signedOutFederatedTokensInvalid:
                    print("user logged in via federation, but currently needs new tokens")
                default:
                    print("unsupported")
                }
            
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        
        // Create AWSMobileClient to connect with AWS
        return AWSMobileClient.default().interceptApplication(
            application,
            didFinishLaunchingWithOptions: launchOptions)

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

