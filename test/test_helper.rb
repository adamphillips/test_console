# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

$:.unshift File.dirname(__FILE__)

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rails/test_help'
require 'test/unit'

require 'shoulda'
require 'mocha'

Rails.backtrace_cleaner.remove_silencers!

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
