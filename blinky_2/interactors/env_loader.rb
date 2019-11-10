require 'interactor'

module Blinky2

  module Interactors

    # This interactor is used solely to ensure that the
    # BLINKY2_TICKETS, BLINKY2_USERS and BLINKY2_ORGANISATIONS
    # environment variables exist, are strings and are readable files.
    class EnvLoader
      include Interactor

      # rubocop:disable Metrics/LineLength
      EXPECTED_VAR_NAMES = %w[BLINKY2_TICKETS BLINKY2_USERS BLINKY2_ORGANISATIONS].freeze

      MESSAGES = {
        not_present:  'is not present',
        not_usable:   'is not a usable string',
        not_readable: 'does not name a readable file'
      }.freeze

      def call
        EXPECTED_VAR_NAMES.each(&method(:validate_environment_variable))
        context.tickets_file       = ENV['BLINKY2_TICKETS']
        context.users_file         = ENV['BLINKY2_USERS']
        context.organisations_file = ENV['BLINKY2_ORGANISATIONS']
      end

      private

      def validate_environment_variable(env_var)
        file_name = ENV[env_var]
        variable_must_exist env_var, file_name
        filename_must_be_usable env_var, file_name
        file_must_be_readable env_var, file_name
      end

      def variable_must_exist(env_var, value)
        fail_with_msg env_var, :not_present unless value
      end

      def filename_must_be_usable(env_var, file_name)
        fail_with_msg env_var, :not_usable unless file_name.is_a?(String)
        # noinspection RubyNilAnalysis
        fail_with_msg env_var, :not_usable if file_name.strip.empty?
      end

      def file_must_be_readable(env_var, file_name)
        fail_with_msg env_var, :not_readable unless File.exist? file_name
        fail_with_msg env_var, :not_readable unless File.file? file_name
        fail_with_msg env_var, :not_readable unless File.readable? file_name
      end

      def fail_with_msg(env_var, msg)
        context.error = "The #{env_var} environment variable #{MESSAGES[msg]}"
        context.fail!
      end

    end
  end
end
