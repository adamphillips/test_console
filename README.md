## Test Console

Interactive console for running TestUnit tests against a Rails application.

Its main purpose is to avoid having to reload the complete Rails environment between test runs in order to speed up TDD.

Please note : This console was written specifically to aid with testing a specific application and so has only been tested in a small number of environments.  Please report any issues via the [Github issues](https://github.com/adamphillips/test_console/issues) page. 

### Features

* Preloads Rails environment.
* Configurable watch folders.  Files in these folders will be reloaded between if they are modfied.
* Configurable stop folders.  Changes to files in these folders mean that a full reload is neccessary.  See limitations at the end of the page for more details.
* Autocomplete test paths.
* Filter test runs across multiple files using a string or regex.


### Installing the console

To install, add the test console to your Gemfile
```ruby
gem 'test_console'
```

You may just want to put it in the development group
```ruby
group :development do
  gem 'test_console'
end
```

Then bundle install
```console
> bundle install
```

### Using the console

To start the console, cd into your tests folder and type
```console
> test_console
```

To run a test type
```console
> run path/to/test.rb
```

  or for a folder of tests
```console
> run folder/to/test
```

You can also just use the shortcut r
```console
> r folder/to/test
```

You can filter a test run by parsing either a string or regex as the second parameter
```console
> r folder/to/test some_tests
> r folder/to/test /some_tests/
```

To rerun only tests that failed or errored on the previous run use the rerun command
```console
> rerun
# or alternatively
> .
```

To quit the console type quit
```console
> quit
```

Any other commands are run as Ruby commands in your test environment and the returned value output
```console
> 5 + 5
=> 10
```

### Configuring the console

The console has a number of configurable options such as the colours used, the folders to watch for changes and the command shortcuts.  To set these options add the following to your test/test_helper.rb

```ruby
TestConsole.setup do |config|
  config.watch_folders << 'app/something'
  config.success_color = :blue
end
```
For a full list of configurable options and their defaults please refer to the source of [lib/test_console/config.rb](https://github.com/adamphillips/test_console/blob/master/lib/test_console/config.rb).


### Dependencies

The only dependency is [Hirb](https://github.com/cldwalker/hirb) for formatting the output data.

### Limitations

Currently it is not possible for the test console to reload certain types of changes.  For example changes to fixtures or rails application config files will require the console to be restarted in order for the changes to take effect.
Whilst we aim to get rid of these limitations eventually, for the time being these folders are also monitored for changes and if a change is found that requires a restart, the console will display a message and not run any further tests in order to avoid unusual behaviour or incorrect test results.