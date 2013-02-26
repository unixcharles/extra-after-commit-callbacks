ActiveRecord::Migration.create_table :dogs, :force => true do |t|
  t.timestamps
end
ActiveRecord::Migration.create_table :cats, :force => true do |t|
  t.timestamps
end

class Dog < ActiveRecord::Base
  @@default_callback_counters = {
    :after_commit => 0,
    :after_commit_on_create  => 0,
    :after_commit_on_update  => 0,
    :after_commit_on_save    => 0,
    :after_commit_on_destroy => 0
  }

  def callback_counters
    @callback_counters ||= @@default_callback_counters.clone
  end

  def reset_callback_counters!
    @callback_counters = @@default_callback_counters.clone
  end

  after_commit do
    callback_counters[:after_commit] += 1
  end
  after_commit_on_save do
    callback_counters[:after_commit_on_save] += 1
  end
  after_commit_on_create do
    callback_counters[:after_commit_on_create] += 1
  end
  after_commit_on_update do
    callback_counters[:after_commit_on_update] += 1
  end
  after_commit_on_destroy do
    callback_counters[:after_commit_on_destroy] += 1
  end
end
class Cat < ActiveRecord::Base; end
