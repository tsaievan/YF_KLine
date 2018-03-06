//
//  YF_KLineVolumePositionModel.swift
//  YF-KLine
//
//  Created by tsaievan on 5/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_KLineVolumePositionModel: NSObject {
    
    ///< 起始点
    var StartPoint: CGPoint?
    
    ///< 终止点
    var EndPoint: CGPoint?
    
    ///< 最高点
    var HighPoint: CGPoint?
    
    ///< 最低点
    var LowPoint: CGPoint?
    
    class func model(withStartPoint startPoint: CGPoint, endPoint: CGPoint, highPoint: CGPoint, lowPoint: CGPoint) -> YF_KLineVolumePositionModel {
        let volumePositionModel = YF_KLineVolumePositionModel()
        volumePositionModel.StartPoint = startPoint
        volumePositionModel.EndPoint = endPoint
        volumePositionModel.HighPoint = highPoint
        volumePositionModel.LowPoint = lowPoint
        return volumePositionModel
    }
}
