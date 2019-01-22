//
// PlayerController.swift
// eyeApp
//
// Create by 周涛 on 2019/1/14.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import AVKit
import MediaPlayer

class EYEPlayerController: UIViewController {
    
    //MARK: -控制视频播放相关属性
    private var url: URL!
    private var videoTitle: String!
    private var playerItem: AVPlayerItem!
    private var player: AVPlayer!
    private var playLayer: AVPlayerLayer!
    
    /**当前定位时间*/
    private var seekTime: Int = 0
    /**当前时间*/
    private var currentTime: Int = 0
    
    private var maxMoveTime: TimeInterval = 110 //单位秒
    
    /**当前音量*/
    private var currentVolume: CGFloat!
    /**当前亮度*/
    private var currentBrightness: CGFloat!
    /**时间观察*/
    private var timeObserve: Any?
    
    //MARK: -初始化数据
    func initialData(urlString: String, videoTitle: String) {
        self.url = URL(string: urlString)
        self.videoTitle = videoTitle
        self.playerItem = AVPlayerItem(url: self.url)
        self.player = AVPlayer(playerItem: self.playerItem)
        self.playLayer = AVPlayerLayer(player: self.player)
    }
    
    private enum PlayerState {
        case playerStateBuffering  //缓冲中
        case playerStatePlaying    //播放中
        case playerReadyToPlay     //准备播放
        case playerStateComplete    //播放完成
        case playerStatePause      //暂停播放
        case playerStateFailed     //播放失败
    }
    
    private var playerState: PlayerState = PlayerState.playerStateBuffering {
        didSet {
            if self.playerState == oldValue {return}
            if oldValue == .playerStateBuffering {
                self.playView.stopLoadingAnimation()
            }
            switch self.playerState {
            case .playerStateBuffering:
                self.playView.startLoadingAnimation()
                
                break
            case .playerStatePlaying:
                self.player.play()
                break
            case .playerStatePause:
                self.player.pause()
                break
            case .playerStateComplete:
                break
            case .playerReadyToPlay:
                self.playView.showAnimation()
                self.playerState = .playerStatePlaying
                break
            default:
                break
            }
        }
    }
    
    private enum PanDirection {
        case HorizontalMoved //水平移动 控制进度
        case VerticalMoved //纵向移动 控制音量或亮度
    }
    
    private var panDirection: PanDirection = PanDirection.HorizontalMoved
    
    @IBOutlet private weak var playView: EYEPlayerView!
    
    //MARK: -视图生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.playerItem == nil {return}
        
        switch self.dataModelType{
        case "followCard":
            let followCardModel = self.dataModel as! FollowCardModel
            
            self.bgImageView.yy_setImage(with: URL(string: followCardModel.data.content.data.cover!.blurred), options: YYWebImageOptions.progressiveBlur)
           
            let duration = followCardModel.data.content.data.duration
            self.playView.timeLabel.text =  String(format: "%@ / %@", timeStringWithTime(times: 0), timeStringWithTime(times: duration))
            
            break
        case "videoSmallCard":
            let videoSmallCardModel = self.dataModel as! VideoSmallCardModel
            self.bgImageView.yy_setImage(with: URL(string: videoSmallCardModel.data.cover!.blurred), options: YYWebImageOptions.progressiveBlur)
            let duration = videoSmallCardModel.data.duration
            self.playView.timeLabel.text =  String(format: "%@ / %@", timeStringWithTime(times: 0), timeStringWithTime(times: duration))
            break
        default:
            break
        }
        
        self.player.replaceCurrentItem(with: self.playerItem)
        //self.prefersStatusBarHidden = true
        
        self.view.bounds = UIScreen.main.bounds
        
        self.playView.frame = CGRect(x: 0, y: 0, width: UIConstant.SCREEN_WIDTH, height: UIConstant.SCREEN_WIDTH * UIConstant.PLAYVIEW_H_W_IN_VERTICAL)
        
        self.playLayer = AVPlayerLayer(player: self.player)
        self.playLayer?.frame = self.playView.bounds
        // AVLayerVideoGravityResize,       // 非均匀模式。两个维度完全填充至整个视图区域
        // AVLayerVideoGravityResizeAspect,  // 等比例填充，直到一个维度到达区域边界
        // AVLayerVideoGravityResizeAspectFill, // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
        if self.playLayer != nil {
            self.playLayer?.videoGravity = .resizeAspect
            //在xib中不要设置playView的背景色，不然整个layer的背景色变为设置颜色，在插入playLayer后不能正常显示，所以应该在其storyboard中进行设置
            self.playView.layer.insertSublayer(self.playLayer!, at: 0)
        }
 
 
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //*****如果设置了atuoresizesubviews 为true需要将其变为false,因为viewdidload调用时，uistoryboard使用的约束布局需要在viewwilllayoutsubviews之后的layoutsubviews才能显示正确的frame,若设置了atuoresizesubviews为true会导致子视图的frame发生变化，切记，切记，切记，我的半天就这么不在了，~~~~(>_<)~~~~
        let dismissalHeader = Bundle.main.loadNibNamed("ZTDismissalHeader", owner: nil, options: nil)?.first as! ZTDismissalHeader
        dismissalHeader.frame =  CGRect(x: 0, y: 0, width: UIConstant.SCREEN_WIDTH, height: 30)
        dismissalHeader.dismissalDelegate = self
        
        self.tableView.header = dismissalHeader
        
        self.addObserversAndNotification()
        self.player.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.currentBrightness = UIScreen.main.brightness
        self.currentVolume = self.playView.getCurrentVolume()
        if self.playerState == .playerStateBuffering {
            self.playView.startLoadingAnimation()
        }
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.allowRotation = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
       
    }
    
    //MARK: -重写父类属性
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    //MARK: -通知,滑动手势及事件添加
    private func addObserversAndNotification() {
        //监听设备方向
        NotificationCenter.default.addObserver(self, selector: #selector(receivedRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        //app退出到后台通知
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        //app进入前台
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterForeground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        //滑动事件
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(pan:)))
        self.playView.addGestureRecognizer(panGesture)
        
        //播放按钮点击事件
        self.playView.action_playBtn.addTarget(self, action: #selector(playOrPauseAction(_:)), for: UIControlEvents.touchUpInside)
        //下一个视频
        self.playView.action_nextBtn.addTarget(self, action: #selector(nextVideoAction(_:)), for: UIControlEvents.touchUpInside)
        //上个视频
        self.playView.action_lastBtn.addTarget(self, action: #selector(lastVideoAction(_:)), for: UIControlEvents.touchUpInside)
        //  屏幕缩放
        self.playView.dismissBtn.addTarget(self, action: #selector(dismissalOrExitFullScreenAction(_:)), for: UIControlEvents.touchUpInside)
        self.playView.slider.addTarget(self, action: #selector(progressValueChange(_:)), for: UIControlEvents.valueChanged)
        self.playView.slider.addTarget(self, action: #selector(progressValueChangeEnd(_:)), for: UIControlEvents.touchCancel)
        
        //监听播放状态
        self.player.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        self.player.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayDidEnd(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        
        self.addTimeObserve()
        
    }
    
    /**取消注册通知和观察者*/
    private func removeObserverAndNotification() {
        //移除观察者
        NotificationCenter.default.removeObserver(self)
        
        // 移除观察者
        self.player.currentItem?.removeObserver(self, forKeyPath: "status")
        self.player.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         if change == nil {return}
        if keyPath == "status" {
            guard let rawValue = change![NSKeyValueChangeKey.newKey] as? Int else {return}
            let status = AVPlayerItem.Status(rawValue: rawValue) ?? AVPlayerItem.Status.unknown
            switch status {
            case .readyToPlay:
                self.playerState = .playerReadyToPlay //点击播放按钮即可播放
                break
            case .failed:
                self.playerState = .playerStateFailed
                assertionFailure("视频播放出错")
                
                break
            case .unknown:
                self.playerState = .playerStateBuffering
                break
            }
        } else if keyPath == "loadedTimeRanges" {
            
        }
    }
    
    
    //MARK: -播放完成
    /*
     * item播放完毕通知
     */
    @objc private func moviePlayDidEnd(note:Notification){
        self.playerState = .playerStateComplete
        self.playView.action_playBtn.setImage(UIImage(named: "Action_reload_player"), for: UIControlState.normal)
        self.playView.setCtrlBtnAlpha(alpha: 1)
        self.playView.coverView.alpha = 0.3
        /*if isFullScreen {
            self.playView.setBrightnessCtrl(alpha: 1)
            self.playView.setVolumeCtrl(alpha: 1)
        }*/
        
        
    }
    
    //MARK: -缓存相关方法
    /**计算缓存区*/
    private func bufferDuration() -> TimeInterval{
        let loadedTimeRanges = self.player.currentItem?.loadedTimeRanges
        //获取缓存区域
        let timeRange = loadedTimeRanges?.first?.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange!.start)
        let durationSeconds = CMTimeGetSeconds(timeRange!.duration)
        // 计算缓冲总进度
        return startSeconds+durationSeconds
    }
    
    /**缓存较差时调用该方法*/
    private func bufferingSomeSecond() {
        
    }
    
    //MARK: -控制按钮响应方法
    @objc private func appDidEnterBackground() {
        
    }
    
    @objc private func appDidEnterForeground() {
        
    }
    
    /**进度条滑动处理*/
    
    @objc private func progressValueChange(_ sender: UISlider) {
        isChangeCurrentTime = true
        var style = String()
        
        let totalTime = CMTimeGetSeconds(CMTimeMake((self.player.currentItem?.duration.value)!, (self.player.currentItem?.duration.timescale)!))
        let seconds = sender.value * Float(totalTime)
        let seekTime = CMTime(seconds: Double(seconds), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        self.seekTime = Int(seekTime.seconds)
        let seekTimeString = self.timeStringWithTime(times: Int(seekTime.seconds))
        let totalTimeString = self.timeStringWithTime(times: Int(totalTime))
        sender.value = Float(seekTime.seconds / totalTime)
        if isFullScreen {
            if Int(self.seekTime) < self.currentTime {
                style = "<<"
            } else if Int(self.seekTime) > self.currentTime {
                style = ">>"
            } else {return}
            
           
            self.playView.timeLabel.text = String(format: "%@ %@ / %@", style, seekTimeString, totalTimeString)
            
        } else {
           
            self.playView.timeLabel.text = String(format: "%@ / %@", seekTimeString, totalTimeString)
            
        }
        
    }
    @objc private func progressValueChangeEnd(_ sender: UISlider) {
        self.currentTime = self.seekTime
        isChangeCurrentTime = false
    }
    
    /**播放或暂停*/
    @objc private func playOrPauseAction(_ sender: UIButton) {
        switch self.playerState {
        case .playerStatePause:
            self.playerState = .playerStatePlaying
            sender.setImage(UIImage(named: "action_player_pause"), for: UIControlState.normal)
            break
        case .playerStatePlaying:
            self.playerState = .playerStatePause
            sender.setImage(UIImage(named: "action_player_play"), for: UIControlState.normal)
            break
        case .playerStateComplete:
            //self.playerState = .playerStateBuffering
            
            //self.playerItem = AVPlayerItem(url: self.url)
            //self.player.replaceCurrentItem(with: self.playerItem)
            self.player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            self.player.play()
            sender.setImage(UIImage(named: "action_player_pause"), for: UIControlState.normal)
        default:
            break
        }
    }
    /**下个视频*/
    @objc private func nextVideoAction(_ sender: UIButton) {
        
    }
    /**上个视频*/
    @objc private func lastVideoAction(_ sender: UIButton) {
        
    }
    /**进入全屏*/
    @objc private func enterFullScreenAction(_ sender: UIButton) {
        EYEDeviceTool.interfaceOrientation(.landscapeRight)
    }
    /**退出视频播放或退出全屏*/
    @objc private func dismissalOrExitFullScreenAction(_ sender: UIButton) {
        if self.isFullScreen {
            EYEDeviceTool.interfaceOrientation(.portrait)
        } else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.allowRotation = false
            }
            //self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true) {
                self.player.pause()
                self.removeObserverAndNotification()
                
            }
        }
    }
    
    
    
    //MARK: -设备旋转方法及全屏属性
    private var isFullScreen: Bool  {
        set {
            self.playView.isFullScreen = newValue
        }
        get {
            return self.playView.isFullScreen
        }
    }
    //设备发生旋转
    @objc private func receivedRotation() {
        let currentOrientation = UIDevice.current.orientation
        switch currentOrientation {
        case .portrait:
            //屏幕直立
            
            self.playView.frame = CGRect(x: 0, y: 0, width: UIConstant.SCREEN_WIDTH, height: UIConstant.SCREEN_WIDTH * UIConstant.PLAYVIEW_H_W_IN_VERTICAL)
            self.playLayer.frame = self.playView.bounds
            self.isFullScreen = false
            
            break
        case .landscapeLeft:
            //屏幕左在上方
            
            self.playView.frame = UIScreen.main.bounds
            self.playLayer.frame = self.playView.bounds
            
            self.isFullScreen = true
            break
        case .landscapeRight:
            
            //屏幕右在上方
            
            self.playView.frame = UIScreen.main.bounds
            self.playLayer.frame = self.playView.bounds
            
            self.isFullScreen = true
            break
        default:
            break
        }
    }
    
    //MARK: -滑动手势
    private var isVolume: Bool = true //控制音量
    @objc private func panAction(pan: UIPanGestureRecognizer) {
        if self.playerState == .playerStateBuffering || self.playerState == .playerStateComplete {
            return
        }
        
        switch pan.state {
        case .began:
            let velocity = pan.velocity(in: self.playView)
            let locationPoint = pan.location(in: self.playView)
            let vX = fabs(velocity.x)
            let vY = fabs(velocity.y)
            if vX > vY {
                self.panDirection = .HorizontalMoved
                self.playView.timeLabel.alpha = 1
                if isFullScreen {
                    self.playView.timeLabel.isHidden = false
                }
                isChangeCurrentTime = true
            } else if vX < vY && isFullScreen{
                self.panDirection = .VerticalMoved
                if locationPoint.x < self.playView.width / 2 {
                    self.isVolume = true
                    self.playView.setVolumeCtrlHidden(isHidden: false)
                    self.playView.setVolumeCtrl(alpha: 1)
                
                } else {
                    self.isVolume = false
                    self.playView.setBrightnessCtrlHidden(isHidden: false)
                    self.playView.setBrightnessCtrl(alpha: 1)
                }
            }
        case .changed:
            switch self.panDirection {
            case .HorizontalMoved:
                let translationX = pan.translation(in: self.playView).x
                self.horizontalMoved(value: translationX)
                break
            case .VerticalMoved:
                let velocity = pan.velocity(in: self.playView)
                //let translationY = pan.translation(in: self.playView).y / (self.playView.height)
                verticalMoved(value: velocity.y)
                
                
                break
            }
            break
        case .ended,.cancelled:
            switch self.panDirection {
            case .HorizontalMoved:
                self.currentTime = self.seekTime
                self.playView.timeLabel.alpha = 0
                if isFullScreen {
                    self.playView.timeLabel.isHidden = true
                }
                self.player.seek(to: CMTime(seconds: Double(self.currentTime), preferredTimescale: 1))
                isChangeCurrentTime = false
                break
            case .VerticalMoved:
                if isFullScreen {
                    if isVolume {
                        self.currentVolume = self.playView.getCurrentVolume()
                        self.playView.setVolumeCtrl(alpha: 0)
                    } else {
                        self.currentBrightness = UIScreen.main.brightness
                        self.playView.setBrightnessCtrl(alpha: 0)
                    }
                }
                break
            }
            break
        default:
            isChangeCurrentTime = false
            break
        }
    }
    /**手势水平移动*/
    private func horizontalMoved(value: CGFloat) {
        var style = String()
        
        let totalTime = CMTimeGetSeconds(CMTimeMake((self.player.currentItem?.duration.value)!, (self.player.currentItem?.duration.timescale)!))
        if isFullScreen {
            if value < 0 {
                style = "<<"
            } else if value > 0{
                style = ">>"
            } else {return}
            
            //将平移距离转换为CMTime格式
            var seconds = Double(value) / Double(self.playView.width) * maxMoveTime + Double(self.currentTime)
            if seconds < 0 {seconds = 0}
            if seconds > Double(totalTime) {
                seconds = Double(totalTime)
            }
            let seekTime =
                
                CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            self.seekTime = Int(seekTime.seconds)
            self.playView.slider.value = Float(seekTime.seconds / totalTime)
            let seekTimeString = self.timeStringWithTime(times: Int(seekTime.seconds))
            let totalTimeString = self.timeStringWithTime(times: Int(totalTime))
            self.playView.timeLabel.text = String(format: "%@ %@ / %@", style, seekTimeString, totalTimeString)
            
        } else {
            var seconds = Double(value) / Double(self.playView.width) * maxMoveTime + Double(self.currentTime)
            if seconds < 0 {seconds = 0}
            if seconds > Double(totalTime) {
                seconds = Double(totalTime)
            }
            
            let seekTime = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            self.playView.slider.value = Float(seekTime.seconds / totalTime)
            self.seekTime = Int(seekTime.seconds)
            let seekTimeString = self.timeStringWithTime(times: Int(seekTime.seconds))
            let totalTimeString = self.timeStringWithTime(times: Int(totalTime))
            self.playView.timeLabel.text = String(format: "%@ / %@", seekTimeString, totalTimeString)
            
        }
    }
    
    
    
    /**手势纵向移动*/
    private func verticalMoved(value: CGFloat) {
        if self.isVolume {
            self.currentVolume -= (value / 10000.0)
            
            self.playView.changeVolume(value: self.currentVolume)
        } else {
            
            self.currentBrightness -= (value / 10000.0)
            self.playView.changeBrightness(value: self.currentBrightness)
        }
    }
    
    //MARK: -刷新时间
    private var isChangeCurrentTime: Bool = false //是否正在修改当前播放进度
    private func addTimeObserve() {
        
        self.timeObserve = self.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: nil, using: { [weak self] (time) in
            if self?.isChangeCurrentTime == true {
                return
            }
            if self?.playerItem != nil {
                let currentItem = self!.playerItem
                let currentTime = CMTimeGetSeconds((currentItem?.currentTime())!)
                let totalTime = CMTimeGetSeconds(CMTimeMake((currentItem?.duration.value)!, (currentItem?.duration.timescale)!))
                
                
                if (currentItem?.seekableTimeRanges.count)! > 0 && (currentItem?.duration.timescale)! != 0 {
                    
                    self?.currentTime = Int(currentTime)
                    let currentTimeString = self!.timeStringWithTime(times: Int(self?.currentTime ?? 0))
                    let totalTimeString = self!.timeStringWithTime(times: Int(totalTime))
                    self!.playView.timeLabel.text = String(format: "%@ / %@", currentTimeString, totalTimeString)
                    self!.playView.slider.value = Float(currentTime / totalTime)
                    self!.playView.currentTimeLabel.text = currentTimeString
                    self!.playView.totalTimeLabel.text = totalTimeString
                }
            }
        })
    }
    
    /**时间转化*/
    private func timeStringWithTime(times: Int) -> String{
        let min = times / 60
        let sec = times % 60
        let timeString = String(format: "%02zd:%02zd", min, sec)
        return timeString
    }
    

 
 
    //--------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var playerView: ZTPlayerView!
    
    private var dataModel: Any!
    private var dataModelType: String!
    
    func initialModelData(dataModel: Any, type: String) {
      self.dataModel = dataModel
        self.dataModelType = type
        switch self.dataModelType{
        case "followCard":
            let followCardModel = self.dataModel as! FollowCardModel
            let urlStr = followCardModel.data.content.data.playUrl
            let title = followCardModel.data.content.data.title
            
            self.url = URL(string: urlStr!)
            self.videoTitle = title
            self.playerItem = AVPlayerItem(url: self.url)
            self.player = AVPlayer(playerItem: self.playerItem)
            self.playLayer = AVPlayerLayer(player: self.player)
            break
        case "videoSmallCard":
            let videoSmallCardModel = self.dataModel as! VideoSmallCardModel
            let urlStr = videoSmallCardModel.data.playUrl
            let title = videoSmallCardModel.data.title
            
            self.url = URL(string: urlStr!)
            self.videoTitle = title
            self.playerItem = AVPlayerItem(url: self.url)
            self.player = AVPlayer(playerItem: self.playerItem)
            self.playLayer = AVPlayerLayer(player: self.player)
            break
        default:
            break
        }
    }
   
}

extension EYEPlayerController: UITableViewDelegate {
    
}

extension EYEPlayerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoDscirptionCell") as? VideoDscirptionCell else {return 0}
        
        return cell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoDscirptionCell") as? VideoDscirptionCell else {return UITableViewCell()}
        switch self.dataModelType {
        case  "textCard":
            let textCardModel = self.dataModel as! TextCardModel
            //cell.videoTiltleLabel =
            break
        case "followCard":
            let followCardModel = self.dataModel as! FollowCardModel
            cell.videoTiltleLabel.text = followCardModel.data.content.data.title
            cell.descriptionLabel.text = followCardModel.data.content.data.description
            cell.author_name.text = followCardModel.data.content.data.author?.name ?? ""
            
            cell.icon.yy_setImage(with: URL(string: followCardModel.data.content.data.author!.icon)!, options: YYWebImageOptions.progressiveBlur)
            cell.author_description.text = followCardModel.data.content.data.author?.description ?? ""
            let duration = followCardModel.data.content.data.duration
            
            cell.simpleLabel.text = String(format: "%@ / %@", followCardModel.data.content.data.category!, timeStringWithTime(times: duration))
            break
        case "videoSmallCard":
            let videoSmallCardModel = self.dataModel as! VideoSmallCardModel
            cell.videoTiltleLabel.text = videoSmallCardModel.data.title
            cell.descriptionLabel.text = videoSmallCardModel.data.description
            cell.author_name.text = videoSmallCardModel.data.author.name
            cell.author_description.text = videoSmallCardModel.data.author.description
            cell.icon.yy_setImage(with: URL(string: videoSmallCardModel.data.author!.icon)!, options: YYWebImageOptions.progressiveBlur)
            
            let duration = videoSmallCardModel.data.duration
            
            cell.simpleLabel.text = String(format: "%@ / %@", videoSmallCardModel.data.category!, timeStringWithTime(times: duration))
            
            break
        default: break
        }
        let size = cell.author_description.text?.heightWithFont(font: UIFont.systemFont(ofSize: 16), fixWidth: UIConstant.SCREEN_WIDTH - 30) ?? CGSize.zero
        cell.height = 193 + size.height
        
        
        return cell
    }
    
    
}

extension EYEPlayerController: DismissalDelegate {
    func dismissal() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.allowRotation = false
        }
        //self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true) {
            //self.player.pause()
            //self.removeObserverAndNotification()
            
        }
    }
}


class VideoDscirptionCell: UITableViewCell {
    @IBOutlet weak var videoTiltleLabel: UILabel!
    
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var author_name: UILabel!
    @IBOutlet weak var author_description: UILabel!
    
}


