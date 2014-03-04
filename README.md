[![Build Status](https://travis-ci.org/MirkoMignini/acts_as_default.png?branch=master)](https://travis-ci.org/MirkoMignini/acts_as_default)

# ActsAsDefault

Using acts as default you can set a default row in your activerecord collection, also for has_many relationships

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_default'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_default

## Usage

Include ActsAsDefault in the models when you need a default row
Call acts_as_default, specifying which field, is present to determine sub-collections

```ruby
class Parent < ActiveRecord::Base
  include ActsAsDefault
  acts_as_default
  has_many :sons
end

class Son < ActiveRecord::Base
  include ActsAsDefault
  acts_as_default :parent_id
  belongs_to :parent
end
```

Then create a migration to create default column:

```ruby
add_column :parents, :default, :boolean
add_column :sons, :default, :boolean
```

## Using default value in the simple way:

```ruby
p1 = Parent.new
p1.save!
p2 = Parent.new
p2.save!
p3 = Parent.new
p3.save!
puts p1.default #true, because was the first created
puts p2.default #false, because a default is already present
puts p3.default #false, because a default is already present

p3.destroy! #if we destroy a non default object nothing happens

p1.destroy! #but if we destroy the default object...
p2.reload #don't forget to reload to see changes
puts p2.default #true, now p2 is default, because was the only one present, in case of more the recent based on created_at will become the default
```

## Setting the default manually

You can always call:
```ruby
p1 = Parent.new
p2 = Parent.new

puts p1.default #true, because was the first created
puts p2.default #false, because a default is already present

model.set_as_default!
```
To immediately switch the object as default and save.

## Using default value in the complex way:

You can use acts_as_default to manage default for collection in has_many relationships
```ruby
p1 = Parent.new
p2 = Parent.new

s1 = Son.new
s1.parent = p1
s1.save!

s2 = Son.new
s2.parent = p1
s2.save!

s3 = Son.new
s3.parent = p2
s3.save!

puts s1.default #true, because was the first created for p1
puts s2.default #false, because a default is already present in p1
puts s3.default #true, because was the first created for p2
```

## Contributing

1. Fork it ( http://github.com/MirkoMignini/acts_as_default/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
