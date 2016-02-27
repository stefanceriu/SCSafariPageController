Pod::Spec.new do |s|
  s.name     = 'SCSafariPageController'
  s.version  = '1.0.2'
  s.platform = :ios
  s.ios.deployment_target = '8.0'

  s.summary  = 'SCSafariPageController page view controller component that reproduces the behavior seen in Mobile Safari\'s tab switcher'
  s.description = <<-DESC
                  SCSafariPageController page view controller component that reproduces the behavior seen in Mobile Safari\'s tab switcher
                  Features:
                  - can zoom out, partially overlap and lean in pages similar to Safari
                  - allows swipe to delete for one or multiple pages at the same time
                  - increases the page angles when scrolling outside its bounds
                  - can zoom into any of the pages 
                  - supports incremental updates
                  and all the rest of the SCPageViewController niceties.
                  DESC
  s.homepage = 'https://github.com/stefanceriu/SCSafariPageController'
  s.author = { 'Stefan Ceriu' => 'stefan.ceriu@yahoo.com' }
  s.social_media_url = 'https://twitter.com/stefanceriu'
  s.source = { :git => 'https://github.com/stefanceriu/SCSafariPageController.git', :tag => "v#{s.version}" }
  s.license = { :type => 'MIT License', :file => 'LICENSE' }
  s.source_files  = 'SCSafariPageController/**/*.{h,m}'
  s.resources  = 'SCSafariPageController/**/*.xib'

  s.dependency 'SCPageViewController'

end