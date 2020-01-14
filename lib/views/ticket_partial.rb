# frozen_string_literal: true

module Blinky
  module Views
    # Use ERB to render partial ticket details
    class TicketPartial
      include ERB::Util

      TEMPLATE = %(<%= sprintf("%15s", @header) %>: [<%= obj[:status]%>] <%= @obj[:subject] %>)

      def render(obj, header = nil)
        @obj    = obj
        @header = header || 'Ticket'
        ERB.new(TEMPLATE).result(binding)
      end
    end
  end
end
