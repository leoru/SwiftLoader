Pod::Spec.new do |s|
  s.name             = "SwiftLoader"
  s.version          = "1.1.0"
  s.summary          = "A simple and beautiful activity indicator"
  s.description      = <<-DESC
  SwiftLoader is a simple and beautiful activity indicator written in Swift.
                       DESC
  s.homepage         = "https://github.com/leoru/SwiftLoader"
  s.screenshots      = "https://raw.githubusercontent.com/leoru/SwiftLoader/master/images/loadergif.gif"
  s.license          = 'MIT'
  s.author           = { "Kirill Kunst" => "kirillkunst@gmail.com" }
  s.source           = { :git => "https://github.com/leoru/SwiftLoader.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kirill_kunst'
  s.swift_version    = '5.0'
  s.platform         = :ios, '13.0'
  s.requires_arc     = true
  s.source_files     = 'Sources/SwiftLoader/SwiftLoader'
  s.frameworks       = 'UIKit'
end
