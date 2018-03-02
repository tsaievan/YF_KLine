//
//  YF_KLineMainView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

protocol YF_KLineMainViewDelegate: NSObjectProtocol {
    
}

class YF_KLineMainView: UIView {
    weak var delegate: YF_KLineMainViewDelegate?
    
    ///< K线类型
    var mainViewType: YF_StockChartViewType?
    
    ///< Accessory指标种类
    var targetLineStatus: YF_StockChartTargetLineStatus?
    
    ///< k线模型对象的数组
    var kLineModels: [Any]?
    
    ///< 需要绘制Index开始值
    var needDrawStartIndex: Int?
    
    ///< 捏合点
    var pinchStartIndex: Int?
    
    ///< 画K线主视图
    func drawMainView() {
        
    }
    
    ///< 更新宽度
    func updateMainViewWidth() {
        
    }
}
