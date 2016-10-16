//
//  AppDelegate.swift
//  GUTS2016
//
//  Created by Tim Hull on 14/10/2016.
//  Copyright © 2016 Tim Hull. All rights reserved.
//

import UIKit
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UserSetupViewController()
        window?.makeKeyAndVisible()
        
        // Set up the SocketIO things
        socket.on("connect", callback: { (data, ack) in
            print("We managed to connect to the sockets!")
        })
        
        socket.on("hit", callback: {(data, ack) in
            print("We hit someone!")
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        })
//        socket.on("update-player-state", callback: {(data, ack) in
//            do {
//                let stuff = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
//                let dataArray: [String: Any] = try JSONSerialization.jsonObject(with: stuff, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
//                player.health = dataArray["health"] as! Int
//                player.exp = dataArray["exp"] as! Int
//                
//                
//            } catch let error {
//                print(error)
//            }
//        })
        
        socket.on("update", callback: {(data, ack) in
            do {
                print(data)
                let stuff = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
                let dataArray: [[String: Any]] = try JSONSerialization.jsonObject(with: stuff, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                
                var currentPlayerData: [String: Any] = [:]
                if let data = dataArray[0][myId] as? [String: Any] {
                    currentPlayerData = data
                    print("******************")
                    print(currentPlayerData)
                    print("******************")
                    player.health = currentPlayerData["health"] as! Int
                    player.exp = currentPlayerData["experience"] as! Int
                    player.hasEmp = currentPlayerData["hasEmp"] as! Bool
                    player.isEmpd = currentPlayerData["empd"] as! Bool
                    print("Does the player have an emp?", player.hasEmp)
                    print("Is there an EMP running?", player.isEmpd)
                }
                
                if player.health <= 0 {
                     player.timeOut()
                }
                
                otherPlayerLocations = dataArray[0]
                
            } catch let error {
                print(error)
            }
        })

        
        socket.on("logged-in", callback: {(data, ack) in
            myId = data[0] as! String
        })
        
        
    
        
        socket.connect()
        
        return true
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

