require 'spec_helper'

require_relative '../../../blinky/persistence/repo'

describe Blinky::Persistence::Repo do
  it 'assigns adapter' do
    class DummyAdapter

    end
    Blinky::Persistence::Repo.adapter = DummyAdapter
    expect(Blinky::Persistence::Repo.adapter.name).to eq 'DummyAdapter'
  end
end