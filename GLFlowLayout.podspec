#
# Be sure to run `pod lib lint GLFlowLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "GLFlowLayout"
  s.version          = "1.0.0"
  s.summary          = "A short description of GLFlowLayout."
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = "https://github.com/GeLeis/GLFlowLayout"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "869313996@qq.com" => "gelei@anve.com" }
  s.source           = { :git => "https://github.com/GeLeis/GLFlowLayout.git", :tag => s.version.to_s }
  s.ios.deployment_target = "9.0"
  s.source_files = "GLFlowLayout/**/*"
end
