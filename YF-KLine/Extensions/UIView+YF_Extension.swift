//
//  UIView+YF_Extension.swift
//  YF-KLine
//
//  Created by tsaievan on 28/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit


// MARK: - UIView的分类, 先写了放在这里
extension UIView {
    ///< View的x值
    ///< 这里需要注意的是, 是用frame值的origin.x, 之前使用bounds, 返回一直是0, 坑了半天
    var x: CGFloat {
        set {
            let X = x
            frame.origin.x = X
        }
        get {
           return frame.origin.x
        }
    }
    
    ///< View的y值
    var y: CGFloat {
        set {
            let Y = y
            frame.origin.y = Y
        }
        get {
            return frame.origin.y
        }
    }
    
    var width: CGFloat {
        set {
            let W = width
            frame.size.width = W
        }
        get {
            return frame.width
        }
    }
    
    var height: CGFloat {
        set {
            let H = height
            frame.size.height = H
        }
        get {
            return frame.height
        }
    }
}
