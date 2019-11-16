# frozen_string_literal: true

module Blinky
  module PreFlight
    module Interactors
      # Ensures that all the file names provide exist and are readable.
      class ValidReadableFiles
        include Interactor
        include Utils

        # Just to get rid of those annoying twiddles for the context vars
        # noinspection RubyResolve
        def call
          name_must_be_a_readable_file 'TICKETS', context.tickets_file
          name_must_be_a_readable_file 'USERS', context.users_file
          name_must_be_a_readable_file 'ORGANIZATIONS', context.organizations_file
        end

        private

        def name_must_be_a_readable_file(env_var, name)
          must_exist(env_var, name)
          must_be_a_file(env_var, name)
          must_be_readable(env_var, name)
        end

        def env_var_msg(name)
          " environment variable #{name}"
        end

        def must_exist(env_var, name)
          fail_with_msg(env_var, :env_var_file_not_found, env_var_msg(name), '') unless File.exist? name
        end

        def must_be_a_file(env_var, name)
          fail_with_msg(env_var, :env_var_file_not_readable, env_var_msg(name), '') unless File.file? name
        end

        def must_be_readable(env_var, name)
          fail_with_msg(env_var, :env_var_file_not_readable, env_var_msg(name), '') unless File.readable? name
        end
      end
    end
  end
end
