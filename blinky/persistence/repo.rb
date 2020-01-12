# frozen_string_literal: true

module Blinky
  module Persistence
    # The over-all repository
    class Repo
      # rubocop:disable Style/TrivialAccessors
      def self.adapter
        @adapter
      end
      # rubocop:enable Style/TrivialAccessors

      # rubocop:disable Style/TrivialAccessors
      def self.adapter=(adapter)
        @adapter = adapter
      end
      # rubocop:enable Style/TrivialAccessors

      def self.save(id, row)
        adapter.save(id, row)
      end

      def self.all
        adapter.all
      end

      def self.find_by_id(id)
        adapter.find_by_id(id)
      end

      def self.query(criteria)
        adapter.query(criteria)
      end

      def self.create(id, row)
        adapter.create(id, row)
      end

      def self.clear
        adapter.clear
      end
    end
  end
end
