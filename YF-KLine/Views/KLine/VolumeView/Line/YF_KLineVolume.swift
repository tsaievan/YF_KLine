//
//  YF_KLineVolume.swift
//  YF-KLine
//
//  Created by tsaievan on 5/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_KLineVolume: NSObject {
    
    ///< 位置model
    var positionModel: YF_KLineVolumePositionModel?
    ///< K线Model
    var kLineModel: YF_KLineModel?
    ///< 线的颜色
    var lineColor: UIColor?
    ///< 当前图形上下文
    var currentContext: CGContext?
    
    init(context: CGContext) {
        currentContext = context
    }
    
    func draw() {
        guard let _ = kLineModel,
        let pModel = positionModel,
        let context = currentContext,
        let lColor = lineColor else {
            return
        }
        ///< 设置画笔颜色
        context.setStrokeColor(lColor.cgColor)
        ///< 设置线宽
        context.setLineWidth(YF_StockChartVariable.kLineWidth)
        ///< 线段点的起始点和终止点
        let solidPoints = [pModel.StartPoint ?? .zero, pModel.EndPoint ?? .zero]
        ///< 画线段
        context.strokeLineSegments(between: solidPoints)
    }

}
