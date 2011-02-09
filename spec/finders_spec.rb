# -*- coding: utf-8 -*-
require 'spec_helper'

class Person
  include Cassandrb::Model

end

describe Cassandrb::Model::Finders do
  it "should get model by key" do
    person = Person.find('1')
  end
end