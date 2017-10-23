#
# Be sure to run `pod lib lint LazySeq.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LazySeq'
  s.version          = '0.5.2'
  s.summary          = 'Implementation of LazySequence and GeneratedSequence'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Simple implementation of GeneratedSequence, and based on it, LazySequence. Difference is that LazySeq stores computation results, while GeneratedSeq doesn't.

It also supports generating using complex reuse function, but it's not required.
                       DESC

  s.homepage         = 'https://github.com/NeedMoreDesu/LazySeq'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oleksii Horishnii' => 'oleksii.horishnii@gmail.com' }
  s.source           = { :git => 'https://github.com/NeedMoreDesu/LazySeq.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LazySeq/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LazySeq' => ['LazySeq/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'DividableRange', '~> 0.1'
end
