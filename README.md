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

You can create simple, unscoped roles like so

```ruby
manager_role = Role.create name: :manager
```

Roles can be granted to role owners

```ruby
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
```

Inherit roles

```ruby
read_role = Role.create name: :read
manager_role.inherit! read_role

user.role?(read_role) # true
```

Scoped roles

```ruby

class YourResource < ActiveRecord::Base
  # this makes your resource a scope to be used in roles
  include ::Rollenspiel::RoleScope

  # here you can define default roles that get automatically created
  # whenever a new instance of your resource is created
  define_roles do |builder, record|

    # this is a simple read role
    builder.role :use

    # you can add multiple roles at once
    builder.role :use, :sell

    # and you can group roles together (single level inheritance)
    builder.role :owner, inherits: [:use, :sell]

    # you can even re-use existing roles to inherit new roles
    builder.role manager_role, inherits: [:use, :sell]
  end
end

car = Resource.create name: "Car"
bike = Resource.create name: "Bike"

car.role(:owner).grant_to! user
bike.role(:use).grant_to! user

user.role?(car.role(:owner))    # true
user.role?(car.role(:use))      # true
user.role?(bike.role(:owner))   # false
user.role?(bike.role(:use))     # true
user.role?(:sell)               # true
user.role?(:sell, YourResource) # true
user.role?(:sell, YourUser)     # false
```

query for role owners

```ruby
resource.owners_of_role(:manager)
resource.indirect_owners_of_role(:read)
```


This project rocks and uses MIT-LICENSE.
