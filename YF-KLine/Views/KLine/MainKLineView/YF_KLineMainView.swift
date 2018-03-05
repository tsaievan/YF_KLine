//
//  YF_KLineMainView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

protocol YF_KLineMainViewDelegate: NSObjectProtocol {
    func kLineMainViewCurrent(needDrawKLineModels kLineModels: [YF_KLineModel])
}

class YF_KLineMainView: UIView {
    ///< 父ScrollView
    var parentScrollView: UIScrollView?
    
    var needDrawKLineModels = [YF_KLineModel]()
    
    weak var delegate: YF_KLineMainViewDelegate?
    
    ///< K线类型
    var mainViewType: YF_StockChartViewType?
    
    ///< Accessory指标种类
    var targetLineStatus: YF_StockChartTargetLineStatus?
    
    ///< k线模型对象的数组
    var kLineModels: [Any]?
    
    ///< 需要绘制Index开始值
    var needDrawStartIndex: Int?
    
    ///< 捏合点
    var pinchStartIndex: Int?
    
    ///< 画K线主视图
    func drawMainView() {
        extractNeedDrawModels()
        convertToKLinePositionModel()
        setNeedsDisplay()
    }
    
    ///< 更新宽度
    func updateMainViewWidth() {
        
    }
    
}

extension YF_KLineMainView {
    fileprivate func extractNeedDrawModels() {
        let lineGap = YF_StockChartVariable.kLineGap
        let lineWidth = YF_StockChartVariable.kLineWidth
        
        ///< 数组个数
        guard let scrollViewWidth = parentScrollView?.width else {
            return
        }
        let needDrawKLineCount = Int((scrollViewWidth - lineGap) / (lineGap + lineWidth))
        var needDrawKLineStartIndex: Int
        guard let startIndex = pinchStartIndex else {
            return
        }
        if startIndex > 0 {
            needDrawKLineStartIndex = startIndex
            needDrawStartIndex = startIndex
        }else {
            guard let startIndex = needDrawStartIndex else {
                return
            }
            needDrawKLineStartIndex = startIndex
        }
        needDrawKLineModels.removeAll()
        guard let models = kLineModels else {
            return
        }
        if needDrawKLineStartIndex < models.count {
            if needDrawKLineStartIndex + needDrawKLineCount < models.count {
                let subArry = models[needDrawKLineStartIndex...needDrawKLineCount]
                //FIXME:- 数组的切片还不怎么会用
                let combineArray: [YF_KLineModel] = (needDrawKLineModels as [Any] + subArry) as! [YF_KLineModel]
                needDrawKLineModels = combineArray
            }else {
                let endIndex = models.count - needDrawKLineStartIndex
                let subArry = models[needDrawKLineStartIndex...endIndex]
                let combineArray: [YF_KLineModel] = (needDrawKLineModels as [Any] + subArry) as! [YF_KLineModel]
                needDrawKLineModels = combineArray
            }
        }
        ///< 响应代理
        delegate?.kLineMainViewCurrent(needDrawKLineModels: needDrawKLineModels)
    }
    
    ///< 将model转化为Position模型
    fileprivate func convertToKLinePositionModel() -> [YF_KLineModel]? {
        guard let firstModel = needDrawKLineModels.first else {
            return nil
        }
        var minAssert = firstModel.Low ?? 0
        var maxAssert = firstModel.High ?? 0
        
        guard let models = kLineModels as? [YF_KLineModel] else {
            return nil
        }
        for model in models {
            guard let high = model.High,
            let low = model.Low else {
                return nil
            }
            if high > maxAssert {
                maxAssert = high
            }
            if low < minAssert {
                minAssert = low
            }
            if targetLineStatus == .BOLL {
                if let mb = model.BOLL_MB {
                    if minAssert > mb {
                        minAssert = mb
                    }
                    if maxAssert < mb {
                        maxAssert = mb
                    }
                }
                if let up = model.BOLL_UP {
                    if minAssert > up {
                        minAssert = up
                    }
                    if maxAssert < up {
                        maxAssert = up
                    }
                }
                if let dn = model.BOLL_DN {
                    if minAssert > dn {
                        minAssert = dn
                    }
                    if maxAssert < dn {
                        maxAssert = dn
                    }
                }
            }else {
                if let ma7 = model.MA7 {
                    if minAssert > ma7 {
                        minAssert = ma7
                    }
                    if maxAssert < ma7 {
                        maxAssert = ma7
                    }
                }
                if let ma30 = model.MA30 {
                    if minAssert > ma30 {
                        minAssert = ma30
                    }
                    if maxAssert < ma30 {
                        maxAssert = ma30
                    }
                }

            }
            
        }
        maxAssert *= 1.0001
        minAssert *= 0.9991
        let minY = STOCK_CHART_K_LINE_MAIN_VIEW_MIN_Y
        
        return nil
    }
    
}
