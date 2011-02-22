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
    
  it "should set the criteria" do
    people = Person.where(:name => 'Joe')

    people.should be_kind_of Cassandrb::Criteria
    people.should respond_to :each
    
  end
end