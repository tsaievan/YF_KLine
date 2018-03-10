//
//  YF_StockChartRightYView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_StockChartRightYView: UIView {
    var maxValue: CGFloat? {
        didSet {
            maxValueLabel.text = String(format: "%.2f", maxValue ?? 0.0)
        }
    }
    
    var middleValue: CGFloat? {
        didSet {
            middleValueLabel.text = String(format: "%.2f", middleValue ?? 0.0)
        }
    }
    
    var minValue: CGFloat? {
        didSet {
            minValueLabel.text = String(format: "%.2f", minValue ?? 0.0)
        }
    }
    
    var minLabelText: String?
    
    lazy fileprivate var maxValueLabel: UILabel = {
        let max = UILabel(text: nil, textColor: .red, fontSize: 10)
        addSubview(max)
        max.snp.makeConstraints({ (make) in
            make.top.right.width.equalTo(self)
            make.height.equalTo(20)
        })
        return max
    }()
    
    lazy fileprivate var middleValueLabel: UILabel = {
        let middle = UILabel(text: nil, textColor: .brown, fontSize: 10)
        addSubview(middle)
        middle.snp.makeConstraints({ (make) in
            make.centerY.right.equalTo(self)
            make.height.width.equalTo(maxValueLabel)
        })
        return middle
    }()
    
    lazy fileprivate var minValueLabel: UILabel = {
        let min = UILabel(text: nil, textColor: .cyan, fontSize: 10)
        addSubview(min)
        min.snp.makeConstraints({ (make) in
            make.bottom.right.equalTo(self)
            make.height.width.equalTo(maxValueLabel)
        })
        return min
    }()
}
