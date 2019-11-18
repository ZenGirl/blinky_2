# frozen_string_literal: true

module Blinky
  module Schema
    # Matches a row against a schema
    class Matcher
      attr_reader :schema, :row
      attr_accessor :error_count

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

      def initialize(schema)
        @schema      = schema
        @error_count = 0
      end

      def match_row(row)
        @row = row
      end

      def validate
        @schema.keys.each do |key|
          value        = @row[key]
          result       = value.nil? ? false : send(SCHEMA_TABLE[@schema[key][:type]], key, value)
          @error_count += 1 if result.nil? || !result
        end
        raise Models::InvalidKeysException, Constants::ERROR_MESSAGES[:row_keys_must_match_schema] if @error_count > 0
      end

      private

      def must_be_string(key, value)
        value.is_a?(String)
      end

      def must_match_guid(key, value)
        value.match(/\b[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b/)
      end

      def must_be_integer(key, value)
        value.match(/[\d]+/)
      end

      def must_be_url(key, value)
        value.match(%r{https?://[\S]+})
      end

      def must_be_datetime(key, value)
        Time.parse(value)
      rescue ArgumentError
        nil
      end

      def must_be_boolean(key, value)
        !!value == value
      end

      def must_be_locale(key, value)
        value.is_a?(String)
      end

      def must_be_timezone(key, value)
        value.is_a?(String)
      end

      def must_be_email(key, value)
        value.match(/\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      end

      def must_be_regex(key, value)
        value.match(@schema[key][:match])
      end

      def must_be_array(key, value)
        value.is_a?(Array)
      end

    end
  end
end
