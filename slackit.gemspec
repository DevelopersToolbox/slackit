lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slackit/version'

Gem::Specification.new do |spec|
    spec.name          = 'slackit'
    spec.version       = Slackit::VERSION
    spec.authors       = ['Tim Gurney aka Wolf']
    spec.email         = ['wolf@tgwolf.com']

    spec.summary       = 'A simple gem for posting to a slack incoming webhook.'
    spec.description   = 'A simple gem for posting raw messages to a slack incoming webhook.'
    spec.homepage      = 'https://github.com/DevelopersToolbox/slackit'
    spec.license       = 'MIT'

    spec.files         = `git ls-files`.split($/)

    spec.bindir        = 'exe'
    spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
    spec.require_paths = ['lib']

    spec.required_ruby_version = '>= 2.5'

    spec.add_development_dependency 'bundler', '~> 2'
    spec.add_development_dependency 'cmessages', '~> 1.0.0'
    spec.add_development_dependency 'json', '~> 2'
#    spec.add_development_dependency 'net-http', '~> 0.1.0'
    spec.add_development_dependency 'rake', '~> 12.3.3'
    spec.add_development_dependency 'rspec', '~> 3.0'
    spec.add_development_dependency 'uri', '~> 0.10.0'

    spec.add_runtime_dependency 'cmessages', '~> 1.0.0'
#    spec.add_runtime_dependency 'net-http', '~> 0.1.0'
    spec.add_runtime_dependency 'json', '~> 2'
    spec.add_runtime_dependency 'uri', '~> 0.10.0'
end
