module Cassandrb
  module Model
    module Persistence
      extend ActiveSupport::Concern
      extend ActiveSupport::Autoload

      module ClassMethods      
        def create(attrs={})
          self.new(attrs).tap {|o| o.save }
        end
        alias insert create
        
      end

      module InstanceMethods
       def initialize
          super
          @new = true
        end

        # Determines whether this is a new document.
        def new?
          @new || false
        end

        def save(options={})
          self.key= SimpleUUID::UUID.new.to_guid if self.key.nil?

          self.client.insert(self.column_family, self.key, self.attributes, options)

          true
        rescue Thrift::ApplicationException
          false
        end

        def destroy(options={})
          self.client.remove(self.column_family, self.key, options)
          true
        rescue Thrift::ApplicationException
          false
        end
        alias delete destroy
        alias remove destroy

        def update_attributes(attrs, options={})
          self.attributes= attrs
          self.client.insert(self.column_family, self.key, self.attributes, options)
          true
        rescue Thrift::ApplicationException
          false
        end
        alias update update_attributes
      end
    end
  end
end