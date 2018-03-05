//
//  YF_VolumeMAView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

class YF_VolumeMAView: UIView {
    
    lazy var VolumeMA7Label: UILabel = {
        let v7l = UILabel(text: nil, textColor: MA_7_COLOR, fontSize: 10)
        addSubview(v7l)
        v7l.snp.makeConstraints({ (make) in
            make.left.equalTo(VolumeDescLabel.snp.right)
            make.top.bottom.equalTo(self)
        })
        return v7l
    }()
    
    lazy var VolumeMA30Label: UILabel = {
        let v30l = UILabel(text: nil, textColor: MA_30_COLOR, fontSize: 10)
        addSubview(v30l)
        v30l.snp.makeConstraints({ (make) in
            make.left.equalTo(VolumeMA7Label.snp.right)
            make.top.bottom.equalTo(self)
        })
        return v30l
    }()
    
    lazy var VolumeDescLabel: UILabel = {
        let vdl = UILabel(text: nil, textColor: ASSISTANT_TEXT_COLOR, fontSize: 10)
        addSubview(vdl)
        vdl.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalTo(self)
        })
        return vdl
    }()
    
    func maProfile(withModel model: YF_KLineModel) {
        VolumeDescLabel.text = String(format: " 成交量(7,30):%.4f", model.Volume ?? 0)
        VolumeMA7Label.text = String(format: "  MA7：%.8f ",model.Volume_MA7 ?? 0)
        VolumeMA30Label.text = String(format: "  MA30：%.8f ",model.Volume_MA30 ?? 0)
    }
}
