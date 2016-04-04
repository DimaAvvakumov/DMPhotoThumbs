Pod::Spec.new do |s|

  s.name         = "DMPhotoThumbs"
  s.version      = "0.0.10"
  s.summary      = "Custom photo thumbs collection for ios."
  s.homepage     = "https://github.com/DimaAvvakumov/DMPhotoThumbs"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Dmitry Avvakumov" => "avvakumov@it-baker.ru" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/DimaAvvakumov/DMPhotoThumbs.git", :tag => "0.0.10" }
  s.source_files = "DMPhotoThumbs", "DMPhotoThumbs/*.{h,m}", "DMPhotoThumbs/collectionView/*.{h,m}"
  s.public_header_files = "DMPhotoThumbs/*.{h,m}"
  s.framework    = "UIKit"
  s.requires_arc = true
  s.resources    = 'DMPhotoThumbs/collectionView/DMPhotoThumbsPhotoCell.xib', 'DMPhotoThumbs/collectionView/DMPhotoThumbsVizorCell.xib'

end
