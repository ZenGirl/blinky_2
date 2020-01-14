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

        def call
          context.data = {
            tickets:       {
              env:  'TICKETS',
              file: validate_env_var('TICKETS')
            },
            users:         {
              env:  'USERS',
              file: validate_env_var('USERS')
            },
            organizations: {
              env:  'ORGANIZATIONS',
              file: validate_env_var('ORGANIZATIONS')
            }
          }
        end

        private

        def validate_env_var(env_var)
          result_var = ENV[env_var]
          context.fail!(message: "#{env_var} #{err(:env_var_not_present)}") if result_var.nil?
          result_var = ('' + result_var).strip
          context.fail!(message: "#{env_var} #{err(:env_var_is_blank)}") if result_var.size <= 0
          result_var
        end
      end
    end
  end
end
