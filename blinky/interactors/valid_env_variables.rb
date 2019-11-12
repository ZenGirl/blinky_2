module Blinky

  module Interactors

    # Ensures all environment variables are meaningful
    # This interactor is used solely to ensure that the
    # BLINKY_TICKETS, BLINKY_USERS and BLINKY_ORGANISATIONS
    # environment variables exist and are non-zero non-blank length strings.
    class ValidEnvVariables
      include Interactor

      def call
        context.tickets_file       = validate_env_var('TICKETS')
        context.users_file         = validate_env_var('USERS')
        context.organisations_file = validate_env_var('ORGANISATIONS')
      end

      private

      def validate_env_var(env_var)
        result_var = ENV[env_var]
        fail_with_msg env_var, :not_present if result_var.nil?
        # ENV will always be a string if present
        result_var = result_var.strip
        fail_with_msg env_var, :not_usable if result_var.size <= 0
        result_var
      end

      def fail_with_msg(env_var, msg)
        context.error = "The #{env_var} #{Blinky::Constants::MESSAGES[msg]}"
        context.fail!
      end

    end

  end

end
