# Install testing gems

gem 'rspec', :env => 'test'
gem 'rspec-rails', :lib => false, :env => 'test' 
gem 'notahat-machinist', :lib => false, :env => 'test'
gem 'faker', :env => 'test'
gem 'fakeweb', :env => 'test'
gem 'ianwhite-pickle', :env => 'test', :lib => false

rake 'gems:install', :env => 'test'
rake 'gems:unpack', :env => 'test'

plugin 'formtastic', :git => 'git clone git://github.com/justinfrench/formtastic.git'

generate 'rspec'
generate 'cucumber'
generate 'pickle'

rake 'rails:freeze:edge' if yes?("Freeze to edge rails? (y/n)")

file "spec/spec.opts", %{
--colour
--format nested
}.strip

file 'spec/blueprints.rb', %{
require 'machinist/active_record'
require File.expand_path(File.dirname(__FILE__) + "/blueprints/shams")

Dir[File.expand_path(File.dirname(__FILE__)) + "/blueprints/*_blueprint.rb"].each do |blueprint|
  require blueprint
end
}.strip

file 'spec/blueprints/shams.rb', %{
require 'faker'

Sham.email { Faker::Internet.email }
Sham.domain_name { Faker::Internet.domain_name }
}.strip

spec_helper = File.open("spec/spec_helper.rb").read
file "spec/spec_helper.rb", spec_helper.gsub("Spec::Runner.configure do |config|", "require File.expand_path(File.dirname(__FILE__) + '/blueprints.rb')\n\nSpec::Runner.configure do |config|")

cucumber_env = File.open("features/support/env.rb").read
file "features/support/env.rb", cucumber_env.gsub("require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')", "require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')\nrequire File.expand_path(File.dirname(__FILE__) + '/../../spec/blueprints')")

# remove prototype and scriptaculous, in favour of jquery

run "rm -f public/javascripts/*"
run "curl http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js > public/javascripts/jquery.1.3.2.min.js"
run "curl http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js > public/javascripts/jquery-ui.1.7.2.min.js"

# Remove unwanted files

run "rm README"
run "rm doc/README_FOR_APP"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm -rf test"

# Make git ignore things we don't like

file '.gitignore', %{
.DS_Store
coverage/*
log/*.log
db/*.db
db/*.sqlite3
db/schema.rb
tmp/**/*
doc/api
doc/app
config/database.yml
END
}.strip

run "rm log/*"
run "rm -rf vendor/gems/*/test"
run "rm -rf vendor/gems/*/test"
run "rm -rf vendor/plugins/*/test"
run "rm -rf vendor/plugins/*/spec"
run "rm -rf vendor/rails/*/test"
run "rm -rf vendor/rails/railties/guides"
run "rm -rf vendor/rails/ci"
run "rm -rf vendor/rails/doc"

# Preserve empty directories

run 'find . \( -type d -empty \) -and \( -not -regex ./\.git.* \) -exec touch {}/.gitignore \;'

git :init
git :add => "."
git :commit => %{-a -m "Initial commit after generation from 'http://github.com/tomafro/dotfiles/tree/master/resource/rails-template.rb"}