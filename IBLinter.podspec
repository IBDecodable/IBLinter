Pod::Spec.new do |s|
  s.name           = 'IBLinter'
  s.version        = '4.26'
  s.summary        = 'A linter tool for Interface Builder.'
  s.homepage       = 'https://github.com/mfernandez94/IBLinter'
  s.license        = { :type => 'MIT', :file => 'LICENSE' }
  s.author         = { 'Yuta Saito' => 'kateinoigakukun@gmail.com' }
  s.source         = { :git => "https://github.com/mfernandez94/IBLinter.git", :tag => s.version}
  s.preserve_paths = '*'
end
