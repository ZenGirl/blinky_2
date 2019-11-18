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
                  :organization_id, :tags, :suspended, :role, :schema_matcher

      def initialize
        @schema_matcher = Schema::Matcher.new(SCHEMA)
      end

      private

      def row_keys_must_match_schema(row)
        error_message = Constants::ERROR_MESSAGES[:row_keys_must_match_schema]
        raise InvalidKeysException, error_message unless row.keys == SCHEMA.keys
      end

      def row_values_must_match_schema(row)
        @schema_matcher.match_row(row)
        @schema_matcher.validate
      end
    end
  end
end
