# frozen_string_literal: true

module Blinky
  module PreFlight
    module Interactors
      # Ensures that all the file names provide exist and are readable.
      class ValidReadableFiles
        include Interactor
        include Utils

        def call
          data = context.data
          data.keys.each do |key|
            name_must_be_a_readable_file data[key][:env], data[key][:file]
          end
        end

        private

        def name_must_be_a_readable_file(env_var, file_name)
          must_exist(env_var, file_name)
          must_be_a_file(env_var, file_name)
          must_be_readable(env_var, file_name)
        end

        def must_exist(env_var, file_name)
          return if File.exist? file_name

          context.fail!(message: "#{env_var} #{file_name} #{err(:env_var_file_not_found)}")
        end

        def must_be_a_file(env_var, file_name)
          return if File.file? file_name

          context.fail!(message: "#{env_var} #{file_name} #{err(:env_var_file_not_readable)}")
        end

        def must_be_readable(env_var, file_name)
          return if File.readable? file_name

          context.fail!(message: "#{env_var} #{file_name} #{err(:env_var_file_not_readable)}")
        end
      end
    end
  end
end
