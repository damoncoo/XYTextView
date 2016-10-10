Pod::Spec.new do |s|
s.name = 'XYTextView'
s.version = '0.1'
s.license = 'MIT'
s.summary = 'an subclass of UITextView,allows to set Place Holder like Text Field,and also can be dynamic frame '
s.homepage = 'https://github.com/damoncoo/XYTextView'
s.authors = { 'Damon' => 'damoncoo@gmail.com' }
s.source = { :git => 'https://github.com/damoncoo/XYTextView.git', :tag => 0.1 }
s.requires_arc = true
s.ios.deployment_target = '7.0'
s.source_files = 'XYTextView.{h,m}'
s.resources = ''
end
