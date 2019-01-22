//
// EYEPlayViewController.swift
// eyeApp
//
// Create by 周涛 on 2019/1/9.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit
import AVFoundation
import MediaPlayer

/*class EYEPlayerController: UIViewController {
    var url: URL?
    var videoTitle: String!
    /**总时长*/
    final var totalTime: Int = 0
    
    private var playerItem: AVPlayerItem?
    private lazy var player : AVPlayer = {
        var player: AVPlayer = AVPlayer(playerItem: self.playerItem)
        return player
    }()
    
    
    /**当前时长*/
    final var currentVideoTime: Int = 0
    /**快进时间*/
    final var seekTime: Int = 0
    private var moveMaxTimeDistance: TimeInterval = 110 //最多快进110秒
    
    /**初始音量*/
    private var initVolume:CGFloat!
    /**初始亮度*/
    private var initBrightness: CGFloat!
    /**当前音量*/
    private var currentVolume: CGFloat!
    /**当前亮度*/
    private var currentBrightness: CGFloat!
    /**时间观察*/
    private var timeObserve: Any?
    
    private enum PlayerState {
        case PlayerStateBuffering  //缓冲中
        case PlayerStatePlaying    //播放中
        case PlayerReadyToPlay     //准备播放
        case PlayerStateComplete    //播放完成
        case PlayerStatePause      //暂停播放
        case PlayerStateFailed     //播放失败
    }
    
    private enum PanDirection {
        case HorizontalMoved //水平移动 控制进度
        case VerticalMoved //纵向移动 控制音量或亮度
    }
    
    private var panDirection: PanDirection = PanDirection.HorizontalMoved
    
    private var playerState: PlayerState = PlayerState.PlayerStateBuffering {
        didSet {
            switch self.playerState {
            case .PlayerStateBuffering:
                self.playView.startLoadingAnimation()
                self.playView.hideAnimation()
                
                self.player.pause()
                self.oldPlayerState = oldValue //保存缓存之前的状态
                break
            case .PlayerStatePause:
                self.playView.stopLoadingAnimation()
                self.player.pause()
                break
            case .PlayerStatePlaying:
                self.playView.stopLoadingAnimation()
                self.player.play()
                break
            case .PlayerStateComplete:
                break
            case .PlayerStateFailed:
                break
            default:
                break
            }
        }
    }
    
    private var oldPlayerState: PlayerState = .PlayerReadyToPlay
    // 界面
   
    @IBOutlet weak var playView: EYEPlayerView!
    
    private var playLayer: AVPlayerLayer?
    private var isFullScreen: Bool = false {
        didSet {
            if self.isFullScreen {
               
                self.playView.isFullScreen = true
            } else {
                
                self.playView.isFullScreen = false
            }
        }
    }
    
    private var isVolume: Bool = false
    
    
   
    
    convenience init(urlStr: String,title: String) {
        self.init()
        self.url = URL(string: urlStr)
        self.videoTitle = title
        
        
    }
    
    func initialData(urlStr: String,title: String) {
        self.url = URL(string: urlStr)
        self.videoTitle = title
        //self.totalTime = totalTime
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.url != nil {
            self.playerItem = AVPlayerItem(url: self.url!)
        }
        
        self.player.replaceCurrentItem(with: self.playerItem)
        //self.prefersStatusBarHidden = true
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.allowRotation = true
        }
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
        
        self.addObserversAndNotificaton()
        self.player.play()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getSystemCurrentVolumeAndBrightness()
        self.initVolume = self.currentVolume
        self.initBrightness = self.currentBrightness
        self.playerState = .PlayerStateBuffering
        self.playView.changeVolume(value: self.currentVolume)
        self.playView.changeBrightness(value: self.currentBrightness)
        /*self.totalTime = Int(Float(self.playerItem!.duration.value) / Float(self.playerItem!.duration.timescale))
        if !self.player.currentItem!.isPlaybackLikelyToKeepUp {
            self.playerState = .PlayerStateBuffering
            self.playView.startLoadingAnimation()
        }*/
    }
    
    
    deinit {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.allowRotation = false
        }
        self.removeObserverAndNotification()
    }
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    //MARK: -获取系统音量及亮度
    private func getSystemCurrentVolumeAndBrightness() {
        self.currentBrightness = UIScreen.main.brightness
        self.currentVolume = self.playView.getCurrentVolume()
    }
    
    private func addObserversAndNotificaton() {
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
        self.playView.action_playBtn.addTarget(self, action: #selector(startAction(_:)), for: UIControlEvents.touchUpInside)
        //下一个视频
        self.playView.action_nextBtn.addTarget(self, action: #selector(nextVideoAction(_:)), for: UIControlEvents.touchUpInside)
        //上个视频
        self.playView.action_lastBtn.addTarget(self, action: #selector(lastVideoAction(_:)), for: UIControlEvents.touchUpInside)
        //  屏幕缩放
        self.playView.action_zoomBtn.addTarget(self, action: #selector(screenZoom_In_Out_Action(_:)), for: UIControlEvents.touchUpInside)
        
        self.playView.dismissBtn.addTarget(self, action: #selector(dismissAction(_:)), for: UIControlEvents.touchUpInside)
        
        
        //监听播放状态
        self.player.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        self.player.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        self.player.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self.player.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
    }
    
    /**取消注册通知和观察者*/
    private func removeObserverAndNotification() {
        //移除观察者
        NotificationCenter.default.removeObserver(self)
        
        // 移除观察者
        self.player.currentItem?.removeObserver(self, forKeyPath: "status")
        self.player.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.player.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        self.player.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        
    }
    
    // KVO监听属性
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status" {
            if self.player.status == .readyToPlay {
                
                self.playerState = .PlayerStatePlaying
                self.addTimeObserve()
            } else if self.player.status == .failed {
                
                self.playerState = .PlayerStateBuffering
            }
        } else if keyPath == "loadedTimeRanges" {
            let timeInterval = availableDuration()
            let duration = self.playerItem!.duration
            let totalDuration = CMTimeGetSeconds(duration)
            //self.playView.progressView.setProgress(Float(timeInterval) / Float(totalDuration), animated: false)
        } else if keyPath == "playbackBufferEmpty" {
            // 当缓冲是空的时候
            if self.playerItem!.isPlaybackBufferEmpty {
               
                self.bufferingSomeSecond()
                 //self.playerState = .PlayerStateBuffering
            }
        } else if keyPath == "playbackLikelyToKeepUp" {
            // 当缓冲好的时候
            
            if self.playerItem!.isPlaybackLikelyToKeepUp {
                self.playerState = .PlayerStatePlaying
            }
        }
    }
    
    /**实时刷新数据*/
    private func addTimeObserve() {
        self.timeObserve = self.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: nil, using: { (time) in
            if self.playerItem != nil {
                let currentItem = self.playerItem
                let currentTime = CMTimeGetSeconds((currentItem?.currentTime())!)
                let totalTime = CMTimeGetSeconds(CMTimeMake((currentItem?.duration.value)!, (currentItem?.duration.timescale)!))
                
               
                if (currentItem?.seekableTimeRanges.count)! > 0 && (currentItem?.duration.timescale)! != 0 {
                    self.totalTime = NSInteger(totalTime)
                    self.currentVideoTime = Int(currentTime)
                    let currentTimeString = self.timeStringWithTime(times: Int(self.currentVideoTime))
                    let totalTimeString = self.timeStringWithTime(times: Int(self.totalTime))
                    self.playView.timeLabel.text = String(format: "%@ / %@", currentTimeString, totalTimeString)
                }
            }
        })
    }
    
    
    //设备发生旋转
    @objc private func receivedRotation() {
        let currentOrientation = UIDevice.current.orientation
        //let frame = UIScreen.main.bounds
        switch currentOrientation {
        case .portrait:
            //屏幕直立
            
            self.playView.frame = CGRect(x: 0, y: 0, width: UIConstant.SCREEN_WIDTH, height: UIConstant.SCREEN_WIDTH * UIConstant.PLAYVIEW_H_W_IN_VERTICAL)
            self.playLayer?.frame = self.playView.bounds
            self.isFullScreen = false
            self.playView.action_zoomBtn.setImage(UIImage(named: "ic_turn_screen_white"), for: UIControlState.normal)
            break
        case .landscapeLeft:
            //屏幕左在上方
            
            self.playView.frame = UIScreen.main.bounds
            self.playLayer?.frame = self.playView.bounds
            self.playView.action_zoomBtn.setImage(UIImage(named: "ic_zoomout_screen_white"), for: UIControlState.normal)
            self.isFullScreen = true
            break
        case .landscapeRight:
            
            //屏幕右在上方
            
             self.playView.frame = UIScreen.main.bounds
             self.playLayer?.frame = self.playView.bounds
             self.playView.action_zoomBtn.setImage(UIImage(named: "ic_zoomout_screen_white"), for: UIControlState.normal)
             self.isFullScreen = true
            break
        default:
            break
        }
    }
    
    //app进入后台模式
    @objc private func appDidEnterBackground() {
        
    }
    
    //app进入前台
    @objc private func appDidEnterForeground() {
        
    }
    
    
    /**计算缓存进度*/
    private func availableDuration() -> TimeInterval {
        let loadedTimeRanges = self.player.currentItem?.loadedTimeRanges
        //获取缓存区域
        let timeRange = loadedTimeRanges?.first?.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange!.start)
        let durationSeconds = CMTimeGetSeconds(timeRange!.duration)
        // 计算缓冲总进度
        return startSeconds+durationSeconds
    }
    
    /**
     缓冲较差时候回调这里
     */
    private func bufferingSomeSecond() {
       
        
        // 如果正在缓存就不往下执行
        if self.playerState == .PlayerStateBuffering {return}
        // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
        self.playerState = .PlayerStateBuffering
        self.playView.startLoadingAnimation()
        //self.player.pause()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
            if !self.playerItem!.isPlaybackLikelyToKeepUp {
                //self.playerState = .PlayerStateBuffering
                self.bufferingSomeSecond()
                return
            }
            
            // 如果此时用户已经暂停了，则不再需要开启播放了
            if self.oldPlayerState == .PlayerStatePause {
                return
            } else {
                //self.player.play()
                self.playerState = .PlayerStatePlaying
                self.playView.stopLoadingAnimation()
            }
        }
    }
    
    /*播放或暂停*/
    @objc private func startAction(_ sender: UIButton) {
        switch self.playerState {
        case .PlayerStatePause:
            self.playerState = .PlayerStatePlaying
             sender.setImage(UIImage(named: "action_player_pause"), for: UIControlState.normal)
            
            break
        case .PlayerStatePlaying:
            self.playerState = .PlayerStatePause
           
            sender.setImage(UIImage(named: "action_player_play"), for: UIControlState.normal)
            break
        case .PlayerStateComplete:
            self.playerState = .PlayerStatePlaying
            sender.setImage(UIImage(named: "Action_reload_player"), for: UIControlState.normal)
        default:
            break
        }
    }
    
    
    /**播放完成*/
    @objc private func moviePlayDidEnd(notification: Notification) {
        self.playerState = .PlayerStateComplete
        self.playView.action_playBtn.setImage(UIImage(named: "Action_reload_player"), for: UIControlState.normal)
    }
    
    /**前一个视频*/
    @objc private func lastVideoAction(_ sender: UIButton) {
        
    }
    
    /**下一个视频*/
    @objc private func nextVideoAction(_ sender: UIButton) {
        
    }
    
    @objc private func screenZoom_In_Out_Action(_ sender: UIButton) {
        self.isFullScreen = !self.isFullScreen
        if self.isFullScreen {
            
            EYEDeviceTool.interfaceOrientation(.landscapeRight)
        } else {
            EYEDeviceTool.interfaceOrientation(.portrait)
        }
        
    }
    
    //退出界面
    @objc private func dismissAction(_ sender: UIButton) {
        self.player.pause() //停止播放
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /**从XXX秒开始播放视频*/
    private func seekTime(dragedTime: CMTime) {
        if self.playerState != .PlayerStateBuffering && self.playerState != .PlayerStateComplete {
            self.player.seek(to: dragedTime)
        }
    }
    
    /**滑动手势*/
    @objc private func panAction(pan: UIPanGestureRecognizer) {
        if self.playerState == .PlayerStateBuffering || self.playerState == .PlayerStateComplete {
            return
        }
        //获取手指点在屏幕上的位置
        let locationPoint = pan.location(in: self.playView)
        let velocity = pan.velocity(in: self.playView)
        switch pan.state {
        case .began:
            /// 使用绝对值来判断移动的方向
            let x = fabs(velocity.x)
            let y = fabs(velocity.y)
            if x > y {
                self.panDirection = .HorizontalMoved
                
                //快进快退中其他控制按钮隐藏
                self.playView.action_lastBtn.alpha = 0
                self.playView.action_likeBtn.alpha = 0
                self.playView.action_moreBtn.alpha = 0
                self.playView.action_nextBtn.alpha = 0
                self.playView.action_playBtn.alpha = 0
                self.playView.action_shareBtn.alpha = 0
                self.playView.dismissBtn.alpha = 0
                self.playView.timeLabel.alpha = 1
                self.playView.coverView.alpha = 0
                self.playView.action_zoomBtn.alpha = 0
                
                //视频暂停播放
                //self.player.pause()
            } else if x < y && self.isFullScreen {
                //全屏状态下才可滑动改变音量和亮度
                
                self.panDirection = .VerticalMoved
                if locationPoint.x < self.playView.width / 2 {
                    //控制音量
                    self.isVolume = true
                    self.playView.volunmeBar.isHidden = false
                    self.playView.volumePlusIcon.isHidden = false
                    self.playView.volumeMinusIcon.isHidden = false
                } else {
                    //控制亮度
                    self.playView.brightnessBar.isHidden = false
                    self.playView.brightnessPlusIcon.isHidden = false
                    self.playView.brightnessMinusIcon.isHidden = false
                    self.isVolume = false
                }
            }
            break
        case .changed:
            switch self.panDirection {
            case .HorizontalMoved:
                let translationX = pan.translation(in: self.playView).x
                self.horizontalMoved(value: translationX)
                break
            case .VerticalMoved:
                let translationY = pan.translation(in: self.playView).y / (self.playView.height - 40)
                verticalMoved(value: translationY)
                
                self.playView.changeVolume(value: translationY)
                
                break
            }
            break
        case .ended,.cancelled:
            switch self.panDirection {
            case .HorizontalMoved:
                self.currentVideoTime = self.seekTime
                self.playView.timeLabel.alpha = 0
                self.player.seek(to: CMTime(seconds: Double(self.currentVideoTime), preferredTimescale: 1))
                break
            case .VerticalMoved:
                if isVolume {
                    self.currentVolume = self.playView.getCurrentVolume()
                } else {
                    self.currentBrightness = UIScreen.main.brightness
                }
                break
            }
            break
        default:
            break
        }
    }
    
    /**时间转化*/
    private func timeStringWithTime(times: Int) -> String{
        let min = times / 60
        let sec = times % 60
        let timeString = String(format: "%02zd:%02zd", min, sec)
        return timeString
    }
    
    /**手势水平移动*/
    private func horizontalMoved(value: CGFloat) {
        var style = String()
        if isFullScreen {
            if value < 0 {
                style = "<<"
            } else if value > 0{
                style = ">>"
            } else {return}
            
            //将平移距离转换为CMTime格式
            var seconds = Double(value) / Double(self.playView.width) * moveMaxTimeDistance + Double(self.currentVideoTime)
            if seconds < 0 {seconds = 0}
            if seconds > Double(totalTime) {
                seconds = Double(totalTime)
            }
            let seekTime =
                
                CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            self.seekTime = Int(seekTime.seconds)
 @IBOutlet weak var videoTitleLabel: UILabel!
 @IBOutlet weak var videoTItleLabel: UILabel!
 let seekTimeString = self.timeStringWithTime(times: Int(seekTime.seconds))
            let totalTimeString = self.timeStringWithTime(times: Int(self.totalTime))
            self.playView.timeLabel.text = String(format: "%@ %@ / %@", style, seekTimeString, totalTimeString)
           
        } else {
            var seconds = Double(value) / Double(self.playView.width) * moveMaxTimeDistance + Double(self.currentVideoTime)
            if seconds < 0 {seconds = 0}
            if seconds > Double(totalTime) {
                seconds = Double(totalTime)
            }
            
            let seekTime = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            
            self.seekTime = Int(seekTime.seconds)
            let seekTimeString = self.timeStringWithTime(times: Int(seekTime.seconds))
            let totalTimeString = self.timeStringWithTime(times: Int(self.totalTime))
            self.playView.timeLabel.text = String(format: "%@ / %@", seekTimeString, totalTimeString)
            
        }
    }
    
    /**手势纵向移动*/
    private func verticalMoved(value: CGFloat) {
        if self.isVolume {
            let v = self.currentVolume + value
            
            self.playView.changeVolume(value: v)
        } else {
            let v = self.currentBrightness + value
            self.playView.changeBrightness(value: v)
        }
    }
}

*/


