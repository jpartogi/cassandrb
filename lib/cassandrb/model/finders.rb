module Cassandrb
  module Model
    module Finders
      extend ActiveSupport::Concern

      module ClassMethods
        def find(key, options={})
          all([key], options).first
        end

        def find_each(options={})
          range = self.client.get_range(self.column_family, options)

          range.each.inject([]) do |arr, keyslice|
            columns= keyslice.columns
            key= keyslice.key

            next arr if columns.to_a.empty? # Columns maybe empty if the row is in a tombstone.
            arr << columns_to_model(key, columns)
          end
        end

        def all(keys, options={})
          results = self.client.multi_get(self.column_family, keys, options)

          results.to_a.each.inject([]) do |arr, result|
            key = result[0]
            columns = result[1]

            next arr if columns.to_a.empty? # Columns maybe empty if the row is in a tombstone.
            arr << ordered_hash_to_model(key, columns)
          end
        end

        private
        def ordered_hash_to_model(key, ordered_hash)
          clazz= self.model_name.constantize rescue self
          hash= ordered_hash.to_hash
          clazz.new.tap do |model|
            model.key= key
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