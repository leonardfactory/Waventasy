# Uncomment the next line to define a global platform for your project
platform :osx, '10.12'

target 'Waventasy' do
  use_frameworks!
  
  pod 'AudioKit', '~> 4.0'
  pod 'SwiftGraph'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = [
        '$(FRAMEWORK_SEARCH_PATHS)'
        ]
    end
end
