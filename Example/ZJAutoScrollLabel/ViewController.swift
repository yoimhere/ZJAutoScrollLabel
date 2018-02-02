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
        scoll.frame = CGRect.init(x: 0, y: 0, width: 300, height: 100)
        scoll.setTexts(["111111111111","222222"])
        scoll.backgroundColor = .red;
        scoll.resume()
        view.addSubview(scoll)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

