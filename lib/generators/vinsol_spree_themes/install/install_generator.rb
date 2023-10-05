module VinsolSpreeThemes
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, type: :boolean, default: false

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/spree_themes\n"
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/spree_themes\n"
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/spree_themes\n", before: /\*\//, verbose: true
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/spree_themes\n", before: /\*\//, verbose: true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=vinsol_spree_themes'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

      # def load_default_theme
      #   puts 'Loading and applying default spree theme...'

      #   filepath = "#{ ::VinsolSpreeThemes::Engine.root }/lib/generators/themes/default.zip"

      #   # creating theme object.
      #   theme = Spree::Theme.new(state: 'drafted', name: 'default')
      #   theme.template_file.attach(io: File.open(filepath), filename: 'default.zip')
      #   theme.save(validate: false)

      #   # extracting the zip file.
      #   ZipFileExtractor.new(filepath, theme)

      #   # publishing theme.
      #   theme.compile
      #   theme.publish
      # end
    end
  end
end
