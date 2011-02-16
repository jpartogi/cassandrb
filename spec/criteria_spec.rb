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

    people.each do |person|
      puts person.name
    end
  end
end