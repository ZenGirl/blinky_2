require 'spec_helper'

require 'constants'
require 'utils'

require 'persistence/adapters/in_memory'
require 'persistence/adapter_delegation'
require 'persistence/users_repo'
require 'persistence/organizations_repo'
require 'persistence/tickets_repo'

require 'pre_flight/interactors/formalize'
require 'pre_flight/interactors/load_data'

describe Blinky::PreFlight::Interactors::LoadData do
  describe '#call' do
    before do
      ctx                  = {
        data: {
          tickets:       {
            env:  'TICKETS',
            file: 'spec/support/tickets_test.json'
          },
          users:         {
            env:  'USERS',
            file: 'spec/support/users_test.json'
          },
          organizations: {
            env:  'ORGANIZATIONS',
            file: 'spec/support/organizations_test.json'
          }
        }
      }
      @context             = Blinky::PreFlight::Interactors::Formalize.call(ctx)
      subject.context.data = @context.data
      subject.call
      @data = subject.context.data
    end
    it 'assigns InMemory adapter' do
      @data.keys.each do |key|
        adapter_name = 'Blinky::Persistence::Adapters::InMemory'
        expect(@data[key][:repo].adapter.class.name).to eq adapter_name
      end
    end
    it 'loads users' do
      repo = @data[:users][:repo]
      entity_keys = Blinky::Constants::SCHEMAS[:users].keys
      rows = repo.all
      expect(rows.size).to eq 5
      rows.each do |row|
        expect(row.keys.sort).to eq(entity_keys.sort)
      end
    end
    it 'loads organizations' do
      repo = @data[:organizations][:repo]
      entity_keys = Blinky::Constants::SCHEMAS[:organizations].keys
      rows = repo.all
      expect(rows.size).to eq 5
      rows.each do |row|
        expect(row.keys.sort).to eq(entity_keys.sort)
      end
    end
    it 'loads tickets' do
      repo = @data[:tickets][:repo]
      entity_keys = Blinky::Constants::SCHEMAS[:tickets].keys
      rows = repo.all
      expect(rows.size).to eq 5
      rows.each do |row|
        expect(row.keys.sort).to eq(entity_keys.sort)
      end
    end
  end
end
