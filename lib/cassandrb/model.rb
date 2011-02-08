require 'cassandrb'

module Cassandrb
  module Model
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    autoload :Key
    autoload :Persistence
    autoload :ColumnFamily

    included do
      extend ActiveModel::Naming
      include ActiveModel::Serialization
      extend Cassandrb::Columns
      include Cassandrb::AttributeMethods
      include Cassandrb::Model::Key
      include Cassandrb::Model::Persistence
      include Cassandrb::Model::ColumnFamily
    end

    def client
      Cassandrb.client
    end
  end
end