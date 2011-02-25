require 'cassandrb'

module Cassandrb
  module Model
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    autoload :Key
    autoload :Finders
    autoload :Persistence
    autoload :ColumnFamily
    autoload :Cloneable

    included do
      extend ActiveModel::Naming
      include ActiveModel::Serialization      
      include Cassandrb::Model::Persistence
      extend Cassandrb::Columns
      include Cassandrb::AttributeMethods
      include Cassandrb::Callbacks
      include Cassandrb::Observers
      include Cassandrb::Model::Cloneable
      include Cassandrb::Model::Key
      include Cassandrb::Model::Finders
      include Cassandrb::Model::ColumnFamily
    end

    module InstanceMethods
      def client
        self.class.client
      end
    end

    module ClassMethods
      def client
        Cassandrb.client
      end
    end

  end
end