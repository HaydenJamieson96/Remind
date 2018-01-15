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
    
    func timerRequest(withInterval interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "Your timer is all done"
        content.sound = .default()
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "userNotification.timer", content: content, trigger: trigger)
        unCenter.add(request, withCompletionHandler: nil)
    }
    
    func dateRequest(withComponents components: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Date Trigger"
        content.body = "It is now the future"
        content.sound = .default()
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "userNotification.date", content: content, trigger: trigger)
        unCenter.add(request, withCompletionHandler: nil)
    }
    
    func locationRequest() {
        let content = UNMutableNotificationContent()
        content.title = "You have returned"
        content.body = "Welcome back."
        content.sound = .default()
        content.badge = 1
        
        let request = UNNotificationRequest(identifier: "userNotification.location", content: content, trigger: nil)
        unCenter.add(request, withCompletionHandler: nil)
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

