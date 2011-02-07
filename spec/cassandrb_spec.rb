require 'spec_helper'

describe Cassandrb do
  it "should raise No Such File or Directory when given a bad configuration file" do
    lambda { Cassandrb.configure('not-here') }.should raise_error(Cassandrb::MissingConfiguration)
  end

  it "should configure client" do
    Cassandrb.configure(File.join(File.dirname(__FILE__), 'fixtures', 'cassandra.yml'))
    Cassandrb.client
  end

end