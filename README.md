# ActiveRecord::Comments

Manage comments for SQL schemas. Set, get and remove comments on tables and columns.

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-comments'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-comments

## Usage

    activerecord_comments [options]
        -t, --table TABLE                Select table
        -c, --column COLUMN              Select column
        -a, --action ACTION              Select action to perform
                                         ["set", "retrieve", "remove"]
        -m, --comment COMMENT            Comment to save
            --conf DBCONF                Database config YAML

