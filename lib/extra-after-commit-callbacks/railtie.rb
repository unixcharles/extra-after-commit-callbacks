module ExtraAfterCommitCallbacks
  class Initialization < Rails::Railtie
    initializer "extra_after_commit_callbacks" do
      ::ActiveRecord::Base.send(:include, ::ExtraAfterCommitCallbacks::ActiveRecordExtension)
    end
  end
end