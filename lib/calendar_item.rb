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
  field :recurrence, type: Hash
  field :exception, type: String
  
  validates_inclusion_of :my_response, in: [ 'Accept', 'Tentative', 'Organizer', 'Decline', 'NoResponseReceived', 'Unknown' ]
  validates_presence_of :outlook_id
  validates_presence_of :google_id, :unless => :exception
  validates_uniqueness_of :outlook_id
  validates_uniqueness_of :google_id, :allow_nil => true
  
  def self.synch_and_save(item, verbose=false)

    cal_item = self.where(:outlook_id => item.id).first || self.new
    
    cal_item.attributes = {:start => item.start, :end => item.end, :subject => item.subject,
      :outlook_id => item.id, :location => item.location, :organizer_name => item.organizer.name, 
      :my_response => item.my_response_type}
    cal_item.set_recurrence(item)
      
    if cal_item.new_record? || cal_item.changed?
      begin
        cal_item.google_id = yield cal_item
      rescue => e
        trace = e.backtrace.join("\n\t")
        message = "Error during processing: #{$!}"
        if verbose
          puts message
          puts "Backtrace:\n\t#{trace}"
        end
        cal_item.exception = message
      end
      cal_item.save!
    end
    cal_item
  end
  
  def set_recurrence(item)
    if item.recurrence
      byday = cadence = until_date = nil
      item.recurrence.each do |config|
        if config[:weekly_recurrence]
          config[:weekly_recurrence][:elems].each do |elem|
            if elem[:interval]
              cadence = elem[:interval][:text]
            end
            if elem[:days_of_week]
              byday = elem[:days_of_week][:text][0..1].downcase
            end            
          end
        end
        if config[:end_date_recurrence]
          config[:end_date_recurrence][:elems].each do |elem|
            if elem[:end_date]
              until_date = Date.parse(elem[:end_date][:text])
            end
          end
        end
      end
      self.recurrence = {freq: 'weekly', byday: byday, interval: cadence} 
      self.recurrence.merge!(until: until_date) if until_date
    end
  end
  
end