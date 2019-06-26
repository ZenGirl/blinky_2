require 'interactor'

module Blinky2

  # This interactor is used solely to ensure that the
  # BLINKY2_TICKETS, BLINKY2_USERS and BLINKY2_ORGANISATIONS
  # environment variables exist, are strings and are readable files.
  class EnvLoader
    include Interactor

    EXPECTED_VAR_NAMES = %w[
      BLINKY2_TICKETS BLINKY2_USERS BLINKY2_ORGANISATIONS
    ].freeze

    MESSAGES = {
      not_present:  'is not present',
      not_usable:   'is not a usable string',
      not_readable: 'does not name a readable file'
    }.freeze

    def call
      EXPECTED_VAR_NAMES.each(&method(:validate_environment_variable))
    end

    private

    # @param [Object] env_var One of the EXPECTED_VAR_NAMES
    def validate_environment_variable(env_var)
      file_name = ENV[env_var]
      variable_must_exist env_var, file_name
      filename_must_be_usable env_var, file_name
      file_must_be_readable env_var, file_name
    end

    # The environment variable must be in the environment
    # @param [String] env_var Environment variable name e.g. BLINKY2_TICKETS
    # @param [String] value e.g. tickets.json
    def variable_must_exist(env_var, value)
      fail_with_msg env_var, :not_present unless value
    end

    # The file name must be usage - a string and not blank
    # @param [String] env_var Environment variable name e.g. BLINKY2_TICKETS
    # @param [String] file_name e.g. tickets.json
    def filename_must_be_usable(env_var, file_name)
      fail_with_msg env_var, :not_usable unless file_name.is_a?(String)
      # noinspection RubyNilAnalysis
      fail_with_msg env_var, :not_usable if file_name.strip.empty?
    end

    # The file name must exist, be a file and be readable.
    # @param [String] env_var Environment variable name e.g. BLINKY2_TICKETS
    # @param [String] file_name e.g. tickets.json
    def file_must_be_readable(env_var, file_name)
      fail_with_msg env_var, :not_readable unless File.exist? file_name
      fail_with_msg env_var, :not_readable unless File.file? file_name
      fail_with_msg env_var, :not_readable unless File.readable? file_name
    end

    # Fail fast!
    # @param [String] env_var Environment variable name e.g. BLINKY2_TICKETS
    # @param [String] msg One of the key symbols found in MESSAGE_STRINGS
    def fail_with_msg(env_var, msg)
      context.error = "The #{env_var} environment variable #{MESSAGES[msg]}"
      context.fail!
    end

  end
end
