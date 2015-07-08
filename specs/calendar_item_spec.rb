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

RSpec::Expectations.configuration.warn_about_potential_false_positives = false

describe CalendarItem do

  before(:all) do
    if ENV['MONGOID_ENV'] != 'test'
      puts "Refusing to run tests with the environment: #{ENV['MONGOID_ENV']}"
      exit
    end
  end

  after(:each) do
    Mongoid.purge!
  end

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
  describe 'validate google_id nil' do
    context 'without exception trace' do
      item.id += '1'
      it { expect {described_class.synch_and_save(item) {|cal_item| nil }}.to raise_error(Mongoid::Errors::Validations) }
    end
    context 'with exception trace' do
      item.id += '2'
      it { expect {described_class.synch_and_save(item) {|cal_item| cal_item.exception = 'Sometrace'; nil }}.not_to raise_error(Mongoid::Errors::Validations) }
    end
    context 'with exception trace' do
      item.id += '3'
      it { expect {described_class.synch_and_save(item) {|cal_item| throw Exception.new }}.not_to raise_error(Mongoid::Errors::Validations) }
    end
  end
end