//
//  ViewController.m
//  Demo
//
//  Created by 魏昆超 on 2018/11/15.
//  Copyright © 2018 魏昆超. All rights reserved.
//

#import "ViewController.h"
#import <WKCPolygonView.h>

@interface ViewController ()<WKCPolygonViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blueColor;
    
    WKCPolygonView * polygonView = [[WKCPolygonView alloc] initWithPercentageValues:@[@(80),@(60),@(90),@(80)]
                                                                         sideLength:100];
    polygonView.frame = CGRectMake(50, 50, polygonView.itemSize.width, polygonView.itemSize.height);
    polygonView.dataSource = self;
    [self.view addSubview:polygonView];
}


#pragma mark - WKCPolygonViewDataSource
- (CAShapeLayer *)polygonView:(WKCPolygonView *)polygon diffusionLineAtIndex:(NSInteger)index
{
    CAShapeLayer * shape = CAShapeLayer.layer;
    shape.strokeColor = UIColor.whiteColor.CGColor;
    shape.lineWidth = 1;
    return shape;
}
    
- (CGSize)polygonView:(WKCPolygonView *)polygon pointItemSizeAtIndex:(NSInteger)index
{
    return CGSizeMake(6, 6);
}

- (CAGradientLayer *)polygonView:(WKCPolygonView *)polygon pointAtIndex:(NSInteger)index
{
    CAGradientLayer * layer = CAGradientLayer.layer;
    layer.backgroundColor = UIColor.whiteColor.CGColor;
    layer.cornerRadius = 3;
    layer.masksToBounds = YES;
    return layer;
}
    
- (CAShapeLayer *)progressFunctionViewForPolygonView:(WKCPolygonView *)polygon
{
    CAShapeLayer * layer = CAShapeLayer.layer;
    layer.fillColor = UIColor.redColor.CGColor;
    return layer;
}

@end
