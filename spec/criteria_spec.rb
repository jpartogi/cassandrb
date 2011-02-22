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
    
  it "should retrieve records using specified criteria" do
    people = Person.where(:name => 'Joe')

    people.should be_kind_of Cassandrb::Criteria
    people.should respond_to :each
  end

  it "should limit the number of records retrieved" do
    people = Person.where(:name => 'Joe').limit(2)
    people.should respond_to :each

    people.each do |person|
      puts person
    end

    people = Person.limit(1)
    people.should respond_to :each
  end
end