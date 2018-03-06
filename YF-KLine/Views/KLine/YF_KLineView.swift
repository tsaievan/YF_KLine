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
    ///< 在didSet这里设置数据
    var kLineModels: [Any]? {
        didSet {
            guard let models = kLineModels else {
                return
            }
            drawKLineMainView()
            ///< 设置contentOffset(偏移值)
            ///< 算法: 模型数组的个数 * 宽度值 + (模型数组的个数 + 1) * 间隔值 + 10
            let kLineViewWidth = CGFloat(models.count) * YF_StockChartVariable.kLineWidth + CGFloat(models.count + 1) * YF_StockChartVariable.kLineGap + 10.0
            
            ///< 偏移量减去scrollView的宽度
            let offset = kLineViewWidth - scrollView.width
            if offset > 0 { ///< 如果offset大于0, 则表明scrollView的contentSize在scrollView中显示不下, 自动滚到下一屏
                scrollView.contentOffset = CGPoint(x: offset, y: 0)
            }else { ///< 否则, 内容可以在scrollView显示, 不需要偏移
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
            guard let model = kLineModels?.last as? YF_KLineModel else {
                return
            }
            ///< 把模型再分发给下面的子view
            kLineMAView.maProfile(withModel: model)
            volumeMAView.maProfile(withModel: model)
            accessoryMAView.maProfile(withModel: model)
            ///< 将kLineView的targetLineStatus再传给accessoryMAView
            accessoryMAView.targetLineStatus = targetLineStatus
        }
    }
    ///< Accessory指标种类
    var targetLineStatus: YF_StockChartTargetLineStatus? {
        didSet {
            guard let status = targetLineStatus else {
                return
            }
            if status.rawValue < 103 {
                if status == .AccessoryClose {
                    ///< 改变K线图主view的高度比例
                    YF_StockChartVariable.setKLineMainViewRatio(ratio: 0.65)
                    ///< 改变K线图交易量View的高度比例
                    YF_StockChartVariable.setKLineVolumeViewRatio(ratio: 0.28)
                }else {
                    ///< 改变K线图主view的高度比例
                    YF_StockChartVariable.setKLineMainViewRatio(ratio: 0.5)
                    ///< 改变K线图交易量View的高度比例
                    YF_StockChartVariable.setKLineVolumeViewRatio(ratio: 0.2)
                }
                ///< 因为高度比例变了, 所以取消之前高度的约束值, 重新更新约束
                //FIXME:- 这里会崩, 原因还没有找到, 先不管
                kLineMainViewHeightConstraint?.deactivate()
                kLineMainView.snp.updateConstraints({ (update) in update.height.equalTo(scrollView).multipliedBy(YF_StockChartVariable.kLineMainViewRatio)
                })
                
                kLineVolumeViewHeightConstraint?.deactivate()
                kLineVolumeView.snp.updateConstraints({ (update) in update.height.equalTo(scrollView).multipliedBy(YF_StockChartVariable.kLineVolumeViewRatio)
                })
                ///< 更新约束之后重绘
                reDraw()
            }
        }
    }
    ///< K线类型
    var mainViewType: YF_StockChartViewType?
    
    ///< scrollView的懒加载属性
    fileprivate lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
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
        addSubview(sv)
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
        main.backgroundColor = .yellow
        main.delegate = self
        scrollView.addSubview(main)
        main.snp.makeConstraints({ (make) in
            make.top.equalTo(scrollView).offset(5)
            make.left.equalTo(scrollView)
            // FIXME: - 这里先改成SCREEN_WIDTH - 100, 先出来视图
            make.width.equalTo(SCREEN_WIDTH - 100)
            ///< 获取K线主视图高度约束, 保存在属性中
            kLineMainViewHeightConstraint =
                make.height.equalTo(scrollView).multipliedBy(mainViewRatio).constraint
        })
        return main
    }()
    
    ///< 成交量图
    fileprivate lazy var kLineVolumeView: YF_KLineVolumeView = {
        let vv = YF_KLineVolumeView()
        vv.delegate = self
        vv.backgroundColor = .black
        scrollView.addSubview(vv)
        vv.snp.makeConstraints({ (make) in
            make.left.equalTo(kLineMainView)
            make.top.equalTo(kLineMainView.snp.bottom).offset(10);
            make.width.equalTo(kLineMainView)
            kLineVolumeViewHeightConstraint
                = make.height.equalTo(scrollView).multipliedBy(volumeViewRatio).constraint
        })
        layoutIfNeeded()
        return vv
    }()
    
    ///< 副图
    fileprivate lazy var kLineAccessoryView: YF_KLineAccessoryView = {
        let av = YF_KLineAccessoryView()
        av.delegate = self
        av.backgroundColor = .clear
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
    
    ///< 右侧价格图
    fileprivate lazy var priceView: YF_StockChartRightYView = {
        let yv = YF_StockChartRightYView()
        yv.backgroundColor = .clear
        ///< 因为y轴是不滚动的, 所以直接加载view上, 而不是加到scrollView上
        ///< 而且要加到scrollView上面
        insertSubview(yv, aboveSubview: scrollView)
        yv.snp.makeConstraints({ (make) in
            make.top.equalTo(self).offset(15)
            make.right.equalTo(self)
            make.width.equalTo(STOCK_CHART_K_LINE_PRICE_VIEW_WIDTH)
            make.bottom.equalTo(kLineMainView).offset(-15)
        })
        return yv
    }()
    
    ///< 右侧成交量图
    fileprivate lazy var volumeView: YF_StockChartRightYView = {
        let yv = YF_StockChartRightYView()
        yv.backgroundColor = .orange
        insertSubview(yv, aboveSubview: scrollView)
        yv.snp.makeConstraints({ (make) in
            make.top.equalTo(kLineVolumeView).offset(10)
            make.right.width.equalTo(priceView)
            make.bottom.equalTo(kLineVolumeView)
        })
        return yv
    }()
    
    ///< 右侧Accessory图
    fileprivate lazy var accessoryView: YF_StockChartRightYView = {
        let yv = YF_StockChartRightYView()
        yv.backgroundColor = .gray
        insertSubview(yv, aboveSubview: scrollView)
        yv.snp.makeConstraints({ (make) in
            make.top.equalTo(kLineAccessoryView).offset(10)
            make.right.width.equalTo(volumeView)
            make.height.equalTo(kLineAccessoryView)
        })
        return yv
    }()
    
    ///< kLine-MAView
    fileprivate lazy var kLineMAView: YF_KLineMAView = {
        let mv = YF_KLineMAView()
        mv.backgroundColor = .darkGray
        addSubview(mv)
        mv.snp.makeConstraints({ (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(self).offset(5);
            make.height.equalTo(10)
        })
        return mv
    }()
    
    fileprivate lazy var volumeMAView: YF_VolumeMAView = {
        let vmv = YF_VolumeMAView()
        vmv.backgroundColor = .darkGray
        addSubview(vmv)
        vmv.snp.makeConstraints({ (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(kLineVolumeView)
            make.height.equalTo(10)
        })
        return vmv
    }()
    
    fileprivate lazy var accessoryMAView: YF_AccessoryMAView = {
        let amv = YF_AccessoryMAView()
        amv.backgroundColor = .cyan
        addSubview(amv)
        amv.snp.makeConstraints({ (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(kLineAccessoryView)
            make.height.equalTo(10)
        })
        return amv
    }()
    
    
    ///< 旧的scrollView准确位移
    fileprivate var oldExactOffset: CGFloat?
    
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
        ///< 将本类的K线类型传给k线主视图的属性
        kLineMainView.mainViewType = mainViewType
        if let status = targetLineStatus?.rawValue, status >= 103 {
            kLineMainView.targetLineStatus = targetLineStatus
        }
        kLineMainView.drawMainView()
    }
    
    ///< 缩放执行方法
    @objc fileprivate func didPinchAction(sender: UIPinchGestureRecognizer) {
        var oldScale: CGFloat = 1.0
        let difValue = sender.scale - oldScale
        ///< sender.scale是一个绝对值, difValue算出的是增长值
        if !abs(difValue).isLessThanOrEqualTo(STOCK_CHART_SCALE_BOUND) { ///< 不小于等于, 即大于
            ///< 获取原来的K线宽度(这个是不变了, 始终都是2)
            let oldKLineWidth = YF_StockChartVariable.kLineWidth
            let oldNeedDrawStartIndex = kLineMainView.needDrawStartIndex
            ///< 线宽也需要做相应的改变
            ///< 在默认为2的线宽宽度上, 放大倍数
            let factor = difValue > 0 ? 1 + STOCK_CHART_SCALE_SCALE : 1 - STOCK_CHART_SCALE_SCALE
            YF_StockChartVariable.setKLineWidth(width: oldKLineWidth * factor)
            ///< 将当前的scale传递给oldScale变量
            oldScale = sender.scale
            ///< 更新mainView的宽度
            kLineMainView.updateMainViewWidth()
            ///< 如果是两个指头缩放
            if sender.numberOfTouches == 2 {
                ///< 获取两个指头位于屏幕的点
                let p1 = sender.location(ofTouch: 0, in: scrollView)
                let p2 = sender.location(ofTouch: 1, in: scrollView)
                ///< 计算这两个点之间的中心点
                let centerPoint = CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
                //FIXME: - 这个地方的逻辑先放在这里
                let oldLeftArrCount = Int(abs((centerPoint.x - scrollView.contentOffset.x) - YF_StockChartVariable.kLineGap) / (YF_StockChartVariable.kLineGap + oldKLineWidth))
                let newLeftArrCount = Int(abs((centerPoint.x - scrollView.contentOffset.x) - YF_StockChartVariable.kLineGap) / (YF_StockChartVariable.kLineGap + YF_StockChartVariable.kLineWidth))
                //FIXME: 这里先强制解包(强制解包会崩)
                kLineMainView.pinchStartIndex = oldNeedDrawStartIndex + oldLeftArrCount - newLeftArrCount
            }
            kLineMainView.drawMainView()
        }
    }
    
    @objc fileprivate func didLongPressAction(sender: UILongPressGestureRecognizer) {
        print("长按")
    }
    
    fileprivate func drawKLineMainView() {
        ///< 将本类的K线模型对象数组传给K线主视图的属性K线模型对象数组
        kLineMainView.kLineModels = kLineModels
        kLineMainView.drawMainView()
    }
    
    fileprivate func drawKLineVolumeView() {
        kLineVolumeView.layoutIfNeeded()
        kLineVolumeView.draw()
    }
    
    fileprivate func drawKLineAccessoryView() {
        accessoryMAView.targetLineStatus = targetLineStatus
        guard let model = kLineModels?.last as? YF_KLineModel  else {
            return
        }
        accessoryMAView.maProfile(withModel: model)
        kLineAccessoryView.layoutIfNeeded()
        kLineAccessoryView.draw()
    }
}


// MARK: - UIScrollViewDelegate代理方法
extension YF_KLineView: UIScrollViewDelegate {
    
}

// MARK: - YF_KLineMainViewDelegate代理方法
extension YF_KLineView: YF_KLineMainViewDelegate {
    func kLineMainViewPositionCurrent(needDrawKLinePositionModels kLinePositionModels: [YF_KLineVolumePositionModel]) {
        
    }
    
    func kLineMainViewCurrentPrice(maxPrice: Double, minPrice: Double) {
        
    }
    
    func kLineMainViewCurrent(needDrawKLineModels kLineModels: [YF_KLineModel]) {
        
    }
}

// MARK: - YF_KLineVolumeViewDelegate代理方法
extension YF_KLineView: YF_KLineVolumeViewDelegate {
    func kLineVolumeView(currentMaxVolume maxVolume: CGFloat, minVolume: CGFloat) {
        
    }
}

// MARK: - YF_KLineAccessoryViewDelegate代理方法
extension YF_KLineView: YF_KLineAccessoryViewDelegate {
    
}
