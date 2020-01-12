require 'spec_helper'

require_relative '../../../blinky/persistence/repo'
require_relative '../../../blinky/persistence/repo_delegation'

describe Blinky::Persistence::RepoDelegation do
  it 'delegates from class to subject' do
    class OneRepo
      extend Blinky::Persistence::RepoDelegation
    end
    singleton_methods = OneRepo.singleton_methods
    expect(singleton_methods.include?(:save)).to be true
    expect(singleton_methods.include?(:all)).to be true
    expect(singleton_methods.include?(:find_by_id)).to be true
    expect(singleton_methods.include?(:query)).to be true
    expect(singleton_methods.include?(:create)).to be true
    expect(singleton_methods.include?(:clear)).to be true
  end
end