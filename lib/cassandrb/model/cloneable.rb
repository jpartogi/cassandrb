module Cassandrb
  module Model
    module Cloneable
      extend ActiveSupport::Concern
    end

    module InstanceMethods
      def clone
        self.class.instantiate(@attributes.except("key").dup, true)
      end
    end

    module ClassMethods
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