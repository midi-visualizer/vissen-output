lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vissen/output/version'

Gem::Specification.new do |spec|
  spec.name          = 'vissen-output'
  spec.version       = Vissen::Output::VERSION
  spec.authors       = ['Sebastian Lindberg']
  spec.email         = ['seb.lindberg@gmail.com']

  spec.summary       = 'The output interface of the vissen system.'
  spec.description   = 'The output module implements all the objects and ' \
                       'facilities used to talk to vissen sinks.'
  spec.homepage      = 'https://github.com/midi-visualizer/vissen-output'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'color', '~> 1.8'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'simplecov', '~> 0.16'
end
