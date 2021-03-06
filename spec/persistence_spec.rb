require 'spec_helper'

class Person
  include Cassandrb::Model

  column :name
end

describe Cassandrb::Model::Persistence do
  before :each do
    @client = Cassandra.new('Keyspace1')   
    Cassandrb.client= @client
  end

  after :each do
    @client.disconnect!
  end

  it "should be able to save model" do
    person = Person.new(:key => "1", :name => 'Joe')
    person.save.should be true

    person = Person.create(:key => "2", :name => 'Boe')
    person.should_not be nil
  end

  it "should be able to destroy model" do
    person = Person.new(:name => 'Moe')
    person.key= "3"
    person.save(:ttl => 10)

    person = Person.find("3")
    person.destroy.should be true

    person = Person.find("3")
    person.should be nil
  end

  it "should be able to update model" do
    person = Person.new(:name => 'Doe')
    person.key= "4"
    person.save

    person.update_attributes(:name => 'Zoe')

    person = Person.find("4")
    person.name.should == "Zoe"
  end

  it "should be able to do callbacks" do
    Person.should respond_to "before_save"
  end
end