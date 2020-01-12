require 'spec_helper'

require 'rom'

require_relative '../../../blinky/persistence/rom'
#require_relative '../../../blinky/constants'

describe Blinky::Repository do
  context 'Users' do
    skip 'loads' do
      fd     = IO.read('blinky/data/organizations.json')
      schema = Blinky::Constants::SCHEMAS[:organizations]
      orgs = Blinky::Repository::Rom.relations[:organizations]
      JSON.parse(fd, symbolize_names: true).each do |pair|
        #p pair
        pair[:domain_names]   = pair[:domain_names].join(',')
        pair[:shared_tickets] = pair[:shared_tickets] ? 1 : 0
        pair[:tags]           = pair[:tags].join(',')
        p pair
        orgs.changeset(:create, pair).commit
      end
      p '-----------------------------------'
      orgs.select.each do |row|
        ap row
      end
      p '==================================='
    end
  end
end