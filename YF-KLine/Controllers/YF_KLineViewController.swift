//
//  YF_KLineViewController.swift
//  YF-KLine
//
//  Created by tsaievan on 27/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

let MAX_COUNT = 1000000000

class YF_KLineViewController: UIViewController {
    
    var currentIndex: Int = -1
    
    var currentType: String?
    
    var gModel: YF_KLineGroupModel?
    
    var loadTimes: Int = 0
    
    var remainDataCount: Int = MAX_COUNT
    lazy var stockChartView: YF_StockChartView = {
        let chartView = YF_StockChartView(frame: SCREEN_BOUNDS)
        chartView.backgroundColor = CHARTVIEW_BACKGROUND_COLOR
        chartView.dataSource = self
        chartView.itemModels = [
            YF_StockChartViewItemModel.getItemModel(title: "指标", type: .other),
            YF_StockChartViewItemModel.getItemModel(title: "分时", type: .timeLine),
            YF_StockChartViewItemModel.getItemModel(title: "1分", type: .kLine),
            YF_StockChartViewItemModel.getItemModel(title: "5分", type: .kLine),
            YF_StockChartViewItemModel.getItemModel(title: "30分", type: .kLine),
            YF_StockChartViewItemModel.getItemModel(title: "60分", type: .kLine),
            YF_StockChartViewItemModel.getItemModel(title: "日线", type: .kLine),
            YF_StockChartViewItemModel.getItemModel(title: "周线", type: .kLine),
        ]
        return chartView
    }()
    
    ///< 懒加载属性
    lazy var modelsDict: [String : YF_KLineGroupModel] = {
        var dict = [String : YF_KLineGroupModel]()
        return dict
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: 横竖屏的设置
extension YF_KLineViewController {
    ///< 自动旋转 设置为false
    override var shouldAutorotate: Bool {
        return false
    }
    
    ///< 支持的屏幕类型: 支持横屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}

// MARK: 设置UI
extension YF_KLineViewController {
    fileprivate func setupUI() {
        view.addSubview(stockChartView)
        ///< 设置stockView的约束
        makeConstraints()
        addGestures()
    }
    
    fileprivate func makeConstraints() {
        stockChartView.snp.makeConstraints { (make) in
            if IS_IPHONE_X {
                make.edges.equalTo(view).inset(UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0))
            }else {
                make.edges.equalTo(view)
            }
        }
    }
    
    fileprivate func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(YF_KLineViewController.dismissViewController))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
}

// MARK: YF_StockChartViewDataSource数据源方法
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
            loadData()
        }else { ///< 如果字典里面有数据, 就返回数据
            return modelsDict[t]
        }
        return nil
    }
}

// MARK: 事件处理
extension YF_KLineViewController {
    ///< 双击返回页面
    @objc fileprivate func dismissViewController() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            dismiss(animated: true, completion: nil)
            return
        }
        appDelegate.isLandScape = false
        dismiss(animated: true, completion: nil)
    }
    
    ///< 加载数据
    @objc fileprivate func loadData() {
        guard let filePath = YF_DefaultFunction.getBaseDataPath() else {
            return
        }
        ///< 如果文件存在, 读取文件中的前300条数据
        if FileManager.default.fileExists(atPath: filePath) {
            let url = URL(fileURLWithPath: filePath)
            guard let data = try? Data(contentsOf: url),
                let rawData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let dataArray = rawData as? [Any],
                let type = self.currentType else {
                    return
            }
            YF_KLineGroupModel.getObject(array: dataArray, successs: { (groupModel) in
                self.gModel = groupModel
                self.modelsDict[type] = self.gModel ///< 将模型放到字典里面, 用做缓存, 不用每次加载网络请求
                self.stockChartView.reloadData() ///< stockChartView刷新数据
            }, failue: nil)
        }
    }
}

