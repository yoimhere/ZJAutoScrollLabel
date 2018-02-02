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
        let scoll = ZJAutoScrollLabel()
        scoll.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: 100)
        scoll.setTexts(["ZJAutoScrollLabel 是一个自动滚动的Label","希望大家能够用的顺畅"])
        scoll.backgroundColor = .red;
        scoll.resume()
        view.addSubview(scoll)
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
            scoll.setTexts(["哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈","啊啊啊啊啊啊啊啊啊啊啊啊啊"])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

