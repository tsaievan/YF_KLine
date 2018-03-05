//
//  YF_AccessoryMAView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_AccessoryMAView: UIView {
    lazy var accessoryDescLabel: UILabel = {
        let adl = UILabel(text: nil, textColor: ASSISTANT_TEXT_COLOR, fontSize: 10)
        addSubview(adl)
        adl.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalTo(self)
        })
        return adl
    }()
    
    lazy var DIFLabel: UILabel = {
        let dl = UILabel(text: nil, textColor: MA_7_COLOR, fontSize: 10)
        addSubview(dl)
        dl.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(accessoryDescLabel.snp.right)
        })
        return dl
    }()
    
    lazy var DEALabel: UILabel = {
        let del = UILabel(text: nil, textColor: MA_30_COLOR, fontSize: 10)
        addSubview(del)
        del.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(DIFLabel.snp.right)
        })
        return del
    }()
    
    lazy var MACDLabel: UILabel = {
        let ml = UILabel(text: nil, textColor: UIColor.color(RGBHex: 0xffffff), fontSize: 10)
        addSubview(ml)
        ml.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(DEALabel.snp.right)
        })
        return ml
    }()
    
    
    ///< Accessory指标种类
    var targetLineStatus: YF_StockChartTargetLineStatus?
    
    func maProfile(withModel model: YF_KLineModel) {
        if targetLineStatus != .KDJ {
            accessoryDescLabel.text = " MACD(12,26,9)"
            DIFLabel.text = String(format: "  DIF: %.4f", model.DIF ?? 0)
            DEALabel.text = String(format: "  DEA: %.4f", model.DEA ?? 0)
            MACDLabel.text = String(format: "  MACD: %.4f", model.MACD ?? 0)
        }else {
            accessoryDescLabel.text = " KDJ(9,3,3)"
            DIFLabel.text = String(format: "  K: %.8f", model.KDJ_K ?? 0)
            DEALabel.text = String(format: "  D: %.8f", model.KDJ_D ?? 0)
            MACDLabel.text = String(format: "  J: %.8f", model.KDJ_J ?? 0)
        }
    }
}
