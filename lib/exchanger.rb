require_relative 'config_store'
require 'viewpoint'
require 'time'
require 'io/console'

class Exchanger

  def initialize(attrs={})
    @@config ||= ConfigStore.new('config/credentials.yml')
    user = attrs[:user] || @@config['user']
    pass = attrs[:password] || @@config['password']
    endpoint = attrs[:endpoint] || @@config['endpoint']
    @cli = Viewpoint::EWSClient.new endpoint, user, pass, :http_opts => {:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE}
  end
  
  def self.config_util(config, property)
    text = "Enter your Outlook #{property}"
    if config[property]
      text += " or press enter to confirm the following:\n#{config[property]}\n"
    end
    puts text
    input = $stdin.gets.chomp
    if !input.empty?
      config[property] = input
    elsif config[property].nil? || config[property].empty?
      puts "WARNING: No information supplied!!"
    end
  end
  
  def self.configure()
    config = ConfigStore.new('config/credentials.yml')
    config_util(config, 'endpoint')
    config_util(config, 'user')
    set_password(config)
  end
  
  def self.set_password(config=nil)
    config ||= ConfigStore.new('config/credentials.yml')
    puts "Enter your Outlook password"
    input = $stdin.noecho(&:gets).chomp
    puts "WARNING: No information supplied!!" if input.nil? || input.empty?
    config['password'] = input if input
    config.save
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