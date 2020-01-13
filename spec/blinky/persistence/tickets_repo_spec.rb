require 'spec_helper'

require_relative '../../../blinky/persistence/adapters/in_memory'
require_relative '../../../blinky/persistence/adapter_delegation'
require_relative '../../../blinky/persistence/tickets_repo'

describe Blinky::Persistence::TicketsRepo do
  before :all do
    @repo = Blinky::Persistence::TicketsRepo
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
        fname       = 'spec/support/tickets_test.json'
        json_string = IO.read(fname)
        @objects     = JSON.parse(json_string, symbolize_names: true)
        @count = 0
        @objects.each do |obj|
          @repo.create(obj[:_id], obj)
          @count += 1
        end
      end
      it 'saves' do
        uuid = '1a227508-9f39-427c-8f57-1b72f3fab87c'
        row = @repo.find_by_id(uuid)
        subject = row[:subject]
        row[:subject] = row[:subject] + '!'
        @repo.save(uuid, row)
        row = @repo.find_by_id(uuid)
        expect(row[:subject]).to eq(subject + '!')
      end
      it 'returns all' do
        rows = @repo.all
        expect(rows.size).to eq 5
      end
      it 'finds by id' do
        expect(@repo.find_by_id('100')).to be_nil
        row = @repo.find_by_id('1a227508-9f39-427c-8f57-1b72f3fab87c')
        expect(row[:_id]).to eq '1a227508-9f39-427c-8f57-1b72f3fab87c'
      end
      it 'queries equal' do
        rows = @repo.query({mode: :equal, priority: 'low'})
        expect(rows.size).to eq 1
        rows = @repo.query({mode: :equal, priority: 'high'})
        expect(rows.size).to eq 2
      end
      it 'queries like' do
        expect(@repo.query({mode: :like, subject: 'm'}).size).to eq 2
        expect(@repo.query({mode: :like, subject: 'g'}).size).to eq 2
        expect(@repo.query({mode: :like, type: 'i'}).size).to eq 3
        expect(@repo.query({mode: :like, status: 'o'}).size).to eq 4
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