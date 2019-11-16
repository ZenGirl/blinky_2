# frozen_string_literal: true

module Blinky
  module PreFlight
    module Interactors
      # Ensures that the files provide are actually JSON
      class ValidJsonFiles
        include Interactor
        include Utils

        def call
          # noinspection RubyResolve
          [context.tickets_file, context.users_file, context.organizations_file].each do |file_name|
            must_not_be_too_big(file_name)
            json_string = load_file(file_name)
            must_match_regex(file_name, json_string)
          end
        end

        private

        def must_not_be_too_big(file_name)
          max_file_size = Blinky::Constants::MAX_FILE_SIZE
          return true if File.size(file_name) <= max_file_size

          fail_with_msg('', :env_var_file_too_big, file_name, '')
        end

        def load_file(file_name)
          result = ''
          begin
            result = IO.read(file_name, mode: 'r')
          rescue IOError => e
            fail_with_msg('', :env_var_file_error, file_name, e)
          rescue StandardError => e
            fail_with_msg('', :env_var_file_error, file_name, e)
          end
          result.strip!
          fail_with_msg('', :env_var_invalid_json, file_name, '') if result.length <= 0
          fail_with_msg('', :env_var_non_utf8, file_name, '') if result.encoding.name != 'UTF-8'

          result
        end

        # For reference, this is modified from:
        # https://stackoverflow.com/questions/2583472/regex-to-validate-json
        # rubocop:disable Layout/SpaceInsideBlockBraces, Style/SymbolProc
        def must_match_regex(file_name, str)
          match_json = str.gsub(/^#{str.scan(/^(?!\n)\s*/).min_by {|l| l.length}}/u, '')
          result     = match_json.match(Blinky::Constants::JSON_REGEX)
          return true unless result.nil?

          fail_with_msg('', :env_var_invalid_json, file_name, '')
        end
        # rubocop:enable Layout/SpaceInsideBlockBraces, Style/SymbolProc
      end
    end
  end
end
