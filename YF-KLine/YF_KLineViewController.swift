//
//  YF_KLineViewController.swift
//  YF-KLine
//
//  Created by tsaievan on 27/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_KLineViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
    }
}

extension YF_KLineViewController: YF_StockChartViewDataSource {
    func getStockDatas(index: Int) {
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
        reloadData()
    }
}

extension YF_KLineViewController {
    
    ///< 加载数据
    fileprivate func reloadData() {
        var params = [String : Any]()
        params["period"] = ""
        params["symbol"] = "btcusdt"
        params["size"] = "300"
        YF_NetworkTool.request(url: "https://api.huobi.pro/market/history/kline", params: params, success: { (response) in
            
        }, failue: nil)
    }
}
