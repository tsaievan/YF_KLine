//
//  ViewController.swift
//  YF-KLine
//
//  Created by tsaievan on 27/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    lazy var presentButton: UIButton = {
        let button = UIButton(title: "跳转到K线图", target: self, action: #selector(ViewController.presentKLineViewController))
        view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension ViewController {
    ///< 计算属性, 自动旋转设置为false
    override var shouldAutorotate: Bool {
        return false
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .yellow
        makeConstraints()
    }
    
    fileprivate func makeConstraints() {
        presentButton.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
    }
}

extension ViewController {
    @objc fileprivate func presentKLineViewController() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.isLandScape = true
        let kLineVc = YF_KLineViewController()
        kLineVc.modalTransitionStyle = .crossDissolve
        kLineVc.modalPresentationStyle = .fullScreen
        present(kLineVc, animated: true, completion: nil)
    }
}

