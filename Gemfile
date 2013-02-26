source :rubygems
gemspec

gem 'rake', :require => false

platforms :mri_18 do
  gem 'SystemTimer'
end

group :test do
  gem 'rspec'
  gem 'sqlite3'
end

group :development, :test do
  gem 'pry', :require => 'pry'
end