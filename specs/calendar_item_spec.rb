require_relative '../lib/calendar_item'

class Organizer
  attr_accessor :name
end
class Item
  attr_accessor :start,:end,:location,:organizer,:my_response_type,:subject,:id, :recurrence
end


item = Item.new
item.start = DateTime.parse("2015-06-26")
item.end = DateTime.parse("2015-06-26")
item.location = "xxxx"
item.organizer = Organizer.new
item.organizer.name = 'xpto'
item.my_response_type = 'Accept'
item.subject = '333'
item.id = "asasasasas12121212111ddd"

describe CalendarItem do

  subject do
    described_class.new(:start => item.start, :end => item.end, :subject => item.subject,
       :outlook_id => item.id, :location => item.location, :organizer_name => item.organizer.name, 
       :my_response => item.my_response_type, :google_id => '12')
     end

  describe '#synch_and_save' do
    context 'new record' do
      created = described_class.synch_and_save(item) {|cal_item| '12' }
      
      it { expect(created.attributes.delete(:_id)).to eq(subject.attributes.delete(:_id)) }
    end

  end
end