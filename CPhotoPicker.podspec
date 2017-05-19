#
# Be sure to run `pod lib lint CAlert.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
s.name             = 'CPhotoPicker'
s.version          = '0.0.1'
s.summary          = 'This a short description of CPhotoPicker.'
s.description      = <<-DESC
TODO: It is easy to use, support for custom pop tips.
DESC
s.homepage         = 'https://github.com/Initial-C/CPhotoPicker/blob/master/README.md'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Initial-C-William Chang' => 'iwilliamchang@outlook.com' }
s.source           = { :git => 'https://github.com/Initial-C/CPhotoPicker.git', :tag => s.version.to_s }
s.ios.deployment_target = '7.0'
s.requires_arc = true

s.source_files = 'Classes/**/*'
s.resources = 'Classes/ImageSource/*.{png,xib,nib,bundle,mov}'
s.public_header_files = 'Classes/*.h'
s.frameworks = 'UIKit', 'QuartzCore'
# s.dependency 'AFNetworking', '~> 2.3'
end
