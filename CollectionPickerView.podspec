#
# Be sure to run `pod lib lint CollectionPickerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CollectionPickerView'
  s.version          = '0.1.0'
  s.summary          = 'A generic customizable picker view based on UICollectionView.'


Fork of AKPickerView-Swift


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

  s.ios.deployment_target = '8.0'

  s.source_files = 'CollectionPickerView/Classes/**/*'

  # s.resource_bundles = {
  #   'CollectionPickerView' => ['CollectionPickerView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
