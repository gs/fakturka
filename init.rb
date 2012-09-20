at_exit do
  require "rubygems"
  require "irb"
  require "drb/acl"
  require "sqlite3"
end

load "script/server"