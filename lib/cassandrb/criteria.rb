require 'cassandrb/criterion/slice'

module Cassandrb
  class Criteria
    
    include Criterion::Slice 

    attr_accessor :criterias, :options, :clazz, :client, :keyspace, :column_family

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
        index_slices= true
      end
    end

    def limit(value=100)
      clone.tap { |criteria| criteria.options[:limit] = value }
    end
    
    def each(&proc)
      clone.tap do |criteria|
        build_index_slices if index_slices?

        slices.each do |result|
          proc.call(result)
        end
      end
    end

  end
end