Pod::Spec.new do |s|
  s.name             = 'KSOProgressHUD'
  s.version          = '0.2.0'
  s.summary          = 'KSOProgressHUD is a replacement for the private UIProgressHUD class.'
  s.description      = <<-DESC
KSOProgressHUD is a replacement for the private UIProgressHUD class. It supports a variety of customizations, including UIVisualEffect background views, custom background views, displaying image, text, progress, along with custom layout support.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/KSOProgressHUD'
  s.license          = { :type => 'BSD', :file => 'license.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/KSOProgressHUD.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  
  s.requires_arc = true

  s.source_files = 'KSOProgressHUD/**/*.{h,m}'
  s.exclude_files = 'KSOProgressHUD/KSOProgressHUD-Info.h'
  s.private_header_files = 'KSOProgressHUD/Private/*.h'

  s.resource_bundles = {
    'KSOProgressHUD' => ['KSOProgressHUD/**/*.{lproj}']
  }

  s.ios.frameworks = 'UIKit'
  s.tvos.frameworks = 'UIKit'
  
  s.dependency 'Stanley'
  s.dependency 'Loki'
  s.dependency 'KSOFontAwesomeExtensions'
  s.dependency 'Quicksilver'
  s.dependency 'Ditko'
end
