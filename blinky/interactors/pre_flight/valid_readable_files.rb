module Blinky
  module Interactors
    module PreFlight
      # Ensures that all the file names provide exist and are readable.
      class ValidReadableFiles
        include Interactor

        # Just to get rid of those annoying twiddles for the context vars
        # noinspection RubyResolve
        def call
          name_must_be_a_readable_file 'TICKETS', context.tickets_file
          name_must_be_a_readable_file 'USERS', context.users_file
          name_must_be_a_readable_file 'ORGANISATIONS', context.organisations_file
        end

        private

        def name_must_be_a_readable_file(env_var, name)
          must_exist(env_var, name)
          must_be_a_file(env_var, name)
          must_be_readable(env_var, name)
        end

        def must_exist(env_var, name)
          fail_with_msg env_var, name, :not_found unless File.exist? name
        end

        def must_be_a_file(env_var, name)
          fail_with_msg env_var, name, :not_readable unless File.file? name
        end

        def must_be_readable(env_var, name)
          fail_with_msg env_var, name, :not_readable unless File.readable? name
        end

        def fail_with_msg(env_var, name, msg)
          context.error = "The #{env_var} environment variable file #{name} #{Blinky::Constants::MESSAGES[msg]}"
          context.fail!
        end
      end
    end
  end
end
