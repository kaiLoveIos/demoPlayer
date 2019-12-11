//
//  ViewController.swift
//  demo
//
//  Created by iMac on 2019/11/21.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import SnapKit
import AVKit
import AVFoundation
class ViewController: UIViewController {
    lazy var centerButton : UIButton = {
        let centerButton = UIButton.init()
        centerButton.backgroundColor = .red
        centerButton.setTitle("点我就完了", for: .normal)
        centerButton.addTarget(self, action: #selector(tiao), for: .touchUpInside)
        return centerButton
    }()
    func getui() {
        view.addSubview(centerButton)
        centerButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.height.equalTo(80)
            make.width.equalTo(100)
        }
    }
    // 强制旋转横屏
         func forceOrientationLandscape() {
             let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
             appdelegate.isForceLandscape = true
             appdelegate.isForcePortrait = false
             _ = appdelegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: view.window)
             let oriention = UIInterfaceOrientation.landscapeRight // 设置屏幕为横屏
             UIDevice.current.setValue(oriention.rawValue, forKey: "orientation")
             UIViewController.attemptRotationToDeviceOrientation()
         }
@objc    func tiao()  {
       
        let playerView = playerViewController.init()
    playerView.modalPresentationStyle = .overFullScreen
        self.present(playerView, animated: true, completion: nil)
       
    }
    override func viewDidLoad() {
        getui()
        view.backgroundColor = .white
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

