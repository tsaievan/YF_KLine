//
//  YF_StockChartVariable.swift
//  YF-KLine
//
//  Created by tsaievan on 28/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

///< 先这样写吧
class YF_StockChartVariable: NSObject {
    ///< k线图的宽度, 默认为2
    static var kLineWidth: CGFloat = 2
    
    ///< 设置k线图的宽度
    class func setKLineWidth(width: CGFloat? = 2) {
        guard let w = width else {
            return
        }
        kLineWidth = w
    }
    
    ///< k线图的间隔, 默认为1
    static var kLineGap: CGFloat = 1
    
    ///< 设置k线图的间隔
    class func setKLineGap(gap: CGFloat? = 1) {
        guard let g = gap else {
            return
        }
        kLineGap = g
    }
    
    ///< MainView的高度占比, 默认为0.5
    static var kLineMainViewRatio: CGFloat = 0.5
    
    ///< 设置MainView的高度占比
    class func setKLineMainViewRatio(ratio: CGFloat? = 0.5) {
        guard let mvr = ratio else {
            return
        }
        kLineMainViewRatio = mvr
    }
    
    ///< VolumeView的高度占比, 默认为0.2
    static var kLineVolumeViewRatio: CGFloat = 0.2
    
    ///< 设置Volume的高度占比
    class func setKLineVolumeViewRatio(ratio: CGFloat? = 0.2) {
        guard let vvr = ratio else {
            return
        }
        kLineVolumeViewRatio = vvr
    }
    
    ///< EMA线
    static var isEMALine: YF_StockChartTargetLineStatus = .EMA
    
    ///< 设置EMA线
    class func setIsEMALine(EMALine: YF_StockChartTargetLineStatus? = .EMA) {
        guard let ema = EMALine else {
            return
        }
        isEMALine = ema
    }
    
    ///< BOLL线
    static var isBOLLLine: YF_StockChartTargetLineStatus = .BOLL
    
    class func setIsBOLLLine(BOLLLine: YF_StockChartTargetLineStatus? = .BOLL) {
        guard let boll = BOLLLine else {
            return
        }
        isBOLLLine = boll
    }
}
