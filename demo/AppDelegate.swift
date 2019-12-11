//
//  AppDelegate.swift
//  demo
//
//  Created by iMac on 2019/11/21.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var isForceLandscape:Bool = false
    var isForcePortrait:Bool = false
    var isForceAllDerictions:Bool = false //支持所有方向
    var allowRotation : Bool?
    
 var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if allowRotation == true {
            return UIInterfaceOrientationMask.landscape
        } else {
            return UIInterfaceOrientationMask.portrait
        }
    }
    func switchNewOrientation(interfaceOrientation:UIInterfaceOrientation)  {
           let resetOrientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
           UIDevice.self.current.setValue(resetOrientationTarget, forKey: "orientation")
           let orientationTarget = NSNumber(integerLiteral: interfaceOrientation.rawValue)
           UIDevice.self.current.setValue(orientationTarget, forKey: "orientation")
       }
}

