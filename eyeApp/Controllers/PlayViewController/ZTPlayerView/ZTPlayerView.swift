//
// ZTPlayerView.swift
// eyeApp
//
// Create by 周涛 on 2019/1/17.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit
import AVFoundation
import MediaPlayer

class ZTProgressSlider: UISlider {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = self.bounds.insetBy(dx: -3, dy: -40)
        if rect.contains(point) {
            return self
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds.insetBy(dx: -3, dy: -10)
        if rect.contains(point) {
            return true
        } else {
            return false
        }
    }
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return self.bounds
    }
}

class ZTProgressView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in self.subviews {
            //判断某个对象是某个类
            if view is ZTProgressSlider {
                let p = self.convert(point, to: view)
                if (view as! ZTProgressSlider).point(inside: p, with: event) {
                    return view
                }
                
            }
            
            //if view.isKind(of: ZTSlider) {}
        }
        return super.hitTest(point, with: event)
    }
}

@IBDesignable class ZTPlayerView: UIView {
    @IBOutlet var view: UIView!
    
    
    /**控制层视图*/
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var playOrPauseBtn: UIButton!
    @IBOutlet weak var nextVideoBtn: UIButton!
    @IBOutlet weak var lastVideoBtn: UIButton!
    @IBOutlet weak var exitFullScreenBtn: UIButton!
    @IBOutlet weak var likeVideoBtn: UIButton!
    @IBOutlet weak var shareVideoBtn: UIButton!
    @IBOutlet weak var moreOperationBtn: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var progressSlider:ZTProgressSlider!
    @IBOutlet weak var bufferProgressView: UIProgressView!
    @IBOutlet weak var progressView: ZTProgressView!
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var dragProgressLabel: UILabel!
    @IBOutlet weak var smallScreenTimeLabel: UILabel!
    @IBOutlet weak var backgroudView: UIView!
    
    @IBOutlet weak var loadingVideoImageView: UIImageView!
    @IBOutlet weak var fullScreenBtn: UIButton!
    @IBOutlet weak var dismissalBtn: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var brightnessBar: EYEBarView!
    @IBOutlet weak var volumeBar: EYEBarView!
    
    @IBOutlet weak var brightnessView: UIView!
    @IBOutlet weak var volumeView: UIView!
    
    private var videoInfoModel: VideoInfoModel!
    
    private var isFullScreen: Bool = false {
        didSet {
            if isFullScreen {
                self.fullScreenBtn.isHidden = true
                self.smallScreenTimeLabel.isHidden = true
                self.dismissalBtn.isHidden = true
                self.exitFullScreenBtn.isHidden = false
                
            } else {
                self.fullScreenBtn.isHidden = false
                self.smallScreenTimeLabel.isHidden = false
                self.dismissalBtn.isHidden = false
                self.exitFullScreenBtn.isHidden = true
            }
            self.makeSubViewsConstraints()
        }
    }
    
    
    private var currentTime: CGFloat = 0
    private var seekTime: CGFloat = 0
    private var totalTime: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ZTPlayerView", bundle: bundle)
        self.view = (nib.instantiate(withOwner: self, options: nil).first as! UIView)
        self.view.frame = bounds
        
        self.addSubview(self.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ZTPlayerView", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        self.view.frame = bounds
        //self.view = Bundle.main.loadNibNamed("ZTPlayerView", owner: self, options: nil)?.first as? UIView
        self.addSubview(self.view)
    }
    
    /**配置模型数据*/
    func configVideoInfoModel(videoInfoModel: VideoInfoModel) {
        self.videoInfoModel = videoInfoModel
        self.playerItem = AVPlayerItem(url: videoInfoModel.videoURL)
        self.player = AVPlayer(playerItem: self.playerItem)
        self.playLayer = AVPlayerLayer(player: self.player)
    }
    
    func beginPlayer() {
        assert(self.videoInfoModel != nil, "error videoInfoModel is nil")
        
        self.coverImageView.yy_setImage(with: self.videoInfoModel.videoCoverImageURL, options: YYWebImageOptions.progressiveBlur)
        
        
        self.videoTitleLabel.text = self.videoInfoModel.videoTitle
        self.totalTime = CGFloat(self.videoInfoModel.videoTotalTime)
        self.totalTimeLabel.text = self.timeStringWithTime(times: Int(self.totalTime))
        self.playLayer = AVPlayerLayer(player: self.player)
        self.playLayer?.frame = CGRect(x: 0, y: 0, width: UIConstant.SCREEN_WIDTH, height: UIConstant.SCREEN_WIDTH * UIConstant.PLAYVIEW_H_W_IN_VERTICAL)
        // AVLayerVideoGravityResize,       // 非均匀模式。两个维度完全填充至整个视图区域
        // AVLayerVideoGravityResizeAspect,  // 等比例填充，直到一个维度到达区域边界
        // AVLayerVideoGravityResizeAspectFill, // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
        if self.playLayer != nil {
            self.playLayer?.videoGravity = .resizeAspect
            //在xib中不要设置playView的背景色，不然整个layer的背景色变为设置颜色，在插入playLayer后不能正常显示，所以应该在其storyboard中进行设置
            self.layer.insertSublayer(self.playLayer!, at: 0)
        }
        self.addObserversAndNotification()
        self.progressSlider.maximumValue = Float(self.totalTime)
        self.player.play()
    }
    
    func closePlayer() {
        self.player.pause()
        self.removeObserverAndNotification()
        //self.player.removeTimeObserver(self.player)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // assert(self.videoInfoModel == nil, "error videoInfoModel is nil")
        self.progressSlider.thumbTintColor = UIColor.clear
        progressSlider.setThumbImage(UIImage(named: "ic_slider_thumb"), for: UIControlState.normal)
        self.configureVolume()
    }
    
    deinit {
        print("ZTPlayerView deinit")
        
    }
    
    //MARK: -播放状态
    enum PlayerState {
        case playerStateBuffering  //缓冲中
        case playerStatePlaying    //播放中
        case playerReadyToPlay     //准备播放
        case playerStateComplete    //播放完成
        case playerStatePause      //暂停播放
        case playerStateFailed     //播放失败
    }
    var playerState: PlayerState = PlayerState.playerStateBuffering
    
    //MARK: -滑动方向
    private enum PanDirection {
        case HorizontalMoved //水平移动 控制进度
        case VerticalMoved //纵向移动 控制音量或亮度
    }
    private var panDirection: PanDirection = PanDirection.HorizontalMoved
    
    private var playerItem: AVPlayerItem!
    private var player: AVPlayer!
    private var playLayer: AVPlayerLayer!
    
    //MARK: -通知,滑动手势及事件添加
    private func addObserversAndNotification() {
        //监听设备方向
        NotificationCenter.default.addObserver(self, selector: #selector(receivedRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        //app退出到后台通知
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        //app进入前台
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterForeground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        //滑动手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(pan:)))
        self.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapShowORHideControlViewAction(_:)))
        self.addGestureRecognizer(tapGesture)
        
        //播放按钮点击事件
        self.playOrPauseBtn.addTarget(self, action: #selector(playOrPauseAction(_:)), for: UIControlEvents.touchUpInside)
        
        self.fullScreenBtn.addTarget(self, action: #selector(enterFullScreenAction(_:)), for: UIControlEvents.touchUpInside)
        
        self.exitFullScreenBtn.addTarget(self, action: #selector(exitFullScreenAtion(_:)), for: UIControlEvents.touchUpInside)
        
        self.progressSlider.addTarget(self, action: #selector(beginTouch(_:)), for: UIControlEvents.touchDown)
        self.progressSlider.addTarget(self, action: #selector(moveTouch(_:)), for: UIControlEvents.valueChanged)
        self.progressSlider.addTarget(self, action: #selector(endTouch(_:)), for: UIControlEvents.touchUpInside)
        
        self.addPeriodicTimeRefresh()
        
        
        //监听播放状态
        self.player.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        self.player.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        self.player.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayDidEnd(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        
    }
    
    /**取消注册通知和观察者*/
    private func removeObserverAndNotification() {
        //移除观察者
        NotificationCenter.default.removeObserver(self)
        
        // 移除观察者
        self.player.currentItem?.removeObserver(self, forKeyPath: "status")
        self.player.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.player.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if change == nil {return}
        if keyPath == "status" {
            guard let rawValue = change![NSKeyValueChangeKey.newKey] as? Int else {return}
            let status = AVPlayerItem.Status(rawValue: rawValue) ?? AVPlayerItem.Status.unknown
            switch status {
            case .readyToPlay:
                self.coverImageView.isHidden = true
                self.playerState = .playerStatePlaying
                self.showcontrolViewAnimation()
                self.player.play()
                self.stopLoadingAnimation()
                break
            case .failed:
                self.playerState = .playerStateFailed
                assertionFailure("视频播放出错")
                
                break
            case .unknown:
                self.playerState = .playerStateBuffering
                self.player.pause()
                self.startLoadingAnimation()
                self.controlView.isHidden = true
                break
            }
        } else if keyPath == "loadedTimeRanges" {
            let timeInterval = bufferDuration()
            let totalDuration = self.totalTime
            self.bufferProgressView.setProgress(Float(timeInterval) / Float(totalDuration), animated: false)
        } else if keyPath == "playbackLikelyToKeepUp" {
            if !self.playerItem.isPlaybackLikelyToKeepUp {
                self.playerState = .playerStateBuffering
                self.player.pause()
                self.startLoadingAnimation()
                self.controlView.isHidden = true
            } else {
                if self.playerState == .playerStateBuffering {
                 self.playerState = .playerStatePlaying
                 self.showcontrolViewAnimation()
                 self.player.play()
                 self.stopLoadingAnimation()
                }
 
            }
        }
    }
    
    /**周期性时间跟新*/
    private func addPeriodicTimeRefresh() {
        
        self.player.addPeriodicTimeObserver(forInterval: CMTime.init(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self](time) in
            guard  let `self` = self else {return}
            
            
            if !self.isSeeking {
                self.currentTime = CGFloat(time.seconds)
                if self.isFullScreen {
                    
                    let currentTimeString = self.timeStringWithTime(times: Int(time.seconds))
                    self.currentTimeLabel.text = currentTimeString
                    
                } else {
                    let totalTimeString = self.timeStringWithTime(times: Int(self.totalTime))
                    let currentTimeString = self.timeStringWithTime(times: Int(time.seconds))
                    self.smallScreenTimeLabel.text = String(format: "%@ / %@", currentTimeString, totalTimeString)
                }
                self.progressSlider.value = Float(time.seconds)
            }
        }
    }
    
    //设备发生旋转
    @objc private func receivedRotation() {
        let currentOrientation = UIDevice.current.orientation
        switch currentOrientation {
        case .portrait:
            //屏幕直立
            
            self.frame = CGRect(x: 0, y: 0, width: UIConstant.SCREEN_WIDTH, height: UIConstant.SCREEN_WIDTH * UIConstant.PLAYVIEW_H_W_IN_VERTICAL)
            self.playLayer.frame = self.bounds
            self.isFullScreen = false
            
            break
        case .landscapeLeft:
            //屏幕左在上方
            
            self.frame = UIScreen.main.bounds
            self.playLayer.frame = self.bounds
            
            self.isFullScreen = true
            break
        case .landscapeRight:
            
            //屏幕右在上方
            
            self.frame = UIScreen.main.bounds
            self.playLayer.frame = self.bounds
            
            self.isFullScreen = true
            break
        default:
            break
        }
    }
    
    
    //MARK: -播放完成
    /*
     * item播放完毕通知
     */
    @objc private func moviePlayDidEnd(note:Notification){
        self.playerState = .playerStateComplete
        self.playOrPauseBtn.setImage(UIImage(named: "Action_reload_player"), for: UIControlState.normal)
        self.controlView.isHidden = false
        
        
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
    
    /**播放或暂停*/
    @objc private func playOrPauseAction(_ sender: UIButton) {
        switch self.playerState {
        case .playerStatePause:
            self.playerState = .playerStatePlaying
            self.player.play()
            sender.setImage(UIImage(named: "action_player_pause"), for: UIControlState.normal)
            break
        case .playerStatePlaying:
            self.playerState = .playerStatePause
            self.player.pause()
            sender.setImage(UIImage(named: "action_player_play"), for: UIControlState.normal)
            break
        case .playerStateComplete:
            sender.setImage(UIImage(named: "action_player_pause"), for: UIControlState.normal)
            self.player.seek(to: CMTime(seconds: 0, preferredTimescale: 1)) { [weak self](_) in
                self?.player.play()
                self?.progressSlider.value = 0
                self?.delayHidden()
            }
            break 
        default:
            break
        }
    }
   
    /**进入全屏*/
    @objc private func enterFullScreenAction(_ sender: UIButton) {
        EYEDeviceTool.interfaceOrientation(.landscapeRight)
    }
    
    /**退出全屏*/
    @objc private func exitFullScreenAtion(_ sender: UIButton) {
        EYEDeviceTool.interfaceOrientation(.portrait)
    }
    
    //MARK: -滑动条拉动
    private var isSeeking = false
    @objc private func beginTouch(_ sender: ZTProgressSlider) {
        self.isSeeking = true
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hidecontrolViewAnimation), object: nil)
        self.seekTime = CGFloat(sender.value)
    }
    
    @objc private func moveTouch(_ sender: ZTProgressSlider) {
        self.seekTime = CGFloat(sender.value)
        self.isSeeking = true
        if isFullScreen {
            
            self.currentTimeLabel.text = self.timeStringWithTime(times: Int(self.seekTime))
        } else {
            let seekTimeString = self.timeStringWithTime(times: Int(self.seekTime))
            
            let totalTimeString = self.timeStringWithTime(times: Int(self.totalTime))
            
            self.smallScreenTimeLabel.text = String(format: "%@ / %@", seekTimeString, totalTimeString)
        }
        
    }
    
    @objc private func endTouch(_ sender: ZTProgressSlider) {
        
        self.currentTime = self.seekTime
        
        self.player.seek(to: CMTimeMakeWithSeconds(Float64(self.currentTime), Int32(NSEC_PER_SEC))) { [weak self](_) in
            self?.isSeeking = false
            print("is seeking = false")
            self?.delayHidden()
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
            let velocity = pan.velocity(in: self)
            let locationPoint = pan.location(in: self)
            let vX = fabs(velocity.x)
            let vY = fabs(velocity.y)
            if vX > vY {
                self.panDirection = .HorizontalMoved
                
                if isFullScreen {
                    self.dragProgressLabel.isHidden = false
                    self.controlView.isHidden = true
                }
            } else if vX < vY && isFullScreen{
                self.panDirection = .VerticalMoved
                if locationPoint.x < self.width / 2 {
                    self.isVolume = true
                    self.volumeView.isHidden = false
                    
                    
                } else {
                    self.isVolume = false
                    self.brightnessView.isHidden = false
                    
                }
            }
        case .changed:
            switch self.panDirection {
            case .HorizontalMoved:
                let translationX = pan.translation(in: self).x
                self.horizontalMoved(value: translationX)
                break
            case .VerticalMoved:
                let velocity = pan.velocity(in: self)
                
                verticalMoved(value: velocity.y)
                
                
                break
            }
            break
        case .ended,.cancelled:
            switch self.panDirection {
            case .HorizontalMoved:
                if isFullScreen {
                    self.dragProgressLabel.isHidden = true
                   
                    self.player.seek(to: CMTime(seconds: Double(self.seekTime), preferredTimescale: CMTimeScale(1))) { (_) in
                        
                    }
                    self.showcontrolViewAnimation()
                }
                break
            case .VerticalMoved:
                if isVolume {
                    self.volumeView.isHidden = true
                } else {
                     self.brightnessView.isHidden = true
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
        
        
        let moveTime = (value * 150) / (self.width)
        self.seekTime = self.currentTime + moveTime
        let totalTimeString = self.timeStringWithTime(times: Int(totalTime))
        let seekTimeString = self.timeStringWithTime(times: Int(self.seekTime))
        
        if isFullScreen {
            if value < 0 {
                style = "<<"
            } else if value > 0{
                style = ">>"
            } else {return}
            
            self.dragProgressLabel.text = String(format: "%@ %@ / %@", style, seekTimeString, totalTimeString)
        }
    
    }
    
    
    private var currentVolume: CGFloat = 0
    private var currentBrightness: CGFloat = 0
    
    /**手势纵向移动*/
    private func verticalMoved(value: CGFloat) {
        if self.isVolume {
            self.currentVolume -= (value / 10000.0)
            self.volumeSlider.value = Float(self.currentVolume)
            self.volumeBar.setBarValue(value: self.currentVolume)
            
        } else {
            
            self.currentBrightness -= (value / 10000.0)
            UIScreen.main.brightness = self.currentBrightness
            self.brightnessBar.setBarValue(value: self.currentBrightness)
        }
    }
    
    private var volumeSlider: UISlider!
    /**配置音量及亮度*/
    private func configureVolume() {
    
        let mpVolumeView = MPVolumeView()
        self.volumeSlider = nil
        for view in mpVolumeView.subviews {
            if NSStringFromClass(view.classForCoder) == "MPVolumeSlider" {
                self.volumeSlider = view as? UISlider
                break
            }
        }
        mpVolumeView.showsRouteButton = false
        volumeSlider.tintColor = UIColor.clear //将thumb变为不可见
        volumeSlider.isHidden = true
        volumeSlider.frame = CGRect.zero
       
        self.volumeBar.addSubview(volumeSlider)
        self.currentVolume = CGFloat(self.volumeSlider!.value)
        
        self.volumeBar.setBarValue(value: self.currentVolume)
        
        
        
        self.currentBrightness = UIScreen.main.brightness
        self.volumeBar.setBarValue(value: self.currentBrightness)
        
    }
    
    /**显示控制层控制按钮动画*/
    func showcontrolViewAnimation() {
        
        self.progressSlider.setThumbImage(UIImage(named: "ic_slider_thumb"), for: UIControlState.normal)
        self.controlView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.controlView.alpha = 1
            
            
        }) { [unowned self](_) in
            self.delayHidden()
            
        }
    }
    
    /**隐藏控制层按钮动画*/
    @objc func hidecontrolViewAnimation() {
        self.progressSlider.setThumbImage(nil, for: UIControlState.normal)
        self.progressSlider.thumbTintColor = UIColor.clear
        UIView.animate(withDuration: 0.2, animations: {
            self.controlView.alpha = 0
        }) { [weak self](_) in
           self?.controlView.isHidden = true
        }
    }
    
    //延迟隐藏
    private func delayHidden(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hidecontrolViewAnimation), object: nil)
        self.perform(#selector(hidecontrolViewAnimation), with: nil, afterDelay: 3)
    }
    
    //开始加载动画
    func  startLoadingAnimation() {
        self.loadingVideoImageView.isHidden = false
        self.playOrPauseBtn.isHidden = true
       
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.repeatCount = Float.infinity
        animation.fillMode = kCAFillModeForwards
        self.loadingVideoImageView.layer.add(animation, forKey: "loading_Video")
    }
    
    func stopLoadingAnimation() {
        self.playOrPauseBtn.isHidden = false
        self.loadingVideoImageView.layer.removeAnimation(forKey: "loading_Video")
        self.loadingVideoImageView.isHidden = true
        
    }
    
    
    private func makeSubViewsConstraints() {
        
        for cons in self.currentTimeLabel.constraints {
            if cons.identifier == "currentTimeLabelWidth" {
                if isFullScreen {
                    cons.constant = 70
                } else {
                    cons.constant = 0
                }
                break
            }
            
        }
        
        for cons in self.totalTimeLabel.constraints {
            if cons.identifier == "totalTimeLabelWidth" {
                if isFullScreen {
                    cons.constant = 70
                } else {
                    cons.constant = 0
                }
                break
            }
        }
        
        
        for cons in self.controlView.constraints {
            if cons.identifier == "progressViewBottomDistance" {
                if isFullScreen {
                    cons.constant = 15
                } else {
                    cons.constant = 0
                }
               break
            }
            
            
        }
        
        self.setNeedsLayout()
        
    }
    
    @objc private func tapShowORHideControlViewAction(_ gestureRecognizer: UITapGestureRecognizer ) {
        guard let view = gestureRecognizer.view else {return}
        if view.tag == 1 {
            self.hidecontrolViewAnimation()
            view.tag = 0
        } else {
            self.showcontrolViewAnimation()
            view.tag = 1
        }
    }
}
