require 'cassandrb'

module Cassandrb
  module Model
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    autoload :Key
    autoload :Finders
    autoload :Persistence
    autoload :ColumnFamily

    included do
      extend ActiveModel::Naming
      include ActiveModel::Serialization      
      include Cassandrb::Model::Persistence
      extend Cassandrb::Columns
      include Cassandrb::AttributeMethods
      include Cassandrb::Callbacks
      include Cassandrb::Observers
      include Cassandrb::Model::Key
      include Cassandrb::Model::Finders
      include Cassandrb::Model::ColumnFamily
    end

    module InstanceMethods
      def client
        self.class.client
      end

      def clone
        self.class.instantiate(@attributes.except("key").dup, true)
      end
    end

    module ClassMethods
      def client
        Cassandrb.client
      end
      
      def instantiate(attrs = nil, allocating = false)
        attributes = attrs || {}
        if attributes["key"] || allocating
          model = allocate
          model.instance_variable_set(:@attributes, attributes)
          model
        else
          new(attrs)
        end
      end
    end

  end
end