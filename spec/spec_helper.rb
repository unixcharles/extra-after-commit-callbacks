$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'extra-after-commit-callbacks'

require 'rspec'
require 'active_record'

::ActiveRecord::Base.send(:include, ::ExtraAfterCommitCallbacks::ActiveRecordExtension)
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

RSpec.configure do |config|
  config.around do |example|
    truncate!
    example.run
    truncate!
  end

  def truncate!
    ActiveRecord::Base.connection.execute("VACUUM")
  end
end