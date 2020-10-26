use_frameworks!

platform :ios, '13.0'

install! 'cocoapods', :deterministic_uuids => false

flutter_application_path = '../flutter_module'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'TensorFlowiOS' do
       pod 'shared', :path => '../TensorFlowMultiplatform/shared'
       pod 'TensorFlowLiteSwift', '~> 0.0.1-nightly', :subspecs => ['CoreML', 'Metal']
       pod 'SnapKit', '~> 5.0.1'
       pod 'RxSwift'
       pod 'RxCocoa'
       install_all_flutter_pods(flutter_application_path)
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if Gem::Version.new('8.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
      end
    end
  end
end
