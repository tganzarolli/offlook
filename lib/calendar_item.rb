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
  
  def self.synch_and_save(item)

    cal_item = self.where(:outlook_id => item.id).first || self.new
    
    cal_item.attributes = {:start => item.start, :end => item.end, :subject => item.subject,
      :outlook_id => item.id, :location => item.location, :organizer_name => item.organizer.name, 
      :my_response => item.my_response_type}
      
    if cal_item.new_record? || cal_item.changed?
      cal_item.google_id = yield cal_item
      cal_item.save!
    end
    cal_item
  end
  
end