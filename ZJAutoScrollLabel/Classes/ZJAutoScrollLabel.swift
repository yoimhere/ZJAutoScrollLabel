//
//  ZJAutoScrollLabel.swift
//
//  Created by admin  on 2018/1/31.
//  Copyright © 2018年 OneByte. All rights reserved.
//
import UIKit

private let kTextsScrollSpace: CGFloat = 30
private let kScrollSpeed: CGFloat = 0.8

public enum ZJAutoScrollDirection{
    /// ←_← 滚动  (正数)
    case scollToLeft(CGFloat)
    /// →_→ 滚动  (正数)
    case scollToRight(CGFloat)
}

public struct ZJAutoScrollAttribute
{
    public static let `default` = ZJAutoScrollAttribute()
    
    /// text之间的间隔  正数
    var space: CGFloat
    
    /// text滚向哪个方向
    var direction: ZJAutoScrollDirection
    
    /// true 会限制text的最小宽度为父视图的宽，  并且text之间的空白间隔会不固定
    var isPagingEnabled: Bool
    
    /// text的字体大小
    var textFont: UIFont?
    
    /// text的字体颜色
    var textColor: UIColor?
    
    public init(direction: ZJAutoScrollDirection = .scollToLeft(kScrollSpeed), space: CGFloat = kTextsScrollSpace, isPagingEnabled: Bool = false, textFont: UIFont? = nil, textColor: UIColor? = nil) {
        self.direction = direction
        self.space  = space < 0.0  ? kTextsScrollSpace : space
        self.isPagingEnabled = isPagingEnabled
        self.textFont = textFont
        self.textColor = textColor
    }
}

public class ZJAutoScrollLabel: UIView
{
    private (set) var scrollAttribute:ZJAutoScrollAttribute = .default
    private (set) var texts:[String] = []
    private (set) var textAndWidths = [String:CGFloat]()
    private (set) var textIndex = 0

    private var reusedlabels: [UILabel] = []
    private var usedLabels: [UILabel] = []
    
    private var isScollToLeft: Bool {
        if case .scollToLeft(_) = scrollAttribute.direction {
            return true
        }else{
            return false
        }
    }
    
    private var perframeDistance: CGFloat{
        switch scrollAttribute.direction{
        case let .scollToLeft(moveDistance):
                return -moveDistance
        case let .scollToRight(moveDistance):
                return moveDistance
        }
    }
    
    private var lableBoundsMinX:CGFloat {
        return 0
    }
    
    private var lableBoundsMaxX:CGFloat {
        return  bounds.size.width
    }
    
    lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(refreshScrollInfo))
        displayLink.add(to: .current, forMode: .commonModes)
        return displayLink
    }()
    
    //MARK: - Life
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.clipsToBounds = true
        stop();
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    public convenience init(frame: CGRect, scrollAttribute: ZJAutoScrollAttribute)
    {
        self.init(frame: frame)
        self.scrollAttribute = scrollAttribute;
    }
    
    public convenience init(scrollAttribute: ZJAutoScrollAttribute)
    {
        self.init(frame: .zero, scrollAttribute: scrollAttribute)
    }
    
    deinit {
        displayLink.invalidate()
    }
    
    //MARK: - Action
    public func setTexts(_ texts:[String])
    {
        self.texts = texts
        calculateTextSize()
    }
    
   /// 预先计算字体宽度并缓存
    func calculateTextSize()
    {
        self.textAndWidths.removeAll()
        let usedFont = scrollAttribute.textFont ?? UILabel().font!
        for text in self.texts {
            let width = text.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 50), options:.usesFontLeading, attributes:[.font:usedFont], context: nil).size.width;
            self.textAndWidths[text] = checkLabelWidth(with: width)
        }
    }
    
    /// 帧刷新
    @objc func refreshScrollInfo()
    {
        if texts.count == 0 || self.bounds == .zero {return}
        
        checkFisrtLabel()
        checkLastLabel()
        moveDistance()
    }
    
    func checkFisrtLabel() {
        if let firstLabel = usedLabels.first {
            let frame = firstLabel.frame
            let isOutOfBound = isScollToLeft ? frame.maxX <= lableBoundsMinX :  frame.minX >= lableBoundsMaxX
            if isOutOfBound {
                let outBoundsLable = usedLabels.removeFirst()
                outBoundsLable.removeFromSuperview()
                reusedlabels.append(outBoundsLable)
            }
        }
    }
    
    func checkLastLabel() {
        while true {
            var isNeedNewLabel = true
            let startX = isScollToLeft ?  lableBoundsMaxX : lableBoundsMinX
            if let lastLabel = usedLabels.last {
                let frame = lastLabel.frame
                isNeedNewLabel = isScollToLeft ? lableBoundsMaxX - frame.maxX >= scrollAttribute.space : lableBoundsMinX - frame.minX <= -scrollAttribute.space
            }
            
            if isNeedNewLabel{
                addNewLable(startX:startX)
            }else{
                break;
            }
        }
    }
    
    func moveDistance (){
        let _ = usedLabels.map{$0.frame.origin.x = $0.frame.origin.x + perframeDistance}
    }
    
    //增加一个新的滚动label
    func addNewLable(startX x:CGFloat)
    {
        let newLabel = getLabel()
   
        let text = texts[textIndex%texts.count]
        newLabel.text = text

        var frame =  self.bounds;
        if let hasWidth = self.textAndWidths[text]{
            frame.size.width = hasWidth
        }else{
            newLabel.sizeToFit()
            let width = checkLabelWidth(with: newLabel.frame.size.width)
            self.textAndWidths[text] = width
            frame.size.width = width
        }
        
        if isScollToLeft{
            frame.origin.x = x
        }else{
            frame.origin.x = x - frame.width;
        }
        
        newLabel.frame = frame;

        addSubview(newLabel)
        usedLabels.append(newLabel)
        textIndex = textIndex + 1
    }
    
    func checkLabelWidth(with width: CGFloat) -> CGFloat {
       return scrollAttribute.isPagingEnabled ? max(width, bounds.size.width) :  width
    }
    
    func getLabel() -> UILabel
    {
        var label:UILabel
        if reusedlabels.isEmpty {
            label = UILabel()

            if let font = scrollAttribute.textFont { label.font = font }
            if let textColor = scrollAttribute.textColor { label.textColor = textColor }
            
        }else{
            label = reusedlabels.removeLast()
        }
        
        return label;
    }
    
    public func resume()
    {
        displayLink.isPaused = false;
    }
    
    public func stop()
    {
        displayLink.isPaused = true;
    }
}
