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
    
    var kLineColors: [UIColor]?
    
    ///< 需要绘制的成交量的位置模型数组
    fileprivate var needDrawKLineVolumePositionModels: [YF_KLineVolumePositionModel]?
    
    ///< Volume_MA7位置数组
    fileprivate var Volume_MA7Positions = [CGPoint]()
    
    ///< Volume_MA30位置数组
    fileprivate var Volume_MA30Positions = [CGPoint]()
    
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
        
        //FIXME:- MA线先不画
        
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
        let maxY = bounds.height
        
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
            guard let positionModels = needDrawKLineVolumePositionModels else {
                return nil
            }
            let kLinePositionModel = positionModels[idx]
        }
        
        
        
        return nil
    }
}
