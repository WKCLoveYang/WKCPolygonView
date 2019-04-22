//
//  WKCPolygonView.m
//  WKCPolygonView
//
//  Created by 魏昆超 on 2018/11/14.
//  Copyright © 2018 魏昆超. All rights reserved.
//

#import "WKCPolygonView.h"

#define WKC_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface WKCPolygonView()

@property (nonatomic, strong) NSArray <NSNumber *> * percentages;
@property (nonatomic, assign) CGFloat sideLength;

@property (nonatomic, assign, readwrite) CGSize itemSize;

@property (nonatomic, assign, readwrite) CGPoint centerPoint; //中心点
@property (nonatomic, assign, readwrite) CGFloat centerLength; //中心长度
@property (nonatomic, strong, readwrite) NSMutableArray <NSValue *> * points;

@property (nonatomic, strong) CAShapeLayer * polygonLayer;

@property (nonatomic, strong, readwrite) NSMutableArray <NSValue *> * progressArray;

@end

@implementation WKCPolygonView

- (instancetype)initWithPercentageValues:(NSArray <NSNumber *> *)percentages
                              sideLength:(CGFloat)sLength
{
    if (self = [super init]) {
        _sideLength = sLength;
        self.backgroundColor = UIColor.clearColor;
        self.percentages = percentages;
    }
    return self;
}

- (void)setPercentages:(NSArray<NSNumber *> *)percentages
{
    _percentages = percentages;
    
    self.centerLength = _sideLength / ( 2 * cos(WKC_RADIANS((percentages.count - 2) * 180 / (percentages.count * 2))));
    self.centerPoint = CGPointMake(_centerLength,
                                   _centerLength);
    self.itemSize = CGSizeMake(2 * _centerLength,
                               2 * _centerLength);
    
    [self slc_setUpPolygon];
}

- (void)slc_setUpPolygon
{
    NSMutableArray <NSValue *> *polygonsArray = NSMutableArray.array;
    NSMutableArray <NSValue *> *progressArray = NSMutableArray.array;
    
    for (NSInteger index = 0; index < _percentages.count; index ++) {
        
        CGFloat angle = 360 / _percentages.count * index;
        CGFloat pChangeX = -_centerLength * sin(WKC_RADIANS(-angle));
        CGFloat pChangeY = -_centerLength * cos(WKC_RADIANS(-angle));
        CGFloat progress = _percentages[index].floatValue / 100;
        
        NSValue * point = [self slc_pointChangeX:pChangeX
                                       progressX:1
                                         changeY:pChangeY
                                       progressY:1];
        NSValue * progressValue = [self slc_pointChangeX:pChangeX
                                               progressX:progress
                                                 changeY:pChangeY
                                               progressY:progress];
        
        [polygonsArray addObject:point];
        [progressArray addObject:progressValue];
    }
    
    
    [self.points addObjectsFromArray:polygonsArray];
    [self.progressArray addObjectsFromArray:progressArray];
    
}

- (void)slc_drawPolygonWithDataSource:(NSArray <NSValue *>*)dataSource
                             forLayer:(CAShapeLayer *)layer
{
    UIBezierPath * bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint:dataSource.firstObject.CGPointValue];
    for (NSInteger index = 1; index < dataSource.count; index ++) {
        NSValue * value = dataSource[index];
        [bezierPath addLineToPoint:value.CGPointValue];
    }
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    [bezierPath closePath];
    
    layer.path = bezierPath.CGPath;
    [self.layer addSublayer:layer];
}

- (NSValue *)slc_pointChangeX:(CGFloat)cX
                    progressX:(CGFloat)pX
                      changeY:(CGFloat)cY
                    progressY:(CGFloat)pY
{
    return [NSValue valueWithCGPoint:CGPointMake(_centerPoint.x + cX * pX, _centerPoint.y + cY * pY)];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(custormPolygonForPolygonView:)]) {
        CAShapeLayer * shapeLayer = [self.dataSource custormPolygonForPolygonView:self];
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        self.polygonLayer = shapeLayer;
        [self slc_drawPolygonWithDataSource:self.points
                                   forLayer:self.polygonLayer];
    }else {
        [self slc_drawPolygonWithDataSource:self.points
                                   forLayer:self.polygonLayer];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(progressFunctionViewForPolygonView:)]) {
        CAShapeLayer * shapeLayer = [self.dataSource progressFunctionViewForPolygonView:self];
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        [self slc_drawPolygonWithDataSource:self.progressArray
                                   forLayer:shapeLayer];
        
        if ([self.dataSource respondsToSelector:@selector(progressFunctionViewGradientMaskForPolygonView:)]) {
            CAGradientLayer * gradient = [self.dataSource progressFunctionViewGradientMaskForPolygonView:self];
            gradient.frame = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
            gradient.mask = shapeLayer;
            gradient.zPosition = -1;
            [self.layer addSublayer:gradient];
            CAShapeLayer * maskShape = CAShapeLayer.new;
            maskShape.path = shapeLayer.path;
            maskShape.lineJoin = kCALineJoinRound;
            maskShape.lineCap = kCALineCapRound;
            maskShape.strokeColor = shapeLayer.strokeColor;
            maskShape.fillColor = UIColor.clearColor.CGColor;
            maskShape.lineWidth = shapeLayer.lineWidth;
            [self.layer addSublayer:maskShape];
        }
        
    }else {
        CAShapeLayer * shapeLayer = CAShapeLayer.layer;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.fillColor = UIColor.whiteColor.CGColor;
        shapeLayer.lineWidth = 0;
        shapeLayer.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.5].CGColor;
        shapeLayer.shadowOffset = CGSizeMake(0, 2);
        shapeLayer.shadowRadius = 4 / 2;
        shapeLayer.shadowOpacity = 0.5;
        [self slc_drawPolygonWithDataSource:self.progressArray
                                   forLayer:shapeLayer];
    }
    
    for (NSInteger index = 0; index < _points.count; index ++) {
        
        NSValue * point = _points[index];
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(polygonView:diffusionLineAtIndex:)]) {
            UIBezierPath * beiziperPath = UIBezierPath.bezierPath;
            [beiziperPath moveToPoint:point.CGPointValue];
            [beiziperPath addLineToPoint:self.centerPoint];
            beiziperPath.lineCapStyle = kCGLineCapRound;
            beiziperPath.lineJoinStyle = kCGLineJoinRound;
            [beiziperPath closePath];
            
            CAShapeLayer * shapeLayer = [self.dataSource polygonView:self diffusionLineAtIndex:index];
            shapeLayer.lineJoin = kCALineJoinRound;
            shapeLayer.lineCap = kCALineCapRound;
            shapeLayer.path = beiziperPath.CGPath;
            [self.layer insertSublayer:shapeLayer
                                 below:self.polygonLayer];
        }
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(polygonView:pointAtIndex:)]) {
            
            CAGradientLayer * gradientLayer = [self.dataSource polygonView:self pointAtIndex:index];
            
            CGSize itemSize = CGSizeZero;
            if ([self.dataSource respondsToSelector:@selector(polygonView:pointItemSizeAtIndex:)]) {
                itemSize = [self.dataSource polygonView:self pointItemSizeAtIndex:index];
            }
            gradientLayer.frame = CGRectMake(point.CGPointValue.x - itemSize.width / 2, point.CGPointValue.y - itemSize.height / 2, itemSize.width, itemSize.height);
            [self.layer addSublayer:gradientLayer];
        }
        
    }
}

#pragma mark - Property
- (CAShapeLayer *)polygonLayer
{
    if (!_polygonLayer) {
        _polygonLayer = CAShapeLayer.layer;
        _polygonLayer.lineJoin = kCALineJoinRound;
        _polygonLayer.lineCap = kCALineCapRound;
        _polygonLayer.strokeColor = UIColor.whiteColor.CGColor;
        _polygonLayer.fillColor = UIColor.clearColor.CGColor;
        _polygonLayer.lineWidth = 2;
    }
    return _polygonLayer;
}

- (NSMutableArray<NSValue *> *)points
{
    if (!_points) {
        _points = NSMutableArray.array;
    }
    return _points;
}

- (NSMutableArray<NSValue *> *)progressArray
{
    if (!_progressArray) {
        _progressArray = NSMutableArray.array;
    }
    return _progressArray;
}

@end
