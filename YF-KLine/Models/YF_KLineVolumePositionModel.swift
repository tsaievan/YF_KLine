//
//  YF_KLineVolumePositionModel.swift
//  YF-KLine
//
//  Created by tsaievan on 6/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_KLineVolumePositionModel: NSObject {
    ///< 起始点
    var StartPoint: CGPoint?
    
    ///< 终止点
    var EndPoint: CGPoint?
    
    ///< 工厂方法
    class func model(withStartPoint startPoint: CGPoint, endPoint: CGPoint) -> YF_KLineVolumePositionModel {
        let positionModel = YF_KLineVolumePositionModel()
        positionModel.StartPoint = startPoint
        positionModel.EndPoint = endPoint
        return positionModel
    }
}
