# blinky2 - A simply CLI for search

This is a simple CLI program to handle the ZenDesk code challenge.
The original PDF is in the `docs` directory.

The current ruby version is `2.6.2` as noted in the `.ruby-version` file.

The gemset is named `blinky_2` as this is a 2nd shot at doing the challenge.

The project name comes from the Blinky Bill comics.

## Usage

Download gems:

`cd [to folder]; bundle install`

To run the app:

`clear;export BLINKY_DATA_HOME='./data'; ruby blinky.rb`

This validates the environment, loads the data, displays 
some statistics and provides an input prompt.

The data includes tickets, organizations and users. 

Valid input prompts are:

`[group] [field_name] [criteria]`

Examples:

You can quit by entering "quit" at the prompt.

There are 3 "groups": users, organizations and tickets.

Groups can be searched by entering a phrases like:

-  users _id 5
-  users name Rose Newton
-  tickets priority high
-  tickets _id 436bf9b0-1147-4c0a-8439-6f79833bff5b
-  organizations name nutralab

There are several "status" commands shown below. 

Status examples:

| command | meaning |
| ------- | ------- |
| help      | Display the help message |
| stats     | Show current groups and row totals |

## Processing

The aim of this process is simplicity and separation of concerns.
As such, I used Interactors.
These are simple ways to divide up a chain of process into discrete sections with a fail fast approach.
Interactors hold a *context* which allows information about the process to be chained together.

The main process configures the required files, and uses an Organizer to chain 3 interactors.
These are `PreLoad`, `Validator`, `Loader` and `Actor`.


