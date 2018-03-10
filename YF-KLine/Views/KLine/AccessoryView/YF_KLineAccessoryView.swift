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
    ///< 需要绘制的K线模型数组
    var needDrawKLineModels: [YF_KLineModel]?
    
    ///< 需要绘制的K线位置数组
    var needDrawKLinePositionModels: [YF_KLinePositionModel]?
    
    ///< K线的颜色数组
    var kLineColors: [UIColor]?
    
    ///< 指标种类
    var targetLineStatus: YF_StockChartTargetLineStatus?
    
    ///< 需要绘制的Volume_MACD位置模型数组
    fileprivate var needDrawKLineAccessoryPositionModels = [YF_KLineVolumePositionModel]()
    
    ///< Volume_DIF位置数组
    fileprivate var Accessory_DIFPositions = [CGPoint]()
    
    ///< Volume_DEA位置数组
    fileprivate var Accessory_DEAPositions = [CGPoint]()
    
    ///< KDJ_K位置数组
    fileprivate var Accessory_KDJ_KPositions = [CGPoint]()
    
    ///< KDJ_D位置数组
    fileprivate var Accessory_KDJ_DPositions = [CGPoint]()
    
    ///< KDJ_J位置数组
    fileprivate var Accessory_KDJ_JPositions = [CGPoint]()
    
    ///< 代理
    weak var delegate: YF_KLineAccessoryViewDelegate?
    
    func draw() {
        
    }
}
