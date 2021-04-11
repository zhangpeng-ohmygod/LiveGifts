//
//  ViewController.swift
//  直播送礼物部件
//
//  Created by apple on 2021/4/11.
//

import UIKit

class ViewController: UIViewController {

    fileprivate lazy var giftContainerView : ZPGiftContainerView = ZPGiftContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giftContainerView.frame = CGRect(x: 0, y: 100, width: 350, height: 90)
        giftContainerView.backgroundColor = UIColor.lightGray
        view.addSubview(giftContainerView)
    }
 
    
    @IBAction func gift1(_ sender: UIButton) {
        
        let gift1 = ZPGiftModel(senderName: "coderwhy", senderURL: "icon4", giftName: "火箭", giftURL: "prop_b")
        giftContainerView.showGiftModel(gift1)
    }
    
    @IBAction func gift2(_ sender: UIButton) {
        
        let gift2 = ZPGiftModel(senderName: "coder", senderURL: "icon2", giftName: "飞机", giftURL: "prop_f")
        giftContainerView.showGiftModel(gift2)
        
    }
    
    @IBAction func gift3(_ sender: UIButton) {
        
        let gift3 = ZPGiftModel(senderName: "why", senderURL: "icon3", giftName: "跑车", giftURL: "prop_g")
        giftContainerView.showGiftModel(gift3)
        
    }
    
}

