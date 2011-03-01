module Cassandrb
  module Criterion
    module IndexSlice

      attr_accessor :clause

      def indexed_slices(options)
        build_index_expressions unless @index_expressions_built

        indexed_slices = client.get_indexed_slices(column_family, clause, options)

        non_deleted_slices = non_deleted_slices(indexed_slices)
        nds_count = non_deleted_slices.length

        unless nds_count == self.options[:count]
          non_deleted_slices = non_deleted_slices.merge(get_more_slices(non_deleted_slices))
        end
        non_deleted_slices
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