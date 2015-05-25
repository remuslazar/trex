//
//  AppDelegate.swift
//  Trex
//
//  Created by Remus Lazar on 25.05.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit

struct GPXURL {
    static let Notification = "GPXURL openURL Notification"
    static let Key = "GPXURL URL Key"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?    
    
    // accept GPX files via AirDrop and broadcast a notification
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let center = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: GPXURL.Notification, object: self, userInfo: [GPXURL.Key:url])
        center.postNotification(notification)
        return true
    }

}

