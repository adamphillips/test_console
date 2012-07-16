## Test Console

Interactive console for running TestUnit tests against a Rails application.

Please note : This console was written specifically to aid with testing a specific application and so has only been tested in a small number of environments.  Please report any issues via the [Github issues](https://github.com/adamphillips/test_console/issues) page.

### Installing the console

To install, add the test console to your Gemfile

```gem 'test_console'
```

You may just want to put it in the development group

```group :development
```

Then bundle install

```> bundle install
```

### Using the console

To start the console, cd into your tests folder and type

```> test_console
```

To run a test type

```> run path/to/test.rb
```

  or for a folder of tests

```> run folder/to/test
```

You can also just use the shortcut r
```> r folder/to/test
```


To rerun only tests that failed or errored on the previous run use the rerun command
```> rerun
# or alternatively
> .
```

To quit the console type quit
```> quit
```
