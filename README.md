# blinky2 - A simply CLI for search

This is a simple CLI program to handle the ZenDesk code challenge.
The original PDF is in the `docs` directory.

The current ruby version is `2.6.2` as noted in the `.ruby-version` file.

The gemset is named `blinky_2` as this is a 2nd shot at doing the challenge.

The project name comes from the Blinky Bill comics.

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

`clear;export BLINKY_DATA_HOME='./blinky/data'; ruby blinky.rb`

This validates the environment, loads the data, displays 
some statistics and provides an input prompt.

The data includes tickets, organizations and users. 

> Mor info to be added here soon!

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

