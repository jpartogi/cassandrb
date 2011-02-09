require 'spec_helper'

class Person
  include Cassandrb::Model

  column :name
end

describe Cassandrb::Model::Persistence do
  it "should save model" do
    person = Person.new(:name => 'Joe')
    person.save.should be true
  end
end