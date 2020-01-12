require 'spec_helper'

require_relative '../../../../blinky/persistence/adapters/in_memory'

describe Blinky::Persistence::Adapters::InMemory do
  let(:adapter) { Blinky::Persistence::Adapters::InMemory.new }
  before :each do
    adapter.clear
  end
  it 'initializes' do
    expect(adapter.map).to eq({})
  end
  it 'clears' do
    expect(adapter.map).to eq({})
    adapter.map[100] = { name: 'Object 100' }
    adapter.map[101] = { name: 'Object 101' }
    adapter.map[102] = { name: 'Object 102' }
    expect(adapter.map.size).to eq(3)
    adapter.clear
    expect(adapter.map).to eq({})
  end
  it 'creates' do
    adapter.create(100, { _id: 100, name: 'Object 100' })
    expect(adapter.map.size).to eq 1
    adapter.create(101, { _id: 101, name: 'Object 101' })
    expect(adapter.map.size).to eq 2
    expect(adapter.map).to eq({
                                100 => { _id: 100, name: 'Object 100' },
                                101 => { _id: 101, name: 'Object 101' }
                              })
  end
  it 'saves' do
    adapter.create(100, { _id: 100, name: 'Object 100' })
    adapter.create(101, { _id: 101, name: 'Object 101' })
    adapter.save(100, { _id: 100, name: 'Object 100', alias: 'Number 100' })
    expect(adapter.map[100]).to eq({ _id: 100, name: 'Object 100', alias: 'Number 100' })
    expect(adapter.map[101]).to eq({ _id: 101, name: 'Object 101' })
  end
  it 'finds by id' do
    adapter.create(100, { _id: 100, name: 'Object 100' })
    adapter.create(101, { _id: 101, name: 'Object 101' })
    expect(adapter.find_by_id(100)).to eq({ _id: 100, name: 'Object 100' })
    expect(adapter.find_by_id(101)).to eq({ _id: 101, name: 'Object 101' })
    expect(adapter.find_by_id(102)).to be_nil
  end
  it 'queries equal' do
    adapter.create(100,{ _id: 100, name: 'Object 100', person: 'Bill', city: 'San Francisco' })
    adapter.create(101,{ _id: 101, name: 'Object 101', person: 'Bob', city: 'San Francisco' })
    adapter.create(102,{ _id: 102, name: 'Object 102', person: 'Kimbo', city: 'Melbourne' })
    rows = adapter.query({ mode: :equal, city: 'San Francisco' })
    expect(rows.size).to eq 2
    rows = adapter.query({ mode: :equal, city: 'Melbourne' })
    expect(rows.size).to eq 1
    rows = adapter.query({ mode: :equal, city: 'Sydney' })
    expect(rows.size).to eq 0
  end
  it 'queries like' do
    adapter.create(100,{ _id: 100, name: 'Object 100', person: 'Bill', city: 'San Francisco' })
    adapter.create(101,{ _id: 101, name: 'Object 101', person: 'Bob', city: 'San Francisco' })
    adapter.create(102,{ _id: 102, name: 'Object 102', person: 'Kimbo', city: 'Melbourne' })
    adapter.create(103,{ _id: 103, name: 'Object 103', person: 'Benjamin', city: 'Melbourne' })
    expect(adapter.query({ mode: :like, city: 'San' }).size).to eq 2
    expect(adapter.query({ mode: :like, city: 'cisco' }).size).to eq 2
    expect(adapter.query({ mode: :like, city: 'Melb' }).size).to eq 2
    expect(adapter.query({ mode: :like, city: 'o' }).size).to eq 4
    expect(adapter.query({ mode: :like, city: 'Syd' }).size).to eq 0
    expect(adapter.query({ mode: :like, person: 'k' }).size).to eq 1
    expect(adapter.query({ mode: :like, person: 'j' }).size).to eq 1
  end
end
