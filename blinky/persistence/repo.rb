# frozen_string_literal: true

module Blinky
  module Persistence
    class Repo
      def self.adapter
        @adapter
      end

      def self.adapter=(adapter)
        @adapter = adapter
      end

      def self.save(row)
        adapter.save(row)
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

      def self.create(row, id)
        adapter.create(row, id)
      end

      def self.clear
        adapter.clear
      end
    end
    module RepoDelegation
      def save(row)
        Repo.save(row)
      end

      def all
        Repo.all
      end

      def find_by_id(id)
        Repo.find(id)
      end

      def query(criteria)
        Repo.query(criteria)
      end

      def create(object, id)
        Repo.create(object, id)
      end

      def clear
        Repo.clear
      end

    end
    class OrganizationRepo
      extend RepoDelegation
    end
  end
end
