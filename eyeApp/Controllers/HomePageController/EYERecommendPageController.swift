//
// EYERecommendPageController.swift
// eyeApp
//
// Create by 周涛 on 2018/11/7.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import Foundation

class EYERecommendPageController: EYEBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
  //  private let squareCardWidth: CGFloat = UIConstant.SCREEN_WIDTH - 20
    //private let margin: CGFloat = 5
   // private let startX: CGFloat = 10
    //private var sections: Int = 0 //section数
    private var numberOfRowsInSectionArray : [Int] = [Int]() //section 0对应精选
   // private var originPoint: CGPoint?

    
    var recommendPageModel: RecommendedPageModel! {
        didSet {
            var section = 0
            numberOfRowsInSectionArray.removeAll()
            if self.recommendPageModel.itemTypeList == nil {return}
            
            for (n,type) in self.recommendPageModel.itemTypeList!.enumerated() {
                switch type {
                case .squareCardCollection:
                    numberOfRowsInSectionArray.append(1)
                    //sections += 1
                    //self.squareCardModel = self.recommendPageModel.itemList![n] as? SquareCardModel
                    break
                case .textCard:
                    
                    section += 1
                    numberOfRowsInSectionArray.append(1)
                    
                   // tmp = 0
                    break
                case .banner:
                    break
                case .videoSmallCard:
                    if section < numberOfRowsInSectionArray.count {
                     numberOfRowsInSectionArray[section] += 1
                    }
                    break
                case .followCard:
                    if section < numberOfRowsInSectionArray.count {
                        numberOfRowsInSectionArray[section] += 1
                    }
                    break
                }
            }
           
           self.tableView.reloadData()
        }
    }
    
    private var refreshHeaderView: ZTZoomRefreshHeader!
    private var refreshFooterView: ZTRefreshFooter!
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource  = self
    
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
        self.refreshHeaderView = ZTZoomRefreshHeader(frame: CGRect(x: 0, y: 0, width: UIConstant.SCREEN_WIDTH, height: 60))
        
        self.tableView.header = refreshHeaderView
       
        self.refreshFooterView = ZTRefreshFooter(frame: CGRect(x: 0, y: 0, width: UIConstant.SCREEN_WIDTH, height: 60))
        self.refreshFooterView.refreshDataDelegate = self
        self.tableView.footer = refreshFooterView
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
}

extension EYERecommendPageController: RefreshGetDataDelegate {
    func refreshGetData() {
        EYEAlamofireNetTools.request(httpMethod: EYERequestType.GET, url: self.recommendPageModel.nextPageUrl ?? "", parameters: nil, headers: nil) { (json, error) in
            if error != nil {
                if self.refreshHeaderView.state == ZTRefreshState.ZTRefreshStateRefreshing {
                    self.refreshHeaderView.state = ZTRefreshState.ZTRefreshStateIdle
                }
                if self.refreshFooterView.state == ZTRefreshState.ZTRefreshStateRefreshing {
                    self.refreshFooterView.state = ZTRefreshState.ZTRefreshStateIdle
                }
                return
            }
            if self.refreshHeaderView.state == ZTRefreshState.ZTRefreshStateRefreshing {
                self.refreshHeaderView.state = ZTRefreshState.ZTRefreshStateIdle
            }
            if self.refreshFooterView.state == ZTRefreshState.ZTRefreshStateRefreshing {
                self.refreshFooterView.state = ZTRefreshState.ZTRefreshStateIdle
            }
            let dict = json?.dictionaryValue
            let model = RecommendedPageModel(dict: dict!)
            self.recommendPageModel =  self.recommendPageModel.addNewRecommendedPageModel(newModel: model)
            
        }
    }
}


//MARK: UITableViewDelegate
extension EYERecommendPageController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= numberOfRowsInSectionArray.count {
            return 0
        }
        return numberOfRowsInSectionArray[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.sectionHeaderHeight))
        //view.backgroundColor = ZTRandomColor()
        return view
    }
    
    
}

//MARK: UITableViewDataSource
extension EYERecommendPageController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlStr: String?
        var title: String?
        var totalTime = 0
        
        if indexPath.section != 0 {
            //var index = numberOfRowsInSectionArray[indexPath.section]
            var index = 0 //计算显示的数据在recommendPageModel.itemTypeList中的位置
            for i in 0 ..< indexPath.section {
                index += numberOfRowsInSectionArray[i]
            }
            index += indexPath.row
            let type = self.recommendPageModel.itemTypeList![index]
            switch type {
            case  .textCard:
                guard let textCardModel = self.recommendPageModel.itemList![index] as? TextCardModel else {break}
               // urlStr = textCardModel.data.actionUrl
                
                break
            case .followCard:
                guard let followCardModel = self.recommendPageModel.itemList![index] as? FollowCardModel else {break}
                urlStr = followCardModel.data.content.data.playUrl
                title = followCardModel.data.header.title
                
                
                break
            case .videoSmallCard:
                guard let videoSmallCardModel = self.recommendPageModel.itemList![index] as? VideoSmallCardModel else {break}
                urlStr = videoSmallCardModel.data.playUrl
                title = videoSmallCardModel.data.title
                break
            default: break
            }
            guard let playerVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZTPlayerViewController") as? ZTPlayerViewController else {return}
            
            playerVC.initialModelData(dataModel: self.recommendPageModel.itemList![index], type: type.rawValue)
            //playerVC.initialData(urlString: urlStr!, videoTitle: title!)
            self.present(playerVC, animated: true, completion: nil)
        } /*else {
            //精选视图
            guard let squareCardModel = self.recommendPageModel.itemList![0] as? SquareCardModel else {return }
            
            
        }*/
        
        if urlStr != nil && title != nil {
            //let playerVC = EYEPlayerController(urlStr: urlStr!, title: title!)
           
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return numberOfRowsInSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var index = 0 //计算显示的数据在recommendPageModel.itemTypeList中的位置
        for i in 0 ..< indexPath.section {
            index += numberOfRowsInSectionArray[i]
        }
        index += indexPath.row
        let type = self.recommendPageModel.itemTypeList![index]
        switch type {
        case  .textCard:
           return 50
        case .followCard:
            return (UIConstant.SCREEN_WIDTH - 32) * 0.73
            
        case .videoSmallCard:
            return 150
            
        case .squareCardCollection:
            
            return 65 + (UIConstant.SCREEN_WIDTH - 32) * 0.73
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var aCell: UITableViewCell!
        if indexPath.section != 0 {
            //var index = numberOfRowsInSectionArray[indexPath.section]
            var index = 0 //计算显示的数据在recommendPageModel.itemTypeList中的位置
            for i in 0 ..< indexPath.section {
                index += numberOfRowsInSectionArray[i]
            }
            index += indexPath.row
            let type = self.recommendPageModel.itemTypeList![index]
            switch type {
            case  .textCard:
                guard let textCardModel = self.recommendPageModel.itemList![index] as? TextCardModel else {break}
                aCell = generateTextCardTableView(tableView, cellForRowAt: indexPath, textCardModel: textCardModel)
                
            break
            case .followCard:
                guard let followCardModel = self.recommendPageModel.itemList![index] as? FollowCardModel else {break}
                aCell = generateFollowCardTableView(tableView, cellForRowAt: indexPath, followCardModel: followCardModel)
            break
            case .videoSmallCard:
                guard let videoSmallCardModel = self.recommendPageModel.itemList![index] as? VideoSmallCardModel else {break}
                aCell = generateVideoSmallCardTableView(tableView, cellForRowAt: indexPath, videoSmallCardModel: videoSmallCardModel)
            break
            default: break
            }
            
        } else {
            //精选视图
            guard let squareCardModel = self.recommendPageModel.itemList![0] as? SquareCardModel else {return UITableViewCell()}
            aCell = generateSelectionTableView(tableView, cellForRowAt: indexPath, squareCardModel: squareCardModel)
            
        }
        if aCell == nil {
            return UITableViewCell()
        }
        return aCell
    }
    
    
    //生成精选视图
    func generateSelectionTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, squareCardModel: SquareCardModel) -> UITableViewCell {
        //var aCell: UITableViewCell?
        guard let aCell = tableView.dequeueReusableCell(withIdentifier: "SelectionViewCell") as? SelectionViewCell else {
            return UITableViewCell()
        }
        aCell.squareCardModel = squareCardModel
        aCell.presentPlayerVCDelegate = self
        
        return aCell
    }
    
    //生成followCard 视图
    func generateFollowCardTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, followCardModel: FollowCardModel) -> UITableViewCell {
        guard let aCell = tableView.dequeueReusableCell(withIdentifier: "FollowCardViewCell") as? FollowCardViewCell else {
            return UITableViewCell()
        }
        aCell.followCardModel = followCardModel
        return aCell
    }
    
    //生成textCard视图
    func generateTextCardTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, textCardModel: TextCardModel) -> UITableViewCell {
        guard let aCell = tableView.dequeueReusableCell(withIdentifier: "TextCardViewCell") as? TextCardViewCell else {
            return UITableViewCell()
        }
        aCell.textCardModel = textCardModel
        return aCell
    }
    
    //生成videoSmallCard视图
    func generateVideoSmallCardTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, videoSmallCardModel: VideoSmallCardModel) -> UITableViewCell {
        guard let aCell = tableView.dequeueReusableCell(withIdentifier: "VideoSmallCardViewCell") as? VideoSmallCardViewCell else {
            return UITableViewCell()
        }
        aCell.videoSmallCardModel = videoSmallCardModel
        return aCell
    }
}


extension EYERecommendPageController: PresentPlayerVCDelegate {
    func presentPlayerVC(model: Any, modelType: String) {
        guard let playerVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZTPlayerViewController") as? ZTPlayerViewController else {return}
        
        playerVC.initialModelData(dataModel: model, type: modelType)
        //playerVC.initialData(urlString: urlStr!, videoTitle: title!)
        self.present(playerVC, animated: true, completion: nil)
    }
}
