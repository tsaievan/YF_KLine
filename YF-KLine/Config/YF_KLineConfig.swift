//
//  YF_KLineConfig.swift
//  YF-KLine
//
//  Created by tsaievan on 28/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

///< K线种类
enum YF_StockChartViewType {
    case kLine ///< K线
    case timeLine ///< 分时图
    case other ///< 其他
}

///< Accessory指标种类
enum YF_StockChartTargetLineStatus {
    case MACD ///< MACD线
    case KDJ ///< KDJ线
    case AccessoryClose ///< 关闭Accessory线
    case MA ///< MA线
    case EMA ///< EMA线
    case BOLL ///< BOLL线
    case CloseMA ///< MA关闭线
}
