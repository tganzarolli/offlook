require 'time'

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


