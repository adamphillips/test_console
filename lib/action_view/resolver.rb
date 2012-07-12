# This sets ActionView to use our custom test when checking whether to cache view templates
module ActionView
  class Resolver
    def caching?
      @caching = TestConsole.views_changed?
    end
  end
end
