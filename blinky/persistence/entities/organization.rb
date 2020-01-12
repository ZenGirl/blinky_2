# frozen_string_literal: true

module Blinky
  module Repository
    module Entities

      class Organization
        attr_reader :_id, :url, :external_id, :name, :domain_names, :created_at, :details, :shared_tickets, :tags

        def initialize(obj)
          @_id            = obj[:_id]
          @url            = obj[:url]
          @external_id    = obj[:external_id]
          @name           = obj[:name]
          @domain_names   = obj[:domain_names]
          @created_at     = obj[:created_at]
          @details        = obj[:details]
          @shared_tickets = obj[:shared_tickets]
          @tags           = obj[:tags]
        end
      end
    end
  end
end
