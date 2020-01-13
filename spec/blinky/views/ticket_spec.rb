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

describe Blinky::Views::Ticket do
  before do

    # Use a dummy users adapter
    adapter = double
    allow(adapter).to receive(:find_by_id).with(1).and_return({ _id: 1, name: 'Alonso' })
    allow(adapter).to receive(:find_by_id).with(2).and_return({ _id: 2, name: 'Bongo' })
    Blinky::Persistence::UsersRepo.adapter = adapter

    # Use a dummy organizations adapter
    adapter = double
    allow(adapter).to receive(:find_by_id).with(110).and_return({ _id: 110, name: 'Jacks Corp' })
    Blinky::Persistence::OrganizationsRepo.adapter = adapter

    # Load up test data
    file_name = './spec/support/tickets_test.json'
    json      = IO.read(file_name)
    @objects  = JSON.parse(json, symbolize_names: true)

  end
  it 'renders without references' do
    view                          = Blinky::Views::Ticket.new
    @objects[0][:submitter_id]    = 1
    @objects[0][:assignee_id]     = 2
    @objects[0][:organization_id] = 110
    rendered                      = view.render(@objects[0])
    expected                      = %(Ticket
            _id: 436bf9b0-1147-4c0a-8439-6f79833bff5b
            url: http://initech.zendesk.com/api/v2/tickets/436bf9b0-1147-4c0a-8439-6f79833bff5b.json
    external_id: 9210cdc9-4bee-485f-a078-35396cd74063
     created_at: 2016-04-28T11:19:34 -10:00
           type: incident
        subject: A Catastrophe in Korea (North)
    description: Nostrud ad sit velit cupidatat laboris ipsum nisi amet laboris ex exercitation amet et proident. Ipsum fugiat aute dolore tempor nostrud velit ipsum.
       priority: high
         status: pending
   submitter_id: 1
    assignee_id: 2
organization_id: 110
           tags: ["Ohio", "Pennsylvania", "American Samoa", "Northern Mariana Islands"]
  has_incidents: false
         due_at: 2016-07-31T02:37:50 -10:00
            via: web
)
    expect(rendered).to eq(expected)
  end
  it 'renders with references' do
    view                          = Blinky::Views::Ticket.new
    @objects[0][:submitter_id]    = 1
    @objects[0][:assignee_id]     = 2
    @objects[0][:organization_id] = 110
    rendered                      = view.render(@objects[0], true)
    expected                      = %(Ticket
            _id: 436bf9b0-1147-4c0a-8439-6f79833bff5b
            url: http://initech.zendesk.com/api/v2/tickets/436bf9b0-1147-4c0a-8439-6f79833bff5b.json
    external_id: 9210cdc9-4bee-485f-a078-35396cd74063
     created_at: 2016-04-28T11:19:34 -10:00
           type: incident
        subject: A Catastrophe in Korea (North)
    description: Nostrud ad sit velit cupidatat laboris ipsum nisi amet laboris ex exercitation amet et proident. Ipsum fugiat aute dolore tempor nostrud velit ipsum.
       priority: high
         status: pending
   submitter_id: 1
    assignee_id: 2
organization_id: 110
           tags: ["Ohio", "Pennsylvania", "American Samoa", "Northern Mariana Islands"]
  has_incidents: false
         due_at: 2016-07-31T02:37:50 -10:00
            via: web
      Submitter: Alonso
       Assignee: Bongo
   Organization: Jacks Corp
)
    expect(rendered).to eq(expected)
  end
end