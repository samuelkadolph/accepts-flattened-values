Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'accepts-flattened-values'
  s.version     = '0.1.1'
  s.summary     = 'accepts-flattened-values is an ActiveRecord mixin to flatten a habtm assocation.'
  s.description = 'accepts-flattened-values is mixin for ActiveRecord that flattens single values from a ' +
                  'has_many or has_and_belongs_to_many assocation into a string and vice versa.'

  s.author   = 'Samuel Kadolph'
  s.email    = 'samuel@kadolph.com'
  s.homepage = 'http://wiki.github.com/samuelkadolph/accepts-flattened-values/'

  s.files        = Dir['CHANGELOG', 'README', 'LICENSE', 'lib/**/*']
  s.require_path = 'lib'

  s.has_rdoc         = true
  s.rdoc_options    << '--main' << 'README'
  s.extra_rdoc_files = ['CHANGELOG', 'README', 'LICENSE']

  s.add_dependency('activesupport', '>=3.0.0.beta4')
  s.add_dependency('activerecord',  '>=3.0.0.beta4')
end
