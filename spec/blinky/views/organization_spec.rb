require 'spec_helper'

require 'constants'
require 'utils'

require 'persistence/adapter_delegation'
require 'persistence/users_repo'
require 'persistence/tickets_repo'
require 'persistence/organizations_repo'

require 'views/master_view'

require 'views/ticket'
require 'views/ticket_partial'
require 'views/user'
require 'views/user_partial'
require 'views/organization'
require 'views/organization_partial'

describe Blinky::Views::Organization do
  before do
    # Load up test data
    file_name = './spec/support/organizations_test.json'
    json      = IO.read(file_name)
    @objects  = JSON.parse(json, symbolize_names: true)
  end
  it 'renders without references' do
    view     = Blinky::Views::Organization.new
    rendered = view.render(@objects[0])
    expected = %(Organization
            _id: 101
            url: http://initech.zendesk.com/api/v2/organizations/101.json
    external_id: 9270ed79-35eb-4a38-a46f-35725197ea8d
           name: Enthaze
   domain_names: ["kage.com", "ecratic.com", "endipin.com", "zentix.com"]
     created_at: 2016-05-21T11:10:28 -10:00
        details: MegaCorp
 shared_tickets: false
           tags: ["Fulton", "West", "Rodriguez", "Farley"]
)
    expect(rendered).to eq(expected)
  end
  it 'renders with references' do
    view     = Blinky::Views::Organization.new
    rendered = view.render(@objects[0], true)
    expected = %(Organization
            _id: 101
            url: http://initech.zendesk.com/api/v2/organizations/101.json
    external_id: 9270ed79-35eb-4a38-a46f-35725197ea8d
           name: Enthaze
   domain_names: ["kage.com", "ecratic.com", "endipin.com", "zentix.com"]
     created_at: 2016-05-21T11:10:28 -10:00
        details: MegaCorp
 shared_tickets: false
           tags: ["Fulton", "West", "Rodriguez", "Farley"]
           User: Loraine Pittman
)
    expect(rendered).to eq(expected)
  end
end