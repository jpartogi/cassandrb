# -*- coding: utf-8 -*-
require 'spec_helper'

class Person
  include Cassandrb::Model

  column :name
end

describe Cassandrb::Model::Finders do
  before :all do
    @client = Cassandra.new('Keyspace1')
  end

  after :all do
    @client.disconnect!
  end

  it "should get model by key" do
    Cassandrb.client= @client

    # Data inserted from persistence_spec
    person = Person.find('1')
    person.name.should == 'Joe'
  end
end