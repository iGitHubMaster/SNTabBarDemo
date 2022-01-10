//
//  ViewController.m
//  SNTabBarDemo
//
//  Created by ShawnWong on 2021/12/27.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat cR = 25;
    // Do any additional setup after loading the view.
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(self.view.center.x-cR, self.view.center.y-cR*2, cR*2, cR*2);
    layer.backgroundColor = [UIColor greenColor].CGColor;
    
    //创建圆环
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(cR, cR) radius:20 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    //圆环遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    // 填充颜色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    // 描边颜色
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 1;
    
    shapeLayer.lineWidth = 2;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineDashPhase = 0.8;
    shapeLayer.path = bezierPath.CGPath;
    [layer setMask:shapeLayer];
    
    //颜色渐变    
    NSMutableArray *colors1 = [NSMutableArray arrayWithObjects:(id)[[UIColor blueColor] CGColor],
                               (id)[[UIColor whiteColor] CGColor], nil];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.shadowPath = bezierPath.CGPath;
    gradientLayer1.frame = layer.bounds;
    gradientLayer1.startPoint = CGPointMake(0, 1);
    gradientLayer1.endPoint = CGPointMake(1, 1);
    [gradientLayer1 setColors:[NSArray arrayWithArray:colors1]];
//    [layer addSublayer:gradientLayer]; //设置颜色渐变
    [layer addSublayer:gradientLayer1];
    
    //动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2.0*M_PI];
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.duration = 1;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.removedOnCompletion = NO;
    [layer addAnimation:rotationAnimation forKey:@"rotationAnnimation"];
    
    [self.view.layer addSublayer:layer];
}


@end
