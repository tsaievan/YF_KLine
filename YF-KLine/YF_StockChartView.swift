//
//  YF_StockChartView.swift
//  YF-KLine
//
//  Created by tsaievan on 27/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

enum YF_StockChartViewType {
    case kLine ///< K线
    case timeLine ///< 分时图
    case other ///< 其他
}

///< YF_StockChartView的数据源
protocol YF_StockChartViewDataSource: NSObjectProtocol {
    func getStockDatas(index: Int) -> Any?
}

class YF_StockChartView: UIView {
    
    ///< K线图View
    lazy var kLine: YF_KLineView = {
        let k = YF_KLineView()
        addSubview(k)
        return k
    }()
    
    ///< 底部选择View
    lazy var segmentView: YF_StockChartSegmentView = {
        let s = YF_StockChartSegmentView()
        addSubview(s)
        return s
    }()
    
    ///< 图标类型
    var currentCenterViewType: YF_StockChartViewType?
    
    ///< 当前索引
    var currentIndex: Int?
    
    weak var dataSource: YF_StockChartViewDataSource?
    
    var itemModels: [Any]? {
        didSet {
            guard let models = itemModels else {
                return
            }
            var array = [YF_StockChartViewItemModel]()
            for m in models {
                array.append((m as? YF_StockChartViewItemModel) ?? YF_StockChartViewItemModel())
            }
        }
    }

    func reloadData() {
        
    }

}


class YF_StockChartViewItemModel: NSObject {
    ///< 标题
    var title: String?
    ///< 类型(K线, 分时图, 其他)
    var centerViewType: YF_StockChartViewType?
    
    class func getItemModel(title: String?, type: YF_StockChartViewType?) -> YF_StockChartViewItemModel {
        let model = YF_StockChartViewItemModel()
        model.title = title
        model.centerViewType = type
        return model
    }
}
