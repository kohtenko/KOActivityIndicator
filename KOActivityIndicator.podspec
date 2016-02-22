
Pod::Spec.new do |s|

  s.name         = "KOActivityIndicator"
  s.version      = "0.0.2"
  s.summary      = "Easy styled, IBDesigneble and IBInspectable activity indicator on swift"

  s.description  = <<-DESC
                   A longer description of KOActivityIndicator in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/kohtenko/KOActivityIndicator"
  s.screenshots  = "https://raw.githubusercontent.com/kohtenko/KOActivityIndicator/master/example.gif"

  s.license      = "MIT"

  s.author             = { "kohtenko" => "kohtenko@gmail.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/kohtenko/KOActivityIndicator.git", :tag => "0.0.2" }


  s.requires_arc = true
  s.source_files  = "KOActivityIndicator", "*.swift"

end
