# ActiveRecord::Comments

Manage comments for SQL schemas. Set, get and remove comments on tables and columns. ActiveRecord bindings and executable with CLI.

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-comments'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-comments

## Executable usage

    Set the DB environment variable to select from database configurations. Current value: "postgres"
        -a, --action ACTION              Action to perform: set, retrieve, remove
        -t, --table TABLE                Select table
        -c, --column COLUMN              Select column
        -m, --comment COMMENT            Comment to save
            --conf DBCONF                Database config YAML (default: /Users/<user>/activerecord_comments/config/database.yml)
