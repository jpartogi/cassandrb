require 'cassandrb/util'
require 'cassandrb/criterion/index_slice'

module Cassandrb
  class Criteria
    
    include Criterion::IndexSlice 

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
      objects(:count => 1).first
    end

    def objects(options={})
      if criterias.empty? then range_slices(options)
      else indexed_slices(options)
      end
    end
    
    def to_a
      if criterias.empty? then range_slices(options)
      else indexed_slices(options)
      end
    end

    def range_slices(options)
      slices= client.get_range(column_family, options)

      slices_to_objects(slices)
    end

    def slices_to_objects(slices)
      more, last_key = 0, nil

      objects = slices.each.inject([]) do |arr, keyslice|
        key, columns= keyslice.key, keyslice.columns

        if not columns.to_a.empty?
          arr << columns_to_model(key, columns)
        else
          more += 1
        end

        last_key = key
        arr
      end

      if more > 0
        options[:start] = last_key
        options[:count] = if more.eql? 1 then more + 1
                          else more
                          end

        objects.pop

        caller_method=  parse_caller(caller.first).last
        m = self.method(caller_method)

        objects += m.call(options)
      end
      objects
    end

    def columns_to_model(key, columns)
      klass= clazz.model_name.constantize rescue self

      klass.new.tap do |model|
        model.key= key
        columns.each { |col_or_supercol| model.send("#{col_or_supercol.column.name}=", col_or_supercol.column.value) }
      end
    end
  end
end
