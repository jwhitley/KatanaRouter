Pod::Spec.new do |s|
  s.name             = "KatanaRouter"
  s.version          = "0.5"
  s.summary          = "App Routing for Katana"
  s.description      = <<-DESC
						  Declarative and type-safe routing for Katana.
                        DESC
  s.homepage         = "https://github.com/michalciurus/KatanaRouter"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Michal Ciurus" => "michael.ciurus@gmail.com" }
  s.social_media_url = "https://twitter.com/MichaelCiurus"
  s.source           = { :git => "https://github.com/michalciurus/KatanaRouter.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.3'
  s.osx.deployment_target = '10.10'
  s.requires_arc = true
  s.source_files     = 'KatanaRouter/**/*.swift'

  s.subspec "Core" do |core|
    core.source_files = 'KatanaRouter'
    core.frameworks = "Foundation"
  end

  s.subspec "ReactiveReSwift" do |rere|
    rere.source_files = 'KatanaRouter/ReactiveReSwift'
    rere.frameworks = "Foundation"
    rere.dependency 'KatanaRouter/Core'
    rere.dependency 'ReactiveReSwift', '~> 3.0.6'
    rere.dependency 'RxSwift',         '~> 3.6.1'
  end

  s.default_subspec = "Core"
end
