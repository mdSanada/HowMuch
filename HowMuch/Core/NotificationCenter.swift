//
//  NotificationCenter.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 29/10/22.
//

import Foundation

public class SNNotificationCenter: NSObject {
    static public let shared = NotificationCenter.init()
    
    static public let ingredients = SNNotificationModel(notification: "Firestore.fetch.ingredients")
    static public let budget = SNNotificationModel(notification: "Firestore.fetch.budget")
    static public let material = SNNotificationModel(notification: "Firestore.fetch.material")
    static public let consumption = SNNotificationModel(notification: "Firestore.fetch.consumption")
    static public let taxes = SNNotificationModel(notification: "Firestore.fetch.taxes")
    static public let profile = SNNotificationModel(notification: "Firestore.fetch.profile")
    static public let sales = SNNotificationModel(notification: "Firestore.fetch.sales")

    static public let materials = SNNotificationModel(notification: "Firestore.fetch.materials")
    
    public static func post(notification: Notification, arguments: [String: Any]) {
        SNNotificationCenter.shared.post(name: notification.name,
                                         object: nil,
                                         userInfo: arguments)
    }
}

public struct SNNotificationModel {
    public let name: Notification.Name
    public let notification: Notification
    
    init(notification: String) {
        self.name = Notification.Name(notification)
        self.notification = Notification(name: name)
    }
}
