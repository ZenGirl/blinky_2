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


## Notes

### git and bash

I like to see which branch I'm working on, so I these lines to my `.bashrc`:

```
# -----------------------------------------------------------------------------
# Colorization
# -----------------------------------------------------------------------------
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Regular
txtblk='\e[0;30m' # Black
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White

# Bold
bldblk='\e[1;30m' # Black
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White

# Underline
unkblk='\e[4;30m' # Black
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White

# Background
bakblk='\e[40m'   # Black
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

find_git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    git_branch="($branch)"
  else
    git_branch=""
  fi
}

find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    git_dirty='*'
  else
    git_dirty=''
  fi
}

PROMPT_COMMAND="find_git_branch; find_git_dirty; $PROMPT_COMMAND"

export PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "
export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
```
