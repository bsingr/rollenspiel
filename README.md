# Rollenspiel

Rails engine for role management for ActiveRecord. Supports scoping and inheritance.

## Requirements

  * Rails 4.2
  * ActiveRecord

## Installation

Add this to your Gemfile

    gem 'rollenspiel'

Then run

    bundle install

And install the migrations

    rake rollenspiel:install:migrations

## Getting Started

For some examples please have a look into [test/dummy/app/models](test/dummy/app/models).

```ruby
# 1) you can create simple, unscoped roles like so
manager_role = Role.create name: :manager

# 2) roles can be granted to role owners

# first, define a role owner model
class YourUser < ActiveRecord::Base
  # this makes your user model an owner of roles
  include ::Rollenspiel::RoleOwner
end

# then grant a role to a new role owner
user = YourUser.create
manager_role.grant_to! user

# and query if the role owner has a role
user.role?(manager_role)    # true
user.role?(:manager)        # true
user.role?(:does_not_exist) # false

# 3) inherit roles

...

# 4) scoped roles

...

class YourResource < ActiveRecord::Base
  # this makes your resource a scope to be used in roles
  include ::Rollenspiel::RoleScope

  # here you can define default roles that get automatically created
  # whenever a new instance of your resource is created
  define_roles do |builder, record|

    # this is a simple read role
    builder.role :read

    # you can add multiple roles at once
    builder.role :read, :write

    # and you can group roles together (single level inheritance)
    builder.role :manager, inherits: [:read, :write]

    # you can even re-use existing roles to inherit new roles
    builder.role Role.find(:manager), inherits: [:read, :write]
  end
end

# 5) inherited + scopes roles

...

# 6) query for role owners

...
```


This project rocks and uses MIT-LICENSE.
