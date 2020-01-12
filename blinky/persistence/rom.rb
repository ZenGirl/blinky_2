# frozen_string_literal: true

Blinky::Repository::Rom = ::ROM.container(:sql, 'sqlite::memory') do |conf|
  # -------------------------------------------------------------------
  # Organizations
  # -------------------------------------------------------------------
  conf.default.create_table(:organizations) do
    column :_id, Integer, primary_key: true
    column :url, String, null: false
    column :external_id, String #:uuid, null: false, default: Sequel.function(:uuid_generate_v4)
    column :name, String, null: false
    column :domain_names, String, null: false
    column :created_at, DateTime, null: false
    column :details, String, null: false
    column :shared_tickets, :boolean
    column :tags, String, null: false
  end
  class Organizations < ROM::Relation[:sql]
    schema(infer: true)
  end
  conf.register_relation(Organizations)
  # -------------------------------------------------------------------
  # Users
  # -------------------------------------------------------------------
  conf.default.create_table(:users) do
    column :_id, Integer, primary_key: true
    column :url, String, null: false
    column :external_id, String #:uuid, null: false, default: Sequel.function(:uuid_generate_v4)
    column :name, String, null: false
    column :alias, String
    column :created_at, DateTime
    column :active, :boolean
    column :verified, :boolean
    column :shared, :boolean
    column :locale, String
    column :timezone, String
    column :last_login_at, DateTime
    column :email, String
    column :phone, String
    column :signature, String
    foreign_key :organization_id, :organizations, null: false, index: true, on_delete: :cascade
    column :suspended, :boolean
    column :role, String
  end
  class Users < ROM::Relation[:sql]
    schema(infer: true)
  end
  conf.register_relation(Users)
  # -------------------------------------------------------------------
  # Users
  # -------------------------------------------------------------------
  conf.default.create_table(:tickets) do
    column :_id, Integer, primary_key: true
    column :url, String, null: false
    column :external_id, String #:uuid, null: false, default: Sequel.function(:uuid_generate_v4)
    column :created_at, DateTime
    column :type, String
    column :subject, String
    column :description, String
    column :priority, String
    column :status, String
    foreign_key :submitter_id, :users, null: false, index: true, on_delete: :cascade
    foreign_key :assignee_id, :users, null: false, index: true, on_delete: :cascade
    foreign_key :organization_id, :organizations, null: false, index: true, on_delete: :cascade
    column :tags, String
    column :has_incidents, :boolean
    column :due_at, DateTime
    column :via, String
  end
  class Tickets < ROM::Relation[:sql]
    schema(infer: true)
  end
  conf.register_relation(Tickets)
end
