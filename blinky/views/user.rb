# frozen_string_literal: true

module Blinky
  module Views
    # Use ERB to render a user
    class User
      include ERB::Util
      include MasterView

      TEMPLATE = %(<%= @header %>
            _id: <%= @obj[:_id] %>
            url: <%= @obj[:url] %>
    external_id: <%= @obj[:external_id] %>
           name: <%= @obj[:name] %>
          alias: <%= @obj[:alias] %>
     created_at: <%= @obj[:created_at] %>
         active: <%= @obj[:active] %>
       verified: <%= @obj[:verified] %>
         shared: <%= @obj[:shared] %>
         locale: <%= @obj[:locale] %>
       timezone: <%= @obj[:timezone] %>
  last_login_at: <%= @obj[:last_login_at] %>
          email: <%= @obj[:email] %>
          phone: <%= @obj[:phone] %>
      signature: <%= @obj[:signature] %>
organization_id: <%= @obj[:organization_id] %>
           tags: <%= @obj[:tags] %>
      suspended: <%= @obj[:suspended] %>
           role: <%= @obj[:role] %>
)

      def initialize
        set_repos_and_views
      end

      def render(obj, show_references = false, header = nil)
        @obj    = obj
        @header = header || 'User'
        result  = ERB.new(TEMPLATE).result(binding)
        if show_references
          result += add_reference(@organizations_repo, @organizations_partial, obj, :organization_id, 'Organization')
          result += "        Tickets:\n"
          add_assigned_tickets(obj)
          add_submitted_tickets(obj)
        end
        result
      end

      # rubocop:disable Style/BracesAroundHashParameters
      def add_assigned_tickets(obj)
        result  = ''
        tickets = @tickets_repo.query({ mode: :equal, assignee_id: obj[:_id] })
        tickets.each do |ticket|
          result += add_reference(@tickets_repo, @tickets_partial, ticket, :_id, 'Assigned')
        end
        result
      end

      # rubocop:enable Style/BracesAroundHashParameters

      # rubocop:disable Style/BracesAroundHashParameters
      def add_submitted_tickets(obj)
        result  = ''
        tickets = @tickets_repo.query({ mode: :equal, submitter_id: obj[:_id] })
        tickets.each do |ticket|
          result += add_reference(@tickets_repo, @tickets_partial, ticket, :_id, 'Submitted')
        end
        result
      end
      # rubocop:enable Style/BracesAroundHashParameters
    end
  end
end
