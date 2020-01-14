# frozen_string_literal: true

module Blinky
  module PreFlight
    module Interactors
      # Loads formalized data into repositories
      class LoadData
        include Interactor

        def call
          data = context.data
          assign_adapters(data)
          assign_data(data)
        end

        private

        def assign_adapters(data)
          data.keys.each do |key|
            repo_name = "Blinky::Persistence::#{key.to_s.capitalize}Repo"
            repo_class = Object.const_get(repo_name)
            repo_class.adapter = Blinky::Persistence::Adapters::InMemory.new
            data[key][:repo] = repo_class
          end
        end

        def assign_data(data)
          data.keys.each do |key|
            data[key][:formalized_objects].each do |row|
              data[key][:repo].create(row[:_id], row)
            end
          end
        end
      end
    end
  end
end
