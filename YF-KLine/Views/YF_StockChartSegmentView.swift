//
//  YF_StockChartSegmentView.swift
//  YF-KLine
//
//  Created by tsaievan on 28/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

///< 底部选择view的代理
protocol YF_StockChartSegmentViewDelegate: NSObjectProtocol {
    func clickSegmentButton(index: Int?, chartSegmentView: YF_StockChartSegmentView?)
}

class YF_StockChartSegmentView: UIView {
    
    weak var delegate: YF_StockChartSegmentViewDelegate?
    
    var items: [Any]?
    
    var selectedIndex: Int?
    
    convenience init(items: [Any]) {
        self.init(frame: .zero)
        self.items = items
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = ASSISTANT_BACKGROUND_COLOR
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
