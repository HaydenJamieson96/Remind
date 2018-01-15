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
        setupActionsAndCategories()
    }
    
    func setupActionsAndCategories() {
        let timerAction = UNNotificationAction(identifier: NotificationActionID.timer.rawValue, title: "Run timer logic.", options: [.authenticationRequired])
        let dateAction = UNNotificationAction(identifier: NotificationActionID.date.rawValue, title: "Run date logic.", options: [.destructive])
        let locationAction = UNNotificationAction(identifier: NotificationActionID.location.rawValue, title: "Run location logic.", options: [.foreground])
        
        let timerCategory = UNNotificationCategory(identifier: NotificationCategory.timer.rawValue, actions: [timerAction], intentIdentifiers: [])
        let dateCategory = UNNotificationCategory(identifier: NotificationCategory.date.rawValue, actions: [dateAction], intentIdentifiers: [])
        let locationCategory = UNNotificationCategory(identifier: NotificationCategory.location.rawValue, actions: [locationAction], intentIdentifiers: [])
        
        unCenter.setNotificationCategories([timerCategory, dateCategory, locationCategory])
    }
    
    func getAttachment(forId id: NotificationAttachmentID) -> UNNotificationAttachment? {
        var imageName: String
        
        switch id {
            case .timer:
                imageName = "TimeAlert"
            case .date:
                imageName = "DateAlert"
            case .location:
                imageName = "LocationAlert"
        }
        
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else { return nil }
        
        do {
            let attachment = try UNNotificationAttachment(identifier: id.rawValue, url: url)
            return attachment
        } catch {
            return nil
        }
    }
    
    func timerRequest(withInterval interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "Your timer is all done"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.timer.rawValue
        
        if let attachment = getAttachment(forId: .timer) {
            content.attachments = [attachment]
        }
        
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
        content.categoryIdentifier = NotificationCategory.date.rawValue
        
        if let attachment = getAttachment(forId: .date) {
            content.attachments = [attachment]
        }
        
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
        content.categoryIdentifier = NotificationCategory.location.rawValue
        
        if let attachment = getAttachment(forId: .location) {
            content.attachments = [attachment]
        }
        
        let request = UNNotificationRequest(identifier: "userNotification.location", content: content, trigger: nil)
        unCenter.add(request, withCompletionHandler: nil)
    }
    
}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        
        if let action = NotificationActionID(rawValue: response.actionIdentifier) {
            NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleAction"), object: action)
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //when app in foreground
        print("UN WILL present")
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}

