//
//  YF_MALine.swift
//  YF-KLine
//
//  Created by tsaievan on 8/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

///< 画均线的线
class YF_MALine: NSObject {
    
    ///< 均线的点
    var MAPositions: [CGPoint]?
    
    ///< BOLL线的点
    var BOLLPositions: [CGPoint]?
    
    ///< 均线类型
    var MAType: YF_MAType?
    
    ///< K线的model
    var kLineModel: YF_KLineModel?
    
    ///< 最大的Y值
    var maxY: CGFloat?
    
    ///< 当前的图形上下文
    fileprivate var currentContext: CGContext?
    
    init(context: CGContext) {
        super.init()
        currentContext = context
    }
}


// MARK: - 绘图的方法
extension YF_MALine {
    func draw() {
        ///< 先确保图形上下文是存在的
        guard let context = currentContext else {
            return
        }
        if MAType == .BOLL_DN || MAType == .BOLL_MB || MAType == .BOLL_UP { ///< BOLL类型的线
            guard let bollPositions = BOLLPositions else {
                return
            }
            ///< 设置线的颜色
            let lineColor = MAType == .BOLL_UP ? BOLL_UP_COLOR : MAType == .BOLL_MB ? BOLL_MB_COLOR : MAType == .BOLL_DN ? BOLL_DN_COLOR : MAIN_TEXT_COLOR
            ///< 设置画笔颜色
            context.setStrokeColor(lineColor.cgColor)
            ///< 设置画笔线宽
            context.setLineWidth(STOCK_CHART_MA_LINE_WIDTH)
            ///< 先拿到第一个点
            guard let firstPoint = BOLLPositions?.first else {
                return
            }
            ///< 图形上下文移到第一个点
            context.move(to: firstPoint)
            ///< 然后遍历余下的点, 把他们连接起来
            for point in bollPositions[1...] {
                context.addLine(to: point)
            }
        }else { ///< MA类型的线
            ///< 先确保MA点都有
            guard let maPositions = MAPositions else {
                return
            }
            ///< 步骤同上,
            let lineColor = MAType == .MA7Type ? MA_7_COLOR : MAType == .MA30Type ? MA_30_COLOR : MAIN_TEXT_COLOR
            ///< 设置画笔颜色
            context.setStrokeColor(lineColor.cgColor)
            ///< 设置画笔颜色
            context.setLineWidth(STOCK_CHART_MA_LINE_WIDTH)
            ///< 先拿到第一个点
            guard let firstPoint = MAPositions?.first else {
                return
            }
            ///< 图形上下文移到第一个点
            context.move(to: firstPoint)
            ///< 然后遍历余下的点, 把他们连接起来
            for point in maPositions {
                context.addLine(to: point)
            }
        }
        ///< 将路径画下来
        context.strokePath()
    }
}
