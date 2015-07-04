require 'mongoid'

if ENV['MONGOID_ENV']
  Mongoid.load!("./config/mongoid.yml")
else
  Mongoid.load!("./config/mongoid.yml", :production)
end