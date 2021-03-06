module Cassandrb
  module Model
    module ColumnFamily
      extend ActiveSupport::Concern
      
      module InstanceMethods
        def column_family
          self.class.column_family
        end
      end

      module ClassMethods
        def column_family
          @column_family ||= self.model_name.plural
        end

        def column_family=(column_family)
          @column_family= column_family
        end
      end
    end
  end
end