# frozen_string_literal: true

module Blinky
  module Views
    # Hold methods used by all views
    module MasterView
      def set_repos_and_views
        @users_repo    = Blinky::Persistence::UsersRepo
        @users_view    = Blinky::Views::User
        @users_partial = Blinky::Views::UserPartial

        @organizations_repo     = Blinky::Persistence::OrganizationsRepo
        @organizations_view     = Blinky::Views::Organization
        @organizations_partial  = Blinky::Views::OrganizationPartial

        @tickets_repo     = Blinky::Persistence::TicketsRepo
        @tickets_view     = Blinky::Views::Ticket
        @tickets_partial  = Blinky::Views::TicketPartial
      end

      def add_reference(repo, view, obj, key, heading)
        ref = repo.find_by_id(obj[key])
        view.new.render(ref, heading) + "\n"
      end
    end
  end
end
