TrackIt
=======

TrackIt is a small gem which helps you keep track of changes in you ActiveRecord models persistently.
While ActiveModel::Dirty allows you to keep track on changes only when the change occurs, TrackIt will keep attributes as changed until you decide to clear them.

Getting Started
===============

First you will have to add TrackIt to your gemfile.

```ruby
gem 'trackit'
```

Run the `bundle install` command in order to install the gem.

After the gem was successfully installed you need to run the generator:

```console
rails generate tracker Model attr_a attr_b
```

This will generate tracking for Model class which inherits from ActiveRecord::Base, and only for attributes attr_a, attr_b.

The last step is migrating your database:

```console
rake db:migrate
```

You may need to restart your app if it is already running.

Usage
=====

TrackIt provides an interface on your model instance as follows:

```ruby
model = Model.new

model.tracked.changed?
model.tracked.changed
model.tracked.attr_a_changed?
model.tracked.attr_b_changed?
.
.
.
```

Each method corresponds to its similiar named method under [ActiveModel::Dirty](http://api.rubyonrails.org/classes/ActiveModel/Dirty.html).

Two auxiliary methods are supplied:

```ruby
model.tracked.set_all_changed
model.tracked.set_all_unchanged
```

Which sets all tracked attributes to changed/unchaged states.

Concrete Example
================
Assume you have a User model which has the following attributes: name, address, current_job

```ruby
class User < ActiveRecord::Base
end
```

And you want to keep track on all those users who changed their current jobs or addresses:

```console
rails generate tracker User address current_job
```

And

```console
rake db:migrate
```

Let's take a look at the effects of our change:

```ruby
u = User.create!(:name => "user1", :adderss => "address1", :current_job => "job1")

u.address = "address2"
u.current_job = "job2"

u.current_job_changed? # => true
u.address_changed? # => true
u.changed? # => true
u.changed # => ['address', 'current_job']

u.tracked.current_job_changed? # => false
u.tracked.address_changed? # => false
u.tracked.changed? # => false
u.tracked.changed # => []

u.save!

u.current_job_changed? # => false
u.address_changed? # => false
u.changed? # => false
u.changed # => []


u.tracked.current_job_changed? # => true
u.tracked.address_changed? # => true
u.tracked.changed? # => true
u.tracked.changed # => ['address', 'current_job']

u.tracked.set_unchanged(:current_job)
u.tracked.current_job_changed? # => false

u.tracked.set_changed(:current_job)
u.tracked.current_job_changed? # => true

u.tracked.set_all_unchanged
u.tracked.changed? # => false
u.tracked.changed # => []

u.tracked.set_all_changed
u.tracked.changed? # => true
u.tracked.changed # => ['address', 'current_job'] # note name is not changed - only tracked attributes get changed.

```
