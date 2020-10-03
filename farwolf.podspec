

Pod::Spec.new do |s|

 

  s.name         = "farwolf"
  s.version      = "1.0.7"
  s.summary      = "weexplus基础库."
  s.description  = <<-DESC
                    Handle the data.
                   DESC

  s.homepage     = "https://weexplus.github.io/doc/"
  s.license      = "MIT"
  s.author             = { "zjr" => "362675035@qq.com" }
  s.source       = { :git => "https://github.com/farwolf2010/farwolf.git", :tag => "1.0.7" }
  s.source_files  = "Source", "farwolf/**/*.{h,m}"
  s.exclude_files = "Source/Exclude"
  s.platform     = :ios, "9.0"

  s.dependency 'MBProgressHUD', '~> 0.9.2'
  s.dependency 'YYModel', '~> 1.0.4'
  s.dependency  "AFNetworking", "~> 4.0.0"
  s.dependency 'Masonry', '~> 0.6.3'
  s.dependency 'SDWebImage', '~> 5.1.0'
   
 
  s.dependency 'TOCropViewController', '~> 2.0.8'
  # s.dependency 'SDCycleScrollView','~> 1.65' 
  # s.dependency 'GSKStretchyHeaderView', '~> 0.12.2'   
  s.dependency 'UIViewController_PopUp', '~> 0.0.2'
  # s.dependency 'SRMonthPicker'
  # s.dependency 'WeexSDK'

  
end
