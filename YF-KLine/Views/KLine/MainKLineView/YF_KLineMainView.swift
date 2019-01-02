//
//  YF_KLineMainView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

@objc
protocol YF_KLineMainViewDelegate: NSObjectProtocol {
    ///< 需要绘制的K线模型数组
    @objc optional
    func kLineMainViewCurrent(needDrawKLineModels kLineModels: [YF_KLineModel])
    
    ///< 需要绘制的K线位置模型数组
    @objc optional
    func kLineMainViewPositionCurrent(needDrawKLinePositionModels kLinePositionModels: [YF_KLinePositionModel])
    
    ///< 当前MainView的最大值和最小值
    @objc optional
    func kLineMainViewCurrentPrice(maxPrice: Double, minPrice: Double)
    
    ///< 当前需要绘制的K线颜色数组
    @objc optional
    func kLineMainViewCurrentLineColors(needDrawKLineColors kLineColors: [UIColor])
    
    ///< 长按显示手指按着的Y_KLinePosition和KLineModel
    @objc optional
    func kLineMainViewLongPress(kLinePositionModel positionModel: YF_KLinePositionModel, kLineModel: YF_KLineModel)
}

class YF_KLineMainView: UIView {
    ///< 父ScrollView
    var parentScrollView: UIScrollView?
    
    ///< 旧的contentOffset值
    var oldContentOffsetX: CGFloat = 0.0
    
    var needDrawKLinePositionModels = [YF_KLinePositionModel]()
    
    var needDrawKLineModels = [YF_KLineModel]()
    
    weak var delegate: YF_KLineMainViewDelegate?
    
    ///< K线类型
    var mainViewType: YF_StockChartViewType?
    
    ///< Accessory指标种类
    var targetLineStatus: YF_StockChartTargetLineStatus?
    
    ///< 捏合点
    var pinchStartIndex: Int?
    
    ///< 7日均线的点的集合, 初始化
    var MA7Positions = [CGPoint]()
    
    ///< 30日均线的点的集合, 初始化
    var MA30Positions = [CGPoint]()
    
    ///< BOLL_MB线的点的集合, 初始化
    var BOLL_MBPositions = [CGPoint]()
    
    ///< BOLL_DN线的点的集合, 初始化
    var BOLL_DNPositions = [CGPoint]()

    ///< BOLL_UP线的点的集合, 初始化
    var BOLL_UPPositions = [CGPoint]()
    
    ///< k线模型对象的数组
    ///< 在kLineModels的setter方法里面更新KLineMainView的宽度
    var kLineModels: [Any]? {
        didSet {
            updateMainViewWidth()
        }
    }
    
    ///< 需要绘制Index开始值
    var needDrawStartIndex: Int {
        set {}
        get {
            guard let scrollViewOffsetX = parentScrollView?.contentOffset.x else {
                return 0
            }
            let offsetX = (scrollViewOffsetX < 0 ? 0 : scrollViewOffsetX)
            let leftArrCount = abs(offsetX - YF_StockChartVariable.kLineGap) / (YF_StockChartVariable.kLineGap + YF_StockChartVariable.kLineWidth)
            return Int(leftArrCount)
        }
    }
    
    ///< 开始的x值
    var startXPosition: Int {
        set {}
        get {
            let leftArrCount = needDrawStartIndex
            let gap = CGFloat(leftArrCount + 1) * (YF_StockChartVariable.kLineGap)
            let width = CGFloat(leftArrCount) * (YF_StockChartVariable.kLineWidth)
            let exceedWidth = (YF_StockChartVariable.kLineWidth) * 0.5
            let xPosition = gap + width + exceedWidth
            return Int(xPosition)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///< 在析构函数中移除观察者
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    ///< 画K线主视图
    func drawMainView() {
        ///< kLineModels不能为空
        guard let _ = kLineModels else {
            return
        }
        extractNeedDrawModels()
        convertToKLinePositionModel()!
        setNeedsDisplay()
    }
    
    ///< 更新宽度
    func updateMainViewWidth() {
        guard let models = kLineModels,
        let parentView = parentScrollView else {
            return
        }
        var kLineViewWidth = CGFloat(models.count) * (YF_StockChartVariable.kLineWidth) + CGFloat(models.count + 1) * (YF_StockChartVariable.kLineGap) + 10
        if kLineViewWidth < parentView.width {
            kLineViewWidth = parentView.width
        }
        snp.updateConstraints { (update) in
            update.width.equalTo(kLineViewWidth)
        }
        layoutIfNeeded()
        ///< 这里contentSize的高度填0, 避免在垂直方向上的滑动
        parentScrollView?.contentSize = CGSize(width: kLineViewWidth, height: 0)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        ///< 如果数组为空, 则不进行绘制, 直接设置本view为背景
        if kLineModels == nil {
            context.clear(rect)
            context.setFillColor(CHARTVIEW_BACKGROUND_COLOR.cgColor)
            context.fill(rect)
            return
        }

        ///< 设置view的背景颜色
        var kLineColors = [UIColor]()
        context.clear(rect)
        context.setFillColor(CHARTVIEW_BACKGROUND_COLOR.cgColor)
        context.fill(rect)

        ///< 设置显示日期的区域背景颜色
        context.setFillColor(ASSISTANT_BACKGROUND_COLOR.cgColor)
        let dateRect = CGRect(x: 0, y: height - 15, width: width, height: height)
        context.fill(dateRect)
        
        ///< 初始化MA线对象
        let MALine = YF_MALine(context: context)

        ///< 这里开始画各种线
        if mainViewType == .kLine {
            let kLine = YF_KLine(context: context)
            kLine.maxY = height - 15
            for (idx, positionModel) in needDrawKLinePositionModels.enumerated() {
                kLine.kLinePositionModel = positionModel
                kLine.kLineModel = needDrawKLineModels[idx]
                guard let kLineColor = kLine.draw() else {
                    return
                }
                kLineColors.append(kLineColor)
            }
        }else {
            var positions = [CGPoint]()
            for positonModel in needDrawKLinePositionModels {
                let openPointY = positonModel.OpenPoint?.y ?? 0.0
                let closePointY = positonModel.ClosePoint?.y ?? 0.0
                let strokeColor = openPointY < closePointY ? K_LINE_INCREASE_COLOR : K_LINE_DECREASE_COLOR
                kLineColors.append(strokeColor)
                ///< 添加位置模型的收盘点
                positions.append(positonModel.ClosePoint ?? .zero)
            }
            MALine.MAPositions = positions
            MALine.MAType = YF_MAType(rawValue: -1)
            MALine.draw()
            
            var lastDrawDatePoint = CGPoint.zero
            for (idx, _) in needDrawKLinePositionModels.enumerated() {
                let point = positions[idx]
                let dateStr = needDrawKLineModels[idx].date ?? ""
                let drawDatePoint = CGPoint(x: point.x + 1, y: height + 1.5)
                ///< 距离大于60才画出来, 否则就不画, 不然密密麻麻不好看
                if lastDrawDatePoint == .zero || point.x - lastDrawDatePoint.x > 60 {
                    (dateStr as NSString).draw(at: drawDatePoint, withAttributes: [.font : UIFont.systemFont(ofSize: 11),
                                                                                   .foregroundColor : ASSISTANT_TEXT_COLOR])
                    lastDrawDatePoint = drawDatePoint
                }
            }
        }
        if targetLineStatus == .BOLL {
            ///< 画BOLL MB线 标准线
            MALine.MAType = .BOLL_MB
            MALine.BOLLPositions = BOLL_MBPositions
            MALine.draw()
            
            ///< 画BOLL UP线 上浮线
            MALine.MAType = .BOLL_UP
            MALine.BOLLPositions = BOLL_UPPositions
            MALine.draw()
            
            ///< 画BOLL DN线 下浮线
            MALine.MAType = .BOLL_DN
            MALine.BOLLPositions = BOLL_DNPositions
            MALine.draw()
        }else if targetLineStatus != .CloseMA {
            ///< 画MA7线
            MALine.MAType = .MA7Type
            MALine.MAPositions = MA7Positions
            MALine.draw()
            
            ///< 画MA30线
            MALine.MAType = .MA30Type
            MALine.MAPositions = MA30Positions
            MALine.draw()
        }
        delegate?.kLineMainViewCurrentLineColors?(needDrawKLineColors: kLineColors)
    }
}


// MARK: - 系统方法
extension YF_KLineMainView {
    override func didMoveToSuperview() {
        guard let superView = superview else {
            super.didMoveToWindow()
            return
        }
        parentScrollView = superView as? UIScrollView
        addAllEventsListeners()
        super.didMoveToWindow()
    }
}

extension YF_KLineMainView {
    ///< 长按的时候根据原始的x位置获得精确的x位置
    func getExactXPosition(withOriginalXPosition xPosition: CGFloat) -> CGFloat {
        let xPositionInMainView = xPosition
        let startIndex = (Int(xPositionInMainView - CGFloat(startXPosition)) / Int ((YF_StockChartVariable.kLineGap) + (YF_StockChartVariable.kLineWidth)))
        let arrCount = needDrawKLinePositionModels.count
        let start = startIndex > 0 ? startIndex - 1 : 0
        if start > arrCount {
            return 0
        }
        for i in start..<arrCount {
            if i + 1 >= needDrawKLineModels.count {
                return 0.0
            }
            let kLinePositionModel = needDrawKLinePositionModels[i+1]
            guard let X = kLinePositionModel.HighPoint?.x else {
                return 0
            }
            let minX = X - (YF_StockChartVariable.kLineGap + YF_StockChartVariable.kLineWidth * 0.5)
            let maxX = X + (YF_StockChartVariable.kLineGap + YF_StockChartVariable.kLineWidth * 0.5)
            if xPositionInMainView > minX && xPositionInMainView < maxX {
                delegate?.kLineMainViewLongPress?(kLinePositionModel: needDrawKLinePositionModels[i], kLineModel: needDrawKLineModels[i])
            }
            return X
        }
        return 0
    }
}

extension YF_KLineMainView {
    fileprivate func extractNeedDrawModels() {
        let lineGap = YF_StockChartVariable.kLineGap
        let lineWidth = YF_StockChartVariable.kLineWidth
        
        ///< 数组个数
        guard let scrollViewWidth = parentScrollView?.width else {
            return
        }
        let needDrawKLineCount = Int((scrollViewWidth - lineGap) / (lineGap + lineWidth))
        var needDrawKLineStartIndex: Int
        let startIndex = pinchStartIndex ?? 0
        if startIndex > 0 {
            needDrawKLineStartIndex = startIndex
            needDrawStartIndex = startIndex
            pinchStartIndex = -1
        }else {
            needDrawKLineStartIndex = needDrawStartIndex
        }
        
        ///< 把之前的数组的元素全部删除, 再重新添加 (这一步不能忘, 否则点集合有问题, 线就会有问题)
        needDrawKLineModels.removeAll()
        guard let models = kLineModels else {
            return
        }
        if needDrawKLineStartIndex < models.count {
            if needDrawKLineStartIndex + needDrawKLineCount < models.count {
                let subArray = (models as NSArray).subarray(with: NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount))
                //FIXME:- 数组的切片还不怎么会用, 转换成了NSArray对象来操作
                let combineArray: [YF_KLineModel] = (needDrawKLineModels as [Any] + subArray) as! [YF_KLineModel]
                needDrawKLineModels = combineArray
            }else {
                let endIndex = models.count - needDrawKLineStartIndex
                let subArray = (models as NSArray).subarray(with: NSMakeRange(needDrawKLineStartIndex, endIndex))
                let combineArray: [YF_KLineModel] = (needDrawKLineModels as [Any] + subArray) as! [YF_KLineModel]
                needDrawKLineModels = combineArray
            }
        }
        ///< 响应代理
        delegate?.kLineMainViewCurrent?(needDrawKLineModels: needDrawKLineModels)
    }
    
    ///< 将model转化为Position模型
    fileprivate func convertToKLinePositionModel() -> [YF_KLinePositionModel]? {
        guard let firstModel = needDrawKLineModels.first else {
            return needDrawKLinePositionModels
        }
        var minAssert = firstModel.Low ?? 0
        var maxAssert = firstModel.High ?? 0

        for model in needDrawKLineModels {
            guard let high = model.High,
            let low = model.Low else {
                return needDrawKLinePositionModels
            }
            if high > maxAssert {
                maxAssert = high
            }
            if low < minAssert {
                minAssert = low
            }
            if targetLineStatus == .BOLL {
                if let mb = model.BOLL_MB {
                    if minAssert > mb {
                        minAssert = mb
                    }
                    if maxAssert < mb {
                        maxAssert = mb
                    }
                }
                if let up = model.BOLL_UP {
                    if minAssert > up {
                        minAssert = up
                    }
                    if maxAssert < up {
                        maxAssert = up
                    }
                }
                if let dn = model.BOLL_DN {
                    if minAssert > dn {
                        minAssert = dn
                    }
                    if maxAssert < dn {
                        maxAssert = dn
                    }
                }
            }else {
                if let ma7 = model.MA7 {
                    if minAssert > ma7 {
                        minAssert = ma7
                    }
                    if maxAssert < ma7 {
                        maxAssert = ma7
                    }
                }
                if let ma30 = model.MA30 {
                    if minAssert > ma30 {
                        minAssert = ma30
                    }
                    if maxAssert < ma30 {
                        maxAssert = ma30
                    }
                }
            }
        }
        maxAssert *= 1.0001
        minAssert *= 0.9991
        let minY = STOCK_CHART_K_LINE_MAIN_VIEW_MIN_Y
        guard let height = parentScrollView?.height else {
            return needDrawKLinePositionModels
        }
        let maxY =  height * YF_StockChartVariable.kLineMainViewRatio - 15
        let unitValue = CGFloat(maxAssert - minAssert) / (maxY - minY)
        needDrawKLinePositionModels.removeAll()
        MA7Positions.removeAll()
        MA30Positions.removeAll()
        BOLL_MBPositions.removeAll()
        BOLL_DNPositions.removeAll()
        BOLL_UPPositions.removeAll()
        for (idx, model) in needDrawKLineModels.enumerated() {
            let xPosition = CGFloat(startXPosition) + CGFloat(idx) * (YF_StockChartVariable.kLineGap + YF_StockChartVariable.kLineWidth)
            let open = model.Open ?? 0.0
            let yPosition = abs(maxY - CGFloat(open - minAssert) / unitValue)
            ///< 算开盘点, 收盘点, 最高点, 最低点
            var openPoint = CGPoint(x: xPosition, y: yPosition)
            let close = model.Close ?? 0.0
            var closePointY = abs(maxY - CGFloat(close - minAssert) / unitValue)
            if abs(closePointY - openPoint.y) < STOCK_CHART_K_LINE_MIN_WIDTH {
                if openPoint.y > closePointY {
                    openPoint.y = closePointY + STOCK_CHART_K_LINE_MIN_WIDTH
                }else if openPoint.y < closePointY {
                    closePointY = openPoint.y + STOCK_CHART_K_LINE_MIN_WIDTH
                }else {
                    if idx > 0 {
                        let preKLineModel = needDrawKLineModels[idx - 1]
                        let preClose = preKLineModel.Close ?? 0
                        if open > preClose {
                            openPoint.y = closePointY + STOCK_CHART_K_LINE_MIN_WIDTH
                        }else {
                            closePointY = openPoint.y + STOCK_CHART_K_LINE_MIN_WIDTH
                        }
                    }else if (idx + 1) < needDrawKLineModels.count {
                        let subKLineModel = needDrawKLineModels[idx + 1]
                        let subOpen = subKLineModel.Open ?? 0
                        if close < subOpen {
                            openPoint.y = closePointY + STOCK_CHART_K_LINE_MIN_WIDTH
                        }else {
                            closePointY = openPoint.y + STOCK_CHART_K_LINE_MIN_WIDTH
                        }
                    }
                }
            }
            let closePoint = CGPoint(x: xPosition, y: closePointY)
            let modelHigh = model.High ?? 0
            let modelLow = model.Low ?? 0
            let highPoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat(modelHigh - minAssert) / unitValue))
            let lowPoint = CGPoint(x: xPosition, y: abs(maxY - CGFloat(modelLow - minAssert) / unitValue))
            let kLinePositionModel = YF_KLinePositionModel.model(withOpenPoint: openPoint, closePoint: closePoint, highPoint: highPoint, lowPoint: lowPoint)
            needDrawKLinePositionModels.append(kLinePositionModel)
            
            ///< MA坐标转换
            ///< 再注明一下, maxY是屏幕的高度 * K线主view所占的比例 - 15
            var ma7Y = maxY
            var ma30Y = maxY
            if unitValue > 0.0000001 {
                if let ma7 = model.MA7 {
                    ma7Y = maxY - CGFloat(ma7 - minAssert) / unitValue
                }
                
                if let ma30 = model.MA30 {
                    ma30Y = maxY - CGFloat(ma30 - minAssert) / unitValue
                }
            }
            let ma7Point = CGPoint(x: xPosition, y: ma7Y)
            let ma30Point = CGPoint(x: xPosition, y: ma30Y)
            
            if model.MA7 != nil {
                MA7Positions.append(ma7Point)
            }
            if model.MA30 != nil {
                MA30Positions.append(ma30Point)
            }
            
            ///< Accessory指标种类是BOLL线
            if targetLineStatus == .BOLL {
                ///< BOLL坐标转换
                var boll_dnY = maxY
                var boll_upY = maxY
                var boll_mbY = maxY
                
                if unitValue > 0.0000001 {
                    if let boll_dn = model.BOLL_DN {
                        boll_dnY = maxY - CGFloat(boll_dn - minAssert) / unitValue
                    }
                    if let boll_up = model.BOLL_UP {
                        boll_upY = maxY - CGFloat(boll_up - minAssert) / unitValue
                    }
                    if let boll_mb = model.BOLL_MB {
                        boll_mbY = maxY - CGFloat(boll_mb - minAssert) / unitValue
                    }
                }
                
                let boll_dnPoint = CGPoint(x: xPosition, y: boll_dnY)
                let boll_upPoint = CGPoint(x: xPosition, y: boll_upY)
                let boll_mbPoint = CGPoint(x: xPosition, y: boll_mbY)
                
                if model.BOLL_MB != nil {
                    BOLL_MBPositions.append(boll_mbPoint)
                }
                if model.BOLL_DN != nil {
                    BOLL_DNPositions.append(boll_dnPoint)
                }
                if model.BOLL_UP != nil {
                    BOLL_UPPositions.append(boll_upPoint)
                }
            }
            
            ///< 响应代理方法
            delegate?.kLineMainViewCurrentPrice?(maxPrice: maxAssert, minPrice: minAssert)
            delegate?.kLineMainViewPositionCurrent?(needDrawKLinePositionModels: needDrawKLinePositionModels)
        }
        return needDrawKLinePositionModels
    }
    
    ///< KVO监听
    fileprivate func addAllEventsListeners() {
        parentScrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            guard let sv = parentScrollView else {
                return
            }
            ///< 终于把bug找出来了, 这里要取绝对值
            let difValue = abs(sv.contentOffset.x - oldContentOffsetX)
            if difValue >= YF_StockChartVariable.kLineGap + YF_StockChartVariable.kLineWidth {
                oldContentOffsetX = sv.contentOffset.x
                drawMainView()
            }
        }
    }
}

// MARK: - 移除所有观察者
extension YF_KLineMainView {
    func removeAllObservers() {
        parentScrollView?.removeObserver(self, forKeyPath: "contentOffset", context: nil)
    }
}
