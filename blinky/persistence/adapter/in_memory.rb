# frozen_string_literal: true

module Blinky
  module Persistence
    module Adapter
      class InMemory
        def initialize
          @map = {}
        end

        def save(row, id)
          @map[id] = row
        end

        def all
          @map.clone.values
        end

        def find_by_id(id)
          @map.fetch(id)
        end

        def query(criteria)
          send "query_#{criteria.class.name.underscore}", criteria
        end

        def create(row, id)
          @map[id] = row
        end

        def clear
          @map = {}
        end

      end
    end
  end
end