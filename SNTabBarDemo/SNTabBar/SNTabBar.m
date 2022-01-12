//
//  SNTabBar.m
//  SNTabBarDemo
//
//  Created by ShawnWong on 2021/12/28.
//

#import "SNTabBar.h"
#import "SNTabBarItem.h"

#define MAINSCREENW [UIScreen mainScreen].bounds.size.width
#define MAINSCREENH [UIScreen mainScreen].bounds.size.height

static CGFloat safeAreH = 34.0;
static CGFloat indicatorR = 28.0;

@interface SNTabBar()<CAAnimationDelegate>

@property (nonatomic, strong) UITabBar *nativeTabBar;
@property (nonatomic, assign) NSInteger itemsCount;

@property (nonatomic, strong) CALayer *selectionIndicator;
@property (nonatomic, strong) CAGradientLayer *selectionIndicatorGradientLayer;

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *backgroundMaskLayer;

@property (nonatomic, assign) CGFloat lastItemPointX;
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) UIButton *lastClickItem;

@end

@implementation SNTabBar

+ (BOOL)accessInstanceVariablesDirectly {
    return NO;
}

- (instancetype)initWithNativeTabBar:(UITabBar *)tabBar {
    if (tabBar) {
        self = [super initWithFrame:tabBar.bounds];
        if (self) {
            self.nativeTabBar = tabBar;
            self.itemsCount = tabBar.items.count;
            self.bezierPath = [UIBezierPath bezierPath];
            
            // backgroudLayer
            [self.backgroundLayer setMask:self.backgroundMaskLayer];
            [self.layer addSublayer:self.backgroundLayer];
            [self.selectionIndicator addSublayer:self.selectionIndicatorGradientLayer];
            [self.layer addSublayer:self.selectionIndicator];
            
            [self setSelectedIndex:0];
        }
        return self;
    }
    return nil;
}

#pragma mark - Setter&Getter

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self setBackgroudMaskLayerBezierPathWithSelectedIndex:_selectedIndex];
    [self setIndicatorLayerAnimationWithSelectedIndex:_selectedIndex];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    if (barTintColor) {
        _barTintColor = barTintColor;
        self.backgroundLayer.backgroundColor = barTintColor.CGColor;
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (backgroundImage) {
        _backgroundImage = backgroundImage;
        [self.backgroundLayer setContents:(__bridge id)backgroundImage.CGImage];
        [self.backgroundLayer setContentsGravity:kCAGravityResizeAspectFill];
        [self.backgroundLayer setContentsScale:[UIScreen mainScreen].scale];
    }
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    if (translucent) {
        [self.backgroundLayer setOpacity:0.75];
    }
}

- (void)setSelectionIndicatorColors:(NSArray<UIColor *> *)selectionIndicatorColors {
    if (selectionIndicatorColors) {
        _selectionIndicatorColors = selectionIndicatorColors;
        self.selectionIndicatorGradientLayer.colors = selectionIndicatorColors;
    }
}

- (void)setItems:(NSArray<SNTabBarItem *> *)items {
    if (items) {
        _items = items;
        CGFloat btnW = MAINSCREENW / items.count;
        for (int i = 0; i < items.count; i++) {
            SNTabBarItem *item = items[i];
            item.frame = CGRectMake(btnW * i, 0, btnW, 49);
            item.tag = 10000 + i;
            [item addTarget:self action:@selector(itemTapAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:item];
            
            if (i == self.selectedIndex) {
                self.lastClickItem = item;
                [item setSelected:YES];
            }
        }
    }
}

#pragma mark - Methods
- (void)itemTapAction:(SNTabBarItem *)item {
    if ([item isKindOfClass:[SNTabBarItem class]]) {
        if (item.isSelected) {
            return;
        }else {
            item.selected = YES;
            self.lastClickItem.selected = NO;
        }
        self.lastClickItem = item;
        [self setSelectedIndex:item.tag - 10000];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sn_tabBar:didSelectItem:)]) {
            [self.delegate sn_tabBar:self didSelectItem:item];
        }
    }
}
#pragma mark - Private
- (void)setIndicatorLayerAnimationWithSelectedIndex:(NSInteger)selectedIndex {
    
    CGFloat itemCenter = MAINSCREENW / (_itemsCount * 2);
    CGFloat itemCenterX = itemCenter * (selectedIndex * 2 + 1);
    
    // 创建关键帧动画并设置动画属性
    CAKeyframeAnimation* keyFrameAnimation =[CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.delegate = self;
    keyFrameAnimation.duration = .5;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    keyFrameAnimation.calculationMode = kCAAnimationPaced; // 均分

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _selectionIndicator.position.x, _selectionIndicator.position.y);
    // 圆弧运动
    CGFloat cPX = fabs(itemCenterX - _selectionIndicator.position.x)/2.0 + (_selectionIndicator.position.x > itemCenterX ? itemCenterX : _selectionIndicator.position.x);
    CGPathAddQuadCurveToPoint(path, NULL, cPX, -80, itemCenterX, 0);
    CGPathAddLineToPoint(path, NULL, itemCenterX, 25);
    CGPathAddLineToPoint(path, NULL, itemCenterX, 0);
    keyFrameAnimation.path = path;
  
    // 添加动画到图层，添加动画后就会行动画
    [_selectionIndicator addAnimation:keyFrameAnimation forKey:@"myAnimation"];
    _lastItemPointX = itemCenterX;
}

- (void)setBackgroudMaskLayerBezierPathWithSelectedIndex:(NSInteger)selectedIndex {
    //     c1       c4
    //  p1              p3
    //      c2      c3
    //          p2
    CGFloat offsetX = 30;
    CGFloat cornerDeep = 49;
    CGFloat itemW = MAINSCREENW / _itemsCount;

    [self.bezierPath removeAllPoints];
    [self.bezierPath moveToPoint:CGPointMake(0, 0)];

    CGFloat p1X = itemW * selectedIndex - offsetX;
    [self.bezierPath addLineToPoint:CGPointMake(p1X, 0)];

    CGFloat p2X = itemW * (selectedIndex + 0.5);
    CGFloat c1PX = itemW * selectedIndex + 10;
    CGFloat c2PX = itemW * selectedIndex + 10;
    [self.bezierPath addCurveToPoint:CGPointMake(p2X, cornerDeep)
                  controlPoint1:CGPointMake(c1PX, 4)
                  controlPoint2:CGPointMake(c2PX, 46)];

    CGFloat p3X = itemW * (selectedIndex + 1) + offsetX;
    CGFloat c3PX = itemW * (selectedIndex + 1) - 10;
    CGFloat c4PX = itemW * (selectedIndex + 1) - 10;
    [self.bezierPath addCurveToPoint:CGPointMake(p3X, 0)
                  controlPoint1:CGPointMake(c3PX, 46)
                  controlPoint2:CGPointMake(c4PX, 4)];

    [self.bezierPath addLineToPoint:CGPointMake(MAINSCREENW, 0)];
    [self.bezierPath addLineToPoint:CGPointMake(MAINSCREENW, self.frame.size.height+safeAreH)];
    [self.bezierPath addLineToPoint:CGPointMake(0, self.frame.size.height+safeAreH)];
    [self.bezierPath closePath];

    self.backgroundMaskLayer.path = self.bezierPath.CGPath;
}


#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([_selectionIndicator animationForKey:@"myAnimation"] == anim) {
        [_selectionIndicator setPosition:CGPointMake(_lastItemPointX, 0)];
    }
}

#pragma mark - Lazy
- (CALayer *)selectionIndicator {
    if (!_selectionIndicator) {
        CALayer *indicatorBgLayer = [CALayer layer];
        indicatorBgLayer.bounds = CGRectMake(0, 0, indicatorR * 2, indicatorR * 2);
        indicatorBgLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(indicatorR, indicatorR)
                                                                  radius:indicatorR startAngle:0 endAngle:M_PI*2 clockwise:YES];
        // 遮罩
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = bezierPath.CGPath;
        [indicatorBgLayer setMask:maskLayer];
        _selectionIndicator = indicatorBgLayer;
    }
    return _selectionIndicator;
}

- (CAGradientLayer *)selectionIndicatorGradientLayer {
    if (!_selectionIndicatorGradientLayer) {
        // 渐变
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(id)[UIColor colorWithRed:0.58 green:0.08 blue:0.40 alpha:1.00].CGColor,
                                 (id)[UIColor colorWithRed:0.92 green:0.42 blue:0.67 alpha:1.00].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(0.8, 0);
        _selectionIndicatorGradientLayer = gradientLayer;
    }
    return _selectionIndicatorGradientLayer;
}

- (CAShapeLayer *)backgroundLayer {
    if (!_backgroundLayer) {
        CAShapeLayer *backgroundLayer =  [CAShapeLayer layer];
        backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _backgroundLayer = backgroundLayer;
    }
    return _backgroundLayer;
}

- (CAShapeLayer *)backgroundMaskLayer {
    if (!_backgroundMaskLayer) {
        CAShapeLayer *maskLayer =  [CAShapeLayer layer];
        _backgroundMaskLayer = maskLayer;
    }
    return _backgroundMaskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backgroundLayer setFrame:self.nativeTabBar.bounds];
    [self.selectionIndicatorGradientLayer setFrame:self.selectionIndicator.bounds];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
