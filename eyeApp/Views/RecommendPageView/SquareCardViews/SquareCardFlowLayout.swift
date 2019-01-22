//
// SquareCardFlowLayout.swift
// eyeApp
//
// Create by 周涛 on 2019/1/3.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit

class SquareCardFlowLayout: UICollectionViewFlowLayout {
    private var lastOffset = CGPoint(x: 0, y: 0)
    
    init(itemSize: CGSize) {
        super.init()
        self.itemSize = itemSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let step = self.itemSize.width + self.minimumLineSpacing
        //let sectionInsetLeft = self.sectionInset.left
        
        if proposedContentOffset.x > lastOffset.x {
            lastOffset.x = lastOffset.x + step
            
           // return CGPoint(x: lastOffset.x , y: proposedContentOffset.y)
        } else if lastOffset.x > proposedContentOffset.x {
            lastOffset.x = lastOffset.x - step
            if lastOffset.x < 0 {
                lastOffset.x = 0
            }
            
        } else {
            return proposedContentOffset
        }
        return CGPoint(x: lastOffset.x , y: proposedContentOffset.y)
       
        
        //
    }
}
