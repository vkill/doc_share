#!/bin/env ruby
require "grit"
require "pry"

repo_path = File.expand_path("../..", __FILE__)
repo = Grit::Repo.new(repo_path)

#get tree latest commit date
repo.log("master", "Gemfile", :max_count => 5).first.date
repo.log("master", "app", :max_count => 5).first.date

#get / contents
repo.tree('master', nil).contents
#get app/ contents
repo.tree('master', 'app/').contents

binding.pry