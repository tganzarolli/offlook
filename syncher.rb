require 'time'
require_relative 'lib/exchanger'
require_relative 'lib/calendar_item'
require_relative 'lib/google_calendar_wrapper'

def synch(incremental=false)

  exchanger = Exchanger.new
  google_calendar = GoogleCalendarWrapper.new
  google_calendar.login_with_or_without_token
  
  if incremental
    items = exchanger.list_calendar_items_since(Date.today)
  else
    items = exchanger.list_calendar_items_between(Date.today, Date.today + 90)
  end

  items.each { |item| CalendarItem.synch_and_save(item) {|item| p item; google_calendar.save(item)} }

end

synch()