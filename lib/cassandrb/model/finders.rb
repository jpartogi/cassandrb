module Cassandrb
  module Model
    module Finders
      extend ActiveSupport::Concern

      module ClassMethods
        def find(key)
          self.client.get(self.column_family, key)
        end
      end
    end
  end
end