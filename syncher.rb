require 'time'
require 'viewpoint'
require_relative 'lib/calendar_item'

def fetch_outlook()
  user = "***REMOVED***"
  pass = ""
  endpoint = "***REMOVED***"
  cli = Viewpoint::EWSClient.new endpoint, user, pass, :http_opts => {:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE}
  start_time = DateTime.parse("2015-06-26").iso8601
  end_time = DateTime.parse("2015-07-04").iso8601

  calendar = cli.get_folder(:calendar)



  calendar.items_since(DateTime.parse("2015-06-26")).first
end

class Organizer
  attr_accessor :name
end
class Item
  attr_accessor :start,:end,:location,:organizer,:my_response_type,:subject,:id
end

def send_to_google(cal_item)
  return 'lobster'
end

def save_to_db(item)

  cal_item = CalendarItem.where(:outlook_id => item.id).first || CalendarItem.new
  cal_item.attributes = {:start => item.start, :end => item.end, :subject => item.subject,
    :outlook_id => item.id, :location => item.location, :organizer_name => item.organizer.name, :my_response => item.my_response_type}
p cal_item
  if cal_item.changed?
    cal_item.google_id = yield cal_item
    cal_item.upsert
  end

end

item = Item.new
item.start = DateTime.parse("2015-06-26")
item.end = DateTime.parse("2015-06-26")
item.location = "xxxx"
item.organizer = Organizer.new
item.organizer.name = 'xpto'
item.my_response_type = 'Accept'
item.subject = 'Isso ai 2'
item.id = "asasasasas12121212111"
save_to_db(item){|cal_item| send_to_google(cal_item) }

