//
//  AppDelegate.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/16/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var movie: Movie?=nil
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 13.0, *) {
            // Window will be loaded by the Scene Delegate.
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.setupRootViewController()
            window?.makeKeyAndVisible()
        }
        ImageCache.default.diskStorage.config.sizeLimit = 50 * 1024 * 1024 // 50 MB disk image cache
        ImageCache.default.memoryStorage.config.totalCostLimit = 10 * 1024 * 1024 // 10 MB memory  image cache
        ImageCache.default.memoryStorage.config.countLimit = 10 * 1024 * 1024 // max 50 images
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

