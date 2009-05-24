#!/usr/bin/env ruby

# Thanks to Wes: http://www.brokenbuild.com/blog/2009/05/09/cleaning-up-your-address-book-on-os-x-with-ruby/
require 'rubygems'
require 'appscript'
 
include Appscript
 
ab = app("Address Book")
 
group_name = "Inverted Duplicate Names"
 
if ab.groups[group_name].eq(:missing_value)
   puts "Creating a group named '#{group_name}'"
   ab.make(:new => :group, :with_properties => {:name => group_name})
end

people = {}

# put in a hash and remove any trailing commas or spaces
ab.people.get.each do |person|
  first_name = person.first_name.get
  last_name = person.last_name.get
  # reject one-name people
  unless last_name == :missing_value or first_name == :missing_value
    people[person.id_.get] = {:first_name => first_name.chomp(',').strip, :last_name => last_name.chomp(',').strip}
  end
end

inverted = []
people.sort.each do |id1, names1|
  people.sort.each do |id2, names2|
    if names1[:first_name] == names2[:last_name] and names1[:last_name] == names2[:first_name]
      inverted << [names1, names2, id1, id2]
    end
  end
end

inverted.each do |pair|
  puts "#{pair[0].values.join(' ')} | #{pair[1].values.join(' ')} | #{pair[2]} | #{pair[3]}\n"
end

puts "#{inverted.size} inverted names found."
 
# TODO
# switch inverted ones - probably need manual choice to correctly pick first vs. last name
# To write: wes.first_name.set('Joe')
 
# You need to save your changes, really.
# ab.save_addressbook

