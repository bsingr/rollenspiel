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

### Define role grantees

```ruby
class YourUser < ActiveRecord::Base
  # this makes your user model an grantee of roles
  role_grantee
end
```

### Grant a role to a role grantee

```ruby
user = YourUser.create
Role.new(name: :manager).grant! user
```

### Query if a role grantee has a role

```ruby
user.role?(:manager)        # true
user.role?(:does_not_exist) # false
```

### Define providers for roles

```ruby
class YourResource < ActiveRecord::Base
  role_provider
end

class YourOtherResource < ActiveRecord::Base
  role_provider
end
```

### Grant roles provided by provider

On class level

```ruby
YourResource.role(:dealer).grant! user

user.role?(:dealer)                    # true
user.role?(:dealer, YourResource)      # true
user.role?(:dealer, YourOtherResource) # false
```

On instance level

```ruby
car = YourResource.create name: "Car"
bike = YourResource.create name: "Bike"

car.role(:grantee).grant! user
bike.role(:use).grant! user

user.role?(car.role(:grantee))       # true
user.role?(car.role(:use))           # true
user.role?(bike.role(:grantee))      # false
user.role?(bike.role(:use))          # true
user.role?(:sell)                    # true
user.role?(:sell, YourResource)      # true
user.role?(:sell, YourOtherResource) # false
```

### Queries

List providers of role

```ruby
YourResource.by_role(name: :sell)
YourResource.by_role(grantee: user)
YourResource.by_role(name: :sell, :grantee: user)
```

List grantees of role

```ruby
User.by_role(name: :sell)
User.by_role(provider: car)
User.by_role(name: :sell, provider: car)
```


This project rocks and uses MIT-LICENSE.
