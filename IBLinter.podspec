Pod::Spec.new do |s|
  s.name           = 'IBLinter'
  s.version        = '0.2.0'
  s.summary        = 'A linter tool for Interface Builder.'
  s.homepage       = 'https://github.com/kateinoigakukun/IBLinter'
  s.license        = { :type => 'MIT', :file => 'LICENSE' }
  s.author         = { 'Yuta Saito' => 'kateinoigakukun@gmail.com' }
  s.source         = { :git => "https://github.com/kateinoigakukun/IBLinter.git", :tag => s.version }
  s.source_files   = 'bin/*'
end
