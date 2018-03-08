//
//  YF_KLineMainView.swift
//  YF-KLine
//
//  Created by tsaievan on 1/3/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

protocol YF_KLineMainViewDelegate: NSObjectProtocol {
    ///< 需要绘制的K线模型数组
    func kLineMainViewCurrent(needDrawKLineModels kLineModels: [YF_KLineModel])
    
    ///< 需要绘制的K线位置模型数组
    func kLineMainViewPositionCurrent(needDrawKLinePositionModels kLinePositionModels: [YF_KLinePositionModel])
    
    ///< 当前MainView的最大值和最小值
    func kLineMainViewCurrentPrice(maxPrice: Double, minPrice: Double)
}

class YF_KLineMainView: UIView {
    ///< 父ScrollView
    var parentScrollView: UIScrollView?
    
    var needDrawKLinePositionModels = [YF_KLinePositionModel]()
    
    var needDrawKLineModels = [YF_KLineModel]()
    
    weak var delegate: YF_KLineMainViewDelegate?
    
    ///< K线类型
    var mainViewType: YF_StockChartViewType?
    
    ///< Accessory指标种类
    var targetLineStatus: YF_StockChartTargetLineStatus?
    
    ///< 捏合点
    var pinchStartIndex: Int?
    
    ///< k线模型对象的数组
    
    ///< 在kLineModels的setter方法里面更新KLineMainView的宽度
    var kLineModels: [Any]? {
        didSet {
            updateMainViewWidth()
        }
    }
    
    ///< 需要绘制Index开始值
    lazy var needDrawStartIndex: Int = {
        guard let scrollViewOffsetX = parentScrollView?.contentOffset.x else {
            return 0
        }
        let offsetX = (scrollViewOffsetX < 0 ? 0 : scrollViewOffsetX)
        let leftArrCount = abs(offsetX - YF_StockChartVariable.kLineGap) / (YF_StockChartVariable.kLineGap + YF_StockChartVariable.kLineWidth)
        return Int(leftArrCount)
    }()
    
    ///< Index开始的X的值
    lazy var startXPosition: Int = {
        let totalKlineGap = CGFloat(needDrawStartIndex + 1) * YF_StockChartVariable.kLineGap
        let totalKlineWidth = CGFloat(needDrawStartIndex) * YF_StockChartVariable.kLineWidth
        let exceedWidth = (YF_StockChartVariable.kLineWidth) * 0.5
        let startXPosition = totalKlineGap + totalKlineWidth + exceedWidth
        return Int(startXPosition)
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///< 画K线主视图
    func drawMainView() {
        extractNeedDrawModels()
        convertToKLinePositionModel()
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
        parentScrollView?.contentSize = CGSize(width: kLineViewWidth, height: parentView.height)
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
                let date = Date(timeIntervalSince1970: needDrawKLineModels[idx].date ?? 0)
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let dateStr = formatter.string(from: date)
                let drawDatePoint = CGPoint(x: point.x + 1, y: height + 1.5)
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
            //TODO: - BOLL点模型还没处理好
        }
    }
}


// MARK: - 系统方法
extension YF_KLineMainView {
    override func didMoveToWindow() {
        guard let superView = superview else {
            super.didMoveToWindow()
            return
        }
        parentScrollView = superView as? UIScrollView
        super.didMoveToWindow()
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
        }else {
            needDrawKLineStartIndex = needDrawStartIndex
        }
        needDrawKLineModels.removeAll()
        guard let models = kLineModels else {
            return
        }
        if needDrawKLineStartIndex < models.count {
            if needDrawKLineStartIndex + needDrawKLineCount < models.count {
                let subArry = models[needDrawKLineStartIndex..<needDrawKLineCount]
                //FIXME:- 数组的切片还不怎么会用
                let combineArray: [YF_KLineModel] = (needDrawKLineModels as [Any] + subArry) as! [YF_KLineModel]
                needDrawKLineModels = combineArray
            }else {
                let endIndex = models.count - needDrawKLineStartIndex
                let subArry = models[needDrawKLineStartIndex..<endIndex]
                let combineArray: [YF_KLineModel] = (needDrawKLineModels as [Any] + subArry) as! [YF_KLineModel]
                needDrawKLineModels = combineArray
            }
        }
        ///< 响应代理
        delegate?.kLineMainViewCurrent(needDrawKLineModels: needDrawKLineModels)
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
        //FIXME:- 其他的线先不画, 先画K线
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
            
            ///< 响应代理方法
            delegate?.kLineMainViewCurrentPrice(maxPrice: maxAssert, minPrice: minAssert)
            delegate?.kLineMainViewPositionCurrent(needDrawKLinePositionModels: needDrawKLinePositionModels)
        }
        return needDrawKLinePositionModels
    }
}
