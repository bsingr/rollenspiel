# Rollenspiel

Rails engine for role management for ActiveRecord. Supports scoping and inheritance.

[![Build Status](https://travis-ci.org/bsingr/rollenspiel.svg)](https://travis-ci.org/bsingr/rollenspiel)
[![Code Climate](https://codeclimate.com/github/bsingr/rollenspiel/badges/gpa.svg)](https://codeclimate.com/github/bsingr/rollenspiel)
[![Test Coverage](https://codeclimate.com/github/bsingr/rollenspiel/badges/coverage.svg)](https://codeclimate.com/github/bsingr/rollenspiel)

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

### Create roles

```ruby
manager_role = Role.create name: :manager
```

### Define role grantees

```ruby
class YourUser < ActiveRecord::Base
  # this makes your user model an grantee of roles
  include ::Rollenspiel::RoleGrantee
end
```

### Grant a role to a role grantee

```ruby
user = YourUser.create
manager_role.grant_to! user
```

### Query if a role grantee has a role

```ruby
user.role?(manager_role)    # true
user.role?(:manager)        # true
user.role?(:does_not_exist) # false
```

### Inherit roles

```ruby
read_role = Role.create name: :read
manager_role.inherit! read_role

user.role?(read_role) # true
```

### Define a provider for roles

```ruby
class YourResource < ActiveRecord::Base
  # this makes your resource a provider of roles
  # here you can define default roles that get automatically created
  # whenever a new instance of your resource is created
  provides_roles_on_instance do |p, record|
    # this is a simple read role
    p.role :use

    # you can add multiple roles at once
    p.role :use, :sell

    # and you can group roles together (single level inheritance)
    p.role :grantee, inherits: [:use, :sell]

    # you can even re-use existing roles to inherit new roles
    p.role manager_role, inherits: [:use, :sell]
  end

  # alternatively OR additionaly use this to provide roles on class level
  provides_roles_on_instance do |p|
    p.role :dealer
  end
end
```

### Grant roles provided by provider

```ruby
car = YourResource.create name: "Car"
bike = YourResource.create name: "Bike"

car.role(:grantee).grant_to! user
bike.role(:use).grant_to! user
YourResource.role(:dealer).grant_to! user

user.role?(car.role(:grantee))    # true
user.role?(car.role(:use))        # true
user.role?(bike.role(:grantee))   # false
user.role?(bike.role(:use))       # true
user.role?(:sell)                 # true
user.role?(:sell, YourResource)   # true
user.role?(:sell, YourUser)       # false
user.role?(:dealer)               # true
user.role?(:dealer, YourResource) # true
```

### Query for role grantees

```ruby
resource.grantees_of_role(:manager)
resource.indirect_grantees_of_role(:read)
```


This project rocks and uses MIT-LICENSE.
