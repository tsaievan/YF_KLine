//
//  YF_KLineAccessoryView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

protocol YF_KLineAccessoryViewDelegate: NSObjectProtocol {
    
}

class YF_KLineAccessoryView: UIView {
    weak var delegate: YF_KLineAccessoryViewDelegate?
}
