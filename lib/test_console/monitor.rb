module TestConsole
  # Monitoring functions
  # ====================
  # These are functions that check for changes whilst the console is open
  # and reload the files if possible
  module Monitor

    # Checks for changes to watched folders and reloads the files if necessary
    def auto_reload!
      # If nil, this means that this is the first run and nothing has changed since initialising the rails env
      @last_reload_time = Time.now and return if @last_reload_time.nil?

      TestConsole::Config.watch_paths.each do |p|
        watch_folder = File.join(Rails.root.to_s, p)
        Dir.glob(File.join('..', p, '**', '*.*rb')).each do |f|
          if File.mtime(f) > @last_reload_time
            abs_path = File.join(Dir.pwd, f)
            rel_path = f.gsub /#{Rails.root.to_s}/, ''
            rel_path = rel_path.gsub /\.\.\//, ''
            rel_path = rel_path.gsub /#{p}\//, ''
            TestConsole.out "Reloading #{rel_path}", :cyan
            klass = Utility.class_from_filename(rel_path)
            Utility.const_remove(klass) if Utility.const_defined?(klass)
            load abs_path
          end
        end
      end

      @last_reload_time = Time.now
    end

    # This monitors the stop folders for changes since the console was initialised
    def stop_folders_changed?
      # If nil, this means that this is the first run and nothing has changed since initialising the rails env
      return false if @last_init_time.nil?

      TestConsole::Config.stop_folders.each do |p|
        path = File.join(TestConsole::Config.app_root, p, '**', '*.{rb,yml}')
        Dir.glob(path).each do |f|
          if file_changed? f, @last_init_time
            TestConsole.error "#{f} has been changed.\nYou will need to restart the console to reload the environment"
            return true
          end
        end
      end

      return false

    end

    # Checks wether views have changed
    def views_changed?
      # If nil, this means that this is the first run and nothing has changed since initialising the rails env
      @last_run_time = Time.now and return false if @last_run_time.nil?
      return false if @checked_views

      TestConsole::Config.view_folders.each do |vf|
        watch_folder = File.join(TestConsole::Config.app_root, vf, '**', '*')
        Dir.glob(watch_folder).each do |f|
          if file_changed? f, @last_run_time
            @checked_views = true
            return true
          end
        end
      end

      @checked_views = true

      return false
    end

    # Checks to see if the specified file has changed since the specified time.
    def file_changed? path, time
      if File.exists? path
        return true if File.mtime(path) > time
      end

      false
    end

  end
end
