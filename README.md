Implement extra after commit for activerecord observers

Equivalent to ActiveRecord models `after_commit :method_name, :on => :create`.

Additionnal callbacks are `after_commit_on_{create/destroy/update}`
