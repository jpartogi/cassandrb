module Cassandrb
  module Model
    module Persistence
      extend ActiveSupport::Concern
      extend ActiveSupport::Autoload

      module ClassMethods      
        def create(attrs={})
          self.new(attrs).tap {|o| o.save }
        end
      end

      module InstanceMethods
        def save(options={})
          self.key= SimpleUUID::UUID.new.to_guid if self.key.nil?
          self.client.insert(self.column_family, self.key, self.attributes, options)
          true
        end

        def destroy(options={})
          self.client.remove(self.column_family, self.key, options)
          true
        end
        alias delete destroy
        alias remove destroy

        def update_attributes(attrs, options={})
          self.client.insert(self.column_family, self.key, attrs, options)
          true
        end
      end
    end
  end
end