//
//  YF_KLineMAView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

let LABEL_WIDTH: CGFloat = 47

class YF_KLineMAView: UIView {
    lazy var MA7Label: UILabel = {
        let m7l = UILabel(text: nil, textColor: MA_7_COLOR, fontSize: 10)
        addSubview(m7l)
        m7l.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(closeLabel.snp.right)
        })
        return m7l
    }()
    
    lazy var MA30Label: UILabel = {
        let m30l = UILabel(text: nil, textColor: MA_30_COLOR, fontSize: 10)
        addSubview(m30l)
        m30l.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(MA7Label.snp.right)
        })
        return m30l
    }()
    
    lazy var dateDescLabel: UILabel = {
        let ddl = UILabel(text: nil, textColor: ASSISTANT_TEXT_COLOR, fontSize: 10)
        addSubview(ddl)
        ddl.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(100)
        })
        return ddl
    }()
    
    lazy var openDescLabel: UILabel = {
        let odl = UILabel(text: " 开:", textColor: ASSISTANT_TEXT_COLOR, fontSize: 10)
        addSubview(odl)
        odl.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(dateDescLabel.snp.right)
        })
        return odl
    }()
    
    lazy var openLabel: UILabel = {
        let ol = UILabel(text: nil, textColor: .white, fontSize: 10)
        addSubview(ol)
        ol.snp.makeConstraints({ (make) in
            make.left.equalTo(openDescLabel.snp.right)
            make.top.bottom.equalTo(self)
            make.width.equalTo(LABEL_WIDTH)
        })
        return ol
    }()
    
    lazy var highDescLabel: UILabel = {
        let hdl = UILabel(text: " 高:", textColor: ASSISTANT_TEXT_COLOR, fontSize: 10)
        addSubview(hdl)
        hdl.snp.makeConstraints({ (make) in
            make.left.equalTo(openLabel.snp.right)
            make.top.bottom.equalTo(self)
        })
        return hdl
    }()
    
    lazy var highLabel: UILabel = {
        let hl = UILabel(text: nil, textColor: .white, fontSize: 10)
        addSubview(hl)
        hl.snp.makeConstraints({ (make) in
            make.left.equalTo(highDescLabel.snp.right)
            make.top.bottom.equalTo(self)
            make.width.equalTo(LABEL_WIDTH)
        })
        return hl
    }()
    
    lazy var lowDescLabel: UILabel = {
        let ldl = UILabel(text: " 低:", textColor: ASSISTANT_TEXT_COLOR, fontSize: 10)
        addSubview(ldl)
        ldl.snp.makeConstraints({ (make) in
            make.left.equalTo(highLabel.snp.right)
            make.top.bottom.equalTo(self)
        })
        return ldl
    }()
    
    lazy var lowLabel: UILabel = {
        let ll = UILabel(text: nil, textColor: .white, fontSize: 10)
        addSubview(ll)
        ll.snp.makeConstraints({ (make) in
            make.left.equalTo(lowDescLabel.snp.right)
            make.top.bottom.equalTo(self)
            make.width.equalTo(LABEL_WIDTH)
        })
        return ll
    }()
    
    lazy var closeDescLabel: UILabel = {
        let cdl = UILabel(text: " 收:", textColor: ASSISTANT_TEXT_COLOR, fontSize: 10)
        addSubview(cdl)
        cdl.snp.makeConstraints({ (make) in
            make.left.equalTo(lowLabel.snp.right)
            make.top.bottom.equalTo(self)
        })
        return cdl
    }()
    
    lazy var closeLabel: UILabel = {
        let cl = UILabel(text: nil, textColor: .white, fontSize: 10)
        addSubview(cl)
        cl.snp.makeConstraints({ (make) in
            make.left.equalTo(closeDescLabel.snp.right)
            make.top.bottom.equalTo(self)
            make.width.equalTo(LABEL_WIDTH)
        })
        return cl
    }()

    
    func maProfile(withModel model: YF_KLineModel) {
//        let date = Date(timeIntervalSince1970: (model.date ?? 1000.0) / 1000.0)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let dateStr = formatter.string(from: date)
        let dateStr = model.date ?? ""
        dateDescLabel.text = " \(dateStr)"
        openLabel.text = String(format: "%.2f", model.Open ?? 0)
        highLabel.text = String(format: "%.2f", model.High ?? 0)
        lowLabel.text = String(format: "%.2f", model.Low ?? 0)
        closeLabel.text = String(format: "%.2f", model.Close ?? 0)
        MA7Label.text = String(format: " MA7: %.2f", model.MA7 ?? 0)
        MA30Label.text = String(format: " MA30: %.2f", model.MA30 ?? 0)
    }
}


