#!/usr/bin/env ruby

# Thanks to Wes: http://www.brokenbuild.com/blog/2009/05/09/cleaning-up-your-address-book-on-os-x-with-ruby/

# TODO: This currently makes you pick twice for each dup, but you can kill it in the middle to start over.  Too lazy to finish it...
require 'rubygems'
require 'appscript'
 
include Appscript
 
ab = app("Address Book")
 
people = []

# put in a hash and remove any trailing commas or spaces
ab.people.get.each do |person|
  first_name = person.first_name.get
  last_name = person.last_name.get
  # reject one-name people
  unless last_name == :missing_value or first_name == :missing_value
    people << {:first_name => first_name.chomp(',').strip, :last_name => last_name.chomp(',').strip, :person => person}
  end
end

inverted = []
people.each do |values1|
  people.each do |values2|
    if values1[:first_name] == values2[:last_name] and values1[:last_name] == values2[:first_name]
      inverted << [values1, values2]
    end
  end
end

puts "#{inverted.size} inverted names found."

inverted.each do |pair|
  first_name = pair[0][:first_name]
  last_name = pair[0][:last_name]
  person1 = pair[0][:person]
  person2 = pair[1][:person]
  puts "is #{first_name} the first name of #{first_name} #{last_name}?"
  answer = gets
  if answer.strip.downcase == 'n'
    tmp = first_name
    first_name = last_name
    last_name = tmp
  end
  person1.first_name.set(first_name)
  person1.last_name.set(last_name)
  person2.first_name.set(first_name)
  person2.last_name.set(last_name)
  puts "#{person1.first_name.get} #{person1.last_name.get} #{person2.first_name.get} #{person2.last_name.get}"
  ab.save_addressbook
end

inverted.each do |values|
  person1 = values[0][:person]
  person2 = values[1][:person]
  puts "#{person1.first_name.get} #{person1.last_name.get} #{person2.first_name.get} #{person2.last_name.get}"
end
