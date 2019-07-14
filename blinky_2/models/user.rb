module Blinky
  module Models

    # This model provides class and instance methods for user objects
    class User
      attr_accessor :_id, :url, :external_id, :name, :alias, :created_at,
                    :active, :verified, :shared, :locale, :timezone,
                    :last_login_at, :email, :phone, :signature,
                    :organization_id, :tags, :suspended, :role

      def initialize(json_hash_vars)
        @_id             = json_hash_vars[:_id]
        @url             = json_hash_vars[:url]
        @external_id     = json_hash_vars[:external_id]
        @name            = json_hash_vars[:name]
        @alias           = json_hash_vars[:alias]
        @created_at      = json_hash_vars[:created_at]
        @active          = json_hash_vars[:active]
        @verified        = json_hash_vars[:verified]
        @shared          = json_hash_vars[:shared]
        @locale          = json_hash_vars[:locale]
        @timezone        = json_hash_vars[:timezone]
        @last_login_at   = json_hash_vars[:last_login_at]
        @email           = json_hash_vars[:email]
        @phone           = json_hash_vars[:phone]
        @signature       = json_hash_vars[:signature]
        @organization_id = json_hash_vars[:organization_id]
        @tags            = json_hash_vars[:tags]
        @suspended       = json_hash_vars[:suspended]
        @role            = json_hash_vars[:role]
      end
    end
  end
end
