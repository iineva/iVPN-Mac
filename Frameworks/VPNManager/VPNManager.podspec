Pod::Spec.new do |s|

  s.name = 'VPNManager'
  s.version = '0.1'
  s.license  = { :type => 'MIT' }
  s.summary  = 'VPN.'
  s.homepage = 'http://blog.isteven.cn'
  s.authors  = { 'Steven' => 'qzs21@qq.com' }
  #s.source   = '/Users/steven/Documents/projects/iVPN-Mac/Frameworks/VPNManager'
  s.source = './'
  s.source_files = '*.{h,m}'
  s.requires_arc = true
  #s.osx.deployment_target = "10.10"
  #s.ios.deployment_target = '8.0'

end