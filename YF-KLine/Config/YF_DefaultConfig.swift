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

let CHARTVIEW_BACKGROUND_COLOR = UIColor.color(RGBHex: 0x181c20)
