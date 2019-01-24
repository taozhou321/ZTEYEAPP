//
// HomePageController.swift
// eyeApp
//
// Create by 周涛 on 2018/10/9.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit
import SwiftyJSON

/// 头标签与绑定界面容器
fileprivate struct SegmentView {
    var headerView: UIView?
    var headerButtom: UIView?
    var bodyView: UIView?
    
    init(header: UIView, body:UIView, headerButtom: UIView?) {
        self.headerView = header
        self.bodyView = body
        self.headerButtom = headerButtom
    }
}

fileprivate struct SegmentContainer {
    var headerScrollView: UIScrollView!
    var bodyScrollView: UIScrollView!
    let buttomLineScrollView = UIScrollView()
    var segmentArray = [SegmentView]()
    var buttomLine: UIView = UIView()
    var showSegmentID: Int = 1//显示第几个标签 从0开始计数
    
    
    /// 添加新标签
    ///
    /// - Parameter segment: 标签容器
    /// - Returns: 是否添加成功
    func addSegment(segment: SegmentContainer) -> Bool {
        return true
    }
    
    //删除标签 从1开始
    mutating func removeSegment(index: Int) -> Bool {
        if index < 1 || index > self.segmentArray.count {
            return false
        }
        self.segmentArray.remove(at: index - 1)
        return true
    }
    
    //将顶部标签视图添加到控制器中
    func insertVC(vc: UIViewController, initSegmentIndex: Int) -> Bool {
        /*guard let nvc = vc.navigationController,let scrollDelegate = (vc as? UIScrollViewDelegate) else {return false}*/
        guard let scrollDelegate = (vc as? UIScrollViewDelegate) else {return false}

        
        if self.headerScrollView == nil || self.bodyScrollView == nil {
            return false
        }
        
        let headerFrame = CGRect(x: 0, y: UIConstant.STATUSBAR_HEIGHT, width: UIConstant.SCREEN_WIDTH, height: UIConstant.HEAD_HEIGHT)
        let bodyFrame = CGRect(x: 0, y: headerFrame.maxY, width: UIConstant.SCREEN_WIDTH, height: UIConstant.SCREEN_HEIGHT - headerFrame.maxY)
        setHeaderAndBodyView(headerFrame: headerFrame, bodyFrame: bodyFrame)
        
        let w = self.segmentW / 2
        buttomLine.frame = CGRect(x: (segmentW - w) / 2, y: headerFrame.height - CGFloat(lineHeight), width: w, height: lineHeight)
        buttomLine.backgroundColor = UIColor.darkGray
        
        self.headerScrollView.delegate = scrollDelegate
        self.bodyScrollView.delegate = scrollDelegate
        self.headerScrollView.addSubview(buttomLine)
        
        
        
        self.headerScrollView.contentOffset.x  = CGFloat(initSegmentIndex) * segmentW
        self.bodyScrollView.contentOffset.x = CGFloat(initSegmentIndex) * UIConstant.SCREEN_WIDTH
        self.buttomLine.origin.x = segmentW / 4  + CGFloat(initSegmentIndex) * segmentW
        
        return true
    }
    
    private func setHeaderAndBodyView(headerFrame: CGRect, bodyFrame: CGRect) {
        self.headerScrollView.showsVerticalScrollIndicator = false
        self.headerScrollView.showsHorizontalScrollIndicator = false
        //self.headerScrollView.isPagingEnabled = true
        self.bodyScrollView.isPagingEnabled = true
        self.bodyScrollView.showsHorizontalScrollIndicator = false
        self.bodyScrollView.showsVerticalScrollIndicator = false
        
        
        
        let segmentWidth: CGFloat = segmentW
        //headerFrame.width / CGFloat(showSegmentCount)
        let startX = headerFrame.origin.x
        for (n,container) in segmentArray.enumerated() {
            let header = container.headerView
            let body = container.bodyView
            header?.frame = CGRect(x: startX + CGFloat(n) * segmentWidth, y: 0, width: segmentWidth, height: headerFrame.height)
            
            body?.frame = CGRect(x: CGFloat(n) * UIConstant.SCREEN_WIDTH, y: 0, width: self.bodyScrollView.width, height: self.bodyScrollView.height)
            //body?.frame.origin.x = CGFloat(n) * UIConstant.SCREEN_WIDTH
            
            self.headerScrollView.addSubview(header!)
            self.bodyScrollView.addSubview(body!)
        }
        
        
        self.headerScrollView.contentSize = CGSize(width: segmentWidth * CGFloat(segmentArray.count), height:0)
        self.bodyScrollView.contentSize = CGSize(width: UIConstant.SCREEN_WIDTH * CGFloat(segmentArray.count), height: 0)
        
        
        
    }
    
    
    var segmentW: CGFloat {
        return (UIConstant.SCREEN_WIDTH - 80) / CGFloat(showSegmentCount)
    }
    
    //顶部页面能显示的标签数
    var showSegmentCount: Int {
        return 5
    }
    
    private var titleColor: UIColor {
        return UIColor.black
    }
    
    private var titleSelectedColor: UIColor {
        return UIColor.blue
    }
    
    private var bottomLineColor: UIColor {
        return titleSelectedColor
    }
    
    private var headerColor: UIColor {
        return UIColor.white
    }
    
    private var backgroundColor: UIColor {
        return UIColor.clear
    }
    
    private var lineHeight: CGFloat {
        return 3
    }
}

class EYEHomePageController: EYEBaseViewController, UIScrollViewDelegate {
    @IBOutlet weak var headScrollView: UIScrollView!
    
    @IBOutlet weak var bodyScrollView: EYEScrollView!
    
    fileprivate var segmentContainer: SegmentContainer = SegmentContainer()
    
    private var tabListModelArray: [EYETabListModel]?
    
    private var currentSegmentIndex = 1 //当前显示标签的索引
    
    private var errorPageView: EYEErrorPageView!
    private var loadingPageView: EYELoadingPageView!
    
   // private var  titles = [String]()
    override func viewDidLoad() {
       
        
        
        headScrollView.delegate = self
        bodyScrollView.delegate = self
        
        errorPageView = EYEErrorPageView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        errorPageView.addTarget(self, action: #selector(getHeadLabelData), for: UIControlEvents.touchUpInside)
        loadingPageView = EYELoadingPageView(frame: CGRect(x: 0, y: 0, width: 42, height: 28))
        
        getHeadLabelData()
    }
    
    
    
    private func installHeadView(titleArray: [String], headScrollView: UIScrollView, bodyScrollView: UIScrollView) {
        segmentContainer.headerScrollView = headScrollView
        segmentContainer.bodyScrollView = bodyScrollView
        
        for (n,title) in titleArray.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.tag = n
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
            tapGesture.numberOfTapsRequired = 1
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapGesture)
            
            var vc = UIViewController()
            if n == 1 {
                vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EYERecommendPageController")
            } else {
                vc.view.backgroundColor = ZTRandomColor()
            }
           
            vc.view.tag = n
            self.addChildViewController(vc)
            segmentContainer.segmentArray.append(SegmentView(header: label, body: vc.view, headerButtom: UIView()))
            
        }
        _ = segmentContainer.insertVC(vc: self, initSegmentIndex: self.currentSegmentIndex)
        
        
    }
    
    @objc private func tapGestureAction(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else {return}
        UIView.animate(withDuration: 0.3) {
            self.segmentContainer.buttomLine.frame.origin.x = view.frame.origin.x +
                self.segmentContainer.segmentW / 4
            self.segmentContainer.bodyScrollView.contentOffset.x = view.frame.origin.x / self.segmentContainer.segmentW * CGFloat(UIConstant.SCREEN_WIDTH)
        }
        self.currentSegmentIndex = view.tag
    }
    
    //MARK:- ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == segmentContainer.bodyScrollView {
            if UIConstant.forbidLeftScroll {
                UIConstant.forbidLeftScroll = false
                return
            }
            //scrollView.isScrollEnabled = false
            let bodyPoint = scrollView.contentOffset
            let headX = bodyPoint.x / UIConstant.SCREEN_WIDTH * segmentContainer.segmentW
            if (segmentContainer.headerScrollView.contentSize.width -  UIConstant.SCREEN_WIDTH) > headX {
                let headPoint = CGPoint(x: headX, y:
                    self.segmentContainer.headerScrollView.contentOffset.y)
                self.segmentContainer.headerScrollView.contentOffset = headPoint
            }
        
            segmentContainer.buttomLine.frame.origin.x = segmentContainer.segmentW / 4   +  headX
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        
        if scrollView == segmentContainer.bodyScrollView  {
            //scrollView.isScrollEnabled = true
            let bodyPoint = scrollView.contentOffset
            let n = Int ((bodyPoint.x + UIConstant.SCREEN_WIDTH / 2) / UIConstant.SCREEN_WIDTH)
            UIView.animate(withDuration: 0.3) {
                self.segmentContainer.buttomLine.frame.origin.x = self.segmentContainer.segmentW / 4 + CGFloat(n) * self.segmentContainer.segmentW
                if n < (self.segmentContainer.segmentArray.count - self.segmentContainer.showSegmentCount) {
                    self.segmentContainer.headerScrollView.contentOffset.x = CGFloat(n) * self.segmentContainer.segmentW }
                else {
                    self.segmentContainer.headerScrollView.contentOffset.x = CGFloat(self.segmentContainer.segmentArray.count - self.segmentContainer.showSegmentCount) * self.segmentContainer.segmentW
                }
                self.segmentContainer.bodyScrollView.contentOffset.x = CGFloat(n) * UIConstant.SCREEN_WIDTH
            }
            self.currentSegmentIndex = n
        }
        
    }
    
    //MARK:- 获取头部标签数据
    @objc private func getHeadLabelData() {
        //[unowned self]
        self.view.hideErrorPage(errorView: errorPageView)
        EYENetTools.share.request(type: .GET, urlStr: EYEAPIHelper.tabList, parameters: nil, progress: nil) { (result, error) in
            
            
            if error != nil || result == nil {
                self.view.showErrorPage(errorView: self.errorPageView)
                return
            }
            
            let json = JSON(rawValue: result!)
            guard let dataArry = json?.dictionaryValue["tabInfo"]?["tabList"].array else {return}
            let models = dataArry.map({ (dict) -> EYETabListModel in
                return EYETabListModel(dict: dict.rawValue as! NSDictionary)
            })
           /* guard let models = json?.dictionaryValue["tabInfo"]?["tabList"].array.map({ (dict) -> EYETabListModel in
                return EYETabListModel(dict: dict.rawValue as! NSDictionary)
            }) else {return}*/
            self.tabListModelArray = models
            if self.tabListModelArray != nil {
                let titles = self.tabListModelArray!.map({ return $0.title
                })
                
                self.installHeadView(titleArray: titles as! [String], headScrollView: self.headScrollView, bodyScrollView: self.bodyScrollView)
                
                //获取推荐的详细信息
                self.getDetailInfo(tabListModel: self.tabListModelArray![1])
            }
            
        }
    }
    
    //MARK:- 获取详细数据信息
    private func getDetailInfo(tabListModel :EYETabListModel) {
        self.view.hideErrorPage(errorView: self.errorPageView)
        self.view.showLoadingPage(loadingView: self.loadingPageView)
        
        /*EYENetTools.share.request(type: .GET, urlStr: tabListModel.apiUrlStr, parameters: nil, progress: nil) { (result, error) in
            if error != nil {
                self.view.showErrorPage(errorView: self.errorPageView)
                self.view.hideLoadingPage(loadingView: self.loadingPageView)
                return
            }
            
            //guard let json = JSON(rawValue: result!) else {return}
            let json = JSON(rawValue: result!)
            print(json ?? 0)
            
        }*/
        
        EYEAlamofireNetTools.request(httpMethod: EYERequestType.GET, url: tabListModel.apiUrlStr, parameters: nil, headers: nil) { (json, error) in
            
            //guard  let `self` = self else {return} [weak self]
            if error != nil {
                self.view.showErrorPage(errorView: self.errorPageView)
                self.view.hideLoadingPage(loadingView: self.loadingPageView)
                return
            }
            
            let dict = json?.dictionaryValue
            let model = RecommendedPageModel(dict: dict!)
           /*
           let testview = Bundle.main.loadNibNamed("SquareCardView", owner: nil, options: nil)?.first as! SquareCardView
            if model.itemTypeList!.first == "squareCardCollection" {
           testview.followCardModel =  (model.itemList?.first as? SquareCardModel)?.data.itemList?.first
                self.segmentContainer.segmentArray[self.currentSegmentIndex].bodyView?.addSubview(testview)
            }
            */
            self.view.hideLoadingPage(loadingView: self.loadingPageView)
            guard let vc = self.childViewControllers[1] as? EYERecommendPageController else {return}
            vc.recommendPageModel = model
            /*if model.itemTypeList!.first == "squareCardCollection" {
                vc.squareCardModel = model.itemList?.first as! SquareCardModel
            }*/
            
         }
        
        /*switch tabListModel.id {
        case -1:
            break
        case -2:
            break
        case 14:
            break
        case 36:
            break
        case 10:
            break
        case 28:
            break
        case 4:
            break
        case 2:
            break
        default:
            break
        }*/
    }
    
    
    //MARK:- 导航栏左右按钮
    @IBAction func rightNavBtnAction(_ sender: UIButton) {
        self.view.hideLoadingPage(loadingView: self.loadingPageView)
    }
    
    @IBAction func leftNavBtnAction(_ sender: UIButton) {
        self.view.showLoadingPage(loadingView: self.loadingPageView)
    }
    
    
    //MARK:- 异常处理
    
}
