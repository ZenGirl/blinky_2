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
          query = { mode: :equal, assignee_id: obj[:_id] }
          @tickets_repo.query(query).each do |ticket|
            result += add_reference(@tickets_repo, @tickets_partial, ticket, :_id, 'Assigned')
          end
          query = { mode: :equal, submitter_id: obj[:_id] }
          @tickets_repo.query(query).each do |ticket|
            result += add_reference(@tickets_repo, @tickets_partial, ticket, :_id, 'Submitted')
          end
        end
        result
      end
    end
  end
end
