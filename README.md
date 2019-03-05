# Sequel::Through

[![Gem Version](https://badge.fury.io/rb/sequel-through.svg)](https://badge.fury.io/rb/sequel-through)
[![Build Status](https://secure.travis-ci.org/kenaniah/sequel-through.svg)](https://travis-ci.org/kenaniah/sequel-through)
[![Inline docs](https://inch-ci.org/github/kenaniah/sequel-through.svg?branch=master)](https://inch-ci.org/github/kenaniah/sequel-through)

This gem extends [sequel](https://github.com/jeremyevans/sequel)'s associations to provide the ability to create associations that flow through other associations, similar to how `:through` works in [ActiveRecord](https://guides.rubyonrails.org/association_basics.html#the-has-many-through-association).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sequel-through'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel-through

## Usage

```ruby
# Load the plugin
Sequel::Model.plugin :cyclical_through_associations

class User < Sequel::Model
  one_to_many :user_has_security_groups
  one_to_many :security_groups, through: :user_has_security_groups
  one_to_many :privileges, through: :security_groups
end
class SecurityGroup < Sequel::Model
  one_to_many :security_group_has_privileges
  one_to_many :privileges, through: :security_group_has_privileges
end
class Privilege < Sequel::Model
end
class UserHasSecurityGroup < Sequel::Model
  many_to_one :user
  many_to_one :security_group
  one_to_many :privileges, through: :security_group
end
class SecurityGroupHasPrivilege < Sequel::Model
  many_to_one :security_group
  many_to_one :privilege
end

# Solve any cyclical dependencies (when :cyclical_through_associations is used)
Sequel::Model.solve_cyclical_associations!

# Use the intermediate associations
User.first.security_groups # => [#<SecurityGroup 1>, #<SecurityGroup 2> ...]
User.first.privileges # => [#<Privilege A>, #<Privilege B> ...]
```

This plugin adds an optional `:through` key for `*_to_one` and `*_to_many` associations. When `:through` is provided,  intermediary associations are traversed and a single `one_through_many` or `many_through_many` association is added to the base model using a JOIN structure calculated from the associations traversed.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kenaniah/sequel-through.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
