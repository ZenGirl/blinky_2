module Blinky
  module Interactors
    module PreFlight
      # Ensures that the files provide are actually JSON
      class ValidJsonFiles
        include Interactor

        def call
          must_not_be_too_big(context.tickets_file)
          json_string = load_file(context.tickets_file)
          must_match_regex(context.tickets_file, json_string)
          must_match_schema(json_string, Blinky::Constants::Schemas[:ticket])
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
          return true if File.size(file_name) < max_file_size

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
        def must_match_regex(file_name, str)
          match_json = str.gsub(/^#{str.scan(/^(?!\n)\s*/).min_by {|l| l.length}}/u, '')
          result     = match_json.match(Blinky::Constants::JSON_REGEX)
          return true unless result.nil?

          context.error = "The file #{file_name} #{error_message(:invalid_json)}"
          context.fail!
        end

        def must_match_schema(file_name, schema)

        end

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
