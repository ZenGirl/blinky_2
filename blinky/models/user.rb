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

      # rubocop:disable Layout/AlignHash
      SCHEMA_TABLE = {
        string:   :must_be_string,
        guid:     :must_match_guid,
        integer:  :must_be_integer,
        url:      :must_be_url,
        datetime: :must_be_datetime,
        boolean:  :must_be_boolean,
        locale:   :must_be_string,
        timezone: :must_be_timezone,
        email:    :must_be_email,
        regex:    :must_be_regex,
        array:    :must_be_array
      }.freeze
      # rubocop:enable Layout/AlignHash

      def must_be_string(value)
        value.is_a?(String)
      end

      def must_match_guid(value)
        value.match(/\b[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b/)
      end

      def must_be_integer(value)
        value.match(/[\d]+/)
      end

      def must_be_url(value)
        value.match(%r{https?://[\S]+})
      end

      def must_be_datetime(value)
        begin
          Time.parse(value)
        rescue ArgumentError
          nil
        end
      end

      def must_be_boolean(value)
        !!value == value
      end

      def must_be_locale(value)
        value.is_a?(String)
      end

      def must_be_timezone(value)
        value.is_a?(String)
      end

      def must_be_email(value)
        value.match(/\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      end

      def must_be_regex(value)
        value.match(SCHEMA[key][:match])
      end

      def must_be_array(value)
        value.is_a?(Array)
      end

      def row_values_must_match_schema(row)
        SCHEMA.keys.each do |key|
          value = row[key]
          result = send(SCHEMA_TABLE[key], value)
        end
        # SCHEMA.keys.each do |key|
        #   value  = row[key]
        #   result = case SCHEMA[key][:type]
        #            when :string
        #              value.is_a?(String)
        #            when :guid
        #              value.match(/\b[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b/)
        #            when :integer
        #              value.match(/[\d]+/)
        #            when :url
        #              value.match(%r{https?://[\S]+})
        #            when :datetime
        #              begin
        #                Time.parse(value)
        #              rescue ArgumentError
        #                nil
        #              end
        #            when :boolean
        #              !!value == value
        #            when :locale
        #              value.is_a?(String)
        #            when :timezone
        #              value.is_a?(String)
        #            when :email
        #              value.match(/\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
        #            when :regex
        #              value.match(SCHEMA[key][:match])
        #            when :array
        #              value.is_a?(Array)
        #            else
        #              raise InvalidKeysException, "Unknown key [#{SCHEMA[key][:type]}]"
        #            end
          if result.nil? || !result
            @error_count += 1
            raise InvalidKeysException, Constants::ERROR_MESSAGES[:row_keys_must_match_schema]
          end
        end
      end
    end
  end
end
