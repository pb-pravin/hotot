require File.expand_path('../lib/hotot/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'hotot'
  s.version     = Hotot::VERSION
  s.date        = '2014-04-22'
  s.summary     = "A bunny wrapper."
  s.description = <<-DESC
    Hotot is a kind of rabbit that wraps bunny gem.
  DESC
  s.authors     = ["Qi He"]
  s.email       = 'qihe229@gmail.com'
  s.homepage    = 'http://github.com/he9qi/hotot'
  s.license     = 'MIT'
  
  s.files         = Dir.glob('lib/**/*.rb')
  s.require_paths = ['lib']
  s.test_files    = Dir.glob('spec/**/*.rb')
  
  s.add_runtime_dependency "bunny", ["~>1.2"]
end