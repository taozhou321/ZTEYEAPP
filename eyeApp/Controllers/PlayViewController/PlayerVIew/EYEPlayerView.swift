//
// EYEPlayerView.swift
// eyeApp
//
// Create by 周涛 on 2019/1/9.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit
import MediaPlayer
class ZTSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return self.bounds
        //return super.trackRect(forBounds: bounds)
    }
}

@IBDesignable class EYEPlayerView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var action_likeBtn: UIButton!
    @IBOutlet weak var action_shareBtn: UIButton!
    @IBOutlet weak var action_moreBtn: UIButton!
    @IBOutlet weak var action_playBtn: UIButton!
    @IBOutlet weak var action_nextBtn: UIButton!
    @IBOutlet weak var action_lastBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var action_zoomBtn: UIButton!
    @IBOutlet weak var loading_Imageview: UIImageView!
    @IBOutlet weak var volunmeBar: EYEBarView!
    @IBOutlet weak var brightnessBar: EYEBarView!
    @IBOutlet weak var brightnessPlusIcon: UIImageView!
    @IBOutlet weak var brightnessMinusIcon: UIImageView!
    @IBOutlet weak var volumePlusIcon: UIImageView!
    @IBOutlet weak var volumeMinusIcon: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var slider: ZTSlider!
    /*lazy var slider: ZTSlider = {
        let slider: ZTSlider = ZTSlider(frame: progressView.bounds)
        slider.setThumbImage(UIImage(named: "ic_slider_thumb"), for: UIControlState.normal)
        return slider
    }()*/
    
    //weak var refreshDelegate: BarViewRefreshDelegate?
    
    private var isShowControlBtn: Bool = true
    private var volumeSlider: UISlider!
    var isFullScreen: Bool = false {
        didSet {
            self.makeSubViewsConstraints()
            //设置哪些控件在全屏下能显示哪些不能显示
            if !self.isFullScreen {
                self.setVolumeCtrlHidden(isHidden: true)
                self.setBrightnessCtrlHidden(isHidden: true)
                self.dismissBtn.setImage(UIImage(named: "ic_video_dismiss"), for: UIControlState.normal)
                self.action_zoomBtn.isHidden = false
                self.timeLabel.isHidden = false
            } else {
                self.setVolumeCtrlHidden(isHidden: false)
                self.setBrightnessCtrlHidden(isHidden: false)
                self.dismissBtn.setImage(UIImage(named: "ic_Zoomout_screen_white"), for: UIControlState.normal)
                self.action_zoomBtn.isHidden = true
                self.timeLabel.isHidden = true
            }
            
            
        }
    }
    
    /**设置音量控件透明度*/
    func setVolumeCtrl(alpha: CGFloat) {
        self.volumePlusIcon.alpha = alpha
        self.volunmeBar.alpha = alpha
        self.volumeMinusIcon.alpha = alpha
    }
    /**设置音量控件是否隐藏*/
    func setVolumeCtrlHidden(isHidden: Bool) {
        self.volumePlusIcon.isHidden = isHidden
        self.volunmeBar.isHidden = isHidden
        self.volumeMinusIcon.isHidden = isHidden
    }
    
    /**设置亮度控件透明度*/
    func setBrightnessCtrl(alpha: CGFloat) {
        self.brightnessPlusIcon.alpha = alpha
        self.brightnessBar.alpha = alpha
        self.brightnessMinusIcon.alpha = alpha
    }
    /**设置亮度控件是否隐藏*/
    func setBrightnessCtrlHidden(isHidden: Bool) {
        self.brightnessPlusIcon.isHidden = isHidden
        self.brightnessBar.isHidden = isHidden
        self.brightnessMinusIcon.isHidden = isHidden
    }
    
    //使用IBDesignable时需要将override init(frame: CGRect)中的方法实现
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EYEPlayerView", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        self.view.frame = bounds
        self.addSubview(self.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EYEPlayerView", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        self.view.frame = bounds
        self.addSubview(self.view)
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setCtrlBtnAlpha(alpha: 0)
        self.setVolumeCtrl(alpha: 0)
        self.setBrightnessCtrl(alpha: 0)
        self.coverView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
        
        
        self.slider.thumbTintColor = UIColor.clear
        slider.setThumbImage(UIImage(named: "ic_slider_thumb"), for: UIControlState.normal)
        
        configureVolume()
        
        self.brightnessBar.setBarValue(value: UIScreen.main.brightness)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    
    
    @objc private func tapAction() {
        isShowControlBtn = !isShowControlBtn
        if isShowControlBtn {
            showAnimation()
        } else {
            hideAnimation()
        }
    }
    
    /**配置系统音量*/
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
        /**设置volumeSliderView的外观*/
        self.volunmeBar.addSubview(volumeSlider)
        self.volunmeBar.setBarValue(value: CGFloat(self.volumeSlider!.value))
        
    }
    
    func getCurrentVolume() -> CGFloat{
        
        return CGFloat(self.volumeSlider.value)
    }
    
    //开始加载动画
    func  startLoadingAnimation() {
        self.loading_Imageview.isHidden = false
        self.coverView.alpha = 0.3
        //self.setCtrlBtnHidden(isHidden: true)
        if self.isFullScreen {
            self.setVolumeCtrlHidden(isHidden: true)
            self.setBrightnessCtrlHidden(isHidden: true)
        }
        
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.repeatCount = Float.infinity
        animation.fillMode = kCAFillModeForwards
        self.loading_Imageview.layer.add(animation, forKey: "loading_Video")
    }
    
    func stopLoadingAnimation() {
        self.coverView.alpha = 0
        //self.setCtrlBtnHidden(isHidden: false)
        if self.isFullScreen {
            self.setVolumeCtrlHidden(isHidden: false)
            self.setBrightnessCtrlHidden(isHidden: false)
        }
        self.loading_Imageview.layer.removeAnimation(forKey: "loading_Video")
        self.loading_Imageview.isHidden = true
        
    }
    
    /**设置控制按钮透明度*/
    func setCtrlBtnAlpha(alpha: CGFloat) {
        self.action_lastBtn.alpha = alpha
        self.action_likeBtn.alpha = alpha
        self.action_moreBtn.alpha = alpha
        self.action_nextBtn.alpha = alpha
        self.action_playBtn.alpha = alpha
        self.action_shareBtn.alpha = alpha
        self.dismissBtn.alpha = alpha
        self.timeLabel.alpha = alpha
        self.action_zoomBtn.alpha = alpha
    }
    
    /**设置控制按钮是否可见*/
    private func setCtrlBtnHidden(isHidden: Bool) {
        self.action_lastBtn.isHidden = isHidden
        self.action_likeBtn.isHidden = isHidden
        self.action_moreBtn.isHidden = isHidden
        self.action_nextBtn.isHidden = isHidden
        self.action_playBtn.isHidden = isHidden
        self.action_shareBtn.isHidden = isHidden
        self.dismissBtn.isHidden = isHidden
        self.timeLabel.isHidden = isHidden
        self.action_zoomBtn.isHidden = isHidden
    }
    
    /**显示控制按钮动画*/
    func showAnimation() {
        self.slider.setThumbImage(UIImage(named: "ic_slider_thumb"), for: UIControlState.normal)
        self.setCtrlBtnHidden(isHidden: false)
        UIView.animate(withDuration: 0.2, animations: {
            self.setCtrlBtnAlpha(alpha: 1)
            self.setVolumeCtrl(alpha: 1)
            self.setBrightnessCtrl(alpha: 1)
            self.coverView.alpha = 0.3
            
            
        }) { [unowned self](_) in
            self.delayHidden()

        }
    }
    
    /**隐藏控制按钮动画*/
    @objc func hideAnimation() {
        self.slider.setThumbImage(nil, for: UIControlState.normal)
        self.slider.thumbTintColor = UIColor.clear
        UIView.animate(withDuration: 0.2, animations: {
            self.setCtrlBtnAlpha(alpha: 0)
            self.setVolumeCtrl(alpha: 0)
            self.setBrightnessCtrl(alpha: 0)
            self.coverView.alpha = 0
        }) { [unowned self](_) in
            self.setCtrlBtnHidden(isHidden: true)
        }
    }
    
    
    
    /**更新音量*/
    func changeVolume(value: CGFloat) {
        self.volumeSlider.value = Float(value)
        self.volunmeBar.setBarValue(value: value)
        
    }
    
    /**更新亮度*/
    func changeBrightness(value: CGFloat) {
        UIScreen.main.brightness = value
        self.brightnessBar.setBarValue(value: value)
        
    }
    
    //延迟隐藏
    private func delayHidden(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideAnimation), object: nil)
        self.perform(#selector(hideAnimation), with: nil, afterDelay: 3)
    }
    
    private func makeSubViewsConstraints() {
        for cons in self.view.constraints {
            if cons.identifier == "TimeLabelTopConstraintIdentifier" {
                
                print("TimeLabelTopConstraintIdentifier")
                
                self.view.removeConstraint(cons)
                break
            }
            if cons.identifier == "progressViewBottom" {
                self.view.removeConstraint(cons)
            }
        }
        
        for cons in self.currentTimeLabel.constraints {
            if cons.identifier == "currentTimeLabelWidth" {
                if isFullScreen {
                    cons.constant = 70
                } else {
                    cons.constant = 0
                }
            }
        }
        
        for cons in self.totalTimeLabel.constraints {
            if cons.identifier == "totalTimeLabelWidth" {
                if isFullScreen {
                    cons.constant = 70
                } else {
                    cons.constant = 0
                }
            }
        }
        
        
        if isFullScreen {
            let cons = NSLayoutConstraint(item: self.timeLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 15)
            cons.identifier = "TimeLabelTopConstraintIdentifier"
            self.view.addConstraint(cons)
            
            let cons2 = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.progressView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 30)
            cons2.identifier = "progressViewBottom"
            self.view.addConstraint(cons2)
            
        } else {
            let cons = NSLayoutConstraint(item: self.timeLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.action_playBtn, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -15)
            cons.identifier = "TimeLabelTopConstraintIdentifier"
            self.view.addConstraint(cons)
            
            let cons2 = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.progressView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            cons2.identifier = "progressViewBottom"
            self.view.addConstraint(cons2)
        }
    }
    

    deinit {
        ZTLog("EYEPlayerView deinit")
    }
}
