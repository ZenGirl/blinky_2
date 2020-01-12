require 'spec_helper'

require_relative '../../../blinky/persistence/repo'
require_relative '../../../blinky/persistence/adapter/in_memory'

describe Blinky::Persistence::Repo do
  context 'Organizations' do
    let(:repo) { Blinky::Persistence::OrganizationRepo }
    before :all do
      Blinky::Persistence::Repo.adapter = Blinky::Persistence::Adapter::InMemory.new
      fd                                = IO.read('blinky/data/organizations.json')
      @pairs                            = JSON.parse(fd, symbolize_names: true)
    end
    before :each do
      repo.clear
    end
    it 'assigns adapter' do
      expect(Blinky::Persistence::Repo.adapter).to be_a Blinky::Persistence::Adapter::InMemory
    end
    it 'responds to organizations' do
      repo.create(@pairs[0], @pairs[0][:_id])
      rows = repo.all
      expect(rows.size).to eq 1
    end
    it 'assigns rows' do
      @pairs.each do |pair|
        repo.create(pair, pair[:_id])
      end
      rows = repo.all
      expect(rows.size).to eq 25
    end
  end
end
