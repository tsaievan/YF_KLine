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
        let params = [String : Any]()
        //        params["period"] = self.currentType
        //        params["symbol"] = "btcusdt"
        //        params["size"] = "300"
        ///< 获取前一天的日期
        let date = Date(timeIntervalSinceNow: -60 * 60 * 24)
        ///< 获取两年前的日期
        let twoYearsDate = Date(timeIntervalSinceNow: -60 * 60 * 24 * 365 * 5)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        let dateString = dateFormatter.string(from: date)
        let twoYearsDateString = dateFormatter.string(from: twoYearsDate)
        
        ///< 请求近两年的数据
        let urlString = "http://q.stock.sohu.com/hisHq?code=zs_000001&start=\(twoYearsDateString)&end=\(dateString)&stat=1&order=D&period=d&rt=jsonp&r=0.8391495715053367&0.9677250558488026"
        //        YF_NetworkTool.request(url: urlString, params: params, success: { (response) in
        //            guard let array = response["hq"] as? [Any],
        //                let groupModel = YF_KLineGroupModel.getObject(array: array), ///< 字典转模型
        //                let type = self.currentType else {
        //                    return
        //            }
        //            self.gModel = groupModel
        //            self.modelsDict[type] = groupModel ///< 将模型放到字典里面, 用做缓存, 不用每次加载网络请求
        //            self.stockChartView.reloadData() ///< stockChartView刷新数据
        //        }, failue: nil)
        YF_NetworkTool.request(url: urlString, params: params, success: { (response) in
            guard let array = response["hq"] as? [Any] else {
                return
            }
            ///< 将数据存成本地文件
            ///< 获取路径
            guard let filePath = YF_DefaultFunction.getBaseDataPath() else {
                return
            }
            let filePathUrl = URL(fileURLWithPath: filePath)
            guard let data = try? JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted) else {
                return
            }
            
            try? data.write(to: filePathUrl, options: .atomic)
            
        }, failue: nil)
    }
}
