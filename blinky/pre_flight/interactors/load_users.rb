# frozen_string_literal: true

module Blinky
  module PreFlight
    module Interactors
      # At this point, the context should hold the file names
      # and those files should be validated as existing, readable
      # and match the generic JSON schema regex.
      # So, now we attempt to load the users file
      class LoadUsers
        include Interactor
        include Utils

        def call
          # Suppress those annoying twiddles for the file name
          # noinspection RubyResolve
          load_and_validate(context.users_file)
        end

        private

        def load_and_validate(file_name)
          # Suppress the fact that the file_name is implicit as it's been validated earlier.
          # noinspection RubyResolve
          json = MultiJson.load(IO.read(file_name), symbolize_keys: true)
          json.each do |row|
            valid_row = Models::User.new(row)
          end
        rescue MultiJson::ParseError => e
          fail_with_msg('TICKETS', :env_var_invalid_json, file_name, e.message)
        end

      end
    end
  end
end
