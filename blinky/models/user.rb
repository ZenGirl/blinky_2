# frozen_string_literal: true

module Blinky
  module Models
    # Basic information and validation for a single USER.
    class User
      # rubocop:disable Layout/AlignHash, Layout/SpaceInsideHashLiteralBraces
      SCHEMA = {
        _id:             {type: :integer},
        url:             {type: :url},
        external_id:     {type: :guid},
        name:            {type: :string},
        alias:           {type: :string},
        created_at:      {type: :datetime},
        active:          {type: :boolean},
        verified:        {type: :boolean},
        shared:          {type: :boolean},
        locale:          {type: :locale},
        timezone:        {type: :timezone},
        last_login_at:   {type: :datetime},
        email:           {type: :email},
        phone:           {type: :regex, match: /\d\d\d\d-\d\d\d-\d\d\d/},
        organization_id: {type: :integer},
        tags:            {type: :array, subtype: :string},
        suspended:       {type: :boolean},
        role:            {type: :array, subtype: :string, allowed: %w[admin agent end_user]}
      }.freeze
      # rubocop:enable Layout/AlignHash, Layout/SpaceInsideHashLiteralBraces

      attr_reader :_id, :url, :external_id, :name, :alias, :created_at, :active, :verified,
                  :shared, :locale, :timezone, :last_login_at, :email, :phone,
                  :organization_id, :tags, :suspended, :role
      attr_accessor :error_count

      def initialize
        @error_count = 0
      end

      private

      def row_keys_must_match_schema(row)
        error_message = Constants::ERROR_MESSAGES[:row_keys_must_match_schema]
        raise InvalidKeysException, error_message unless row.keys == SCHEMA.keys
      end

      def row_values_must_match_schema(row)
        SCHEMA.keys.each do |key|
          value = row[key]
          result = case SCHEMA[key][:type]
                   when :string
                     value.is_a?(String)
                   when :guid
                     value.match(/\b[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b/)
                   when :integer
                     row[key].match(/[\d]+/)
                   when :url
                     row[key].match(%r{https?://[\S]+})
                   when :datetime
                     begin
                       Time.parse(row[key])
                     rescue ArgumentError
                       nil
                     end
                   when :boolean
                     !!row[key] == row[key]
                   when :locale
                     row[key].is_a?(String)
                   when :timezone
                     row[key].is_a?(String)
                   when :email
                     row[key].match(/\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
                   when :regex
                     row[key].match(SCHEMA[key][:match])
                   when :array
                     row[key].is_a?(Array)
                   else
                     raise InvalidKeysException, "Unknown key [#{SCHEMA[key][:type]}]"
                   end
          if result.nil? || !result
            @error_count += 1
            raise InvalidKeysException, Constants::ERROR_MESSAGES[:row_keys_must_match_schema]
          end
        end
      end
    end
  end
end
