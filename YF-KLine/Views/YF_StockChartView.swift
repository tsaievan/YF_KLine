//
//  YF_StockChartView.swift
//  YF-KLine
//
//  Created by tsaievan on 27/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

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
    
    ///< 数据源
    weak var dataSource: YF_StockChartViewDataSource? {
        didSet {
            if itemModels != nil {
                segmentView.selectedIndex = 4
            }
        }
    }
    
    /**
     * 在模型数组的set方法中
     * 1. 遍历数组模型
     * 2. 创建新的数组, 把遍历出来的模型对象的title作为元素加到新数组中
     */
    var itemModels: [Any]? {
        didSet {
            guard let models = itemModels else {
                return
            }
            var array = [String]()
            for m in models {
                array.append(((m as? YF_StockChartViewItemModel)?.title) ?? "")
            }
            
            ///< 把这个包含标题元素的数组又传给segmentView的items, 在segmentView的items的setter方法中做一些事情
            segmentView.items = array
            ///< 取出模型数组的第一个模型的type作为当前view的type(或K线, 或分时, 或其他)
            guard let type = (itemModels?.first as? YF_StockChartViewItemModel)?.centerViewType else {
                return
            }
            currentCenterViewType = type
            if dataSource != nil {
                segmentView.selectedIndex = 4
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI
extension YF_StockChartView {
    fileprivate func setupUI() {
        makeConstraints()
    }
    
    fileprivate func makeConstraints() {
        kLine.snp.makeConstraints { (make) in
            make.bottom.right.top.equalTo(self)
            make.left.equalTo(segmentView.snp.right)
        }
        
        segmentView.snp.makeConstraints { (make) in
            make.bottom.left.top.equalTo(self)
            make.width.equalTo(50)
        }
    }
}

// MARK: - 事件处理
extension YF_StockChartView {
    func reloadData() {
        ///< reload方法实际上是调用segmentView的selectedIndex的setter方法
        segmentView.selectedIndex = segmentView.selectedIndex
    }
}


// MARK: - YF_StockChartSegmentViewDelegate代理方法实现
extension YF_StockChartView: YF_StockChartSegmentViewDelegate {
    func clickSegmentButton(index: Int?, chartSegmentView: YF_StockChartSegmentView?) {
        currentIndex = index
        guard let i = index else {
            return
        }
        if i == 105 {
            YF_StockChartVariable.setIsBOLLLine(BOLLLine: .BOLL)
            kLine.targetLineStatus = i
            kLine.reDraw()
            bringSubview(toFront: segmentView)
        }else if i >= 100 && i != 105 {
            YF_StockChartVariable.setIsEMALine(EMALine: YF_StockChartTargetLineStatus(rawValue: i))
            kLine.targetLineStatus = i
            kLine.reDraw()
            bringSubview(toFront: segmentView)
        }else {
            ///< 通过index获取数据源, 根据index获取items数组中的item元素
            guard let data = dataSource?.getStockDatas(index: i),
                let items = itemModels,
                let item = items[i] as? YF_StockChartViewItemModel else {
                    return
            }
            let type = item.centerViewType ?? .other
            ///< 当index对应的模型的type和当前type不同时
            if type != currentCenterViewType {
                currentCenterViewType = type
                switch type {
                case .kLine:
                    kLine.isHidden = false
                    bringSubview(toFront: segmentView)
                default: break
                }
            }
            ///< 当index对应的模型的type不为其他时
            if type != .other {
                ///< 把代理方法获取到的data数据传给K线的view
                kLine.kLineModels = data as? [Any]
                ///< 设置K线View的类型
                kLine.mainViewType = type
                ///< 重绘K线
                kLine.reDraw()
            }
            bringSubview(toFront: segmentView)
        }
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
