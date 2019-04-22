Pod::Spec.new do |s|
s.name         = "WKCPolygonView"
s.version      = "0.1.1"
s.summary      = "多边形功能视图,用于显示进度百分比!"
s.homepage     = "https://github.com/WKCLoveYang/WKCPolygonView.git"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "WeiKunChao" => "wkcloveyang@gmail.com" }
s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/WKCLoveYang/WKCPolygonView.git", :tag => "0.1.1" }
s.source_files  = "WKCPolygonView/**/*.{h,m}"
s.public_header_files = "WKCPolygonView/**/*.h"
s.frameworks = "Foundation", "UIKit"
s.requires_arc = true

end

