# WKCPolygonView

原项目SLCPolygonView, 移动至此.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/WKCPolygonView.svg?style=flat)](https://cocoapods.org/pods/WKCPolygonView) [![License: MIT](https://img.shields.io/cocoapods/l/WKCPolygonView.svg?style=flat)](http://opensource.org/licenses/MIT)


多边形功能视图,用于显示进度百分比!


`pod 'WKCPolygonView'`

## 初始化
```
WKCPolygonView * WKCPolygonView = [[WKCPolygonView alloc] initWithPercentageValues:@[@(80),@(60),@(90),@(80)]
sideLength:100];
polygonView.frame = CGRectMake(50, 50, polygonView.itemSize.width, polygonView.itemSize.height);
[self.view addSubview:polygonView];
```

## 代理
1.1 自定义扩散线.
```
- (CAShapeLayer *)polygonView:(WKCPolygonView *)polygon diffusionLineAtIndex:(NSInteger)index
{
CAShapeLayer * shape = CAShapeLayer.layer;
shape.strokeColor = UIColor.whiteColor.CGColor;
shape.lineWidth = 1;
return shape;
}
```

1.2 自定义关键点.
```
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
```
1.3 自定义内部功能图.
```
- (CAShapeLayer *)progressFunctionViewForPolygonView:(WKCPolygonView *)polygon
{
CAShapeLayer * layer = CAShapeLayer.layer;
layer.fillColor = UIColor.redColor.CGColor;
return layer;
}
```

1.4 自定义外边框.
```
- (CAShapeLayer *)custormPolygonForPolygonView:(WKCPolygonView *)polygon
```


![Alt text](https://github.com/WKCLoveYang/WKCPolygonView/raw/master/1.jpg).
