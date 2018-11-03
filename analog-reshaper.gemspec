lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'analog/reshaper/version'

Gem::Specification.new do |spec|
  spec.name          = 'analog-reshaper'
  spec.version       = Analog::Reshaper::VERSION
  spec.authors       = ['Peter Boling']
  spec.email         = ['peter.boling@gmail.com']

  spec.summary       = 'analog (gem) plugin allowing non-linear reshape of numbers'
  spec.description   = 'analog (gem) plugin: non-linear reshaping of numbers according to configured ranges'
  spec.homepage      = 'https://github.com/pboling/analog-reshaper'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'hashie', '~> 3.6'
  spec.add_runtime_dependency 'memoist', '~> 0.15'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'colorize'
  spec.add_development_dependency 'rake', ['>= 10.0', '<= 13']
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rspec-block_is_expected', '~> 1.0'
  spec.add_development_dependency 'rspec-pending_for', '~> 0.1'
  spec.add_development_dependency 'wwtd'
end
