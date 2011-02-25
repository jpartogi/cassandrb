# -*- coding: utf-8 -*-
require 'spec_helper'

class Person
  include Cassandrb::Model

  column :name
end

describe Cassandrb::Model::Finders do
  before :all do
    @client = Cassandra.new('Keyspace1')
    Cassandrb.client= @client
  end

  after :all do
    @client.disconnect!
  end

  it "should get model by key" do
    # Data inserted from persistence_spec
    person = Person.find('1')
    person.name.should == 'Joe'
    
    people = Person.find(["1","2", "3"])
    people.should be_kind_of Array
    people.length.should be 2
  end

end