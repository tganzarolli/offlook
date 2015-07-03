require 'google_calendar'
class GoogleCalendarWrapper
  
  TRANSLATOR = {'Accept' => 'confirmed', 'Tentative' => 'tentative', 'Decline' => 'cancelled', 'Organizer' => 'confirmed'}
  def initialize
    @@config ||= ConfigStore.new('config/google_credentials.yml')
    @cal = nil
  end
  
  def login_with_or_without_token
    params = {}
    if @@config['refresh_token']
      params[:refesh_token] = @@config['refresh_token']
    end

    # Create an instance of the calendar.
    @cal = Google::Calendar.new(params.merge!(:client_id => @@config['client_id'],
                               :client_secret => @@config['client_secret'],
                               :calendar      => @@config['calendar_id'],
                               :redirect_url  => "urn:ietf:wg:oauth:2.0:oob") # this is what Google uses for 'applications'
                               )

    if !@@config['refresh_token']

      # A user needs to approve access in order to work with their calendars.
      puts "Visit the following web page in your browser and approve access."
      puts @cal.authorize_url
      puts "\nCopy the code that Google returned and paste it here:"

      # Pass the ONE TIME USE access code here to login and get a refresh token that you can use for access from now on.
      refresh_token = @cal.login_with_auth_code( $stdin.gets.chomp )
      @@config['refresh_token'] = refresh_token
      @@config.save
    end
  end
  
  def save(cal_item)
    event = @cal.create_event do |e|
      e.title = cal_item.subject
      e.start_time = cal_item.start.to_time
      e.end_time = cal_item.end.to_time
      e.location = cal_item.location
      e.description = "My response: #{TRANSLATOR[cal_item.my_response]}"
      e.creator_name = cal_item.organizer_name
    end
    event.id
  end
end