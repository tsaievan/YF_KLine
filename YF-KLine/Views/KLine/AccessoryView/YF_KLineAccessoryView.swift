//
//  YF_KLineAccessoryView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

protocol YF_KLineAccessoryViewDelegate: NSObjectProtocol {
    func kLineAccessoryViewCurrent(withMaxVaule maxValue: CGFloat, minValue: CGFloat)
}

class YF_KLineAccessoryView: UIView {
    ///< 需要绘制的K线模型数组
    var needDrawKLineModels: [YF_KLineModel]?
    
    ///< 需要绘制的K线位置数组
    var needDrawKLinePositionModels: [YF_KLinePositionModel]?
    
    ///< K线的颜色数组
    var kLineColors: [UIColor]?
    
    ///< 指标种类
    var targetLineStatus: YF_StockChartTargetLineStatus?
    
    ///< 需要绘制的Volume_MACD位置模型数组
    fileprivate var needDrawKLineAccessoryPositionModels = [YF_KLineVolumePositionModel]()
    
    ///< Volume_DIF位置数组
    fileprivate var Accessory_DIFPositions = [CGPoint]()
    
    ///< Volume_DEA位置数组
    fileprivate var Accessory_DEAPositions = [CGPoint]()
    
    ///< KDJ_K位置数组
    fileprivate var Accessory_KDJ_KPositions = [CGPoint]()
    
    ///< KDJ_D位置数组
    fileprivate var Accessory_KDJ_DPositions = [CGPoint]()
    
    ///< KDJ_J位置数组
    fileprivate var Accessory_KDJ_JPositions = [CGPoint]()
    
    ///< 代理
    weak var delegate: YF_KLineAccessoryViewDelegate?
    
    ///< 重写drawRect方法
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        ///< 副图, 需要区分是MACD线还是KDJ线, 进而选择不同的数据源和绘制方法
        if targetLineStatus != .KDJ {
            ///< MACD线
            let kLineAccessory = YF_KLineAccessory(context: context)
            for (idx, volumePositionModel) in needDrawKLineAccessoryPositionModels.enumerated() {
                kLineAccessory.positionModel = volumePositionModel
                guard let models = needDrawKLineModels,
                    let colors = kLineColors else {
                    return
                }
                kLineAccessory.kLineModel = models[idx]
                kLineAccessory.lineColor = colors[idx]
                kLineAccessory.draw()
            }
            let MALine = YF_MALine(context: context)
            ///< 画DIF线
            MALine.MAType = .MA7Type
            MALine.MAPositions = Accessory_DIFPositions
            MALine.draw()
            
            ///< 画DEA线
            MALine.MAType = .MA30Type
            MALine.MAPositions = Accessory_DEAPositions
            MALine.draw()
        }else {
            let MALine = YF_MALine(context: context)
            ///< 画KDJ_K线
            MALine.MAType = .MA7Type
            MALine.MAPositions = Accessory_KDJ_KPositions
            MALine.draw()
            
            ///< 画KDJ_D线
            MALine.MAType = .MA30Type
            MALine.MAPositions = Accessory_KDJ_DPositions
            MALine.draw()
            
            ///< 画KDJ_J线
            MALine.MAType = YF_MAType(rawValue: -1)
            MALine.MAPositions = Accessory_KDJ_JPositions
            MALine.draw()
        }   
    }
}


// MARK: - 绘图的相关方法
extension YF_KLineAccessoryView {
    
    ///< 在这个方法中, 将K线模型点转换成KLineAccessory线的坐标点
    func draw() {
        guard let models = needDrawKLineModels else {
            return
        }
        needDrawKLineAccessoryPositionModels = convertToKLinePositionModel(withKLineModels: models)
        ///< 调用此方法会间接调用drawRect方法
        setNeedsDisplay()
    }
}

extension YF_KLineAccessoryView {
    fileprivate func convertToKLinePositionModel(withKLineModels kLineModels: [YF_KLineModel]) -> [YF_KLineVolumePositionModel] {
        let minY = STOCK_CHART_K_LINE_ACCESSORY_VIEW_MIN_Y
        let maxY = height
        var minValue = CGFloat(MAXFLOAT)
        var maxValue = CGFloat(0.0)
        
        var volumePositionModels = [YF_KLineVolumePositionModel]()
        if targetLineStatus != .KDJ { ///< 不为KDJ模式
            ///< 第一次循环是为了找出最大值和最小值
            for model in kLineModels {
                if let dif = model.DIF {
                    if CGFloat(dif) < minValue {
                        minValue = CGFloat(dif)
                    }
                    if CGFloat(dif) > maxValue {
                        maxValue = CGFloat(dif)
                    }
                }
                if let dea = model.DEA {
                    if CGFloat(dea) < minValue {
                        minValue = CGFloat(dea)
                    }
                    if CGFloat(dea) > maxValue {
                        maxValue = CGFloat(dea)
                    }
                }
                if let macd = model.MACD {
                    if CGFloat(macd) < minValue {
                        minValue = CGFloat(macd)
                    }
                    if CGFloat(macd) > maxValue {
                        maxValue = CGFloat(macd)
                    }
                }
            }
            let unitValue = (maxValue - minValue) / (maxY - minY)
            ///< 因为这个方法会调用多次, 所以数组在添加之前一定要清空
            Accessory_DIFPositions.removeAll()
            Accessory_DEAPositions.removeAll()
            
            ///< 第二次循环将K线的模型转换成交易量的位置模型存储起来
            ///< 并且将CGPoint的点数组准备好
            for (idx, model) in kLineModels.enumerated() {
                guard let positionModels = needDrawKLinePositionModels else {
                    return volumePositionModels
                }
                let kLinePositionModel = positionModels[idx]
                let xPosition = kLinePositionModel.HighPoint?.x ?? 0
                let yPosition = -CGFloat(model.MACD ?? 0) / unitValue + (maxY - (-minValue) / unitValue)
                let startPoint = CGPoint(x: xPosition, y: yPosition)
                let endPoint = CGPoint(x: xPosition, y: (maxY - (-minValue) / unitValue))
                
                let volumePositionModel = YF_KLineVolumePositionModel.model(withStartPoint: startPoint, endPoint: endPoint)
                volumePositionModels.append(volumePositionModel)
                
                ///< MA坐标转换
                var DIFY = maxY
                var DEAY = maxY
                if unitValue > 0.0000001 {
                    if let dif = model.DIF {
                        DIFY = -CGFloat(dif) / unitValue + (maxY - (-minValue) / unitValue)
                    }
                    if let dea = model.DEA {
                        DEAY = -CGFloat(dea) / unitValue + (maxY - (-minValue) / unitValue)
                    }
                }
                let DIFPoint = CGPoint(x: xPosition, y: DIFY)
                let DEAPoint = CGPoint(x: xPosition, y: DEAY)
                
                if model.DIF != nil {
                    Accessory_DIFPositions.append(DIFPoint)
                }
                if model.DEA != nil {
                    Accessory_DEAPositions.append(DEAPoint)
                }
            }
        }else { ///< KDJ模式
            ///< 第一次循环是为了找出最大值和最小值
            for model in kLineModels {
                if let kdj_k = model.KDJ_K {
                    if CGFloat(kdj_k) < minValue {
                        minValue = CGFloat(kdj_k)
                    }
                    if CGFloat(kdj_k) > maxValue {
                        maxValue = CGFloat(kdj_k)
                    }
                }
                if let kdj_d = model.KDJ_D {
                    if CGFloat(kdj_d) < minValue {
                        minValue = CGFloat(kdj_d)
                    }
                    if CGFloat(kdj_d) > maxValue {
                        maxValue = CGFloat(kdj_d)
                    }
                }
                if let kdj_j = model.KDJ_J {
                    if CGFloat(kdj_j) < minValue {
                        minValue = CGFloat(kdj_j)
                    }
                    if CGFloat(kdj_j) > maxValue {
                        maxValue = CGFloat(kdj_j)
                    }
                }
            }
            let unitValue = (maxValue - minValue) / (maxY - minY)
            ///< 将几个KDJ数组里面的元素都清空, 因为这个方法可能会调用多次, 所以如果不清空的话会造成元素异常
            Accessory_KDJ_KPositions.removeAll()
            Accessory_KDJ_DPositions.removeAll()
            Accessory_KDJ_JPositions.removeAll()
            
            ///< 第二次循环将K线的模型转换成交易量的位置模型存储起来
            ///< 并且将CGPoint的点数组准备好
            for (idx, model) in kLineModels.enumerated() {
                guard let positionModels = needDrawKLinePositionModels else {
                    return volumePositionModels
                }
                let kLinePositionModel = positionModels[idx]
                let xPosition = kLinePositionModel.HighPoint?.x ?? 0
                
                ///< MA坐标转换
                var KDJ_K_Y = maxY
                var KDJ_D_Y = maxY
                var KDJ_J_Y = maxY
                
                if unitValue > 0.0000001 {
                    if let kdj_k = model.KDJ_K {
                        KDJ_K_Y = maxY - (CGFloat(kdj_k) - minValue) / unitValue
                    }
                    if let kdj_d = model.KDJ_D {
                        KDJ_D_Y = maxY - (CGFloat(kdj_d) - minValue) / unitValue
                    }
                    if let kdj_j = model.KDJ_J {
                        KDJ_J_Y = maxY - (CGFloat(kdj_j) - minValue) / unitValue
                    }
                }
                let KDJ_KPoint = CGPoint(x: xPosition, y: KDJ_K_Y)
                let KDJ_DPoint = CGPoint(x: xPosition, y: KDJ_D_Y)
                let KDJ_JPoint = CGPoint(x: xPosition, y: KDJ_J_Y)
                
                if model.KDJ_K != nil {
                    Accessory_KDJ_KPositions.append(KDJ_KPoint)
                }
                if model.KDJ_D != nil {
                    Accessory_KDJ_DPositions.append(KDJ_DPoint)
                }
                if model.KDJ_J != nil {
                    Accessory_KDJ_JPositions.append(KDJ_JPoint)
                }
            }
        }
        delegate?.kLineAccessoryViewCurrent(withMaxVaule: maxValue, minValue: minValue)
        return volumePositionModels
    }
}

