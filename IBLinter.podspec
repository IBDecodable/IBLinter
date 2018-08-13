Pod::Spec.new do |s|
  s.name           = 'IBLinter'
  s.version        = '0.4.2'
  s.summary        = 'A linter tool for Interface Builder.'
  s.homepage       = 'https://github.com/IBDecodable/IBLinter'
  s.license        = { :type => 'MIT', :file => 'LICENSE' }
  s.author         = { 'Yuta Saito' => 'kateinoigakukun@gmail.com' }
  s.source         = { :http => "#{s.homepage}/releases/download/#{s.version}/portable_iblinter.zip" }
  s.preserve_paths = '*'
end
