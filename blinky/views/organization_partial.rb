# frozen_string_literal: true

module Blinky
  module Views
    # Use ERB to render partial organization details
    class OrganizationPartial
      include ERB::Util

      TEMPLATE = %(<%= sprintf("%15s", @header) %>: <%= @obj[:name] %>)

      def render(obj, header = nil)
        @obj    = obj
        @header = header || 'Organization'
        ERB.new(TEMPLATE).result(binding)
      end
    end
  end
end
