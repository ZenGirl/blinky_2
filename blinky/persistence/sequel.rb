# frozen_string_literal: true

module Blinky
  module Repository
    class Sequel
      attr_reader :db, :organizations

      def initialize
        @db = ::Sequel.sqlite
      end

      def create_tables
        @db.create_table :organizations do
          primary_key :_id
          String :url
          String :external_id
          String :name
          String :domain_names
          String :created_at
          String :details
          Integer :shared_tickets
          String :tags
        end
      end

      def load_organizations(formalized_objects)
        @organizations = @db[:organizations]
        formalized_objects.each do |obj|
          @organizations.insert(
            _id:            obj[:id],
            url:            obj[:url],
            external_id:    obj[:external_id],
            name:           obj[:name],
            domain_names:   obj[:domain_names].join(','),
            created_at:     obj[:created_at],
            details:        obj[:details],
            shared_tickets: obj[:shared_tickets] ? 1 : 0,
            tags:           obj[:tags].join(',')
          )
        end
      end

    end
  end
end
