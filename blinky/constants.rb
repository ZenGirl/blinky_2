# frozen_string_literal: true

module Blinky
  module Constants
    ENV_VAR_NAMES = %w[TICKETS USERS ORGANIZATIONS].freeze

    # rubocop:disable Layout/AlignHash
    # Disabled because it shows irritating message which provides no perceivable benefit
    ERROR_MESSAGES = {
      env_var_not_present:        'is not present',
      env_var_is_blank:           'is blank',
      env_var_file_not_found:     'does not name an existing file',
      env_var_file_not_readable:  'does not name a readable file',
      env_var_file_error:         'file caused an exception: ',
      env_var_file_too_big:       'file is too big',
      env_var_invalid_json:       'is not valid json',
      env_var_non_utf8:           'has non UTF-8 chars',
      row_keys_must_match_schema: 'row does not match schema'
    }.freeze
    # rubocop:enable Layout/AlignHash

    # For reference, this is modified from:
    # https://stackoverflow.com/questions/2583472/regex-to-validate-json
    # rubocop:disable Style/MutableConstant, Style/RegexpLiteral
    JSON_REGEX = /(
         # define subtypes and build up the json syntax, BNF-grammar-style
         # The {0} is a hack to simply define them as named groups here but not match on them yet
         # I added some atomic grouping to prevent catastrophic backtracking on invalid inputs
         (?<number>  -?(?=[1-9]|0(?!\d))\d+(\.\d+)?([eE][+-]?\d+)?){0}
         (?<boolean> true | false | null ){0}
         (?<string>  " (?>[^"\\\\]* | \\\\ ["\\\\bfnrt\/] | \\\\ u [0-9a-f]{4} )* " ){0}
         (?<array>   \[ (?> \g<json> (?: , \g<json> )* )? \s* \] ){0}
         (?<pair>    \s* \g<string> \s* : \g<json> ){0}
         (?<object>  \{ (?> \g<pair> (?: , \g<pair> )* )? \s* \} ){0}
         (?<json>    \s* (?> \g<number> | \g<boolean> | \g<string> | \g<array> | \g<object> ) \s* ){0}
       )
    \A \g<json> \Z
    /uix
    # rubocop:enable Style/MutableConstant, Style/RegexpLiteral

    # Should be changeable via command line
    MAX_FILE_SIZE    = 200_000 # bytes
  end
end
