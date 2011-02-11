module Cassandrb
  module Model
    module Persistence
      extend ActiveSupport::Concern
      extend ActiveSupport::Autoload


      module InstanceMethods
        def save(*args)
          self.key= SimpleUUID::UUID.new.to_s if self.key.nil?
          self.client.insert(self.column_family, self.key, self.attributes)
          true
        end

        def destroy
          
        end
      end
    end
  end
end