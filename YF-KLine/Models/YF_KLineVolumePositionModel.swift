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
    
    class func model(withStartPoint startPoint: CGPoint, endPoint: CGPoint) -> YF_KLineVolumePositionModel {
        let volumePositionModel = YF_KLineVolumePositionModel()
        volumePositionModel.StartPoint = startPoint
        volumePositionModel.EndPoint = endPoint
        return volumePositionModel
    }
}
