#!/usr/bin/env ruby

# Thanks to Wes: http://www.brokenbuild.com/blog/2009/05/09/cleaning-up-your-address-book-on-os-x-with-ruby/

# This is another little script to fix a botched phone import (thanks ATT) where names were inverted (but not duplicated) and had a comma appended
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
    next unless first_name =~ /,$/
    p "#{last_name} #{first_name}"
    last = first_name.chomp(',').strip
    first = last_name.chomp(',').strip
    person.first_name.set(first)
    person.last_name.set(last)
    p "#{last} #{first}"
    ab.save_addressbook
  end
end
