//
//  YF_KLineVolumeView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

protocol YF_KLineVolumeViewDelegate: NSObjectProtocol {
    func kLineVolumeView(currentMaxVolume maxVolume: CGFloat, minVolume: CGFloat);
}

class YF_KLineVolumeView: UIView {
    
    ///< 需要绘制的K线模型数组
    var needDrawKLineModels: [YF_KLineModel]?
    
    ///< 需要绘制的K线位置数组
    var needDrawKLinePositionModles: [YF_KLinePositionModel]?
    
    ///< K线颜色
    var kLineColors: [UIColor]?
    
    ///< Accessory指标种类
    var targetLineStatus: YF_StockChartTargetLineStatus?
    
    ///< 需要绘制的成交量的位置模型数组
    fileprivate var needDrawKLineVolumePositionModels: [YF_KLineVolumePositionModel]?
    
    ///< Volume_MA7位置数组
    fileprivate var Volume_MA7Positions = [CGPoint]()
    
    ///< Volume_MA30位置数组
    fileprivate var Volume_MA30Positions = [CGPoint]()
    
    ///< 代理
    weak var delegate: YF_KLineVolumeViewDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if needDrawKLineVolumePositionModels == nil {
            return
        }
        
        ///< 获取当前的上下文
        guard let context = UIGraphicsGetCurrentContext(),
        let positonModels = needDrawKLineVolumePositionModels,
        let kLineModels = needDrawKLineModels,
        let colors = kLineColors else {
            return
        }
        let kLineVolume = YF_KLineVolume(context: context)
        for (i, volumePositionModel) in positonModels.enumerated() {
            kLineVolume.positionModel = volumePositionModel
            kLineVolume.kLineModel = kLineModels[i]
            kLineVolume.lineColor = colors[i]
            kLineVolume.draw()
        }
        if targetLineStatus != .CloseMA {
            let MALine = YF_MALine(context: context)
            
            ///< 画MA7线
            MALine.MAType = .MA7Type
            MALine.MAPositions = Volume_MA7Positions
            MALine.draw()
            
            ///< 画MA30线
            MALine.MAType = .MA30Type
            MALine.MAPositions = Volume_MA30Positions
            MALine.draw()
        }
    }
    
    ///< 绘制Volume方法
    func draw() {
        //FIXME:-数据异常没有做判断, 暂时还不知道会不会出问题
        guard let models = needDrawKLineModels else {
            return
        }
        needDrawKLineVolumePositionModels = convertToKLinePositionModel(withKLineModels: models)
        setNeedsDisplay()
    }   
}

extension YF_KLineVolumeView {
    
    ///< 根据KLineModel转换成Position数组
    fileprivate func convertToKLinePositionModel(withKLineModels kLineModels: [YF_KLineModel]) -> [YF_KLineVolumePositionModel]? {
        let minY = STOCK_CHART_K_LINE_VOLUME_VIEW_MIN_Y
        let maxY = height
        
        guard let firstModel = kLineModels.first else {
            return nil
        }
        var minVolume = firstModel.Volume ?? 0
        var maxVolume = firstModel.Volume ?? 0
        
        for model in kLineModels {
            guard let volume = model.Volume else {
                return nil
            }
            if volume < minVolume {
                minVolume = volume
            }
            if volume > maxVolume {
                maxVolume = volume
            }
            if model.Volume_MA7 != nil {
                if minVolume > model.Volume_MA7! {
                    minVolume = model.Volume_MA7!
                }
                if maxVolume < model.Volume_MA7! {
                    minVolume = model.Volume_MA7!
                }
            }
            if model.Volume_MA30 != nil {
                if minVolume > model.Volume_MA30! {
                    minVolume = model.Volume_MA30!
                }
                if maxVolume < model.Volume_MA30! {
                    maxVolume = model.Volume_MA30!
                }
            }
        }
        let unitValue = (maxVolume - minVolume) / Double((maxY - minY))
        var volumePositonModels = [YF_KLineVolumePositionModel]()
        Volume_MA7Positions.removeAll()
        Volume_MA30Positions.removeAll()
        
        for (idx, model) in kLineModels.enumerated() {
            guard let positionModels = needDrawKLinePositionModles else {
                return nil
            }
            let kLinePositionModel = positionModels[idx]
            let xPosition = kLinePositionModel.HighPoint?.x ?? 0
            var yPosition = abs(maxY - CGFloat((model.Volume ?? 0) - minVolume) / CGFloat(unitValue))
            if abs(yPosition - height) < 0.5 {
                yPosition = height - 1
            }
            let startPoint = CGPoint(x: xPosition, y: yPosition)
            let endPoint = CGPoint(x: xPosition, y: height)
            let volumePositionModel = YF_KLineVolumePositionModel.model(withStartPoint: startPoint, endPoint: endPoint)
            volumePositonModels.append(volumePositionModel)
            
            ///< MA坐标转换
            var ma7Y = maxY
            var ma30Y = maxY
            if unitValue > 0.0000001 {
                if model.Volume_MA7 != nil {
                    ma7Y = maxY - CGFloat((model.Volume_MA7! - minVolume) / unitValue)
                }
                if model.Volume_MA30 != nil {
                    ma30Y = maxY - CGFloat((model.Volume_MA30! - minVolume) / unitValue)
                }
            }
            let ma7Point = CGPoint(x: xPosition, y: ma7Y)
            let ma30Point = CGPoint(x: xPosition, y: ma30Y)
            
            if model.Volume_MA7 != nil {
                Volume_MA7Positions.append(ma7Point)
            }
            if model.Volume_MA30 != nil {
                Volume_MA30Positions.append(ma30Point)
            }
        }
        delegate?.kLineVolumeView(currentMaxVolume: CGFloat(maxVolume), minVolume: CGFloat(minVolume))
        return volumePositonModels
    }
}
