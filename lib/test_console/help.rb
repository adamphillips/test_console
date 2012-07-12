module TestConsole
  module Help
    # Help text
    # =========

    def help
    "
    Test console help
    =================
    Run Commands : #{RUN_COMMANDS.join(', ')}

    To run a test, type 'run' followed by the path to the test
    You can also append a string or regex to filter by

    Examples:
      run functional/mgm
      run functional/application_controller_test.rb
      run functional/application_controller_test.rb 'PartOfTestName'
      run functional/application_controller_test.rb /PartOfTestName/i

    Rerun Commands : #{RERUN_COMMANDS.join(', ')}

    Reruns only the tests that failed or errored in the previous run

    Quit Commands : #{QUIT_COMMANDS.join(', ')}

    Exits the console
    "
    end
  end
end
