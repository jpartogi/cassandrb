require 'cassandrb'

module Cassandrb
  class Railtie < Rails::Railtie

    initializer "configure" do
      if File.exist?(Rails.root + "config/cassandra.yml")
        Cassandrb.configure Rails.root.join('config', 'cassandra.yml'), Rails.env
      end
    end

  end
end