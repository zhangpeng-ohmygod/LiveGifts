//
//  ZPGiftChannelView.swift
//  直播送礼物部件
//
//  Created by apple on 2021/4/11.
//

import UIKit

enum ZPGiftChannelState {
    case idle
    case animating
    case willEnd
    case endAnimating
}


class ZPGiftChannelView: UIView {

    
    var bgView :UIView!
    var iconImageView :UIImageView!
    var senderLabel :UILabel!
    var giftDescLabel :UILabel!
    var giftImageView :UIImageView!
    var digitLabel :ZPGiftDigitLabel!
    
    fileprivate var cacheNumber : Int = 0
    fileprivate var currentNumber : Int = 0
    
    var state : ZPGiftChannelState = .idle
    
    var complectionCallback : ((ZPGiftChannelView) -> Void)?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var giftModel : ZPGiftModel? {
        didSet {
            // 1.对模型进行校验
            guard let giftModel = giftModel else {
                return
            }
            
            // 2.给控件设置信息
            iconImageView.image = UIImage(named: giftModel.senderURL)
            senderLabel.text = giftModel.senderName
            giftDescLabel.text = "送出礼物：【\(giftModel.giftName)】"
            giftImageView.image = UIImage(named: giftModel.giftURL)
            
            // 3.将ChanelView弹出
            state = .animating
            performAnimation()
        }
    }

    
}

// MARK:- 设置UI界面
extension ZPGiftChannelView {
    
    fileprivate func setupUI(){
        
        bgView = UIView()
        bgView.frame = CGRect(x: 0, y: 0, width: 250, height: self.bounds.height)
        self.backgroundColor = UIColor.yellow
        addSubview(bgView)
        
        iconImageView = UIImageView.init(frame: CGRect(x: 5, y: 5, width: self.bounds.height - 10, height: self.bounds.height - 10))
        iconImageView.backgroundColor = UIColor.blue
        bgView.addSubview(iconImageView)
        
        senderLabel = UILabel(frame: CGRect(x: iconImageView.bounds.width + 10, y: 5, width: 60, height: 15))
        senderLabel.textColor = UIColor.white
        senderLabel.font = UIFont.boldSystemFont(ofSize: 11)
        senderLabel.text = "xxxxxxxxxxx"
        senderLabel.numberOfLines = 1
        senderLabel.textAlignment = NSTextAlignment.left
        bgView.addSubview(senderLabel)
        
        giftDescLabel = UILabel(frame: CGRect(x: iconImageView.bounds.width + 10, y: senderLabel.bounds.maxY + 5, width: bgView.bounds.width - iconImageView.bounds.height - senderLabel.bounds.minX, height: 15))
        
        giftDescLabel.textColor = UIColor.orange
        giftDescLabel.font = UIFont.boldSystemFont(ofSize: 12)
        giftDescLabel.text = "xxxxxxxxxxx"
        giftDescLabel.numberOfLines = 1
        giftDescLabel.textAlignment = NSTextAlignment.left
//        giftDescLabel.sizeToFit()
        bgView.addSubview(giftDescLabel)
        
        
        giftImageView = UIImageView.init(frame: CGRect(x: bgView.bounds.width - self.bounds.height - 30, y: 0, width: self.bounds.height, height: self.bounds.height))
//        giftImageView.backgroundColor = UIColor.blue
        
        bgView.addSubview(giftImageView)
        
        
        digitLabel = ZPGiftDigitLabel(frame: CGRect(x: bgView.bounds.width + 5, y: 5, width: self.bounds.width - bgView.bounds.width-5, height: 30))
        digitLabel.textColor = UIColor.white
        digitLabel.font = UIFont.boldSystemFont(ofSize: 15)
        digitLabel.text = "xxxxxxxxxxx"
        digitLabel.numberOfLines = 1
        digitLabel.textAlignment = NSTextAlignment.left
        self.addSubview(digitLabel)
        
    }
    
}


// MARK:- 设置UI界面
extension ZPGiftChannelView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.green.cgColor
    }
}

 

// MARK:- 对外提供的函数
extension ZPGiftChannelView {
    func addOnceToCache() {
        
        if state == .willEnd {
            performDigitAnimation()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        } else {
            cacheNumber += 1
        }
        
    }
    
    
    
    class func loadFromNib() -> ZPGiftChannelView {
        return ZPGiftChannelView(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
       // return Bundle.main.loadNibNamed("HYGiftChannelView", owner: nil, options: nil)?.first as! HYGiftChannelView
    }
}


// MARK:- 执行动画代码
extension ZPGiftChannelView {
    fileprivate func performAnimation() {
        digitLabel.alpha = 1.0
        digitLabel.text = " x1 "
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.frame.origin.x = 0
        }, completion: { isFinished in
            self.performDigitAnimation()
        })
    }
    
    fileprivate func performDigitAnimation() {
        currentNumber += 1
        digitLabel.text = " x\(currentNumber) "
       
        digitLabel.showDigitAnimation {
            
            if self.cacheNumber > 0 {
                self.cacheNumber -= 1
                self.performDigitAnimation()
            } else {
                self.state = .willEnd
                self.perform(#selector(self.performEndAnimation), with: nil, afterDelay: 3.0)
            }
            
        }
    }
    
    @objc fileprivate func performEndAnimation() {
        
        state = .endAnimating
        
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0.0
        }, completion: { isFinished in
            self.currentNumber = 0
            self.cacheNumber = 0
            self.giftModel = nil
            self.frame.origin.x = -self.frame.width
            self.state = .idle
            self.digitLabel.alpha = 0.0
            
            if let complectionCallback = self.complectionCallback {
                complectionCallback(self)
            }
        })
    }
}
