require 'spec_helper'

require_relative '../../../blinky/persistence/adapters/in_memory'
require_relative '../../../blinky/persistence/adapter_delegation'
require_relative '../../../blinky/persistence/organizations_repo'

describe Blinky::Persistence::OrganizationsRepo do
  before :all do
    @repo = Blinky::Persistence::OrganizationsRepo
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
        fname       = 'spec/support/organizations_test.json'
        json_string = IO.read(fname)
        @objects     = JSON.parse(json_string, symbolize_names: true)
        @count = 0
        @objects.each do |obj|
          @repo.create(obj[:_id], obj)
          @count += 1
        end
      end
      it 'saves' do
        row = @repo.find_by_id(105)
        details = row[:details]
        row[:details] = row[:details] + '!'
        @repo.save(105, row)
        row = @repo.find_by_id(105)
        expect(row[:details]).to eq(details + '!')
      end
      it 'returns all' do
        rows = @repo.all
        expect(rows.size).to eq 5
      end
      it 'finds by id' do
        expect(@repo.find_by_id(100)).to be_nil
        row = @repo.find_by_id(105)
        expect(row[:_id]).to eq 105
      end
      it 'queries equal' do
        rows = @repo.query({mode: :equal, name: 'Plasmos'})
        expect(rows.size).to eq 1
        rows = @repo.query({mode: :equal, name: 'Xylar'})
        expect(rows.size).to eq 1
        rows = @repo.query({mode: :equal, name: 'Kumbucha'})
        expect(rows.size).to eq 0
      end
      it 'queries like' do
        expect(@repo.query({mode: :like, name: 'x'}).size).to eq 1
        expect(@repo.query({mode: :like, name: 'n'}).size).to eq 2
        expect(@repo.query({mode: :like, name: 'e'}).size).to eq 2
        expect(@repo.query({mode: :like, name: 'o'}).size).to eq 2
        expect(@repo.query({mode: :like, name: 'j'}).size).to eq 0
        expect(@repo.query({mode: :like, details: 'n'}).size).to eq 2
        expect(@repo.query({mode: :like, details: 'm'}).size).to eq 3
        expect(@repo.query({mode: :like, details: 'ö'}).size).to eq 1
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