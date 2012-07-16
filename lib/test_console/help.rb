module TestConsole
  module Help
    include TestConsole::Colors
    include TestConsole::Config

    # Help text
    # =========

    def help
    "
    #{color('Test Console help', :bold)}
    =================

    #{color('Run Commands', :bold)} : #{color(run_commands.join(', '), :bold)}
    To run a test, type 'run' followed by the path to the test
    You can also append a string or regex to filter by

    Examples:
      run functional/
      run functional/application_controller_test.rb
      run functional/application_controller_test.rb 'PartOfTestName'
      run functional/application_controller_test.rb /PartOfTestName/i

    #{color('Rerun Commands', :bold)} : #{color(rerun_commands.join(', '), :bold)}
    Reruns only the tests that failed or errored in the previous run

    #{color('Quit Commands', :bold)} : #{color(quit_commands.join(', '), :bold)}
    Exits the console
    "
    end
  end
end
