require 'spec_helper'
require 'support/models'
require 'support/observers'

describe 'Model' do

  let!(:observer) { AfterCommitObserver.instance }

  context 'create' do
    before :each do
      observer.reset_callback_counters!

      ActiveRecord::Base.transaction do
        some_transaction_noise!
        @dog = Dog.create
      end
    end

    it 'run after_commit' do
      expect(observer.callback_counters[:after_commit]).to eq(1)
      expect(@dog.callback_counters[:after_commit]).to eq(1)
    end

    it 'run after_commit_on_save' do
      expect(observer.callback_counters[:after_commit_on_save]).to eq(1)
      expect(@dog.callback_counters[:after_commit_on_save]).to eq(1)
    end

    it 'run after_commit_on_create' do
      expect(observer.callback_counters[:after_commit_on_create]).to eq(1)
      expect(@dog.callback_counters[:after_commit_on_create]).to eq(1)
    end

    it 'doesn\'t run after_commit_on_update' do
      expect(observer.callback_counters[:after_commit_on_update]).to eq(0)
      expect(@dog.callback_counters[:after_commit_on_update]).to eq(0)
    end

    it 'doesn\'t run after_commit_on_destroy' do
      expect(observer.callback_counters[:after_commit_on_destroy]).to eq(0)
      expect(@dog.callback_counters[:after_commit_on_destroy]).to eq(0)
    end
  end

  context 'update' do
    before :each do
      @dog = Dog.create
      @dog.reset_callback_counters!
      observer.reset_callback_counters!

      ActiveRecord::Base.transaction do
        some_transaction_noise!
        @dog.updated_at = Time.now
        @dog.save
      end
    end

    it 'run after_commit' do
      expect(observer.callback_counters[:after_commit]).to eq(1)
      expect(@dog.callback_counters[:after_commit]).to eq(1)
    end

    it 'run after_commit_on_save' do
      expect(observer.callback_counters[:after_commit_on_save]).to eq(1)
      expect(@dog.callback_counters[:after_commit_on_save]).to eq(1)
    end

    it 'doesn\'t run after_commit_on_create' do
      expect(observer.callback_counters[:after_commit_on_create]).to eq(0)
      expect(@dog.callback_counters[:after_commit_on_create]).to eq(0)
    end

    it 'run after_commit_on_update' do
      expect(observer.callback_counters[:after_commit_on_update]).to eq(1)
      expect(@dog.callback_counters[:after_commit_on_update]).to eq(1)
    end

    it 'doesn\'t run after_commit_on_destroy' do
      expect(observer.callback_counters[:after_commit_on_destroy]).to eq(0)
      expect(@dog.callback_counters[:after_commit_on_destroy]).to eq(0)
    end
  end

  context 'destroy' do
    before :each do
      @dog = Dog.create
      @dog.reset_callback_counters!
      observer.reset_callback_counters!

      ActiveRecord::Base.transaction do
        some_transaction_noise!
        @dog.destroy
      end
    end

    it 'run after_commit' do
      expect(observer.callback_counters[:after_commit]).to eq(1)
      expect(@dog.callback_counters[:after_commit]).to eq(1)
    end

    it 'doesn\'t run after_commit_on_save' do
      expect(observer.callback_counters[:after_commit_on_save]).to eq(0)
      expect(@dog.callback_counters[:after_commit_on_save]).to eq(0)
    end

    it 'doesn\'t run after_commit_on_create' do
      expect(observer.callback_counters[:after_commit_on_create]).to eq(0)
      expect(@dog.callback_counters[:after_commit_on_create]).to eq(0)
    end

    it 'doesn\'t run after_commit_on_update' do
      expect(observer.callback_counters[:after_commit_on_update]).to eq(0)
      expect(@dog.callback_counters[:after_commit_on_update]).to eq(0)
    end

    it 'run after_commit_on_destroy' do
      expect(observer.callback_counters[:after_commit_on_destroy]).to eq(1)
      expect(@dog.callback_counters[:after_commit_on_destroy]).to eq(1)
    end
  end

  context 'rollback' do
    before :each do
      @dog = Dog.create
      @dog.reset_callback_counters!
      observer.reset_callback_counters!

      ActiveRecord::Base.transaction do
        some_transaction_noise!
        @dog.destroy
        raise ActiveRecord::Rollback
      end

      ActiveRecord::Base.transaction do
        some_transaction_noise!
        @dog.updated_at = Time.now
        @dog.save
      end
    end

    it 'clean itself in the case of rollback' do
      expect(observer.callback_counters[:after_commit_on_destroy]).to eq(0)
      expect(@dog.callback_counters[:after_commit_on_destroy]).to eq(0)

      expect(observer.callback_counters[:after_commit_on_update]).to eq(1)
      expect(@dog.callback_counters[:after_commit_on_update]).to eq(1)
    end
  end

  def some_transaction_noise!
    cat1 = Cat.create
    cat2 = Cat.create
    cat2.touch
    cat3 = Cat.create
    cat3.destroy
  end
end