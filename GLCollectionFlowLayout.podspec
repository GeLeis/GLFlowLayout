Pod::Spec.new do |s|
s.name         = "GLCollectionFlowLayout"
s.version      = "1.0.3"
s.license      = "MIT"
s.summary      = "GLCollectionFlowLayout自定义瀑布流,支持多组section"

s.homepage     = "https://github.com/GeLeis/GLFlowLayout"
s.source       = { :git => "https://github.com/GeLeis/GLFlowLayout.git", :tag => "#{s.version}" }
s.source_files = "GLFlowLayout/**/*"
s.requires_arc = true
s.ios.deployment_target = "9.0"
s.author             = { "869313996@qq.com" => "gelei@anve.com" }
end