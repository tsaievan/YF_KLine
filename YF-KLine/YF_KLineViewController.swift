//
//  YF_KLineViewController.swift
//  YF-KLine
//
//  Created by tsaievan on 27/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_KLineViewController: UIViewController {
    
    var currentIndex: Int = -1
    
    var currentType: String?
    
    var gModel: YF_KLineGroupModel?
    
    lazy var stockChartView: YF_StockChartView = {
        let chartView = YF_StockChartView(frame: SCREEN_BOUNDS)
        chartView.backgroundColor = CHARTVIEW_BACKGROUND_COLOR
//        view.addSubview(chartView)
        return chartView
    }()
    
    ///< 懒加载属性
    lazy var modelsDict: [String : YF_KLineGroupModel] = {
        var dict = [String : YF_KLineGroupModel]()
        return dict
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        view.addSubview(stockChartView)
    }
}

extension YF_KLineViewController: YF_StockChartViewDataSource {
    func getStockDatas(index: Int) -> Any? {
        var type: String?
        switch index {
        case 0:
            type = "1min"
        case 1:
            type = "1min"
        case 2:
            type = "1min"
        case 3:
            type = "5min"
        case 4:
            type = "30min"
        case 5:
            type = "60min"
        case 6:
            type = "1day"
        case 7:
            type = "1week"
        default: break
        }
        currentIndex = index
        currentType = type
        guard let t = type else {
            return nil
        }
        if modelsDict[t] == nil { ///< 如果字典里面没有数据, 那么就去加载数据
            reloadData()
        }else { ///< 如果字典里面有数据, 就返回数据
            return modelsDict[t]
        }
        return nil
    }
}

extension YF_KLineViewController {
    
    ///< 加载数据
    fileprivate func reloadData() {
        var params = [String : Any]()
        params["period"] = self.currentType
        params["symbol"] = "btcusdt"
        params["size"] = "300"
        YF_NetworkTool.request(url: "https://api.huobi.pro/market/history/kline", params: params, success: { (response) in
            guard let dict = response["data"] as? [Any],
            let groupModel = YF_KLineGroupModel.getObject(array: dict), ///< 字典转模型
            let type = self.currentType else {
                return
            }
            self.gModel = groupModel
            self.modelsDict[type] = groupModel ///< 将模型放到字典里面, 可能是做缓存用?
            self.stockChartView.reloadData() ///< stockChartView刷新数据
        }, failue: nil)
    }
}
