module Cassandrb
  module Criterion
    module IndexSlice

      attr_accessor :clause

      def indexed_slices(options)
        build_index_expressions unless @index_expressions_built

        indexed_slices = client.get_indexed_slices(column_family, clause, options)

        slices_to_objects(indexed_slices)
      end

      def expressions
        @expressions ||= []
      end

      private
      def build_index_expressions
        criterias.each do |key,value|

          key= key.field if key.respond_to? :field

          op= key.operator  if key.respond_to? :operator || '='

          client.create_index(keyspace, column_family, key.to_s, clazz.columns[key].validate_with)

          expressions << client.create_idx_expr(key.to_s, value, op)
        end

        @clause= client.create_idx_clause(expressions)

        @index_expressions_built= true
      end
    end
  end
end