# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

workspace 'Vimeo'
project 'Vimeo.xcodeproj'

target 'Vimeo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Vimeo
  pod 'VimeoNetworking', :path => 'Submodules/VimeoNetworking'
  pod 'VimeoUpload', :path => 'Submodules/VimeoUpload'

  pod 'BMPlayer', '~> 0.9.1'
  pod 'YTVimeoExtractor'
  pod 'Alamofire'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
