# frozen_string_literal: true

module Blinky
  module Persistence
    # A module with commands to be implemented by specific repo
    module AdapterDelegation
      def adapter
        @adapter
      end

      def adapter=(adapter)
        @adapter = adapter
      end

      def save(id, row)
        @adapter.save(id, row)
      end

      def all
        @adapter.all
      end

      def find_by_id(id)
        @adapter.find_by_id(id)
      end

      def query(criteria)
        @adapter.query(criteria)
      end

      def create(id, object)
        @adapter.create(id, object)
      end

      def clear
        @adapter.clear
      end
    end
  end
end
