require_relative 'mongo'
class CalendarItem
  include Mongoid::Document
  
  field :outlook_id, type: String
  field :google_id, type: String
  field :location, type: String
  field :organizer_name, type: String
  field :subject, type: String
  field :my_response, type: String
  field :start, type: DateTime
  field :end, type: DateTime
  
  validates_inclusion_of :my_response, in: [ 'Accept', 'Reject',  'Tentative' ]
  validates_uniqueness_of :outlook_id
  validates_uniqueness_of :google_id
end