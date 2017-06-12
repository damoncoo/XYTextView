Pod::Spec.new do |s|
s.name = 'XYTextView'
s.version = '0.1.1'
s.license = 'MIT'
s.summary = 'an subclass of UITextView,allows to set Place Holder like Text Field,and also can be dynamic frame '
s.homepage = 'https://coding.net/u/damoncoo/p/XYTextView/git'
s.authors = { 'Damon' => 'damoncoo@gmail.com' }
s.source = { :git => 'https://git.coding.net/damoncoo/XYTextView.git', :tag => "0.1.1" }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'XYTextView.{h,m}'
s.resources = 'LICENSE'
end
