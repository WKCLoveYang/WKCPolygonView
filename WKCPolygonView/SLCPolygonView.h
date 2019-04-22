//
//  SLCPolygonView.h
//  SLCPolygonView
//
//  Created by 魏昆超 on 2018/11/14.
//  Copyright © 2018 魏昆超. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLCPolygonView;

@protocol SLCPolygonViewDataSource <NSObject>

@optional

- (CAShapeLayer *)polygonView:(SLCPolygonView *)polygon
         diffusionLineAtIndex:(NSInteger)index; //自定义中心扩散线

- (CGSize)polygonView:(SLCPolygonView *)polygon
 pointItemSizeAtIndex:(NSInteger)index; //自定义关键点大小

- (CAGradientLayer *)polygonView:(SLCPolygonView *)polygon
                    pointAtIndex:(NSInteger)index; //自定义关键点

- (CAShapeLayer *)progressFunctionViewForPolygonView:(SLCPolygonView *)polygon; //自定义内部进度功能图 - (有默认,默认白色内部填充...)

- (CAGradientLayer *)progressFunctionViewGradientMaskForPolygonView:(BSHPolygonView *)polygon; //自定义渐变遮罩 先回调自定义内部进度功能图才有效

- (CAShapeLayer *)custormPolygonForPolygonView:(SLCPolygonView *)polygon; //自定义多边形图 - (有默认,默认白色线条填充,宽度2...)

@end

@interface SLCPolygonView : UIView

@property (nonatomic, strong) id <SLCPolygonViewDataSource> dataSource;

@property (nonatomic, assign, readonly) CGSize itemSize; //视图大小
@property (nonatomic, assign, readonly) CGPoint centerPoint; //中心点
@property (nonatomic, assign, readonly) CGFloat centerLength; //中心长度
@property (nonatomic, strong, readonly) NSMutableArray <NSValue *> * points; //点数组
@property (nonatomic, strong, readonly) NSMutableArray <NSValue *> * progressArray; //进度点数组

/**
 初始化

 @param percentages 数据源
 @param sLength 边长
 @return 返回当前视图对象
 */
- (instancetype)initWithPercentageValues:(NSArray <NSNumber *> *)percentages
                              sideLength:(CGFloat)sLength;

@end

