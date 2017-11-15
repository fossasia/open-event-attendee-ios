platform :ios, '8.0'
use_frameworks!

target 'FOSSAsia' do
    
pod 'Pages'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'DateTools', :git => 'https://github.com/MatthewYork/DateTools.git'
pod 'MGSwipeTableCell', :git => 'https://github.com/MortimerGoro/MGSwipeTableCell.git'
pod 'DZNEmptyDataSet', :git => 'https://github.com/dzenbot/DZNEmptyDataSet.git'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end

end

