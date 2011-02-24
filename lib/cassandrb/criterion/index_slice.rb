module Cassandrb
  module Criterion
    module Slice
      def build_index_slices
        criterias.each do |key,value|

          key= key.field if key.respond_to? :field

          op= key.operator  if key.respond_to? :operator || '='

          client.create_index(keyspace, column_family, key.to_s, clazz.columns[key].validate_with)

          expressions << client.create_idx_expr(key.to_s, value, op)
        end

        clause = client.create_idx_clause(expressions)
        indexed_slices= client.get_indexed_slices(column_family, clause, :count => self.options[:limit])
        slices= clazz.get_slice(indexed_slices)
      end

      def slices=(slices)
        @slices= slices
      end

      def slices
        @slices ||= clazz.find_each(:count => self.options[:limit])
      end

      def index_slices=(value)
        @index_slices=value
      end

      def index_slices?
        @index_slices ||= false
      end

      def expressions
        @expressions ||= []
      end
    end
  end
end