//
//  playerViewController.swift
//  demo
//
//  Created by iMac on 2019/12/7.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
class playerViewController: UIViewController {
    var dataArr : Array<String> = ["2.0X","1.5X","1.25X","1.0X","0.75X"]
    var indexNum:Int = 3
    var ldNum : Double = 0.0
    var isSuo : Bool = false
    var videoUrl : URL?
    var item : AVPlayerItem?
    var player: AVPlayer?
    var playerlayer : AVPlayerLayer?
    var playerTimeObserver: Any?
    var stringDur : String?
    var slidering = false
    var videoTimer : Timer?
    var headerAndBottomNum : Int = 0
    var sumTime : CMTime?
    var vomalSlider : UISlider?
    
    
    lazy var playView : UIView = {
        let  playView = UIView.init()
        playView.backgroundColor = . black
        return playView
    }()
    lazy var currTImeLabel : UILabel = {
        let currTimeLabel = UILabel.init()
        currTimeLabel.textColor = .white
        currTimeLabel.font = UIFont.systemFont(ofSize: 12)
        return  currTimeLabel
    }()
    lazy var playerSlider : UISlider = {
        let  playerSlider = UISlider.init()
        playerSlider.minimumValue = 0
        playerSlider.maximumValue = 1
        playerSlider.isUserInteractionEnabled = true
        playerSlider.translatesAutoresizingMaskIntoConstraints = false
        playerSlider.maximumTrackTintColor = UIColor(red: 0.13, green: 0.13, blue: 0.2, alpha: 1)
        playerSlider.minimumTrackTintColor = UIColor(red: 0.87, green: 0.27, blue: 0.08, alpha: 1)
        playerSlider.setThumbImage(#imageLiteral(resourceName: "icon_slide"), for: .normal)
        //        playerSlider
        //            .addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        playerSlider.addTarget(self, action: #selector(sliderHua(_:)), for: .touchUpInside)
        playerSlider.addTarget(self, action: #selector(sliderValueChange(_:)), for: .valueChanged)
        return playerSlider
    }()
    lazy var playProgressView : UIProgressView = {
        let  playProgressView = UIProgressView.init(frame: CGRect(x: 0, y: 0, width: self.playView.frame.width-142, height: 2))
        playProgressView.backgroundColor = .lightGray
        self.playView.insertSubview(playProgressView, belowSubview: self.playerSlider)
        playProgressView.tintColor = .red
        playProgressView.progress = 0
        return playProgressView
    }()
    lazy var playButton : UIButton = {
        let  playButton = UIButton.init()
        playButton.setImage(#imageLiteral(resourceName: "zanting"), for: .normal)
        playButton.addTarget(self, action: #selector(installVideo), for: .touchUpInside)
        return  playButton
    }()
    lazy var disButton : UIButton = {
        let  disButton = UIButton.init()
        disButton.setBackgroundImage(UIImage(named: "返回"), for: .normal)
        disButton.addTarget(self, action: #selector(dis), for: .touchUpInside)
        return disButton
    }()
    lazy var leftLabel : UILabel = {
        let leftLabel = UILabel()
        leftLabel.textColor = .white
        leftLabel.font = UIFont(name: "Helvetica Neue", size: 12*rWidth)
        return leftLabel
    }()
    lazy var rightLabel : UILabel = {
        let rightLabel = UILabel()
        rightLabel.font = UIFont.systemFont(ofSize: 12)
        rightLabel.textColor = .white
        rightLabel.text = self.stringDur
        return  rightLabel
    }()
    lazy var bottomView : UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .black
        bottomView.alpha = 1
        return  bottomView
    }()
    lazy var headerView : UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .black
        headerView.alpha = 1
        return headerView
    }()
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "测试视频.mp4"
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 15)
        titleLabel.textColor = .white
        return titleLabel
    }()
    lazy var ceView : UIView = {
        let  ceView = UIView()
//        ceView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.75)
        ceView.backgroundColor = .black
        ceView.alpha = 0.75
        ceView.isHidden = true
        return ceView
    }()
    lazy var bsTableView : UITableView = {
        let bsTaleView = UITableView()
        bsTaleView.rowHeight = 50
        bsTaleView.delegate = self
        bsTaleView.dataSource = self
        bsTaleView.tableFooterView = UIView()
        bsTaleView.separatorStyle = .none
        bsTaleView.backgroundColor = .clear
        bsTaleView.alpha = 1
        return bsTaleView
    }()
    lazy var leftView : UIView = {
        let  leftView = UIView()
        leftView.backgroundColor = .red
        return leftView
    }()
    lazy var rightView : UIView = {
        let rightView = UIView()
        rightView.backgroundColor = .clear
        return rightView
    }()
    lazy var sdButton : UIButton = {
        let sdButton = UIButton()
        sdButton.setTitle("倍速", for: .normal)
        sdButton.setTitleColor(.black, for: .highlighted)
        sdButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        sdButton.tintColor = .white
        sdButton.addTarget(self, action: #selector(clickbsButton), for: .touchUpInside)
        return  sdButton
    }()
    lazy var volumeView : MPVolumeView = {
            let  volumeView = MPVolumeView.init(frame: CGRect(x: 100, y: 100, width: 80, height: 50) )
            volumeView.isHidden = true
           // MPVolumeSettingsAlertHide()
            return volumeView
        }()
    lazy var suoButton : UIButton = {
        let  suoButton = UIButton()
        suoButton.setBackgroundImage(#imageLiteral(resourceName: "屏幕锁定"), for: .normal)
        suoButton.tintColor = .white
        suoButton.addTarget(self, action: #selector(clickSuoButton), for: .touchUpInside)
        suoButton.alpha = 1
        return suoButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPlayer()
        self.getUI()
        openTimer()
        addTapGest()
        getSystemVolumSlider()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.allowRotation = true
        appdelegate.switchNewOrientation(interfaceOrientation: UIInterfaceOrientation.landscapeRight)
//        forceOrientationLandscape()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
          let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
             appdelegate.allowRotation = false
             appdelegate.switchNewOrientation(interfaceOrientation: UIInterfaceOrientation.portrait)
    }
    @objc  func dis() {
        self.dismiss(animated: true, completion: nil)
        removeObserver()
    }
}
//MARK:- 系统音量调节
extension playerViewController {
    //获取系统音量滑块
    private func getSystemVolumSlider()  {
        let volumeView = MPVolumeView()
        vomalSlider = nil
        for view in volumeView.subviews {
            if NSStringFromClass(view.classForCoder) == "MPVolumeSlider" {
                vomalSlider = view as? UISlider
                break
            }
        }
    }
    func changeVolmSliderValue(value : CGFloat)  {
         vomalSlider?.value -= Float(value/10000)
    }
    func changeLiangValue(value : CGFloat)  {
        UIScreen.main.brightness -= value/10000
    }
}
//MARK:-playView手势
extension playerViewController {
    func addTapGest(){
        //点击手势
        let clickeView = UITapGestureRecognizer(target: self, action: #selector(clickPlayView))
        playView.addGestureRecognizer(clickeView)
        //右滑
        let  playViewRigth = UIPanGestureRecognizer()
        playViewRigth.addTarget(self, action: #selector(handlePan(swipe:)))
        playView.addGestureRecognizer(playViewRigth)
    }
    
    @objc func handlePan(swipe : UIPanGestureRecognizer) {
        //获取手指在屏幕中的位置
        let locationPoint = swipe.location(in: playView)
        //根据上次和本次的位置计算
        let celoctyPoint = swipe.velocity(in: playView)
        
        swipe.setTranslation(.zero, in: playView)
        let abX = abs(celoctyPoint.x)
        let abY = abs(celoctyPoint.y)
      
        if swipe.state == UIGestureRecognizer.State.changed {
            if abX > abY {
                let time = player?.currentTime()
                sumTime = CMTimeMake(value: (time?.value)!, timescale: (time?.timescale)!)
                /// 将平移距离转成CMTime格式
                let addend = CMTime.init(seconds: Double(celoctyPoint.x/200), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                      self.sumTime = CMTimeAdd(self.sumTime!, addend)
                      /// 总时间
                      let totalTime = item?.duration
                      
                let totalMovieDuration = CMTimeMake(value: (totalTime?.value)!, timescale: (totalTime?.timescale)!)
                      
                      if self.sumTime! > totalMovieDuration {
                          self.sumTime = totalMovieDuration
                      }
                      ///最小时间0
                      let small = CMTime.init(seconds: 0.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                      if self.sumTime! < small {
                          self.sumTime = small
                      }
                player?.seek(to: sumTime!)
            }else if abY > abX {
                //判断为左侧上下滑动
                if locationPoint.x < self.view.bounds.size.width/2 {
                    changeLiangValue(value: celoctyPoint.y)
                    //判断为右侧上下滑动
                }else if locationPoint.x > self.view.bounds.size.width/2 {
                    changeVolmSliderValue(value: celoctyPoint.y)
                }
            }
        } else if  swipe.state == UIGestureRecognizer.State.ended {
            if abX > abY {
                player?.play()
                 self.sumTime = CMTime.init(seconds: 0.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            }else if abY > abX {
                if celoctyPoint.y < 0 {
                   
                }else {
                   
                }
            }
        }
    }
    //点击手势
    @objc  func clickPlayView()  {
        if isSuo == false {
            if videoTimer != nil {
                stopTimer()
                videoTimer = nil
            }
            UIView.animate(withDuration: 1) {
                self.headerView.alpha = 1
                self.bottomView.alpha = 1
                 self.suoButton.alpha = 1
            }
            openTimer()
            ceView.isHidden = true
        }else{
            if videoTimer != nil {
                stopTimer()
                videoTimer = nil
            }
            UIView.animate(withDuration: 1) {
                self.headerView.alpha = 0
                self.bottomView.alpha = 0
                self.suoButton.alpha = 1
            }
            openTimer()
            ceView.isHidden = true
        }
        }

}
//MARK:-TableView
extension playerViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bsTableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.centerLabel.text =  dataArr[indexPath.row]
        cell.centerLabel.textColor = .white
        if indexNum == indexPath.row {
            cell.centerLabel.textColor = .green
        }else{
             cell.centerLabel.textColor = .white
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexNum = indexPath.row
        bsTableView.reloadData()
        switch indexPath.row {
        case 0:
            player?.rate = 2.0
            break
        case 1 :
            player?.rate = 1.5
            break
        case 2 :
            player?.rate = 1.25
            break
        case 3 :
            player?.rate = 1.0
            break
        case 4 :
            player?.rate = 0.75
            break
        default:
            break
        }
    }
    
}
//MARK:-点击事件
extension playerViewController {
  @objc  func clickbsButton()  {
        stopTimer()
        ceView.isHidden = false
        headerView.alpha = 0
        bottomView.alpha = 0
        suoButton.alpha = 0
    }
@objc  func clickSuoButton() {
        suoButton.isSelected = !suoButton.isSelected
        if suoButton.isSelected {
            suoButton.tintColor = .purple
            headerView.alpha = 0
            bottomView.alpha = 0
            isSuo = true
        }else{
            suoButton.tintColor = .white
            headerView.alpha = 1
            bottomView.alpha = 1
            isSuo = false
           }
    }
}
//MARK:-定时器
extension playerViewController {
    func openTimer()  {
        videoTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(headerAndbottom), userInfo: nil, repeats: true)
        videoTimer?.fire()
    }
    @objc func headerAndbottom()  {
        headerAndBottomNum = headerAndBottomNum+1
        if headerAndBottomNum == 5 {
            stopTimer()
            UIView.animate(withDuration: 1) {
                self.headerView.alpha = 0
                self.bottomView.alpha = 0
                self.suoButton.alpha = 0
            }
      
        }
    }
    func stopTimer()  {
        if videoTimer != nil {
            videoTimer?.invalidate()
            videoTimer = nil
            headerAndBottomNum = 0
        }
    }
}
//MARK:-播放监听
extension playerViewController {
    private func addObserver() {
        //          removeObserver()
        // 当前播放时间 (间隔: 每秒10次)
        let interval = CMTime(value: 1, timescale: 10)
        NotificationCenter.default.addObserver(self as Any, selector: #selector(self.playerItemDidPLayeToEnd), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime , object: nil)
        playerTimeObserver = player!.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] (time) in
            
            let item = self?.player?.currentItem
            if self!.player!.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(self!.player!.currentTime())
                let stringCurrentTime = self!.getFormatPlayTime(secound: Int(currentTime))
                self!.leftLabel.text = stringCurrentTime
                let totalTime = TimeInterval(item!.duration.value)/TimeInterval(item!.duration.timescale)
                self!.playerSlider.value = Float(currentTime/totalTime)
            }
        }
    }
    @objc func playerItemDidPLayeToEnd(notification : NSNotification)  {
        returnPlay()
    }
    func returnPlay()  {
        if !(self.player != nil) {
            return
        }
        let a : CGFloat = 0
        let dragedSecond : Int = Int(floor(a))
        self.player?.seek(to: .zero)
        player?.play()
    }
    private func removeObserver() {
        guard let observer = playerTimeObserver else { return }
        playerTimeObserver = nil
        player!.removeTimeObserver(observer)
    }
    func getFormatPlayTime(secound : Int)->String{
        let hm:user_long_t = user_long_t(secound%1000)
        
        let s:user_long_t = user_long_t(secound/1000);
        
        let m:user_long_t=user_long_t(s/60);
        let miao:user_long_t=user_long_t(s%60);
        
        let str = String(format: "%02ld:%02ld", miao,hm)
        let str1 = str.prefix(8)
        let aa = String(str1)
        return aa
    }
}
//MARK: -滑动进度条
extension playerViewController {
    @objc  func sliderHua(_ slider : UISlider)  {
        if player?.status == AVPlayer.Status.readyToPlay {
            //            player?.pause()
            let duration = slider.value * Float(TimeInterval((item?.duration.value)!) / TimeInterval((item?.duration.timescale)!))
            let seekTime = CMTimeMake(value: Int64(duration), timescale: 1)
            player?.seek(to: seekTime)
            player?.play()
        }
    }
    @objc func sliderTouchDown(_ slider : UISlider) {
        slidering = true
    }
    @objc func sliderValueChange(_ slider : UISlider)  {
        player?.pause()
    }
}

//MARK:-ui
extension playerViewController {
    func getUI()  {
       
        view.addSubview(playView)
        playView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.height.equalTo(Width)
            make.width.equalTo(Height)
        }
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(50)
        }
        bottomView.addSubview(playerSlider)
        playerSlider.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView).offset(50*rWidth)
            make.bottom.equalTo(bottomView).offset(-30*rWidth)
            make.right.equalTo(bottomView).offset(-60*rWidth)
            make.centerX.equalTo(bottomView)
        }
        bottomView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.right.equalTo(playerSlider.snp.left).offset(-10*rWidth)
            make.centerY.equalTo(playerSlider)
        }
        bottomView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(playerSlider.snp.right).offset(10*rWidth)
            make.centerY.equalTo(playerSlider)
        }
        bottomView.addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel).offset(5)
            make.top.equalTo(leftLabel.snp.bottom).offset(5*rWidth)
        }
        bottomView.addSubview(sdButton)
        sdButton.snp.makeConstraints { (make) in
            make.right.equalTo(playerSlider)
            make.centerY.equalTo(playButton)
        }
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        headerView.addSubview(disButton)
        disButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView)
            make.left.equalTo(headerView).offset(10)
        }
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(disButton)
            make.centerX.equalTo(headerView)
        }
        view.addSubview(ceView)
        ceView.snp.makeConstraints { (make) in
            make.right.bottom.top.equalTo(view)
            make.width.equalTo(200)
        }
        ceView.addSubview(bsTableView)
        bsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(ceView).offset(50)
            make.bottom.equalTo(ceView).offset(-50)
            make.left.right.equalTo(ceView)
        }
        view.addSubview(suoButton)
        suoButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.left.equalTo(view).offset(40)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
    }
}
//MARK:-播放
extension playerViewController {
    @objc   func installVideo()  {
        playButton.isSelected = !playButton.isSelected
        if playButton.isSelected {
            playButton.setImage(#imageLiteral(resourceName: "bofang"), for: .normal)
            player!.pause()
        }else{
            playButton.setImage(#imageLiteral(resourceName: "zanting"), for: .normal)
            player!.play()
        }
    }
    func getPlayer() {
        let videoPath = Bundle.main.path(forResource: "BIG", ofType: "mp4")
        let videoUrl = URL(fileURLWithPath: videoPath!)
        item = AVPlayerItem(url: videoUrl)
        player = AVPlayer(playerItem: item)
        playerlayer = AVPlayerLayer(player: player)
        playerlayer?.frame = CGRect(x: 0, y: 0, width:Height , height: Width)
        // playerlayer?.videoGravity = .resizeAspect
        playView.layer.addSublayer(playerlayer!)
        //获取视频总时长
        let audioAsset = AVURLAsset.init(url: URL(fileURLWithPath: videoPath!))
        let audioDuration = audioAsset.duration
        let audioDuratio = CMTimeGetSeconds(audioDuration)
        let audioDuratioWIthInt = Int(audioDuratio)
        stringDur = self.getFormatPlayTime(secound: audioDuratioWIthInt)
        player?.play()
        addObserver()
    }
}
//MARK:-屏幕旋转
extension playerViewController {
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
    // 强制旋转竖屏
    func forceOrientationPortrait() {
        let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.isForceLandscape = false
        appdelegate.isForcePortrait = true
        _ = appdelegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: view.window)
        let oriention = UIInterfaceOrientation.portrait // 设置屏幕为竖屏
        UIDevice.current.setValue(oriention.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}
