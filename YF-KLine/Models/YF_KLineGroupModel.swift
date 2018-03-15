//
//  YF_KLineGroupModel.swift
//  YF-KLine
//
//  Created by tsaievan on 27/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_KLineGroupModel: NSObject {
    
    var models: [Any]?
    
    class func getObject(array: [Any], successs: ((YF_KLineGroupModel)->())?, failue:(() -> ())?) {
        let groupModel = YF_KLineGroupModel()
        var mtArray: [YF_KLineModel] = [YF_KLineModel]()
        var preModel = YF_KLineModel()
        DispatchQueue.global().async {
            for arr in array {
                guard let a = arr as? [Any] else {
                    DispatchQueue.main.async {
                        failue?()
                    }
                    return
                }
                ///< 在这里字典转模型!
                let m = YF_KLineModel()
                ///< 这里将前一个klineModel赋值给当前klineModel的previous属性
                m.previousKLineModel = preModel
                m.initWith(array: a)
                ///< 这里将本模型赋值给klineModel的parentGroupModel对象, 这样klineModel就知道自己所在的组
                m.parentGroupModel = groupModel
                ///< 用可变数组将模型都存起来
                mtArray.append(m)
                ///< 将当前模型赋值给preModel变量
                preModel = m
            }
            ///< 将可变数组赋值给组模型的models属性
            groupModel.models = mtArray
            ///< 初始化第一个model的数据
            let firstModel = mtArray[0]
            firstModel.initFirstModel()
            
            ///< 初始其他model的数据
            for m in mtArray {
                m.initData()
            }
            DispatchQueue.main.async {
                successs?(groupModel)
            }
        }
    }
}
