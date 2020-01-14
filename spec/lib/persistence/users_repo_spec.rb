require 'spec_helper'

require_relative '../../../lib/persistence/adapters/in_memory'
require_relative '../../../lib/persistence/adapter_delegation'
require_relative '../../../lib/persistence/users_repo'

describe Blinky::Persistence::UsersRepo do
  before :all do
    @repo = Blinky::Persistence::UsersRepo
  end
  context 'InMemory adapter' do
    before :all do
      @repo.adapter = Blinky::Persistence::Adapters::InMemory.new
    end
    it 'clears' do
      @repo.clear
      expect(@repo.all).to eq([])
    end
    context 'with test data' do
      before :all do
        fname       = 'spec/support/users_test.json'
        json_string = IO.read(fname)
        @objects     = JSON.parse(json_string, symbolize_names: true)
        @count = 0
        @objects.each do |obj|
          @repo.create(obj[:_id], obj)
          @count += 1
        end
      end
      it 'saves' do
        row = @repo.find_by_id(2)
        signature = row[:signature]
        row[:signature] = row[:signature] + '!'
        @repo.save(2, row)
        row = @repo.find_by_id(2)
        expect(row[:signature]).to eq(signature + '!')
      end
      it 'returns all' do
        rows = @repo.all
        expect(rows.size).to eq 5
      end
      it 'finds by id' do
        expect(@repo.find_by_id(100)).to be_nil
        row = @repo.find_by_id(3)
        expect(row[:_id]).to eq 3
      end
      it 'queries equal' do
        rows = @repo.query({mode: :equal, name: 'Cross Barlow'})
        expect(rows.size).to eq 1
        rows = @repo.query({mode: :equal, name: 'Rose Newton'})
        expect(rows.size).to eq 1
        rows = @repo.query({mode: :equal, name: 'Kumbucha'})
        expect(rows.size).to eq 0
      end
      it 'queries like' do
        expect(@repo.query({mode: :like, name: 's'}).size).to eq 3
        expect(@repo.query({mode: :like, name: 'b'}).size).to eq 1
        expect(@repo.query({mode: :like, name: 'e'}).size).to eq 4
        expect(@repo.query({mode: :like, name: 'j'}).size).to eq 0
        expect(@repo.query({mode: :like, alias: 'n'}).size).to eq 2
        expect(@repo.query({mode: :like, alias: 'm'}).size).to eq 5
        expect(@repo.query({mode: :like, alias: 'ö'}).size).to eq 0
      end
      it 'creates' do
        rows = @repo.all
        expect(rows.size).to eq @count
      end
      it 'clears' do
        @repo.clear
        expect(@repo.all.size).to eq 0
        @count = 0
        @objects.each do |obj|
          @repo.create(obj[:_id], obj)
          @count += 1
        end
      end
    end
  end
end