# frozen_string_literal: true

module Blinky
  module PreFlight
    module Interactors
      # Ensures all environment variables are meaningful
      # This interactor is used solely to ensure that the
      # TICKETS, USERS and ORGANIZATIONS
      # environment variables exist and are non-zero non-blank length strings.
      class ValidEnvVariables
        include Interactor
        include Utils

        # Sigh. Just to get rid of those annoying twiddles for the context vars
        # noinspection RubyResolve
        def call
          context.tickets_file       = validate_env_var('TICKETS')
          context.users_file         = validate_env_var('USERS')
          context.organizations_file = validate_env_var('ORGANIZATIONS')
        end

        private

        def validate_env_var(env_var)
          result_var = ENV[env_var]
          fail_with_msg(env_var, :env_var_not_present, ' environment variable', '') if result_var.nil?
          # ENV will always be a string if present
          result_var = ('' + result_var).strip
          fail_with_msg(env_var, :env_var_is_blank, ' environment variable', '') if result_var.size <= 0
          result_var
        end
      end
    end
  end
end
