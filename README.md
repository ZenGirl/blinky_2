# blinky2 - A simply CLI for search

This is a simple CLI program to handle the ZenDesk code challenge.
The original PDF is in the `docs` directory.

The current ruby version is `2.6.2` as noted in the `.ruby-version` file.

The gemset is named `blinky_2` as this is a 2nd shot at doing the challenge.

The project name comes from the Blinky Bill comics.

**NOTE:** Slight mistake: The code folder should be `lib` not `blinky`. My bad. Will be fixed. Only just noticed.

**NOTE:** This project uses the `JFormalize` gem which is one I created based on previous requirements.
[See here for details] (https://github.com/ZenGirl/JFormalize) 

The `JFormalize` gem handles all the grunt work of opening, reading and parsing of a JSON file.
The last act of the gem is to **formalize** the raw hash objects against a provided schema.
This avoids the grunt work of validating keys and values.

I have used a simple `InMemory` adapter to provide a repository pattern.
The repository pattern used is as follows:

A repo:

```ruby
module Blinky
  module Persistence
    class SomeRepo
      extend AdapterDelegation
    end
  end
end
```

The `AdapterDelegation` inserts some standard calls to a data set and allows assigning an adapter.
An adapter then implements those standard calls.
Only an `InMemory` adapter is used, but adapters for `Sqlite`, `MySql` or `MSSQL` could easily be created.

No relationships are handled at present.
That is, no `has_many` relations are provided.
(Exercise for the reader?) 

> Strictly speaking, the repository classes should be gemified, but that can come later.

## Installation

Use:

```bash
bundle install
```

## Testing

    clear; bundle exec rspec; bundle exec rubocop

I used `rspec`, `rubocop` and `simple_cov` for testing and coverage.
I could have used `minitest`, but it seems more fitting to use common testing.

The `JFormalize` gem uses `minitest` as it is important to have no external dependencies in it.

Once the tests have been run, the code coverage can be viewed [here](./coverage/index.html).

> Obviously this won't show up in github.

## Usage

To run the app:

`./run.sh`

Or:

`clear; TICKETS=./data/tickets.json USERS=./data/users.json ORGANIZATIONS=./data/organizations.json bundle exec ruby blinky.rb`

This validates the environment, loads the data and provides an input prompt.
If any errors have occurred they are shown and the process aborts.

For example:
```
$ clear; USERS=./data/users.json ORGANIZATIONS=./data/organizations.json bundle exec ruby blinky.rb
Welcome to Blinky search!
A simple CLI for search for a coding challenge.
Errors occurred during load:
TICKETS is not present
  
  
Bye
```

The data includes tickets, organizations and users.
Because the application uses the `JFormalize` gem, the data is validated and defaulted by that gem.
For example, in the test data provided, some JSON objects are missing required keys or have invalid data.
The `JFormalize` adjusts these values during its operation so the main application can be assured of validated, formalized data.

The requirements specify that the 'output is not prescriptive' implies that the input is 'prescriptive'.
As such the input process follows the "Call Centre Approach" described in the specifications.

The first display shows a banner and input options plus a blue colorized prompt:

```
Welcome to Blinky search!
A simple CLI for search for a coding challenge.

Type quit [enter] to exit at any time.
Type help [enter] to view this message.

        Select search options:
        * Type 1 to search datasets (Users, Tickets or Organizations)
        * Type 2 to view a list of searchable fields

 >
```  

At this point the user can type `quit`, `help`, `1` or `2`.
> The process allows for `^C` at any point

The `2` option shows the fields for each dataset as prescribed in the specification.

The `1` option moves into search mode, as denoted by the yellow prompt:

```
Select 1) Users or 2) Tickets or 3) Organizations or 4) exit to main menu.
 >
```

Option `4` is obvious.
Each of the other options sets the repository to search.
Choosing any of the `1`, `2` or `3` option switches to a set of purple prompts requesting the field name and value.

Example:

```
Enter search field
 > _id
Enter search value
 > 1
Searching Users for _id with a value of '1'
```

If the search field is not recognized for that repository, then the user is advised:

```
Select 1) Users or 2) Tickets or 3) Organizations or 4) exit to main menu.
 > 1
Enter search field
 > goober bongo
The field [goober] is unknown
```

If the field is recognized, then the value is checked.
If it contains any `*` characters, then a `like` search is initiated.
Otherwise, an `equal` search is initiated.

In both cases, case is not significant.

An example run:

```
Welcome to Blinky search!
A simple CLI for search for a coding challenge.

Type quit [enter] to exit at any time.
Type help [enter] to view this message.

        Select search options:
        * Type 1 to search
        * Type 2 to view a list of searchable fields

 > 1
Select 1) Users or 2) Tickets or 3) Organizations or 4) exit to main menu.
 > 1
Enter search field
 > _id
Enter search value
 > 1
Searching Users for _id with a value of '1'
User
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
organization_id: 119
           tags: ["Springville", "Sutton", "Hartsville/Hartley", "Diaperville"]
      suspended: true
           role: admin
   Organization: Multron
        Tickets:
       Assigned: [solved] A Problem in Russian Federation
       Assigned: [solved] A Problem in Malawi
      Submitted: [open] A Nuisance in Kiribati
      Submitted: [pending] A Nuisance in Saint Lucia
Select 1) Users or 2) Tickets or 3) Organizations or 4) exit to main menu.
 >
```

Note that referenced items are included.
In this case (`Users`), these are the organization and tickets.
The same is true for `Tickets` and `Organizations`. 

## Processing

The aim of this process is simplicity and separation of concerns.
As such, I used Interactors.
These are simple ways to divide up a chain of process into discrete sections with a fail fast approach.
Interactors hold a *context* which allows information about the process to be chained together.

The main process configures the required files, and uses an Organizer to chain 3 interactors.
These are `EnvLoad`, `JsonValidator`, `Loader` and `Actor`.

## Git

[Full details](./GitFlow.md)
[Bash details](./GitBash.md)

