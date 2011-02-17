module Cassandrb
  class Criteria

    def initialize(clazz)
      @criterias||= Hash.new
      @clazz= clazz
      @client= clazz.client
    end

    def where(criteria_hash={})
      @criterias.update(criteria_hash)
      self
    end

    def criterias=(criterias)
      @criterias= criterias
    end

    def criterias
      @criterias ||= Hash.new
    end
    
    def each(&proc)
      keyspace= @client.keyspace
      column_family= @clazz.column_family

      expressions = []
      criterias.each do |key,value|

        if key.respond_to? :field 
          key= key.field
        end
        op='=='
        if key.respond_to? :operator
          op= key.operator
        end

        @client.create_index(keyspace, column_family, key.to_s, @clazz.columns[key].validate_with)

        expressions << @client.create_idx_expr(key.to_s, value, op) # Don't hardcode to only ==
      end

      clause = @client.create_idx_clause(expressions)
      slice= @client.get_indexed_slices(column_family, clause)
      results = @clazz.get_slice(slice)

      results.each do |result|
        proc.call(result)
      end
      self      
    end
  end
end