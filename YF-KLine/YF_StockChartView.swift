//
//  YF_StockChartView.swift
//  YF-KLine
//
//  Created by tsaievan on 27/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

enum YF_StockChartViewType {
    case kLine
    case timeLine
    case other
}

///< YF_StockChartView的数据源
protocol YF_StockChartViewDataSource: NSObjectProtocol {
    func getStockDatas(index: Int) -> Any?
}

class YF_StockChartView: UIView {
    
    weak var dataSource: YF_StockChartViewDataSource?
    
    var itemModels: [Any]? {
        didSet {
            
        }
    }

    func reloadData() {
        
    }

}


class YF_StockChartViewItemModel: NSObject {
    var title: String?
    
    class func getItemModel(title: String?, type: YF_StockChartViewType?) -> YF_StockChartViewItemModel {
        let model = YF_StockChartViewItemModel()
        return model
    }
}
