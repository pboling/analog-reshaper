source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'analog', require: 'scale'
gem 'awesome_print'
gem 'colorize'

group :test do
  gem 'byebug', '~> 10', platform: :mri, require: false
  gem 'pry', '~> 0', platform: :mri, require: false
  gem 'pry-byebug', '~> 3', platform: :mri, require: false
  gem 'rspec-pending_for', '~> 0.1', require: false
  gem 'rubocop', '~> 0.60.0'
  gem 'rubocop-rspec', '~> 1.24.0'
  gem 'simplecov', '~> 0', require: false
end

# Specify your gem's dependencies in analog-reshaper.gemspec
gemspec
