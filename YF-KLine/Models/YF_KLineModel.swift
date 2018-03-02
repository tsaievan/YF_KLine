//
//  YF_KLineModel.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_KLineModel: NSObject {
    
    ///< 前一个model
    var previousKLineModel: YF_KLineModel?
    ///< 父modelArray: 用来给当前Model索引到parent数组
    var parentGroupModel: YF_KLineGroupModel?
    
    func initWith(dictionary dict: [String : Any]) {
        
    }
    
    func initFirstModel() {
        
    }
    
    func initData() {
        
    }
}
