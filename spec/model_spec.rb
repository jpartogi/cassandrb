require 'spec_helper'

class Person
  include Cassandrb::Model

  column :name
  column :gender, :default => 'Female'
end

class Foo
  include Cassandrb::Model

  field :name
end

describe Cassandrb::Model do
  it "should set properties defined" do
    name = 'Joe'
    person = Person.new(:name => name)
    
    person.name.should == name

    foo = Foo.new(:name => name)
    foo.name.should == name
  end

  it "should set default value" do
    person = Person.new
    person.gender.should == 'Female'
  end

  it "should let us define the key manually" do
    person = Person.new
    person.key= "1"
    person.key.should == "1"

    person = Person.new(:key => "1")
    person.key.should == "1"
  end

end
