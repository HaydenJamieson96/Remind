//
//  UNService.swift
//  Remind
//
//  Created by Hayden Jamieson on 15/01/2018.
//  Copyright © 2018 Hayden Jamieson. All rights reserved.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    
    private override init() {}
    static let shared = UNService()
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound, .carPlay]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "NO UN auth error")
            guard granted else {
                print("USER DENIED ACCESS")
                return
            }
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
    }
}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //when app in foreground
        print("UN WILL present")
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}

