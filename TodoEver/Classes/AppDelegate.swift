//
//  AppDelegate.swift
//  TodoEver
//
//  Created by taqun on 2015/05/26.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        
        self.configureEvernoteSDK()
        self.configureCoreData()
        
        self.initViewController()
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    private func configureEvernoteSDK() {
        let consumerKey     = TDEConfig.ENSDK_CONSUMER_KEY
        let consumerSecret  = TDEConfig.ENSDK_CONSUMER_SECRET
        
        ENSession.setSharedSessionConsumerKey(consumerKey, consumerSecret: consumerSecret, optionalHost: ENSessionHostSandbox)
    }
    
    private func configureCoreData() {
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("TodoEver.sqlite")
    }
    
    private func initViewController() {
        let navigationController: UINavigationController
        let viewController: UIViewController
        
        if TDEModelManager.sharedInstance.isLoggedIn {
            let storyBoard = UIStoryboard(name: "IndexViewController", bundle: nil)
            viewController = storyBoard.instantiateInitialViewController() as! TDEIndexViewController
            
        } else {
            let storyBoard = UIStoryboard(name: "SigninViewController", bundle: nil)
            viewController = storyBoard.instantiateInitialViewController() as! UIViewController
        }
        
        navigationController = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = navigationController
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        TDEModelManager.sharedInstance.save()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }


}

