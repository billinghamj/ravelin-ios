Pod::Spec.new do |s|
	s.name = 'Ravelin'
	s.version = '0.1.1'
	s.summary = 'Client-side Obj-C library for the Ravelin API. Ravelin is a fraud detection tool.'
	s.homepage = 'https://github.com/billinghamj/ravelin-ios'

	s.license = { type: 'MIT', file: 'LICENSE' }
	s.author = { 'James Billingham' => 'james@jamesbillingham.com' }
	s.source = { git: 'https://github.com/billinghamj/ravelin-ios.git', tag: "v#{s.version}" }

	s.ios.deployment_target = '7.0'

	s.source_files = 'Ravelin/**/*.{m,h}'
	s.public_header_files = 'Ravelin/**/*.h'
end
