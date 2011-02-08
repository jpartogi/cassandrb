module Cassandrb
  module Model
    module Key
      extend ActiveSupport::Concern

      module InstanceMethods
        def key
          @key
        end

        def key=(value)
          @key = value.to_s
        end

        def key_attr
          :key
        end
      end
    end
  end
end