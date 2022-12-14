//
//  AppDelegate.swift
//  Notedy
//
//  Created by Nuntapat Hirunnattee on 29/7/2565 BE.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //delay launchScreen
        Thread.sleep(forTimeInterval: 0.5)
        // Override point for customization after application launch.
        
        //print realm's path file
        //print("Realm's Local : \(Realm.Configuration.defaultConfiguration.fileURL)")
        
        //stop navigation bar background changes when scrolling down
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBarAppearance.backgroundColor = UIColor(named: "PrimaryColor")
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UIBarButtonItem.appearance().tintColor = .white
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

