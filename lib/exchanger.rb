require_relative 'config_store'
require 'viewpoint'
require 'time'

class Exchanger

  def initialize(attrs={})
    @@config ||= ConfigStore.new('config/credentials.yml')
    user = attrs[:user] || @@config['user']
    pass = attrs[:password] || @@config['password']
    endpoint = attrs[:endpoint] || @@config['endpoint']
    @cli = Viewpoint::EWSClient.new endpoint, user, pass, :http_opts => {:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE}
  end
  
  def list_calendar_items_since(date)
    calendar = @cli.get_folder(:calendar)
    calendar.items_since(date)
  end

  def list_calendar_items_between(start_date, end_date)
    calendar = @cli.get_folder(:calendar)
    calendar.items_between(start_date, end_date)
  end
  

end