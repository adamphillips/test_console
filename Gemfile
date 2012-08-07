source "http://rubygems.org"

# Declare your gem's dependencies in test_console.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'ruby-debug'
gem 'rails'
gem 'hirb'

group :ci do
  gem 'sqlite3'
  gem 'test-unit', '1.2.3'
  gem 'shoulda', :require => 'shoulda'
  gem 'mocha', '0.11.4', :require => 'mocha'
  gem 'fakefs', :require => "fakefs/safe"
end

group :development, :test do
  gem 'rdoc'
  gem 'test-unit', '1.2.3'
  gem 'shoulda'
  gem 'mocha', '0.11.4'
  gem 'fakefs', :require => "fakefs/safe"
end
