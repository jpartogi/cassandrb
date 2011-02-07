require 'cassandrb'

module Ripple
  class Railtie < Rails::Railtie

    initializer "configure" do
      if File.exist?(Rails.root + "config/cassandra.yml")
        Ripple.load_configuration Rails.root.join('config', 'cassandra.yml'), [Rails.env]
      end
    end

  end
end