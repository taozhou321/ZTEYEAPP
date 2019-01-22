//
// SelectionViewCell.swift
// eyeApp
//
// Create by 周涛 on 2018/11/16.
// Copyright © 2018年 周涛. All rights reserved..
// github: https://github.com/taozhou321

import Foundation

protocol PresentPlayerVCDelegate {
    func presentPlayerVC(model: Any, modelType: String)
}

class SelectionViewCell: UITableViewCell {
    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var headSubTitle: UILabel!
    @IBOutlet weak var selectionCollectionView: UICollectionView! //精选视图
    var presentPlayerVCDelegate: PresentPlayerVCDelegate?
    
    var squareCardModel: SquareCardModel! {
        didSet {
            let header = squareCardModel.data.header
            
            self.headSubTitle.text = header.subTitle
            self.headTitle.text = header.title
            self.selectionCollectionView.delegate = self
            self.selectionCollectionView.dataSource = self
            //  计算selectionCollectionView中的itemSize的大小
            let itemWidth = UIConstant.SCREEN_WIDTH - 2 * 16
            let itemHeight: CGFloat = itemWidth * 0.73
            
            (self.selectionCollectionView.collectionViewLayout as? SquareCardFlowLayout)?.itemSize = CGSize(width: itemWidth, height: itemHeight)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SelectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.squareCardModel == nil {return 0}
        return self.squareCardModel.data.itemList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: squardCollectionCellidentifier, for: indexPath) as? SquareCardCollectionCell, let itemLists = self.squareCardModel.data.itemList  else {return UICollectionViewCell()}
        cell.followCardModel = itemLists[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let followCardModel =  self.squareCardModel.data.itemList?[indexPath.item] else {return}
       // let urlStr = followCardModel.data.content.data.playUrl
        //let title = followCardModel.data.header.title
       // if urlStr != nil && title != nil {
        
            self.presentPlayerVCDelegate?.presentPlayerVC(model: followCardModel, modelType: "followCard")
            //let playerVC = EYEPlayerController(urlStr: <#T##String#>, title: <#T##String#>)
       // }
    }
    
}
