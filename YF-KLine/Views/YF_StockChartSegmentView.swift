//
//  YF_StockChartSegmentView.swift
//  YF-KLine
//
//  Created by tsaievan on 28/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

let STOCK_CHART_SEGMENT_START_TAG = 2000

///< 底部选择view的代理协议
protocol YF_StockChartSegmentViewDelegate: NSObjectProtocol {
    func clickSegmentButton(index: Int?, chartSegmentView: YF_StockChartSegmentView?)
}

class YF_StockChartSegmentView: UIView {
    ///< 代理属性
    weak var delegate: YF_StockChartSegmentViewDelegate?
    
    ///< segmentView的模型数组
    var items: [Any]?
    
    ///< 选择的index, 先赋值一个0吧, 后面可能会改
    var selectedIndex: Int = 0 {
        didSet {
            guard let btn = viewWithTag(STOCK_CHART_SEGMENT_START_TAG + selectedIndex) as? UIButton else {
                return
            }
            ///< 在set方法中调用按钮的点击事件
            segmentButtonClicked(sender: btn)
        }
    }
    
    fileprivate lazy var indicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.backgroundColor = ASSISTANT_BACKGROUND_COLOR
        let titleArray = ["MACD",
                          "KDJ",
                          "关闭",
                          "MA",
                          "EMA",
                          "BOLL",
                          "关闭"]
        var preButton: UIButton?
        for (i, title) in titleArray.enumerated() {
            ///< 循环创建button
//            let btn = UIButton()
            let btn = UIButton(title: title, titleColor: MAIN_TEXT_COLOR, selectedColor: MA_30_COLOR, fontSize: 13, target: self, action: #selector(YF_StockChartSegmentView.segmentButtonClicked(sender:)))
            btn.tag = STOCK_CHART_SEGMENT_START_TAG + 100 + i
            indicatorView.addSubview(btn)
            btn.snp.makeConstraints{ make in
                /**
                 * note: 这里要特别注意
                 * 因为我之前写的是CGFloat(1 / titleArray.count)
                 * 因为 1 为Int类型, 所以 1 / titleArray.count 始终为0
                 * 就算强转成CGFloat, 也是0.0
                 * 所以应该在除之前, 就转换类型
                 */
                make.height.equalTo(indicatorView).multipliedBy(1.0 / CGFloat(titleArray.count))
                make.width.equalTo(indicatorView)
                make.left.equalTo(indicatorView)
                if preButton != nil {
                    make.top.equalTo(preButton!.snp.bottom)
                }else {
                    make.top.equalTo(indicatorView)
                }
            }
            
            ///< 循环创建分割线
            let view = UIView()
            view.backgroundColor = UIColor(red: 52.0 / 255.0, green: 56.0 / 255.0, blue: 67.0 / 255.0, alpha: 1.0)
            indicatorView.addSubview(view)
            
            view.snp.makeConstraints({ (make) in
                make.left.right.equalTo(btn)
                make.top.equalTo(btn.snp.bottom)
                make.height.equalTo(0.5)
            })
            ///< 将当前创建出来的button赋值给前一个button变量
            preButton = btn
        }
        let firstButton = indicatorView.subviews[0] as! UIButton
        firstButton.isSelected = true
        secondLevelSelectedBtn1 = firstButton
        let firstButton2 = indicatorView.subviews[6] as! UIButton
        firstButton2.isSelected = true
        secondLevelSelectedBtn2 = firstButton2
        addSubview(indicatorView)
        return indicatorView
    }()
    
    ///< 选择的按钮
    fileprivate var selectedBtn: UIButton?
    
    ///< 二级选择按钮1
    fileprivate var secondLevelSelectedBtn1: UIButton?
    
    ///< 二级选择按钮2
    fileprivate var secondLevelSelectedBtn2: UIButton?
    
    ///< 便利构造函数
    convenience init(items: [Any]) {
        self.init(frame: .zero)
        self.items = items
    }
    
    ///< 重写指定构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI
extension YF_StockChartSegmentView {
    fileprivate func setupUI() {
        clipsToBounds = true
        backgroundColor = ASSISTANT_BACKGROUND_COLOR
        makeConstraints()
    }
    
    fileprivate func makeConstraints() {
        indicatorView.snp.makeConstraints({ (make) in
            make.height.bottom.width.equalTo(self)
            make.right.equalTo(self.snp.right)
        })
    }
}

// MARK: - 按钮点击事件
extension YF_StockChartSegmentView {
    @objc fileprivate func segmentButtonClicked(sender: UIButton) {
        selectedBtn = sender
        if sender.tag == STOCK_CHART_SEGMENT_START_TAG {
            return
        }
        delegate?.clickSegmentButton(index: sender.tag, chartSegmentView: self)
    }
}
