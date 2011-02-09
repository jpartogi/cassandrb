require 'spec_helper'

class Person
  include Cassandrb::Model

  column :name
end

describe Cassandrb::Model::Persistence do
  before :each do
    @client = Cassandra.new('Keyspace1')
  end

  after :each do
    @client.disconnect!
  end

  it "should save model" do
    Cassandrb.client= @client

    person = Person.new(:name => 'Joe')
    person.key= "1"
    person.save.should be true
  end
end