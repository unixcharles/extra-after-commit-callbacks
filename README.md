extra-after-commit-callbacks
============================

Add extra callbacks for ActiveRecord models and observers.

Replacement for ActiveRecord models `after_commit :method_name, :on => :create`.

Getting started
===============

```
gem 'extra-after-commit-callbacks'
```

#### Directly from the an ActiveRecord model:

```ruby
class Model < ActiveRecord::Base
  after_commit_on_create :test
end
```

#### From an ActiveRecord observer:

```ruby
class AnotherObserver < ActiveRecord::Observer
  observe :model

  def after_commit(object)
    # ...
  end

  def after_commit_on_create(object)
    # ...
  end

  def after_commit_on_save(object)
    # ...
  end

  def after_commit_on_update(object)
    # ...
  end

  def after_commit_on_destroy(object)
    # ...
  end
end
```

### How this differ from `after_commit :on => :{create/update/destroy}`

First, you can't use the `:on` option from the observers.

Also, the behaviour of this Gem is different from the `:on` option because it doesn't interfere with other object inside the transaction.

When you `:on` with `after_commit` in Rails, if any of the objects being commited within the transaction fullfill the requirement, the callback will be triggered.

#### i.e.:

With `after_commit :on` option:

```ruby
class Boat < ActiveRecord::Base
  after_commit :on => :destroy do
    puts 'The boat sink...'
  end
end

class Plane < ActiveRecord::Base
  after_commit :on => :destroy do
    puts 'The plane crash...'
  end
end

> boat, plane = Boat.create, Plane.create; ActiveRecord::Base.transaction { boat.save; plane.destroy }
   (0.3ms)  BEGIN
   ...
   (0.2ms)  COMMIT
'The boat sink...'
'The plane crash...'
=> nil
```

Pull request?
=============
Yes.