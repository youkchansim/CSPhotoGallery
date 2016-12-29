#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CSPhotoGallery'
  s.version          = '0.5.11'
  s.summary          = 'A simple and elegant Photo gallery'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'CSPhotoGallery is a PhotoGallery that is simple and elegant. and This is written Swift. '

  s.homepage         = 'https://github.com/youkchansim/CSPhotoGallery'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chansim Youk' => 'dbrckstla@naver.com' }
  s.source           = { :git => 'https://github.com/youkchansim/CSPhotoGallery.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Pod/Classes/**/*.*'
  s.resource_bundles = {'CSPhotoGallery' => ['Pod/Assets/**/*.{imageset,png,json,storyboard}']}
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
