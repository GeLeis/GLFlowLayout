Pod::Spec.new do |s|
s.name         = "GLFlowLayout"
s.version      = "1.0.0"
s.license      = "MIT"
s.summary      = "自定义瀑布流,支持多组section"

s.homepage     = "https://github.com/GeLeis/GLFlowLayout"
s.source       = { :git => "https://github.com/GeLeis/GLFlowLayout.git", :tag => "#{s.version}" }
s.source_files = "YYLoginTextFeild/Classes/**/*" # "Classes/*.{h,m,swift}" # 你代码的位置， Classes/*.{h,m} 表示 Classes 文件夹下所有的.h和.m文件
#资源文件地址
s.resource = 'GLFlowLayout/**/*'

s.requires_arc = true
s.platform     = :ios, "9.0"
s.author             = { "869313996@qq.com" => "gelei@anve.com" }
end
