# frozen_string_literal: true

module Blinky
  module PreFlight
    module Interactors
      # Ensures that the files provide are actually JSON
      class ValidJsonFiles
        include Interactor

        def call
          # noinspection RubyResolve
          [context.tickets_file, context.users_file, context.organisations_file].each do |file_name|
            must_not_be_too_big(file_name)
            json_string = load_file(file_name)
            must_match_regex(file_name, json_string)
          end
        end

        private

        # This class is a private exception class
        class InvalidJson < StandardError
          def initialize(msg)
            super
          end
        end

        def must_not_be_too_big(file_name)
          max_file_size = Blinky::Constants::MAX_FILE_SIZE
          return true if File.size(file_name) <= max_file_size

          context.error = "The #{file_name} should be less than #{max_file_size}"
          context.fail!
        end

        def load_file(file_name)
          result = IO.read(file_name, mode: 'r')
          result.strip!
          raise InvalidJson, error_message(:invalid_json) if result.length <= 0
          raise InvalidJson, error_message(:non_utf8) if result.encoding.name != 'UTF-8'

          result
        rescue IOError => e
          fail_with_exp(file_name, :file_error, e)
        rescue StandardError => e
          fail_with_exp(file_name, :file_error, e)
        end

        # For reference, this is modified from:
        # https://stackoverflow.com/questions/2583472/regex-to-validate-json
        # rubocop:disable Layout/SpaceInsideBlockBraces, Style/SymbolProc
        def must_match_regex(file_name, str)
          match_json = str.gsub(/^#{str.scan(/^(?!\n)\s*/).min_by {|l| l.length}}/u, '')
          result     = match_json.match(Blinky::Constants::JSON_REGEX)
          return true unless result.nil?

          context.error = "The file #{file_name} #{error_message(:invalid_json)}"
          context.fail!
        end
        # rubocop:enable Layout/SpaceInsideBlockBraces, Style/SymbolProc

        def error_message(sym)
          Blinky::Constants::MESSAGES[sym]
        end

        def fail_with_exp(file_name, sym, exp)
          context.error = "Reading the #{file_name} #{error_message(sym)}#{exp.message}"
          context.fail!
        end
      end
    end
  end
end
