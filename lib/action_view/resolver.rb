# In order to be able to run our tests with cache_classes enabled, we need to be able to control when our views are reloaded.
# Otherwise view changes won't take effect in our console
# This sets ActionView to use our custom test when checking whether to cache view templates meaning that we can use this function to expire the view cache as necessary.
module ActionView
  class Resolver

    # Wether to cache view templates
    def caching?
      @caching = TestConsole.views_changed?
    end
  end
end
