require 'active_support/concern'

module ExtraAfterCommitCallbacks
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    EXTRA_AFTER_COMMIT_CALLBACK_TYPES = [:commit_on_save, :commit_on_create, :commit_on_update, :commit_on_destroy]

    included do
      EXTRA_AFTER_COMMIT_CALLBACK_TYPES.each do |callback_type|
        define_model_callbacks callback_type, :only => :after
      end

      before_save    :_mark_for_after_commit_on_save!
      before_create  :_mark_for_after_commit_on_create!
      before_update  :_mark_for_after_commit_on_update!
      before_destroy :_mark_for_after_commit_on_destroy!

      after_commit   :_run_extra_after_commit_callbacks!
      after_rollback :_clear_after_commit_callbacks!
    end

    private

    def _mark_for_after_commit_on_save!
      @_trigger_after_commit_on_save_for_successfull_transaction = true
    end

    def _mark_for_after_commit_on_create!
      @_trigger_after_commit_on_create_for_successfull_transaction = true
    end

    def _mark_for_after_commit_on_update!
      @_trigger_after_commit_on_update_for_successfull_transaction = true
    end

    def _mark_for_after_commit_on_destroy!
      @_trigger_after_commit_on_destroy_for_successfull_transaction = true
    end

    def _run_extra_after_commit_callbacks!
      notify_observers(:after_commit_on_save)    if @_trigger_after_commit_on_save_for_successfull_transaction
      notify_observers(:after_commit_on_create)  if @_trigger_after_commit_on_create_for_successfull_transaction
      notify_observers(:after_commit_on_update)  if @_trigger_after_commit_on_update_for_successfull_transaction
      notify_observers(:after_commit_on_destroy) if @_trigger_after_commit_on_destroy_for_successfull_transaction

      run_callbacks :commit_on_save,    :only => :after if @_trigger_after_commit_on_save_for_successfull_transaction
      run_callbacks :commit_on_create,  :only => :after if @_trigger_after_commit_on_create_for_successfull_transaction
      run_callbacks :commit_on_update,  :only => :after if @_trigger_after_commit_on_update_for_successfull_transaction
      run_callbacks :commit_on_destroy, :only => :after if @_trigger_after_commit_on_destroy_for_successfull_transaction

      _clear_after_commit_callbacks!
    end

    def _clear_after_commit_callbacks!
      @_trigger_after_commit_on_save_for_successfull_transaction    = false
      @_trigger_after_commit_on_create_for_successfull_transaction  = false
      @_trigger_after_commit_on_update_for_successfull_transaction  = false
      @_trigger_after_commit_on_destroy_for_successfull_transaction = false
    end
  end
end