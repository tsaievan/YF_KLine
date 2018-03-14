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
    lazy var previousKLineModel: YF_KLineModel? = {
        let pm = YF_KLineModel()
        pm.DIF = 0.0
        pm.DEA = 0.0
        pm.MACD = 0.0
        pm.MA7 = 0.0
        pm.MA12 = 0.0
        pm.MA26 = 0.0
        pm.MA30 = 0.0
        pm.EMA7 = 0.0
        pm.EMA12 = 0.0
        pm.EMA26 = 0.0
        pm.EMA30 = 0.0
        pm.Volume_MA7 = 0.0
        pm.Volume_MA30 = 0.0
        pm.Volume_EMA7 = 0.0
        pm.Volume_EMA30 = 0.0
        pm.SumOfLastClose = 0.0
        pm.SumOfLastVolume = 0.0
        pm.KDJ_K = 50.0
        pm.KDJ_D = 50.0
        pm.MA20 = 0.0
        pm.BOLL_MD = 0.0
        pm.BOLL_MB = 0.0
        pm.BOLL_DN = 0.0
        pm.BOLL_UP = 0.0
        pm.BOLL_SUBMD_SUM = 0.0
        pm.BOLL_SUBMD = 0.0
        return pm
    }()
    
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
    lazy var MA7: Double? = {
        var ma7: Double?
        if YF_StockChartVariable.isEMALine == .MA {
            guard let array = parentGroupModel?.models as NSArray? else {
                return ma7
            }
            let index = array.index(of: self)
            if index >= 6 {
                guard let sum = SumOfLastClose,
                    let oriArr = array as? [YF_KLineModel] else {
                        return ma7
                }
                if index > 6 {
                    ma7 = (sum - (oriArr[index - 7].SumOfLastClose ?? 0)) / 7
                }else {
                    ma7 = sum / 7
                }
            }
            return ma7
        }else {
            ma7 = EMA7
            return ma7
        }
    }()
    ///< MA（30）=（C1+C2+……C30）/30
    lazy var MA30: Double? = {
        var ma30: Double?
        if YF_StockChartVariable.isEMALine == .MA {
            guard let array = parentGroupModel?.models as NSArray? else {
                return ma30
            }
            let index = array.index(of: self)
            if index >= 29 {
                guard let sum = SumOfLastClose,
                    let oriArr = array as? [YF_KLineModel] else {
                        return ma30
                }
                ma30 = (sum - (oriArr[index - 30].SumOfLastClose ?? 0)) / 30
                return ma30
            }else {
                guard let sum = SumOfLastClose else {
                    return ma30
                }
                ma30 = sum / 30
                return ma30
            }
        }else {
            ma30 = EMA30
            return ma30
        }
    }()
    
    lazy var MA12: Double? = {
        var ma12: Double?
        guard let array = parentGroupModel?.models as NSArray? else {
            return ma12
        }
        let index = array.index(of: self)
        if index >= 11 {
            guard let sum = SumOfLastClose,
                let oriArr = parentGroupModel?.models as? [YF_KLineModel] else {
                    return ma12
            }
            if index > 11 {
                ma12 = (sum - (oriArr[index - 12].SumOfLastClose ?? 0)) / 12
                return ma12
            }else {
                ma12 = sum / 12
                return ma12
            }
        }
        return ma12
    }()
    
    lazy var MA26: Double? = {
        var ma26: Double?
        guard let array = parentGroupModel?.models as NSArray? else {
            return ma26
        }
        let index = array.index(of: self)
        if index >= 25 {
            guard let sum = SumOfLastClose,
                let oriArr = parentGroupModel?.models as? [YF_KLineModel] else {
                    return ma26
            }
            if index > 25 {
                ma26 = (sum - (oriArr[index - 26].SumOfLastClose ?? 0)) / 26
                return ma26
            }else {
                ma26 = sum / 26
                return ma26
            }
        }
        return ma26
    }()
    
    lazy var Volume_MA7: Double? = {
        var vma7: Double?
        if YF_StockChartVariable.isEMALine == .MA {
            guard let array = parentGroupModel?.models as NSArray? else {
                return vma7
            }
            let index = array.index(of: self)
            if index >= 6 {
                guard let sum = SumOfLastVolume,
                    let oriArr = array as? [YF_KLineModel] else {
                        return vma7
                }
                if index > 6 {
                    vma7 = (sum - (oriArr[index - 7].SumOfLastVolume ?? 0)) / 7
                    return vma7
                }else {
                    vma7 = sum / 7
                    return vma7
                }
            }
        }else {
            vma7 = Volume_EMA7
            return vma7
        }
        return vma7
    }()
    
    lazy var Volume_MA30: Double? = {
        var vma30: Double?
        if YF_StockChartVariable.isEMALine == .MA {
            guard let array = parentGroupModel?.models as NSArray? else {
                return vma30
            }
            let index = array.index(of: self)
            if index >= 29 {
                guard let sum = SumOfLastVolume,
                    let oriArr = array as? [YF_KLineModel] else {
                        return vma30
                }
                if index > 29 {
                    vma30 = (sum - (oriArr[index - 30].SumOfLastVolume ?? 0)) / 30
                    
                }else {
                    vma30 = sum / 30
                }
                return vma30
            }
        }else {
            vma30 = Volume_EMA30
            return vma30
        }
        return vma30
    }()
    
    lazy var Volume_EMA7: Double? = {
        var vema7: Double = 0.0
        guard let v = Volume,
            let pv = previousKLineModel?.Volume_EMA7 else {
                return vema7
        }
        vema7 = (v + 3 * pv) / 4
        return vema7
    }()
    
    lazy var Volume_EMA30: Double? = {
        var vema30: Double = 0.0
        guard let v = Volume,
            let pv = previousKLineModel?.Volume_EMA30 else {
                return vema30
        }
        vema30 = (2 * v + 29 * pv) / 31
        return vema30
    }()
    
    // MARK: - BOLL线
    lazy var MA20: Double? = {
        var ma20: Double?
        guard let array = parentGroupModel?.models as NSArray?,
            let sum = SumOfLastClose else {
                return ma20
        }
        let index = array.index(of: self)
        if index >= 19 {
            guard let oriArr = array as? [YF_KLineModel] else {
                return ma20
            }
            if index > 19 {
                ma20 = (sum - (oriArr[index - 20].SumOfLastClose ?? 0)) / 20
                return ma20
            }else {
                guard let sum = SumOfLastClose else {
                    return ma20
                }
                ma20 = sum / 20
                return ma20
            }
        }
        return ma20
    }()
    
    lazy var BOLL_MD: Double? = {
        var bmd: Double?
        guard let array = parentGroupModel?.models as NSArray?,
            let sum = previousKLineModel?.BOLL_SUBMD_SUM else {
                return bmd
        }
        let index = array.index(of: self)
        if index >= 20 {
            guard let oriArr = parentGroupModel?.models as? [YF_KLineModel] else {
                return bmd
            }
            bmd = sqrt((sum - (oriArr[index - 20].BOLL_SUBMD_SUM ?? 0)) / 20)
            return bmd
        }
        return bmd
    }()
    
    lazy var BOLL_MB: Double? = {
        var bmb: Double?
        guard let array = parentGroupModel?.models as NSArray?,
            let sum = SumOfLastClose else {
                return bmb
        }
        let index = array.index(of: self)
        if index >= 19 {
            guard let oriArr = parentGroupModel?.models as? [YF_KLineModel] else {
                return bmb
            }
            if index > 19 {
                bmb = (sum - (oriArr[index - 19].SumOfLastClose ?? 0)) / 20
                return bmb
            }else {
                bmb = sum / Double(index)
                return bmb
            }
        }
        return bmb
    }()
    
    lazy var BOLL_UP: Double? = {
        var bup: Double?
        guard let array = parentGroupModel?.models as NSArray? else {
            return bup
        }
        let index = array.index(of: self)
        guard let bmb = BOLL_MB,
            let bmd = BOLL_MD else {
                return bup
        }
        bup = bmb + 2 * bmd
        return bup
    }()
    
    lazy var BOLL_DN: Double? = {
        var bdn: Double?
        guard let array = parentGroupModel?.models as NSArray? else {
            return bdn
        }
        let index = array.index(of: self)
        guard let bmb = BOLL_MB,
            let bmd = BOLL_MD else {
                return bdn
        }
        bdn = bmb - 2 * bmd
        return bdn
    }()
    
    lazy var BOLL_SUBMD_SUM: Double? = {
        var bss: Double?
        guard let array = parentGroupModel?.models as NSArray? else {
            return bss
        }
        let index = array.index(of: self)
        guard let sum = previousKLineModel?.BOLL_SUBMD_SUM,
            let bs = BOLL_SUBMD else {
                return bss
        }
        bss = sum + bs
        return bss
    }()
    
    lazy var BOLL_SUBMD: Double? = {
        var bs: Double?
        guard let array = parentGroupModel?.models as NSArray? else {
            return bs
        }
        let index = array.index(of: self)
        guard let close = Close,
            let ma20 = MA20 else {
                return bs
        }
        if index >= 20 {
            bs = (close - ma20) * (close - ma20)
            return bs
        }
        return bs
    }()
    
    lazy var EMA7: Double? = {
        var ema7: Double?
        guard let close = Close,
            let pema7 = previousKLineModel?.EMA7 else {
                return ema7
        }
        ema7 = (close + 3 * pema7) / 4
        return ema7
    }()
    
    lazy var EMA30: Double? = {
        var ema30: Double?
        guard let close = Close,
            let pema30 = previousKLineModel?.EMA30 else {
                return ema30
        }
        ema30 = (2 * close + 29 * pema30) / 31
        return ema30
    }()
    
    lazy var EMA12: Double? = {
        var ema12: Double?
        guard let close = Close,
            let pema12 = previousKLineModel?.EMA12 else {
                return ema12
        }
        ema12 = (2 * close + 11 * pema12) / 13
        return ema12
    }()
    
    lazy var EMA26: Double? = {
        var ema26: Double?
        guard let close = Close,
            let pema26 = previousKLineModel?.EMA26 else {
                return ema26
        }
        ema26 = (2 * close + 25 * pema26) / 27
        return ema26
    }()
    
    lazy var DIF: Double? = {
        var dif: Double?
        guard let ema12 = EMA12,
            let ema26 = EMA26 else {
                return dif
        }
        dif = ema12 - ema26
        return dif
    }()
    
    lazy var DEA: Double? = {
        var dea: Double?
        guard let d = previousKLineModel?.DEA,
            let dif = DIF else {
                return dea
        }
        dea = d * 0.8 + 0.2 * dif
        return dea
    }()
    
    lazy var MACD: Double? = {
        var macd: Double?
        guard let dif = DIF,
            let dea = DEA else {
                return macd
        }
        macd = 2 * (dif - dea)
        return macd
    }()
    
    ///< 9Clock内最低价
    var NineClocksMinPrice: Double? = 0
    
    func getNineClocksMinPrice() {
        guard let models = parentGroupModel?.models as? [YF_KLineModel] else {
            return
        }
        if models.count >= 8 {
            rangeLastNinePrice(byArray: models, condition: .orderedDescending)
        }else {
            return
        }
    }
    
    ///< 9Clock内最高价
    var NineClocksMaxPrice: Double? = 0
    
    func getNineClocksMaxPrice() {
        guard let models = parentGroupModel?.models as? [YF_KLineModel] else {
            return
        }
        if models.count >= 8 {
            rangeLastNinePrice(byArray: models, condition: .orderedAscending)
        }else {
            return
        }
    }
    
    lazy var RSV_9: Double? = {
        //FIXME: -不知道这么写对不对, 先把这俩函数调一遍吧
        getNineClocksMinPrice()
        getNineClocksMaxPrice()
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
    func initWith(array: [Any]) {
        date = array[0] as? String
        Open = (array[1] as? NSString)?.doubleValue
        Close = (array[2] as? NSString)?.doubleValue
        Low = (array[5] as? NSString)?.doubleValue
        High = (array[6] as? NSString)?.doubleValue
        Volume = (array[8] as? NSString)?.doubleValue
        SumOfLastClose = (Close ?? 0) + (previousKLineModel?.SumOfLastClose ?? 0)
        SumOfLastVolume = (Volume ?? 0) + (previousKLineModel?.SumOfLastVolume ?? 0)
    }
    
    func initFirstModel() {
        //FIXME: -不知道这么写对不对, 先把这俩函数调一遍吧
        getNineClocksMaxPrice()
        getNineClocksMinPrice()
        KDJ_K = 55.27
        KDJ_D = 55.27
        KDJ_J = 55.27
        EMA7 = Close
        EMA12 = Close
        EMA26 = Close
        EMA30 = Close
        NineClocksMinPrice = Low
        NineClocksMaxPrice = High
        DIF = DIF ?? 0
        DEA = DEA ?? 0
        MACD = MACD ?? 0
        guard let models = parentGroupModel?.models as? [YF_KLineModel] else{
            return
        }
        rangeLastNinePrice(byArray: models, condition: .orderedAscending)
        rangeLastNinePrice(byArray: models, condition: .orderedDescending)
        RSV_9 = RSV_9 ?? 0
        KDJ_K = KDJ_K ?? 0
        KDJ_D = KDJ_D ?? 0
        KDJ_J = KDJ_J ?? 0
        MA20 = MA20 ?? 0
        BOLL_MD = BOLL_MD ?? 0
        BOLL_MB = BOLL_MB ?? 0
        BOLL_UP = BOLL_UP ?? 0
        BOLL_DN = BOLL_DN ?? 0
        BOLL_SUBMD = BOLL_SUBMD ?? 0
        BOLL_SUBMD_SUM = BOLL_SUBMD_SUM ?? 0
    }
    
    func initData() {
        //FIXME: -不知道这么写对不对, 先把这俩函数调一遍吧
        getNineClocksMaxPrice()
        getNineClocksMinPrice()
        
        //FIXME:- 这里的算法还有点问题, 前7个点应该没有MA7数据的
        if MA7 != nil {
            
        }
        MA12 = MA12 ?? 0
        MA26 = MA26 ?? 0
        MA30 = MA30 ?? 0
        EMA7 = EMA7 ?? 0
        EMA12 = EMA12 ?? 0
        EMA26 = EMA26 ?? 0
        EMA30 = EMA30 ?? 0
        DIF = DIF ?? 0
        DEA = DEA ?? 0
        MACD = MACD ?? 0
        NineClocksMaxPrice = NineClocksMaxPrice ?? 0
        NineClocksMinPrice = NineClocksMinPrice ?? 0
        RSV_9 = RSV_9 ?? 0
        KDJ_K = KDJ_K ?? 0
        KDJ_D = KDJ_D ?? 0
        KDJ_J = KDJ_J ?? 0
        MA20 = MA20 ?? 0
        BOLL_MD = BOLL_MD ?? 0
        BOLL_MB = BOLL_MB ?? 0
        BOLL_UP = BOLL_UP ?? 0
        BOLL_DN = BOLL_DN ?? 0
        BOLL_SUBMD = BOLL_SUBMD ?? 0
        BOLL_SUBMD_SUM = BOLL_SUBMD_SUM ?? 0
    }
}

extension YF_KLineModel {
    fileprivate func rangeLastNinePrice(byArray array: [YF_KLineModel], condition: ComparisonResult) {
        let count = array.count
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
                array[j].NineClocksMaxPrice = emMaxValue
            }
            for i in (0..<(count - 8)) {
                var j = 8
                var emMaxValue = 0.0
                var em = j
                while em >= i {
                    guard let high = array[em].High else {
                        break
                    }
                    if emMaxValue < high {
                        emMaxValue = high
                    }
                    em = em - 1
                }
                array[j].NineClocksMaxPrice = emMaxValue
                j = j + 1
            }
        case .orderedDescending:
            for j in (1...7).reversed() {
                var emMinValue = 10000000000.0
                var em = j
                while em >= 0 {
                    guard let low = array[em].Low else {
                        break
                    }
                    if emMinValue > low {
                        emMinValue = low
                    }
                    em = em - 1
                }
                array[j].NineClocksMinPrice = emMinValue
            }
            for i in (0..<(count - 8)) {
                var j = 8
                var emMinValue = 10000000000.0
                var em = j
                while em >= i {
                    guard let low = array[em].Low else {
                        break
                    }
                    if emMinValue > low {
                        emMinValue = low
                    }
                    em = em - 1
                }
                array[j].NineClocksMinPrice = emMinValue
                j = j + 1
            }
        default:
            break
        }
    }
}
