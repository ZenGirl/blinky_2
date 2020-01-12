require 'spec_helper'

#require 'sqlite3'

require_relative '../../../blinky/persistence/db'
require_relative '../../../blinky/constants'

describe Blinky::Repository::Db do
  context 'create' do
    skip 'creates users' do
      obj    = Blinky::Repository::Db.new
      fd     = IO.read('blinky/data/users.json')
      schema = Blinky::Constants::SCHEMAS[:users]
      sql    = "insert into users values (#{'?,' * (schema.keys.size - 1)}?)"
      JSON.parse(fd, symbolize_names: true).each do |pair|
        pair[:tags]      = pair[:tags].join(',')
        pair[:active]    = pair[:active] ? 1 : 0
        pair[:verified]  = pair[:verified] ? 1 : 0
        pair[:shared]    = pair[:shared] ? 1 : 0
        pair[:suspended] = pair[:suspended] ? 1 : 0
        stmt             = obj.dbc.prepare sql
        schema.keys.each_with_index do |key, idx|
          stmt.bind_param idx + 1, pair[key]
        end
        stmt.execute
        stmt.close
      end
      obj.dbc.execute("select * from users") do |row|
        p row
      end
    end
  end
end
