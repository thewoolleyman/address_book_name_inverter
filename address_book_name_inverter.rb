#!/usr/bin/env ruby
require 'rubygems'
require 'appscript'
 
include Appscript
 
ab = app("Address Book")
 
# group_name = "Inverted Duplicate Names"
 
# if ab.groups[group_name].eq(:missing_value)
#    puts "Creating a group named '#{group_name}'"
#    ab.make(:new => :group, :with_properties => {:name => group_name})
# end

people = {}

ab.people.get.each do |person|
  people[person.id_.get] = {:first_name => person.first_name.get, :last_name => person.last_name.get}
end

p people
 
# To edit properties of a person do this:
#
# wes = ab.people["Wes Maldonado"].get # <= the call to get actually executes the search
# p wes.first_name.get # 'Wes'
# wes.first_name.set('Wesley')
# p wes.first_name.get # 'Wesley'
 
# You need to save your changes, really.
# ab.save_addressbook

