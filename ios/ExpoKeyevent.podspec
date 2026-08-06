Pod::Spec.new do |s|
  s.name           = 'ExpoKeyevent'
  s.version        = '0.2.5'
  s.summary        = 'Native key and gamepad events for React Native and Expo'
  s.description    = 'Native key and gamepad events for React Native and Expo'
  s.author         = 'Mehrdad Moradi'
  s.homepage       = 'https://github.com/thegreatzeus/expo-keyevent'
  s.platforms      = {
    :ios => '16.4',
    :tvos => '16.4'
  }
  s.source         = { git: '' }
  s.static_framework = true

  s.dependency 'ExpoModulesCore'

  # Swift/Objective-C compatibility
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
  }

  s.source_files = "**/*.{h,m,mm,swift,hpp,cpp}"
end
