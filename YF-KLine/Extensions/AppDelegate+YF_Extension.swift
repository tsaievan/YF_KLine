//
//  AppDelegate+YF_Extension.swift
//  YF-KLine
//
//  Created by tsaievan on 14/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

extension AppDelegate {
    func requestBaseData() {
        ///< 目前没有参数, 先填空吧, 以后接口变了可能会用的到
        let paramsArray = ["m", "w", "d"]
        var params = [String : Any]()
        
        //        params["symbol"] = "btcusdt"
        //        params["size"] = "300"
        ///< 获取前一天的日期
        let date = Date(timeIntervalSinceNow: -60 * 60 * 24)
        ///< 获取八年前的日期
        let twoYearsDate = Date(timeIntervalSinceNow: -60 * 60 * 24 * 365 * 7)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        let dateString = dateFormatter.string(from: date)
        let twoYearsDateString = dateFormatter.string(from: twoYearsDate)
        params["start"] = twoYearsDateString
        params["end"] = dateString
        for period in paramsArray {
            params["period"] = period
            ///< 请求近两年的数据
            ///< 一些获取行情历史数据的接口
            ///< http://img1.money.126.net/data/hs/kline/day/history/2015/1399001.json
            ///< https://api.huobi.pro/market/history/kline
            ///< http://q.stock.sohu.com/hisHq?code=zs_000001&start=19990504&end=20171215&stat=1&order=D&period=d&callback=historySearchHandler&rt=jsonp&r=0.8391495715053367&0.9677250558488026
            let urlString = "http://q.stock.sohu.com/hisHq?code=zs_000001&stat=1&order=D&rt=jsonp&r=0.8391495715053367&0.9677250558488026"
            YF_NetworkTool.request(url: urlString, params: params, success: { (response) in
                guard let array = response["hq"] as? [Any] else {
                    return
                }
                ///< 将数据存成本地文件
                ///< 获取路径
                guard let filePath = YF_DefaultFunction.getBaseDataPath() else {
                    return
                }
                let filePathUrl = URL(fileURLWithPath: filePath + period)
                guard let data = try? JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted) else {
                    return
                }
                try? data.write(to: filePathUrl, options: .atomic)
            }, failue: nil)
        }
    }
}
