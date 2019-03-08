$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'py3o_fusion'
  s.version     = '1.0.0'
  s.date        = '2019-03-08'
  s.summary     = 'Generate PDF from ODF via Py3o.Fusion'
  s.authors     = ['Olle Wreede']
  s.email       = 'olle@wreede.se'
  s.files       = Dir['{lib}/**/*']
  s.homepage    =
    'https://github.com/ollej/py3o_fusion'
  s.license     = 'MIT'

  s.add_dependency 'httparty', '~> 0.16.4'

  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'rake', '~> 11.2'
end
