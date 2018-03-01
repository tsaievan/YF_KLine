//
//  YF_KLineView.swift
//  YF-KLine
//
//  Created by tsaievan on 28/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit
import SnapKit

class YF_KLineView: UIView {
    
    ///< 第一个view的高所占比例
    var mainViewRatio: CGFloat = YF_StockChartVariable.kLineMainViewRatio
    ///< 第二个view(成交量)的高所占比例
    var volumeViewRatio: CGFloat = YF_StockChartVariable.kLineVolumeViewRatio
    ///< 数据
    var kLineModels: [Any]?
    ///< Accessory指标种类
    var targetLineStatus: YF_StockChartTargetLineStatus?
    ///< K线类型
    var mainViewType: YF_StockChartViewType?
    
    ///< scrollView的懒加载属性
    fileprivate lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.bounces = false
        sv.delegate = self
        
        ///< 添加缩放手势
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(YF_KLineView.didPinchAction(sender:)))
        sv.addGestureRecognizer(pinch)
        ///< 添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(YF_KLineView.didLongPressAction(sender:)))
        sv.addGestureRecognizer(longPress)
        
        sv.addSubview(sv)
        sv.snp.makeConstraints({ (make) in
            make.top.left.bottom.equalTo(self)
            make.right.equalTo(self).offset(-48)
        })
        layoutIfNeeded()
        return sv
    }()
    
    ///< 主K线图
    fileprivate lazy var kLineMainView: YF_KLineMainView = {
        let main = YF_KLineMainView()
        main.delegate = self
        scrollView.addSubview(main)
        main.snp.makeConstraints({ (make) in
            make.top.equalTo(scrollView).offset(5)
            make.left.equalTo(scrollView)
            make.width.equalTo(0)
            ///< 获取K线主视图高度约束, 保存在属性中
            kLineMainViewHeightConstraint =
             make.height.equalTo(scrollView).multipliedBy(mainViewRatio).constraint
            // TODO: - 加载rightYYView
        })
        return main
    }()
    
    fileprivate lazy var kLineVolumeView: YF_KLineVolumeView = {
        let vv = YF_KLineVolumeView()
        vv.delegate = self
        scrollView.addSubview(vv)
        vv.snp.makeConstraints({ (make) in
            make.left.equalTo(kLineMainView)
            make.top.equalTo(kLineMainView.snp.bottom).offset(10);
            make.width.equalTo(kLineMainView)
            ///< 获取K线成交量视图高度约束, 保存在属性中
            kLineVolumeViewHeightConstraint = make.height.equalTo(scrollView).multipliedBy(volumeViewRatio).constraint
        })
        layoutIfNeeded()
        return vv
    }()
    
    fileprivate lazy var kLineAccessoryView: YF_KLineAccessoryView = {
        let av = YF_KLineAccessoryView()
        av.delegate = self
        scrollView.addSubview(av)
        av.snp.makeConstraints({ (make) in
            make.left.equalTo(kLineVolumeView)
            make.top.equalTo(kLineVolumeView.snp.bottom).offset(10)
            make.width.equalTo(kLineVolumeView)
            make.height.equalTo(scrollView).multipliedBy(0.2)
        })
        layoutIfNeeded()
        return av
    }()
    
    ///< kLine-MAView
    fileprivate lazy var kLineMAView: YF_KLineMAView? = {
        let mv = YF_KLineMAView()
        addSubview(mv)
        mv.snp.makeConstraints({ (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(self).offset(5);
            make.height.equalTo(10)
        })
        return mv
    }()
    
    ///< 长按后显示的那条竖直的线
    fileprivate var verticalView: UIView?
    
    ///< 主K线图高度约束对象
    fileprivate var kLineMainViewHeightConstraint: Constraint?
    ///< k线成交量视图高度约束对象
    fileprivate var kLineVolumeViewHeightConstraint: Constraint?
    ///< 价格视图高度约束对象
    fileprivate var priceViewHeightConstrain: Constraint?
    ///< 交易量视图高度约束对象
    fileprivate var volumeViewHeightConstrain: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - 事件处理
extension YF_KLineView {
    ///< 重绘
    func reDraw() {
        
    }
    
    @objc fileprivate func didPinchAction(sender: UIPinchGestureRecognizer) {
        
    }
    
    @objc fileprivate func didLongPressAction(sender: UILongPressGestureRecognizer) {
        
    }
}


// MARK: - UIScrollViewDelegate代理方法
extension YF_KLineView: UIScrollViewDelegate {
    
}

// MARK: - YF_KLineMainViewDelegate代理方法
extension YF_KLineView: YF_KLineMainViewDelegate {
    
}

// MARK: - YF_KLineVolumeViewDelegate代理方法
extension YF_KLineView: YF_KLineVolumeViewDelegate {
    
}

// MARK: - YF_KLineAccessoryViewDelegate代理方法
extension YF_KLineView: YF_KLineAccessoryViewDelegate {
    
}
