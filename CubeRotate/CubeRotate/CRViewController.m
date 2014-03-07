//
//  CRViewController.m
//  CubeRotate
//
//  Created by fenda-fly on 14-3-7.
//  Copyright (c) 2014年 com.fenda.wdg. All rights reserved.
//

#import "CRViewController.h"

@interface CRViewController ()

@end

@implementation CRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainLayer = [CALayer layer];
    self.mainLayer.contentsScale = [UIScreen mainScreen].scale;
    self.mainLayer.frame = self.view.bounds;
    
    //前
    [self addLayer:@[@0,@0,@100,@0,@0,@0,@0]];
    //后
    [self addLayer:@[@0,@0,@(-100),@(M_PI),@0,@0,@0]];
    //左
    [self addLayer:@[@(-100),@0,@0,@(-M_PI_2),@0,@1,@0]];
    //右
    [self addLayer:@[@(100),@0,@0,@(M_PI_2),@0,@1,@0]];
    //上
    [self addLayer:@[@(0),@(-100),@0,@(-M_PI_2),@1,@0,@0]];
    //下
    [self addLayer:@[@(0),@(100),@0,@(M_PI_2),@1,@0,@0]];
    
    //主layer的3D变换
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/700;
    /*解释下M34
     struct CATransform3D
     {
     CGFloat m11（x缩放）, m12（y切变）, m13（旋转）, m14（）;
     CGFloat m21（x切变）, m22（y缩放）, m23（）, m24（）;
     CGFloat m31（旋转）, m32（）, m33（）, m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）;
     CGFloat m41（x平移）, m42（y平移）, m43（z平移）, m44（）;
     };
     ps:整体比例变换时，也就是m11==m22时，若m33>1，图形整体缩小，若0<m33<1，图形整体放大，若s<0,发生关于原点的对称等比变换。
     首先要实现view（layer）的透视效果（就是近大远小），是通过设置m34的：
     CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
     rotationAndPerspectiveTransform.m34 = 1.0 / -500;
     m34负责z轴方向的translation（移动），m34= -1/D,  默认值是0，也就是说D无穷大，这意味layer in projection plane（投射面）和layer in world coordinate重合了。
     D越小透视效果越明显。
     所谓的D，是eye（观察者）到投射面的距离。
     
     */
    
    
    //在X轴上做一个20度的小旋转 在那个轴上面旋转就是对应的坐标值为1，当前为X轴旋转
    transform = CATransform3DRotate(transform, M_PI/9, 1, 0, 0);
    //设置CAlayer的sublayerTransform
    self.mainLayer.sublayerTransform = transform;
    //添加Layer
    [self.view.layer addSublayer:self.mainLayer];
    
    //动画
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
    
    //从0到360度
    
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    
    //间隔3秒
    
    animation.duration = 3.0;
    
    //无限循环
    
    animation.repeatCount = HUGE_VALF;
    
    //开始动画
    
    [self.mainLayer addAnimation:animation forKey:@"rotation"];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)addLayer:(NSArray *)params
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.contentsScale = [UIScreen mainScreen].scale;
    gradient.bounds = CGRectMake(0, 0, 200, 200);  //生成的图像的大小必须是每个面的X/Y/Z的二倍。
    
    //定位渐变的位置为View的中间
    gradient.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    gradient.colors = @[(id)[UIColor grayColor].CGColor,(id)[UIColor blackColor].CGColor];
    gradient.locations = @[@0,@1];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    
    
    //根据参数对CAlayer进行偏移和旋转Transform
    CATransform3D transform = CATransform3DMakeTranslation([[params objectAtIndex:0]floatValue], [[params objectAtIndex:1]floatValue], [[params objectAtIndex:2]floatValue]);
    
    transform = CATransform3DRotate(transform, [[params objectAtIndex:3]floatValue], [[params objectAtIndex:4]floatValue], [[params objectAtIndex:5]floatValue], [[params objectAtIndex:6]floatValue]);
    //设置tranform属性并把Layer加入到主Layer中
    gradient.transform = transform;
    [self.mainLayer addSublayer:gradient];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
