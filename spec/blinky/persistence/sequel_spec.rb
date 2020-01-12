require 'spec_helper'

require 'sequel'

require_relative '../../../blinky/persistence/sequel'
require_relative '../../../blinky/constants'

describe Blinky::Repository::Sequel do

  context 'Create' do
    skip 'Creates' do
      db = Blinky::Repository::Sequel.new
      db.create_tables
      fd    = IO.read('blinky/data/organizations.json')
      pairs = JSON.parse(fd, symbolize_names: true)
      db.load_organizations(pairs)
      ap db.organizations.all
    end
  end

end
