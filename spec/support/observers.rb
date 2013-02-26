class TestObserver < ActiveRecord::Observer
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
end

class AfterCommitObserver < TestObserver
  observe Dog

  def after_commit(object)
    callback_counters[:after_commit] += 1
  end

  def after_commit_on_create(object)
    callback_counters[:after_commit_on_create] += 1
  end

  def after_commit_on_save(object)
    callback_counters[:after_commit_on_save] += 1
  end

  def after_commit_on_update(object)
    callback_counters[:after_commit_on_update] += 1
  end

  def after_commit_on_destroy(object)
    callback_counters[:after_commit_on_destroy] += 1
  end
end