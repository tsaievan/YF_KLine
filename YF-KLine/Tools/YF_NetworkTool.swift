//
//  YF_NetworkTool.swift
//  YF-KLine
//
//  Created by tsaievan on 27/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit
import Alamofire

///< 这里先简单封装一下
class YF_NetworkTool {
    class func request(url: String, params: [String : Any]?, success: (([String : Any]) -> ())?, failue: (() -> ())?) {
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (result) in
            if result.error != nil {
                failue?()
            }else {
                if let data = result.data,
                    let rawValue = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments),
                    let dict = rawValue as? [String : Any] {
                    success?(dict)
                }
            }
        }
    }
}
