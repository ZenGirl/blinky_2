# frozen_string_literal: true

module Blinky
  module Views
    # Use ERB to render a ticket
    class Ticket
      include ERB::Util
      include MasterView

      TEMPLATE = %(<%= @header %>
            _id: <%= @obj[:_id] %>
            url: <%= @obj[:url] %>
    external_id: <%= @obj[:external_id] %>
     created_at: <%= @obj[:created_at] %>
           type: <%= @obj[:type] %>
        subject: <%= @obj[:subject] %>
    description: <%= @obj[:description] %>
       priority: <%= @obj[:priority] %>
         status: <%= @obj[:status] %>
   submitter_id: <%= @obj[:submitter_id] %>
    assignee_id: <%= @obj[:assignee_id] %>
organization_id: <%= @obj[:organization_id] %>
           tags: <%= @obj[:tags] %>
  has_incidents: <%= @obj[:has_incidents] %>
         due_at: <%= @obj[:due_at] %>
            via: <%= @obj[:via] %>
)

      def initialize
        set_repos_and_views
      end

      def render(obj, show_references = false, header = nil)
        @obj    = obj
        @header = header || 'Ticket'
        result  = ERB.new(TEMPLATE).result(binding)
        if show_references
          #TODO: This needs refactoring
          result += add_reference(@users_repo, @users_partial, obj, :submitter_id, 'Submitter')
          result += add_reference(@users_repo, @users_partial, obj, :assignee_id, 'Assignee')
          result += add_reference(@organizations_repo, @organizations_partial, obj, :organization_id, 'Organization')
        end
        result
      end
    end
  end
end
