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
    var SumOfLastClose: NSNumber?
    
    ///< 该model及其之前所有成交量之和
    var SumOfLastVolume: NSNumber?
    
    ///< 日期
    var Date: NSString?
    
    ///< 开盘价
    var Open: NSNumber?
    
    ///< 收盘价
    var Close: NSNumber?
    
    ///< 最高价
    var High: NSNumber?
    
    ///< 最低价
    var Low: NSNumber?
    
    ///< 成交量
    var Volume: CGFloat?
    
    ///< 是否是某个月的第一个交易日
    var isFirstTradeDate: Bool?
    
    // MARK: - 内部自动初始化
    var MA7: NSNumber?
    
    func initWith(dictionary dict: [String : Any]) {
        
    }
    
    func initFirstModel() {
        
    }
    
    func initData() {
        
    }
}
