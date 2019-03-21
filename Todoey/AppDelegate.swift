//
//  AppDelegate.swift
//  Todoey
//
//  Created by Nikita Dvoriadkin on 10/02/2019.
//  Copyright © 2019 Nikita Dvoriadkin. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
        } catch {
            print("Error occured initializing realm: \(error)")
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        return true
    }

    

}

