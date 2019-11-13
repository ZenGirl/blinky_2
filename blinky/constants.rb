module Blinky
  module Constants
    ENV_VAR_NAMES = %w[TICKETS USERS ORGANISATIONS].freeze

    # rubocop:disable Metrics/LineLength, Layout/AlignHash
    # Disabled because it shows irritating message which provides no perceivable benefit
    MESSAGES = {
      not_present:  'environment variable is not present',
      not_usable:   'environment variable is blank',
      not_found:    'does not name an existing file',
      not_readable: 'does not name a readable file'
    }.freeze
    # rubocop:enable Metrics/LineLength, Layout/AlignHash

    # rubocop:disable Metrics/LineLength, Layout/AlignHash, Layout/AlignArray, Style/PercentLiteralDelimiters, Layout/SpaceInsideHashLiteralBraces
    SCHEMAS = {
      ticket:       {
        required:   %w(_id url external_id created_at type subject description
                       priority status submitter_id assignee_id organization_id
                       tags has_incidents due_at via),
        properties: {
          _id:             {type: :guid},
          url:             {type: :url},
          external_id:     {type: :guid},
          created_at:      {type: :date},
          type:            {type: :string},
          subject:         {type: :string},
          description:     {type: :string},
          priority:        {type: :string, members: %w(high low normal urgent)},
          status:          {type: :string, members: %w(closed hold open pending solved)},
          submitter_id:    {type: :integer},
          assignee_id:     {type: :integer},
          organization_id: {type: :integer},
          tags:            {type: :array, sub_type: :string},
          has_incident:    {type: :boolean},
          due_at:          {type: :date},
          via:             {type: :string}
        }
      },
      user:         {
        required:   %w(_id url external_id name alias created_at active
                    verified shared locale timezone last_login_at
                    email phone signature organization_id tags suspended role),
        properties: {
          _id:             {type: :integer},
          url:             {type: :string},
          external_id:     {type: :guid},
          name:            {type: :string},
          alias:           {type: :string},
          created_at:      {type: :date},
          active:          {type: :boolean},
          verified:        {type: :boolean},
          shared:          {type: :boolean},
          locale:          {type: :locale},
          timezone:        {type: :timezone},
          last_login_at:   {type: :date},
          email:           {type: :email},
          phone:           {type: :regex, pattern: /\d\d\d\d-\d\d\d-\d\d\d/},
          signature:       {type: :string},
          organization_id: {type: :integer},
          tags:            {type: :array, sub_type: :string},
          suspended:       {type: :boolean},
          role:            {type: :string, members: %w(admin agent end-user)}
        }
      },
      organization: {
        required:   %w(_id url external_id name domain_names
                    created_at details shared_tickets tags),
        properties: {
          _id:            {type: :integer},
          url:            {type: :string},
          external_id:    {type: :guid},
          name:           {type: :string},
          domain_names:   {type: :array, sub_type: :string},
          created_at:     {type: :date},
          shared_tickets: {type: :boolean},
          tags:           {type: :array, sub_type: :string}
        }
      }
    }.freeze
    # rubocop:enable Metrics/LineLength, Layout/AlignHash, Layout/AlignArray, Style/PercentLiteralDelimiters, Layout/SpaceInsideHashLiteralBraces
  end
end
