require 'cassandrb/util'
require 'cassandrb/criterion/index_slice'

module Cassandrb
  class Criteria
    
    include Criterion::IndexSlice
    include Enumerable

    attr_accessor :criterias, :options, :clazz, :client, :keyspace, :column_family, :objects

    def initialize(clazz)
      @criterias, @options = {}, {}
      @clazz= clazz
      @client= clazz.client
      @keyspace= client.keyspace
      @column_family= clazz.column_family
    end

    def where(selector={})
      clone.tap do |criteria|
        criterias.update(selector)
      end
    end

    def all
      clone
    end

    def limit(value=100)
      clone.tap { |criteria| criteria.options[:count] = value }
    end

    def more(options={})
      clone.tap do |criteria|
        criteria.options[:start]= options[:from]
        criteria.options[:finish]= options[:to]
      end
    end

    def from(value)
      more(:from => value)
    end

    def to(value)
      more(:to => value)
    end
    
    def each(&block)
      objects= self.to_a
      objects.each(&block)
    end

    def first
      clone.tap do |criteria|
        criteria.options[:count] = 1  
      end.to_a.first
    end

    def objects(options={})
      if criterias.empty? then get_objects range_slices(options)
      else get_objects indexed_slices(options)
      end
    end
    
    def to_a
      if criterias.empty? then get_objects(range_slices(options))
      else get_objects(indexed_slices(options))
      end
    end

    def range_slices(options)
      slices= client.get_range(column_family, options)

      non_deleted_slices = non_deleted_slices(slices)
      nds_count = non_deleted_slices.length

      unless nds_count == self.options[:count]
        non_deleted_slices = non_deleted_slices.merge(get_more_slices(non_deleted_slices))
      end
      non_deleted_slices
    end

    private
    def get_more_slices(current_slices)
      nds_count = current_slices.length

      more = self.options[:count] - nds_count || 2

      options[:count] = more + 1
      options[:start] = current_slices.keys.last

      caller_method=  parse_caller(caller.first).last
      m = self.method(caller_method)
      slices = m.call(options)
    end

    def get_objects(keys_columns)
      keys_columns.each.inject([]) do |results, keys_columns|
        results << columns_to_object(keys_columns[0], keys_columns[1])
      end
    end

    def non_deleted_slices(slices)
      slices.each.inject({}) do |results, keyslice|
        key, columns = keyslice.key, keyslice.columns
        unless columns.empty?
          results[key] = columns
        end
        results
      end.with_indifferent_access
    end

    def columns_to_model(key, columns)
      klass= clazz.model_name.constantize rescue self

      klass.new.tap do |model|
        model.key= key
        columns.each { |col_or_supercol| model.send("#{col_or_supercol.column.name}=", col_or_supercol.column.value) }
      end
    end
    alias :columns_to_object :columns_to_model
  end
end
