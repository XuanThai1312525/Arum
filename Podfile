# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_modular_headers!
inhibit_all_warnings!
pre_install do |installer|
    remove_swiftui()
end

def remove_swiftui
  # 解决 xcode13 Release模式下SwiftUI报错问题
  system("rm -rf ./Pods/Kingfisher/Sources/SwiftUI")
  code_file = "./Pods/Kingfisher/Sources/General/KFOptionsSetter.swift"
  code_text = File.read(code_file)
  code_text.gsub!(/#if canImport\(SwiftUI\) \&\& canImport\(Combine\)(.|\n)+#endif/,'')
  system("rm -rf " + code_file)
  aFile = File.new(code_file, 'w+')
  aFile.syswrite(code_text)
  aFile.close()
end

target 'Arum' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'SwiftyJSON'
  pod 'Alamofire'
  pod 'PromiseKit'
  pod 'IQKeyboardManagerSwift'
  pod 'KeychainAccess'
  pod 'RxSwiftExt', '~> 5'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod "RxGesture"
  pod 'RxDataSources', '~> 4.0'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'Kingfisher'
  pod 'WebViewJavascriptBridge'
  pod 'R.swift'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'IQKeyboardManagerSwift'
  # Pods for Arum

  target 'ArumTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ArumUITests' do
    # Pods for testing
  end

end
