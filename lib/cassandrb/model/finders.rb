module Cassandrb
  module Model
    module Finders
      extend ActiveSupport::Concern

      module ClassMethods
        def find(key)
          ordered_hash_to_model(self.client.get(self.column_family, key))
        end

        def find_range(options={})
          range = self.client.get_range(self.column_family, options)

          range.each.inject([]) do |arr, keyslice|
            columns= keyslice.columns
            key= keyslice.key
            arr << columns_to_model(key, columns)
          end
        end

        private
        def ordered_hash_to_model(ordered_hash)
          clazz= self.model_name.constantize rescue self
          
          hash= ordered_hash.to_hash
          clazz.new.tap do |model|
            hash.each {|k,v| model.send("#{k}=", v) }
          end
        end

        def columns_to_model(key, columns)
          clazz= self.model_name.constantize rescue self

          clazz.new.tap do |model|
            model.key= key
            columns.each { |col_or_supercol| model.send("#{col_or_supercol.column.name}=", col_or_supercol.column.value) }
          end
        end
      end
    end
  end
end