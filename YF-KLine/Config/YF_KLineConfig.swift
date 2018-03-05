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
enum YF_StockChartTargetLineStatus: Int {
    case MACD = 100 ///< MACD线
    case KDJ ///< KDJ线
    case AccessoryClose ///< 关闭Accessory线
    case MA ///< MA线
    case EMA ///< EMA线
    case BOLL ///< BOLL线
    case CloseMA ///< MA关闭线
}

///< 币种
enum YF_CoinType {
    case BTC ///< 比特币
    case ETF ///< 以太坊
    case None ///< 未定义货币
}

///< K线图YView的宽度
let STOCK_CHART_K_LINE_PRICE_VIEW_WIDTH: CGFloat = 47

///< K线图上成交量最小的Y
let STOCK_CHART_K_LINE_VOLUME_VIEW_MIN_Y: CGFloat = 20

///< K线图的缩放界线
let STOCK_CHART_SCALE_BOUND: CGFloat = 0.03

///< K线缩放因子
let STOCK_CHART_SCALE_SCALE: CGFloat = 0.03
