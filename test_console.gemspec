$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "test_console/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "test_console"
  s.version     = TestConsole::VERSION
  s.authors     = ["Adam Phillips"]
  s.email       = ["adam@indivisible.org.uk"]
  s.homepage    = "https://github.com/adamphillips/test_console"
  s.summary     = "Console for testing Ruby on Rails applications."
  s.description = "Console for testing Rails applications with TestUnit."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_dependency "rails", ">= 3.0"
  if RUBY_VERSION >= '1.9'
    s.add_dependency "test-unit", "1.2.3"
  end
  s.add_dependency "hirb"

  s.add_development_dependency "rdoc"
  s.add_development_dependency "mocha"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "sqlite3"
  if RUBY_VERSION < '1.9'
    s.add_development_dependency "ruby-debug"
  else
    s.add_development_dependency "ruby-debug19"
  end
end
