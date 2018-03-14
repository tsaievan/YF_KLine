//
//  YF_DefaultFunction.swift
//  YF-KLine
//
//  Created by tsaievan on 14/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_DefaultFunction {
    class func getBaseDataPath() -> String? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else {
            return nil
        }
        let filePath = path + "/stockIndexHistoryData.json"
        return filePath
    }
}
