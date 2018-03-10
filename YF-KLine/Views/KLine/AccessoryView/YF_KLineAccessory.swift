//
//  YF_KLineAccessory.swift
//  YF-KLine
//
//  Created by tsaievan on 10/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_KLineAccessory: NSObject {
    
    ///< K线图的位置模型
    var positionModel: YF_KLineVolumePositionModel?
    
    ///< K线图的数据模型
    var kLineModel: YF_KLineModel?
    
    ///< 线的颜色
    var lineColor: UIColor?
    
    ///< 当前的图形上下文
    var currentContext: CGContext?
    
    init(context: CGContext) {
        currentContext = context
    }
}


// MARK: - 绘图方法
extension YF_KLineAccessory {
    func draw() {
        guard let context = currentContext else {
            return
        }
        ///< 设置画笔颜色
        context.setStrokeColor(K_LINE_INCREASE_COLOR.cgColor)
        ///< 设置线宽
        context.setLineWidth(YF_StockChartVariable.kLineWidth)
        ///< 设置线段
        let startPoint = positionModel?.StartPoint ?? .zero ///< 起点
        let endPoint = positionModel?.EndPoint ?? .zero ///< 终点
        let solidPoints = [startPoint, endPoint]
        
        if (kLineModel?.MACD ?? 0) > 0 { ///< 如果数据模型的MACD值大于0, 就使用另外一种颜色
            context.setStrokeColor(K_LINE_DECREASE_COLOR.cgColor)
        }
        context.strokeLineSegments(between: solidPoints)
    }
}
