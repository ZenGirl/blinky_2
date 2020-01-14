# frozen_string_literal: true

module Blinky
  module Persistence
    module Adapters
      # A simple in memory repository
      class InMemory
        attr_accessor :map

        def initialize
          @map = {}
        end

        def save(id, row)
          @map[id] = row
        end

        def all
          @map.clone.values
        end

        def find_by_id(id)
          @map.fetch(id)
        rescue KeyError => e
          puts 'KeyError!'
          puts e
          nil
        end

        def query(criteria)
          key = criteria.keys.reject { |k| k == :mode }[0]
          val = criteria[key]
          if criteria[:mode] == :equal
            query_equal(key, val)
          elsif criteria[:mode] == :like
            query_like(key, val)
          end
        end

        def create(id, row)
          @map[id] = row
        end

        def clear
          @map = {}
        end

        private

        def query_equal(key, val)
          @map.values.select do |obj|
            if obj[key].is_a?(Array)
              arr_str = obj[key].join(' ').downcase
              arr_str.index(val.downcase)
            else
              obj[key].to_s.downcase == val.to_s.downcase
            end
          end
        end

        def query_like(key, val)
          @map.select do |_, v|
            v[key].match(/#{val.gsub('*', '.*')}/i)
          end.values
        end
      end
    end
  end
end
