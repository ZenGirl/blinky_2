# frozen_string_literal: true

module Blinky
  module Views
    # Use ERB to render partial user details
    class UserPartial
      include ERB::Util

      TEMPLATE = %(<%= sprintf("%15s", @header) %>: <%= @obj[:name] %>)

      def render(obj, header = nil)
        @obj    = obj
        @header = header || 'User'
        ERB.new(TEMPLATE).result(binding)
      end
    end
  end
end
