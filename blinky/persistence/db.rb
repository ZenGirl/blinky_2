# frozen_string_literal: true

module Blinky
  module Repository
    # Test sqlite
    class Db
      attr_reader :dbc
      attr_accessor :users, :tickets, :organizations

      def initialize
        @dbc = SQLite3::Database.new('')
        create_users
        #create_tickets
        #create_organizations
      end

      def create_users
        @users = @dbc.execute <<-SQL
          create table users (
            _id             varchar(36) primary key,
            url             varchar(255),
            external_id     varchar(36),
            name            varchar(255),
            alias           varchar(255),
            created_at      varchar(255),
            active          integer,
            verified        integer,
            shared          integer,
            locale          varchar(255),
            timezone        varchar(255),
            last_login_at   varchar(255),
            email           varchar(255),
            phone           varchar(255),
            signature       varchar(255),
            organization_id int,
            tags            varchar(255),
            suspended       integer,
            role            varchar(255)
          );
        SQL
      end

      #def create_tickets
      #
      #end

      #def create_organizations
      #
      #end

    end
  end
end