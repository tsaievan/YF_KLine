//
//  YF_KLineModel.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_KLineModel: NSObject {
    
    ///< 货币类型
    var CoinType: YF_CoinType?
    
    ///< 前一个model
    var previousKLineModel: YF_KLineModel?
    
    ///< 父modelArray: 用来给当前Model索引到parent数组
    var parentGroupModel: YF_KLineGroupModel?
    
    ///< 该model及其之前所有收盘价之和
    var SumOfLastClose: Double?
    
    ///< 该model及其之前所有成交量之和
    var SumOfLastVolume: Double?
    
    ///< 日期
    var date: String?
    
    
    ///< 开盘价
    var Open: Double?
    
    ///< 收盘价
    var Close: Double?
    
    ///< 最高价
    var High: Double?
    
    ///< 最低价
    var Low: Double?
    
    ///< 成交量
    var Volume: Double?
    
    ///< 是否是某个月的第一个交易日
    var isFirstTradeDate: Bool?
    
    // MARK: - 内部自动初始化
    ///< 移动平均数分为MA(简单移动平均数)和EMA(指数移动平均数), 其计算公式如下:
    ///< [C为收盘价, N为周期数] :
    ///< MA（N）=（C1+C2+……CN）/N
    
    ///< MA（7）=（C1+C2+……C7）/7
    var MA7: Double?
    ///< MA（30）=（C1+C2+……C30）/30
    var MA30: Double?
    
    var MA12: Double?
    
    var MA26: Double?
    
    var Volume_MA7: Double?
    
    var Volume_MA30: Double?
    
    var Volume_EMA7: Double?
    
    var Volume_EMA30: Double?
    
    // MARK: - BOLL线
    var MA20: Double?
    
    var BOLL_MD: Double?
    
    var BOLL_MB: Double?
    
    var BOLL_UP: Double?
    
    var BOLL_DN: Double?
    
    var BOLL_SUBMD_SUM: Double?
    
    var BOLL_SUBMD: Double?
    
    var EMA7: Double?
    
    var EMA30: Double?
    
    var EMA12: Double?
    
    var EMA26: Double?
    
    var DIF: Double?
    
    var DEA: Double?
    
    var MACD: Double?
    
    ///< 9Clock内最低价
    var NineClocksMinPrice: Double?
    
    ///< 9Clock内最高价
    lazy var NineClocksMaxPrice: Double? = {
        var max: Double?
        
        return max
    }()
    
    lazy var RSV_9: Double? = {
        var rsv_9 = 100.0
        guard let min = NineClocksMinPrice,
            let max = NineClocksMaxPrice,
            let close = Close else {
                return rsv_9
        }
        if min == max {
            return rsv_9
        }else {
            rsv_9 = (close - min) * 100 / (max - min)
            return rsv_9
        }
    }()
    
    lazy var KDJ_K: Double? = {
        var kdj_k: Double?
        guard let rsv_9 = RSV_9 else {
            return kdj_k
        }
        guard let pModel = previousKLineModel,
            let k = pModel.KDJ_K else {
                kdj_k = (rsv_9 + 2 * 50) / 3
                return kdj_k
        }
        kdj_k = (rsv_9 + 2 * k) / 3
        return kdj_k
    }()
    
    lazy var KDJ_D: Double? = {
        var kdj_d: Double?
        guard let kdj_k = KDJ_K else {
            return kdj_d
        }
        guard let pModel = previousKLineModel,
            let k = pModel.KDJ_D else {
                kdj_d = (kdj_k + 2 * 50) / 3
                return kdj_d
        }
        kdj_d = (kdj_k + 2 * k) / 3
        return kdj_d
    }()
    
    lazy var KDJ_J: Double? = {
        var kdj_j: Double?
        guard let k = KDJ_K,
            let d = KDJ_D else{
                return kdj_j
        }
        kdj_j = 3 * k - 2 * d
        return kdj_j
    }()
    
    
    
    
    
    ///< 初始化一些基本数据
    func initWith(dictionary dict: [String : Any]) {
        if let d = dict["id"] {
            date = d as? String
        }
        if let open = dict["open"] {
            Open = open as? Double
        }
        if let low = dict["low"] {
            Low = low as? Double
        }
        if let high = dict["high"] {
            High = high as? Double
        }
        if let close = dict["close"] {
            Close = close as? Double
        }
        if let volume = dict["vol"] {
            Volume = volume as? Double
        }
        SumOfLastClose = (Close ?? 0) + (previousKLineModel?.SumOfLastClose ?? 0)
        SumOfLastVolume = (Volume ?? 0) + (previousKLineModel?.SumOfLastVolume ?? 0)
    }
    
    func initFirstModel() {
        KDJ_K = 55.27
        KDJ_D = 55.27
        KDJ_J = 55.27
        EMA7 = Close
        EMA12 = Close
        EMA26 = Close
        EMA30 = Close
        NineClocksMinPrice = Low
        NineClocksMaxPrice = High
        
    }
    
    func initData() {
        RSV_9 = RSV_9 ?? 0
        KDJ_K = KDJ_K ?? 0
    }
}

extension YF_KLineModel {
    fileprivate func rangeLastNinePrice(byArray array: [YF_KLineModel], condition: ComparisonResult) {
        switch condition {
        case .orderedAscending:
            for j in (1...7).reversed() {
                var emMaxValue = 0.0
                var em = j
                while em > 0 {
                    guard let high = array[em].High else {
                        break
                    }
                    if emMaxValue < high {
                        emMaxValue = high
                    }
                    em = em - 1
                }
                print("emMaxValue = \(emMaxValue)")
                array[j].NineClocksMaxPrice = emMaxValue
            }
            for i in ()) {
                
            }
        default:
            <#code#>
        }
    }
}
