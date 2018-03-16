//
//  YF_DefaultFunction.swift
//  YF-KLine
//
//  Created by tsaievan on 16/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_DefaultFunction {
    class func getBaseDataPath() -> String? {
        let baseDataFile = "/baseDataFile.json"
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else {
            return nil
        }
        return path + baseDataFile
    }
}
