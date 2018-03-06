//
//  YF_KLinePositionModel.swift
//  YF-KLine
//
//  Created by tsaievan on 5/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_KLinePositionModel: NSObject {
    
    ///< 开盘点
    var OpenPoint: CGPoint?
    
    ///< 收盘点
    var ClosePoint: CGPoint?
    
    ///< 最高点
    var HighPoint: CGPoint?
    
    ///< 最低点
    var LowPoint: CGPoint?
    
    class func model(withOpenPoint openPoint: CGPoint, closePoint: CGPoint, highPoint: CGPoint, lowPoint: CGPoint) -> YF_KLinePositionModel {
        let positionModel = YF_KLinePositionModel()
        positionModel.OpenPoint = openPoint
        positionModel.ClosePoint = closePoint
        positionModel.HighPoint = highPoint
        positionModel.LowPoint = lowPoint
        return positionModel
    }
}
