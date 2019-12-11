//
//  model.swift
//  demo
//
//  Created by iMac on 2019/12/5.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
class model: NSObject {
         var image: UIImage?             // 视频封面
          var duration: Double?           // 视频时长
          var asset: PHAsset?             // 操作信息的对象
          var videoUrl: URL?              // 视频本地地址
          var avSet: AVAsset?             // 剪辑控制
          var creationDate: Date?         // 视频创建时间
}
