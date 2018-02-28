//
//  YF_StockChartVariable.swift
//  YF-KLine
//
//  Created by tsaievan on 28/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

///< 先这样写吧
class YF_StockChartVariable {
    ///< k线图的宽度, 默认为2
    class var kLineWidth: CGFloat {
        return 2
    }
    
    ///< 设置k线图的宽度
    class func setKLineWidth(width: CGFloat? = 2) {
        
    }
    
    ///< k线图的间隔, 默认为1
    class var kLineGap: CGFloat {
        return 1
    }
    
    ///< 设置k线图的间隔
    class func setKLineGap(gap: CGFloat? = 1) {
        
    }
    
    ///< MainView的高度占比, 默认为0.5
    class var kLineMainViewRatio: CGFloat {
        return 0.5
    }
    
    ///< 设置MainView的高度占比
    class func setKLineMainViewRatio(ratio: CGFloat? = 0.5) {
        
    }
    
    ///< VolumeView的高度占比, 默认为0.2
    class var kLineVolumeViewRatio: CGFloat {
        return 0.2
    }
    
    ///< 设置Volume的高度占比
    class func setKLineVolumeViewRatio(ratio: CGFloat? = 0.2) {
        
    }
    
    ///< EMA线
    class var isEMALine: YF_StockChartTargetLineStatus {
        return .EMA
    }
    
    ///< 设置EMA线
    class func setIsEMALine(EMALine: YF_StockChartTargetLineStatus? = .EMA) {
        
    }
    
    ///< BOLL线
    class var isBOLLLine: YF_StockChartTargetLineStatus {
        return .BOLL
    }
    
    class func setIsBOLLLine(BOLLLine: YF_StockChartTargetLineStatus? = .BOLL) {
        
    }
}
