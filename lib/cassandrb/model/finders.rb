module Cassandrb
  module Model
    module Finders
      extend ActiveSupport::Concern

      module ClassMethods

        [ :where, :limit, :all, :first, :last ].each do |name|
          define_method(name) do |*args|
            criteria.send(name, *args)
          end
        end

        def find(key, options={})
          original_key= key.dup
          key = [key] unless key.is_a? Array

          rows= get_by_rowkey(key, options)

          if original_key.is_a? Array then rows
          elsif original_key.is_a? String or key.is_a? Integer then rows.first
          else raise 'Not supported'
          end
          
        end

        def criteria
          scope_stack.last || Cassandrb::Criteria.new(self)
        end

        def scope_stack
          scope_stack_for = Thread.current[:cassandrb_scope_stack] ||= {}
          scope_stack_for[object_id] ||= []
        end

        private
        def get_by_rowkey(keys, options={})
          results = self.client.multi_get(self.column_family, keys, options)

          results.to_a.each.inject([]) do |arr, result|
            key = result[0]
            columns = result[1]

            next arr if columns.to_a.empty? # Columns maybe empty if the row is in a tombstone.
            arr << ordered_hash_to_model(key, columns)
          end
        end

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