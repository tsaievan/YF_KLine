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
        var strokeColor: UIColor?
        guard let model = kLineModel,
        let context = currentContext,
        let positionModel = kLinePositionModel else {
            return strokeColor
        }
        ///< 设置画笔颜色
        let openPointY = positionModel.OpenPoint?.y ?? 0
        let closePointY = positionModel.ClosePoint?.y ?? 0
        if openPointY > closePointY {
            strokeColor = K_LINE_DECREASE_COLOR
        }else {
            strokeColor = K_LINE_INCREASE_COLOR
        }
        ///< 这里先强行解包
        context.setStrokeColor(strokeColor!.cgColor)
        
        let highPoint = positionModel.HighPoint ?? .zero
        let lowPoint = positionModel.LowPoint ?? .zero
        let openPoint = positionModel.OpenPoint ?? .zero
        let closePoint = positionModel.ClosePoint ?? .zero
        ///< 画中间较宽的开收盘线段-实体线
        ///< 设置线宽
        context.setLineWidth(YF_StockChartVariable.kLineWidth)
        let solidPoints: [CGPoint] = [openPoint, closePoint]
        ///< 这个函数会创建一条新的路径, 添加独立的线段到这条路径中, 然后再画这条路径
        ///< 当前的路径将被清除
        context.strokeLineSegments(between: solidPoints)
        
        ///< 画上下影线
        context.setLineWidth(STOCK_CHART_SHADOW_LINE_WIDTH)
        let shadowPoints: [CGPoint] = [highPoint, lowPoint]
        context.strokeLineSegments(between: shadowPoints)
        
        ///< 计算每个模型对应的时间字符串
//        let timeInterval = (model.date ?? 0) / 1000.0
//        let date = Date(timeIntervalSince1970: timeInterval)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        let dateString = dateFormatter.string(from: date)
        
        ///< 字符串的截取
        var dateString = model.date ?? ""
//        let startIndex = dateString.index(dateString.startIndex, offsetBy: 4)
//        dateString = String(dateString[startIndex..<dateString.endIndex])
        let drawDatePoint = CGPoint(x: lowPoint.x + 1, y: (maxY ?? 0.0) + 1.5)
        guard let lastPoint = lastDrawDatePoint else {
            return strokeColor
        }
        if lastPoint == .zero || drawDatePoint.x - lastPoint.x > 60 {
            ///< 字也是画上去的
            (dateString as NSString).draw(at: drawDatePoint, withAttributes: [.font : UIFont.systemFont(ofSize: 11),
                                                                               .foregroundColor : ASSISTANT_TEXT_COLOR])
            lastDrawDatePoint = drawDatePoint
        }
        return strokeColor;
    }
}
