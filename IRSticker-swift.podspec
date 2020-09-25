Pod::Spec.new do |spec|
  spec.name         = "IRSticker-swift"
  spec.version      = "0.1.0"
  spec.summary      = "A powerful sticker of iOS."
  spec.description  = "A powerful sticker of iOS."
  spec.homepage     = "https://github.com/irons163/IRSticker-swift.git"
  spec.license      = "MIT"
  spec.author       = "irons163"
  spec.platform     = :ios, "11.0"
  spec.swift_version= "5"
  spec.source       = { :git => "https://github.com/irons163/IRSticker-swift.git", :tag => spec.version.to_s }
  spec.source_files  = "IRSticker-swift/**/*.swift"
  spec.resources = ["IRSticker-swift/**/IRSticker.bundle"]
end