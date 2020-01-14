# frozen_string_literal: true

module Blinky
  module Constants
    ENV_VAR_NAMES = %w[TICKETS USERS ORGANIZATIONS].freeze

    MESSAGES = {
      env_var_not_present:       'is not present',
      env_var_is_blank:          'is blank',
      env_var_file_not_found:    'does not name an existing file',
      env_var_file_not_a_file:   'is not a file',
      env_var_file_not_readable: 'does not name a readable file',
      env_var_file_error:        'caused an error'
    }.freeze

    SCHEMAS = {
      tickets:       {
        _id:             { type: :guid },
        url:             { type: :url },
        external_id:     { type: :guid },
        created_at:      { type: :datetime },
        type:            { type: :string, allowed: %w[incident problem question task], default: 'incident' },
        subject:         { type: :string },
        description:     { type: :string, default: '' },
        priority:        { type: :string, allowed: %w[high low normal urgent] },
        status:          { type: :string, allowed: %w[closed hold open pending solved] },
        submitter_id:    { type: :integer },
        assignee_id:     { type: :integer, default: 0 },
        organization_id: { type: :integer, default: 0 },
        tags:            { type: :array, subtype: :string },
        has_incidents:   { type: :boolean },
        due_at:          { type: :datetime, default: '1970-01-01T00:00:00 -10:00' },
        via:             { type: :string, allowed: %w[chat voice web] }
      },
      users:         {
        _id:             { type: :integer },
        url:             { type: :url },
        external_id:     { type: :guid },
        name:            { type: :string },
        alias:           { type: :string, default: '' },
        created_at:      { type: :datetime },
        active:          { type: :boolean },
        verified:        { type: :boolean, default: false },
        shared:          { type: :boolean },
        locale:          { type: :locale, default: '' },
        timezone:        { type: :timezone, default: '' },
        last_login_at:   { type: :datetime },
        email:           { type: :email, default: 'nobody@nowhere.com' },
        phone:           { type: :regex, match: /\d\d\d\d-\d\d\d-\d\d\d/ },
        signature:       { type: :string },
        organization_id: { type: :integer, default: 0 },
        tags:            { type: :array, subtype: :string },
        suspended:       { type: :boolean },
        role:            { type: :string, allowed: %w[admin agent end_user] }
      },
      organizations: {
        _id:            { type: :integer },
        url:            { type: :url },
        external_id:    { type: :guid },
        name:           { type: :string },
        domain_names:   { type: :array },
        created_at:     { type: :datetime },
        details:        { type: :string },
        shared_tickets: { type: :boolean },
        tags:           { type: :array, subtype: :string }
      }
    }.freeze
  end
end
