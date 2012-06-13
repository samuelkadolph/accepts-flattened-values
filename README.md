# accepts-flattened-values

accepts-flattened-values is an ActiveRecord mixin to flatten a `has_many` or `has_and_belongs_to_many` assocation.

## Description

accepts-flattened-values is a mixin for ActiveRecord to be used on any model with a `has_many` or `has_and_belongs_to_many`
association. The purpose of this mixin is to simplify a tag like association for any model or association.

## Installation

Add this line to your application's Gemfile:

    gem "accepts-flattened-values"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install accepts-flattened-values

## Usage

```ruby
require "accepts-flattened-values"

create_table(:users) { |t| t.string :name }
create_table(:interests) { |t| t.string :value }
create_table(:interests_users, id: false) do |t|
  t.references :interest
  t.references :user
end

class Interest < ActiveRecord::Base
  attr_accessible :value
end

class User < ActiveRecord::Base
  include AcceptsFlattenedValues

  attr_accessible :name

  has_and_belongs_to_many :interests
  accepts_flattened_values_for :interests
end

user = User.create!(name: "Sam")
user.interests.create!(value: "ruby")
user.interests.create!(value: "ruby on rails")
user.interests.create!(value: "starcraft")
user.interests_values # => "ruby,ruby on rails,starcraft"

user.interests_values = "ruby,battlefield"
user.interests # => [#<Interest value: "ruby">, #<Interest value: "battlefield">]

<%= form_for @user do |f| %>
  <%= f.label :interests_values %>:
  <%= f.text_field :interests_values %>
<% end %>
```

## Contributing

Fork, branch & pull request.
