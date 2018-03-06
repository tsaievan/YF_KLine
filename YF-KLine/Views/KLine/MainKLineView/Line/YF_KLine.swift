//
//  YF_KLine.swift
//  YF-KLine
//
//  Created by tsaievan on 6/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_KLine: NSObject {
    ///< K线的位置model
    var kLinePositionModel: YF_KLinePositionModel?
    
    ///< k线的数据model
    var kLineModel: YF_KLineModel?
    
    ///< 最大的Y
    var maxY: CGFloat?
    
    ///< 当前的上下文环境
    fileprivate var currentContext: CGContext?
    
    ///< 最后一个绘制日期点
    fileprivate var lastDrawDatePoint: CGPoint?
    
    init(context: CGContext) {
        super.init()
        currentContext = context
        lastDrawDatePoint = .zero
    }
}

// MARK: - 绘图相关方法
extension YF_KLine {
    ///< 绘制K线, 单个, 还要返回一个颜色对象
    func draw() -> UIColor? {
        guard let model = kLineModel,
        let context = currentContext,
        let positionModel = kLinePositionModel else {
            return nil
        }
        ///< 设置画笔颜色
        let openPoint = positionModel.OpenPoint?.y ?? 0
        let closePoint = positionModel.ClosePoint?.y ?? 0
        var strokeColor: UIColor?
        if openPoint > closePoint {
            strokeColor = K_LINE_DECREASE_COLOR
        }else {
            strokeColor = K_LINE_INCREASE_COLOR
        }
        ///< 这里先强行解包
        context.setStrokeColor(strokeColor!.cgColor)
        
    }
    
}
