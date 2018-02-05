//
//  ViewController.swift
//  ZJAutoScrollLabel
//
//  Created by yoimhere on 02/02/2018.
//  Copyright (c) 2018 yoimhere. All rights reserved.
//

import UIKit
import ZJAutoScrollLabel

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let noticeView = ZJNoticeView()
        noticeView.frame = CGRect(x: 10, y: 0, width: view.frame.size.width - 20, height: 30)
        noticeView.layer.cornerRadius  = 8
        noticeView.layer.masksToBounds = true
        noticeView.center = view.center
        noticeView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5);
        view.addSubview(noticeView)
        
        noticeView.scrollLabel.setTexts(["关关雎鸠，在河之洲。窈窕淑女，君子好逑。", "参差荇菜，左右流之。窈窕淑女，寤寐求之。", "求之不得，寤寐思服。悠哉悠哉，辗转反侧。", "参差荇菜，左右采之。窈窕淑女，琴瑟友之。", "参差荇菜，左右芼之。窈窕淑女，钟鼓乐之。"])
        noticeView.scrollLabel.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

