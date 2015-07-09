#!/usr/bin/env ruby

require 'time'
require 'optparse'

# Runs a block of code without warnings.
def silence_warnings(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end

def synch(auto=true, full=false, verbose=false)
  exchanger = Exchanger.new
  google_calendar = GoogleCalendarWrapper.new

  auto && google_calendar.login_with_token || google_calendar.login_with_or_without_token
  
  today = Date.today
  items = (full) ? exchanger.list_calendar_items_between(today - 180, today + 180) : exchanger.list_calendar_items_since(today)

  items.each { |item| CalendarItem.synch_and_save(item, verbose) {|item| p item.to_json if verbose; google_calendar.save(item)} }
end

options = {}

opt_parser = OptionParser.new do |opt|  
  opt.banner = "Usage: syncher.rb [OPTIONS]"
  opt.separator  ""
  opt.separator  "Options"

  opt.on("-f","--full","takes events that occur until 180 days behind and ahead of today") do |name|
    options[:full] = true
  end
  
  opt.on("-a","--auto","assumes a key was generated and won't prompt for Google authorization") do |name|
    options[:auto] = true
  end

  opt.on("-v","--verbose","outputs the synched items") do |name|
    options[:verbose] = true
  end
  
  opt.on("-s","--setup","setups Outlook configuration and credentials") do |name|
    options[:setup] = true
  end
  
  opt.on("-c","--calendar","setups Google Calendar Id") do |name|
    options[:calendar] = true
  end
  
  opt.on("-p","--password","changes Outlook password") do |name|
    options[:password] = true
  end
  
  opt.on("-h","--help","help") do
    puts opt_parser
    puts "\nWARNING: If you don't explicitly set MONGOID_ENV, production config will be used!"
    exit
  end
end

opt_parser.parse!

silence_warnings do 
  require_relative 'lib/exchanger'
  require_relative 'lib/calendar_item'
  require_relative 'lib/google_calendar_wrapper'
  if options[:setup]
    Exchanger.configure
  elsif options[:password]
    Exchanger.set_password
  elsif options[:calendar]
    GoogleCalendarWrapper.setup_calendar
  else
    synch(options[:auto], options[:full], options[:verbose])
  end
end