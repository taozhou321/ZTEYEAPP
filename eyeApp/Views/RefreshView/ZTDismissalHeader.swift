//
// ZTDismissalHeader.swift
// eyeApp
//
// Create by 周涛 on 2019/1/16.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

import UIKit
protocol DismissalDelegate {
    func dismissal() 
}


class ZTDismissalHeader: ZTRefreshComponent {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var stackView: UIView!
    
    
    var dismissalDelegate: DismissalDelegate?
    //let distance: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label1.alpha = 0
        self.label2.alpha = 0
        self.label3.alpha = 0
        self.label4.alpha = 0
        self.label5.alpha = 0
        self.label6.alpha = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.y = -self.height
    }
    

    
    override var state: ZTRefreshState {
        didSet {
            if self.state == oldValue {return}
            if self.state == .ZTRefreshStateIdle && oldValue == .ZTRefreshStateRefreshing {
                
                UIView.animate(withDuration: self.hideTimeInterval, animations: {
                    self.scrollView.insetTop = self.scrollViewOriginalInset.top
                    
                }) { (finished) in
                    self.transform = CGAffineTransform.identity
                    self.pullingPercent = 0
                }
            } else if self.state == .ZTRefreshStateRefreshing {
               // self.scrollView.insetTop = self.height + self.scrollViewOriginalInset.top
                //通知控制器dismissal
                print("ZTDismissalHeader")
                self.dismissalDelegate?.dismissal()
            }
        }
    }
    
    
    override func scrollViewContentOffsetDidChange(change: Dictionary<NSKeyValueChangeKey, Any>?) {
        super.scrollViewContentOffsetDidChange(change: change)
        if change == nil {return}
        guard  let offset = (change![NSKeyValueChangeKey.newKey]) as? CGPoint else {return}
        let offsetY = offset.y
        /**发生偏移时的offsetY*/
        let happenOffsetY = -self.scrollViewOriginalInset.top
        let thresholdOffsetY = happenOffsetY -  2 * self.height //判断状态改变的竖直方向上的阀值
        if offsetY > happenOffsetY {return}
        let pullingPercent = (happenOffsetY - offsetY - self.height) / ( self.height)
        let translation = offsetY + self.height - happenOffsetY
        if translation <= 0 {
            self.transform = CGAffineTransform(translationX: 0, y: offsetY + self.height)
        }
        if pullingPercent <= 0 {
            
            self.label1.alpha = 0
            self.label2.alpha = 0
            self.label3.alpha = 0
            self.label4.alpha = 0
            self.label5.alpha = 0
            self.label6.alpha = 0
            
        }
        
        if self.scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .ZTRefreshStateIdle {
                if pullingPercent > 0 {
                    showDismissalLabel(percent: pullingPercent)
                }
            }
            if self.state == .ZTRefreshStateIdle && offsetY <=  thresholdOffsetY {
                self.state = .ZTRefreshStatePulling
            } else if self.state == .ZTRefreshStatePulling && thresholdOffsetY < offsetY {
                self.state = .ZTRefreshStateIdle
            }
        } else if self.state == .ZTRefreshStatePulling {
            self.state = .ZTRefreshStateRefreshing
        } else if self.state == .ZTRefreshStateIdle && pullingPercent < 1 {
            self.pullingPercent = pullingPercent
            showDismissalLabel(percent: pullingPercent)
        }
        
    }
    
    private func showDismissalLabel(percent: CGFloat) {
        //let tmp = Int(percent * 10)
       // self.transform = CGAffineTransform(translationX: 0, y: 0.5 * self.height * (percent - 0.4))
        let a: CGFloat = 1.0/6.0
        switch percent {
        case 0..<a:
            self.label1.alpha = (percent) * 10
            self.label2.alpha = 0
            self.label3.alpha = 0
            self.label4.alpha = 0
            self.label5.alpha = 0
            self.label6.alpha = 0
            break
        case a..<2*a:
            self.label1.alpha = 1
            self.label2.alpha = (percent - a) * 10
            self.label3.alpha = 0
            self.label4.alpha = 0
            self.label5.alpha = 0
            self.label6.alpha = 0
            break
        case 2*a..<3*a:
            self.label1.alpha = 1
            self.label2.alpha = 1
            self.label3.alpha = (percent - 2*a) * 10
            self.label4.alpha = 0
            self.label5.alpha = 0
            self.label6.alpha = 0
            break
        case 3*a..<4*a:
            self.label1.alpha = 1
            self.label2.alpha = 1
            self.label3.alpha = 1
            self.label4.alpha = (percent - 3*a) * 10
            self.label5.alpha = 0
            self.label6.alpha = 0
            break
        case 4*a..<5*a:
            self.label1.alpha = 1
            self.label2.alpha = 1
            self.label3.alpha = 1
            self.label4.alpha = 1
            self.label5.alpha = (percent - 4*a) * 10
            self.label6.alpha = 0
            break
        case 5*a...1:
            self.label1.alpha = 1
            self.label2.alpha = 1
            self.label3.alpha = 1
            self.label4.alpha = 1
            self.label5.alpha = 1
            self.label6.alpha = (percent - 5*a) * 10
            break
        default:
           
            break
        }
    }
    
}
