module Cassandrb
  module Model
    module Finders
      extend ActiveSupport::Concern

      module ClassMethods
        def find(key)
          instantiate(self.client.get(self.column_family, key))
        end

        private
        def instantiate(ordered_hash)
          clazz= self.model_name.constantize rescue self
          
          hash= ordered_hash.to_hash
          clazz.new.tap do |model|
            hash.each {|k,v| model.send("#{k}=", v) }
          end
        end
      end
    end
  end
end