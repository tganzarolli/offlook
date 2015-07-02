require 'time'
require_relative 'lib/exchanger'
require_relative 'lib/calendar_item'
require_relative 'lib/google_calendar'

def synch()
  exchanger = Exchanger.new
  google_calendar = GoogleCalendar.new
  items = exchanger.list_calendar_items_since(Date.today)
  p items.first
  #items.each { |item| CalendarItem.synch_and_save(item) {|item| google_calendar.save(item) } }
end

synch()