#
# Be sure to run `pod lib lint CollectionPickerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CollectionPickerView'
  s.version          = '0.1.2'
  s.summary          = 'A generic customizable picker view based on UICollectionView.'

  s.description      = <<-DESC
  Generic and customizable picker based on UICollectionView. Picker cells are fully
  customizable. Supports flat/wheel look, snap to center after scroll, horizontal
  and vertical direction.

  Fork of AKPickerView-Swift. Works in iOS 8.
                       DESC

  s.homepage         = 'https://github.com/3ph/CollectionPickerView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '3ph' => 'instantni.med@gmail.com' }
  s.source           = { :git => 'https://github.com/3ph/CollectionPickerView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '4.2'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CollectionPickerView/Classes/**/*'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end
