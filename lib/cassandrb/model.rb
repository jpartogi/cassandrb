module Cassandrb
  module Model
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    included do
      extend ActiveModel::Naming
      include ActiveModel::Serialization
      extend Cassandrb::Columns
      include Cassandrb::AttributeMethods
    end

    
  end
end