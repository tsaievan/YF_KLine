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
    var x: CGFloat {
        set {
            let X = x
            bounds.origin.x = X
        }
        get {
           return bounds.origin.x
        }
    }
    
    ///< View的y值
    var y: CGFloat {
        set {
            let Y = y
            bounds.origin.y = Y
        }
        get {
            return bounds.origin.y
        }
    }
    
    var width: CGFloat {
        set {
            let W = width
            bounds.size.width = W
        }
        get {
            return bounds.width
        }
    }
    
    var height: CGFloat {
        set {
            let H = height
            bounds.size.height = H
        }
        get {
            return bounds.height
        }
    }
}
