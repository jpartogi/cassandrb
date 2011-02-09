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
      extend Cassandrb::Columns
      include Cassandrb::AttributeMethods
      include Cassandrb::Model::Key
      include Cassandrb::Model::Finders
      include Cassandrb::Model::Persistence
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