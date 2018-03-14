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
    class func request(url: String, params: [String : Any]?, success: (([String: Any]) -> ())?, failue: (() -> ())?) {
        let queue = DispatchQueue(label: "com.tsaievan.networktool")
        queue.async {
            Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseString(completionHandler: { (response) in
                if response.error != nil {
                    failue?()
                }else {
                    guard let resultString = response.value else {
                        return
                    }
                    let startIndex = resultString.index(resultString.startIndex, offsetBy: 10)
                    let endIndex = resultString.index(resultString.endIndex, offsetBy: -3)
                    
                    let freshString = String(resultString[startIndex..<endIndex])
                    guard let data = freshString.data(using: .utf8),
                        let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                        let responseDict = dict as? [String : Any] else {
                            return
                    }
                    success?(responseDict)
                }
            })
        }
    }
}


