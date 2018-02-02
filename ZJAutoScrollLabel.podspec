Pod::Spec.new do |s|
s.name         = "ZJAutoScrollLabel"
s.version      = "0.0.1"
s.summary      = " A view which can scroll with texts"
s.description  = <<-DESC
A view which can scroll with texts swift
DESC

s.homepage     = "https://github.com/yoimhere/ZJAutoScrollLabel"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "yoimhere" => "yoimhere@163.com" }

s.ios.deployment_target = '8.0'
s.source         = { :git => "https://github.com/yoimhere/ZJAutoScrollLabel.git", :tag =>s.version.to_s}
s.source_files   = "ZJAutoScrollLabel/Classes/*.swift"
end
