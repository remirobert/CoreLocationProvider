Pod::Spec.new do |s|
    s.name         = 'CoreLocationProvider'
    s.version      = '1.0.0'
    s.summary      = 'A centralized location update subscription for you app.'
    s.homepage = "https://github.com/remirobert/CoreLocationProvider"
    s.license      = 'MIT'
    s.author       = { 'Remi ROBERT' => 'remirobert33530@gmail.com' }
    s.source       = { :git => 'https://github.com/remirobert/CoreLocationProvider.git', :tag => s.version }

    s.source_files = 'CoreLocationProvider/**/*.{swift,h,m}'
    s.requires_arc = true

    s.ios.deployment_target = '10.0'
    s.ios.frameworks = 'CoreLocation'
end
