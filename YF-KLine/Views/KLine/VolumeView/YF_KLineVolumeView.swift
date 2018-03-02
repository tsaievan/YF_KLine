//
//  YF_KLineVolumeView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

protocol YF_KLineVolumeViewDelegate: NSObjectProtocol {
    
}

class YF_KLineVolumeView: UIView {
    weak var delegate: YF_KLineVolumeViewDelegate?
    
    func draw() {
        
    }
}
