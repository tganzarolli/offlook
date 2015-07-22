require 'google_calendar'
require 'timezone_parser'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

#monkey patch
module Google
  class Event
    def local_timezone_json
      tz = Time.now.zone
      tz_name = TimezoneParser::getTimezones(tz).last
      ",\"timeZone\" : \"#{tz_name}\""
    end
  end
end

class GoogleCalendarWrapper
  
  TRANSLATOR = {'Accept' => 'confirmed', 'Tentative' => 'tentative', 'Decline' => 'cancelled', 'Organizer' => 'confirmed'}
  def initialize
    @@config ||= ConfigStore.new('config/google_credentials.yml')
    @cal = nil
  end
  
  def login_with_token
    # Create an instance of the calendar.
    @cal = Google::Calendar.new(:client_id => @@config['client_id'],
                             :client_secret => @@config['client_secret'],
                             :calendar      => @@config['calendar_id'],
                             :refresh_token => @@config['refresh_token'],
                             :redirect_url  => "urn:ietf:wg:oauth:2.0:oob") # this is what Google uses for 'applications'
  end
  
  def self.setup_calendar()
    config ||= ConfigStore.new('config/google_credentials.yml')
    puts "Enter your calendar id. This must copied from your calendar settings."
    puts "Current one is: #{config['calendar_id']}" if config['calendar_id']
    input = $stdin.gets.chomp
    if !input.empty?
      config['calendar_id'] = input
    else
      puts "WARNING: No information supplied!!"
    end
    config.save
  end

  def login_with_or_without_token
    params = {}
    if @@config['refresh_token']
      params[:refresh_token] = @@config['refresh_token']
    end
    # Create an instance of the calendar.
    @cal = Google::Calendar.new(params.merge!(:client_id => @@config['client_id'],
                             :client_secret => @@config['client_secret'],
                             :calendar      => @@config['calendar_id'],
                             :redirect_url  => "urn:ietf:wg:oauth:2.0:oob") # this is what Google uses for 'applications'
    )
    
    if !@@config['refresh_token']

      # A user needs to approve access in order to work with their calendars.
      puts "Visit the following web page in your browser and approve access. Pressing enter will get you there.\n\n"
      url = @cal.authorize_url
      puts url
      $stdin.gets.chomp
      system "open \"#{url}\""
      puts "\nThen copy the code that Google returned and paste it here:"

      # Pass the ONE TIME USE access code here to login and get a refresh token that you can use for access from now on.
      refresh_token = @cal.login_with_auth_code( $stdin.gets.chomp )
      @@config['refresh_token'] = refresh_token
      @@config.save
    end
  end
  
  def save(cal_item)
    event = @cal.find_or_create_event_by_id(cal_item.google_id) do |e|
      e.title = cal_item.subject
      e.start_time = cal_item.start.to_time
      e.end_time = cal_item.end.to_time
      e.location = cal_item.location
      e.recurrence = cal_item.recurrence
      e.reminders = {'useDefault'  => false, 'overrides' => [{'method' => "popup", 'minutes' => 30}, {'method' => "sms", 'minutes' => 15}]}
      e.description = "Organizer: #{cal_item.organizer_name}. My response: #{cal_item.my_response}"
    end
    event.id
  end
end
