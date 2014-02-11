#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "TAITestURLProtocol"
  s.version          = "0.1.0"
  s.summary          = "A modernized fork of ILCannedURLProtocol by Claus Broch of Infinite Loop."
  s.license          = 'BSD'
  s.author           = { "Jarkko Laiho" => "jarkko@taiste.fi" }
  s.source           = { :git => "https://github.com/taiste/TAITestURLProtocol.git", :tag => s.version.to_s }
  s.source_files     = 'TAITestURLProtocol/*.{h,m}'
  s.homepage         = 'https://github.com/taiste/TAITestURLProtocol'
  s.requires_arc     = true
end
