//
// ZTPlayerController.swift
// eyeApp
//
// Create by 周涛 on 2019/1/21.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

class ZTPlayerViewController: UIViewController {
    @IBOutlet weak var playerViewss: ZTPlayerView!
    
    private var dataModel: Any!
    private var dataModelType: String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!
    
    private var videoInfoModel: VideoInfoModel!
    
    func initialModelData(dataModel: Any, type: String) {
        self.dataModel = dataModel
        self.dataModelType = type
        switch self.dataModelType{
        case "followCard":
            let followCardModel = self.dataModel as! FollowCardModel
            let urlStr = followCardModel.data.content.data.playUrl
            let videoTitle = followCardModel.data.content.data.title
            let durationTime = followCardModel.data.content.data.duration
            let videoBackgroundImageStr = followCardModel.data.content.data.cover!.blurred
            let videoCoverImageStr = followCardModel.data.content.data.cover!.feed
            self.videoInfoModel = VideoInfoModel.init(videoURL: URL(string: urlStr!)!, videoTitle: videoTitle!, videoTotalTime: durationTime, videoBackgroundImageURL: URL(string: videoBackgroundImageStr!)!, videoCoverImageURL: URL(string: videoCoverImageStr!)!)
                
               // VideoInfoModel.init(videoURL: URL(string: urlStr!)!, videoTitle: videoTitle!, videoTotalTime: durationTime)
            
            break
        case "videoSmallCard":
            let videoSmallCardModel = self.dataModel as! VideoSmallCardModel
            let urlStr = videoSmallCardModel.data.playUrl
            let videoTitle = videoSmallCardModel.data.title
            let durationTime = videoSmallCardModel.data.duration
            let videoBackgroundImageStr = videoSmallCardModel.data.cover!.blurred
            let videoCoverImageStr = videoSmallCardModel.data.cover!.feed
            self.videoInfoModel = VideoInfoModel.init(videoURL: URL(string: urlStr!)!, videoTitle: videoTitle!, videoTotalTime: durationTime, videoBackgroundImageURL: URL(string: videoBackgroundImageStr!)!, videoCoverImageURL: URL(string: videoCoverImageStr!)!)
           
            break
        default:
            break
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerViewss.configVideoInfoModel(videoInfoModel: self.videoInfoModel)
        self.bgImageView.yy_setImage(with: self.videoInfoModel?.videoBackgroundImageURL, options: YYWebImageOptions.progressiveBlur)
        tableView.delegate = self
        tableView.dataSource = self
        
        //*****如果设置了atuoresizesubviews 为true需要将其变为false,因为viewdidload调用时，uistoryboard使用的约束布局需要在viewwilllayoutsubviews之后的layoutsubviews才能显示正确的frame,若设置了atuoresizesubviews为true会导致子视图的frame发生变化，切记，切记，切记，我的半天就这么不在了，~~~~(>_<)~~~~
        let dismissalHeader = Bundle.main.loadNibNamed("ZTDismissalHeader", owner: nil, options: nil)?.first as! ZTDismissalHeader
        dismissalHeader.frame =  CGRect(x: 0, y: 0, width: UIConstant.SCREEN_WIDTH, height: 30)
        dismissalHeader.dismissalDelegate = self
        
        self.tableView.header = dismissalHeader
        self.addTargetEvent()
        self.playerViewss.beginPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.allowRotation = true
        }
        if self.playerViewss.playerState == .playerStateBuffering {
            self.playerViewss.startLoadingAnimation()
        }
    
    }
    
    private func addTargetEvent() {
        self.playerViewss.dismissalBtn.addTarget(self, action: #selector(exitInterface), for: UIControlEvents.touchUpInside)
    }
   
    @objc func exitInterface() {
        self.playerViewss.closePlayer()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.allowRotation = true
        }
        self.dismiss(animated: true) {
            
        }
    }
    
    /**时间转化*/
    private func timeStringWithTime(times: Int) -> String{
        let min = times / 60
        let sec = times % 60
        let timeString = String(format: "%02zd:%02zd", min, sec)
        return timeString
    }
}

extension ZTPlayerViewController: UITableViewDataSource {
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

extension ZTPlayerViewController: UITableViewDelegate {
    
}


extension ZTPlayerViewController: DismissalDelegate {
    func dismissal() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.allowRotation = false
        }
        self.playerViewss.closePlayer()
        //self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true) {
            
            //self.removeObserverAndNotification()
            
        }
    }
}
