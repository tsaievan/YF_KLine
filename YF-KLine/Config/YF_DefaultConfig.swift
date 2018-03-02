//
//  YF_DefaultConfig.swift
//  YF-KLine
//
//  Created by tsaievan on 27/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == .phone)

let SCREEN_BOUNDS = UIScreen.main.bounds

let SCREEN_WIDTH = UIScreen.main.bounds.width

let SCREEN_HEIGHT = UIScreen.main.bounds.height

let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_X = (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)


// MARK: - 颜色
let CHARTVIEW_BACKGROUND_COLOR = UIColor.color(RGBHex: 0x181c20) ///< chartView的北京颜色

let ASSISTANT_BACKGROUND_COLOR = UIColor.color(RGBHex: 0x1d2227) ///< 辅助背景颜色

let MAIN_TEXT_COLOR = UIColor.color(RGBHex: 0xe1e2e6) ///< 主文字颜色

let MA_30_COLOR = UIColor.color(RGBHex: 0x49a5ff) ///< MA30颜色

let SEPERATOR_LINE_COLOR = UIColor(red: 52.0 / 255.0, green: 56.0 / 255.0, blue: 67.0 / 255.0, alpha: 1.0)


