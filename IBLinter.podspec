Pod::Spec.new do |s|
  s.name           = 'IBLinter'
  s.version        = '0.3.0'
  s.summary        = 'A linter tool for Interface Builder.'
  s.homepage       = 'https://github.com/IBDecodable/IBLinter'
  s.license        = { :type => 'MIT', :file => 'LICENSE' }
  s.author         = { 'Yuta Saito' => 'kateinoigakukun@gmail.com' }
  s.source         = { :git => "https://github.com/IBDecodable/IBLinter.git", :tag => s.version }
  s.preserve_paths = 'bin/*'
end
