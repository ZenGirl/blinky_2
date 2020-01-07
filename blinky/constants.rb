# frozen_string_literal: true

module Blinky
  module Constants
    ENV_VAR_NAMES = %w[TICKETS USERS ORGANIZATIONS].freeze

    # rubocop:disable Layout/AlignHash
    # Disabled because it shows irritating message which provides no perceivable benefit
    MESSAGES = {
        env_var_not_present:       'is not present',
        env_var_is_blank:          'is blank',
        env_var_file_not_found:    'does not name an existing file',
        env_var_file_not_a_file:   'is not a file',
        env_var_file_not_readable: 'does not name a readable file',
        env_var_file_error:        'caused an error'
    }.freeze
    # rubocop:enable Layout/AlignHash

    SCHEMAS = {
        tickets:       {
            _id:             {type: :guid},
            url:             {type: :url},
            external_id:     {type: :guid},
            created_at:      {type: :datetime},
            type:            {type: :string, allowed: %w[incident problem question task]},
            subject:         {type: :string},
            description:     {type: :string},
            priority:        {type: :string, allowed: %w[high low normal urgent]},
            status:          {type: :string, allowed: %w[closed hold open pending solved]},
            submitter_id:    {type: :integer},
            assignee_id:     {type: :integer},
            organization_id: {type: :integer},
            tags:            {type: :array, subtype: :string},
            has_incidents:   {type: :boolean},
            due_at:          {type: :datetime},
            via:             {type: :string, allowed: %w[chat voice web]}
        },
        users:         {
            _id:             {type: :integer},
            url:             {type: :url},
            external_id:     {type: :guid},
            name:            {type: :string},
            alias:           {type: :string},
            created_at:      {type: :datetime},
            active:          {type: :boolean},
            verified:        {type: :boolean},
            shared:          {type: :boolean},
            locale:          {type: :locale},
            timezone:        {type: :timezone},
            last_login_at:   {type: :datetime},
            email:           {type: :email},
            phone:           {type: :regex, match: /\d\d\d\d-\d\d\d-\d\d\d/},
            organization_id: {type: :integer},
            tags:            {type: :array, subtype: :string},
            suspended:       {type: :boolean},
            role:            {type: :string, allowed: %w[admin agent end_user]}
        },
        organizations: {
            _id:            {type: :integer},
            url:            {type: :url},
            external_id:    {type: :guid},
            name:           {type: :string},
            domain_names:   {type: :array},
            created_at:     {type: :datetime},
            details:        {type: :string},
            shared_tickets: {type: :boolean},
            tags:           {type: :array, subtype: :string}
        }
    }.freeze
  end
end
