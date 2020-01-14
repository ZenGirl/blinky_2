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

describe Blinky::Views::User do
  before do

    # Use a dummy organizations adapter
    adapter = double
    allow(adapter).to receive(:find_by_id).with(110).and_return({ _id: 110, name: 'Jacks Corp' })
    Blinky::Persistence::OrganizationsRepo.adapter = adapter

    # Load up test data
    file_name = './spec/support/users_test.json'
    json      = IO.read(file_name)
    @objects  = JSON.parse(json, symbolize_names: true)

  end
  it 'renders without references' do
    view                          = Blinky::Views::User.new
    @objects[0][:submitter_id]    = 1
    @objects[0][:assignee_id]     = 2
    @objects[0][:organization_id] = 110
    rendered                      = view.render(@objects[0])
    expected                      = %(User
            _id: 1
            url: http://initech.zendesk.com/api/v2/users/1.json
    external_id: 74341f74-9c79-49d5-9611-87ef9b6eb75f
           name: Francisca Rasmussen
          alias: Miss Coffey
     created_at: 2016-04-15T05:19:46 -10:00
         active: true
       verified: true
         shared: false
         locale: en-AU
       timezone: Sri Lanka
  last_login_at: 2013-08-04T01:03:27 -10:00
          email: coffeyrasmussen@flotonic.com
          phone: 8335-422-718
      signature: Don't Worry Be Happy!
organization_id: 110
           tags: ["Springville", "Sutton", "Hartsville/Hartley", "Diaperville"]
      suspended: true
           role: admin
)
    expect(rendered).to eq(expected)
  end
  it 'renders with references' do
    view                          = Blinky::Views::User.new
    @objects[0][:submitter_id]    = 1
    @objects[0][:assignee_id]     = 2
    @objects[0][:organization_id] = 110
    rendered                      = view.render(@objects[0], true)
    expected                      = %(User
            _id: 1
            url: http://initech.zendesk.com/api/v2/users/1.json
    external_id: 74341f74-9c79-49d5-9611-87ef9b6eb75f
           name: Francisca Rasmussen
          alias: Miss Coffey
     created_at: 2016-04-15T05:19:46 -10:00
         active: true
       verified: true
         shared: false
         locale: en-AU
       timezone: Sri Lanka
  last_login_at: 2013-08-04T01:03:27 -10:00
          email: coffeyrasmussen@flotonic.com
          phone: 8335-422-718
      signature: Don't Worry Be Happy!
organization_id: 110
           tags: ["Springville", "Sutton", "Hartsville/Hartley", "Diaperville"]
      suspended: true
           role: admin
   Organization: Jacks Corp
        Tickets:
)
    expect(rendered).to eq(expected)
  end
end