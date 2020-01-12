# frozen_string_literal: true

module Blinky
  module Persistence
    # A module with commands to be implemented by specific repo
    module RepoDelegation
      def adapter
        Repo.adapter
      end

      def adapter=(adapter)
        Repo.adapter = adapter
      end

      def save(id, row)
        Repo.save(id, row)
      end

      def all
        Repo.all
      end

      def find_by_id(id)
        Repo.find_by_id(id)
      end

      def query(criteria)
        Repo.query(criteria)
      end

      def create(id, object)
        Repo.create(id, object)
      end

      def clear
        Repo.clear
      end
    end
  end
end
