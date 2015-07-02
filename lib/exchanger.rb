require 'config_store'
require 'viewpoint'

class Exchanger

  def initialize(attrs={})
    @@config ||= ConfigStore('config/credentials.yml')
    user = attrs[:user] || @@config['user']
    pass = attrs[:passwd] || @@config['passwd']
    endpoint = attrs[:endpoint] || @@config['endpoint']
    @cli = Viewpoint::EWSClient.new endpoint, user, pass, :http_opts => {:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE}
  end
  
  def list_calendar_items_since(date)
    calendar = @cli.get_folder(:calendar)
    calendar.items_since(DateTime.parse(date.iso8601))
  end

end