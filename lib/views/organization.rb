# frozen_string_literal: true

module Blinky
  module Views
    # Use ERB to render an organization
    class Organization
      include ERB::Util
      include MasterView

      TEMPLATE = %(<%= @header %>
            _id: <%= @obj[:_id] %>
            url: <%= @obj[:url] %>
    external_id: <%= @obj[:external_id] %>
           name: <%= @obj[:name] %>
   domain_names: <%= @obj[:domain_names] %>
     created_at: <%= @obj[:created_at] %>
        details: <%= @obj[:details] %>
 shared_tickets: <%= @obj[:shared_tickets] %>
           tags: <%= @obj[:tags] %>
)

      def initialize
        set_repos_and_views
      end

      def render(obj, show_references = false, header = nil)
        @obj    = obj
        @header = header || 'Organization'
        result  = ERB.new(TEMPLATE).result(binding)
        if show_references
          common_query = { mode: :equal, organization_id: obj[:_id] }
          @users_repo.query(common_query).each do |user|
            result += add_reference(@users_repo, @users_partial, user, :_id, 'User')
          end
          @tickets_repo.query(common_query).each do |ticket|
            result += add_reference(@tickets_repo, @tickets_partial, ticket, :_id, 'Ticket')
          end
        end
        result
      end
    end
  end
end
