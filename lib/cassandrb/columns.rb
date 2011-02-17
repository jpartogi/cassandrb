module Cassandrb
  module Columns
    def columns
      @columns ||= {}.with_indifferent_access
    end
    alias fields columns

    def column(name, options={})
      col = Column.new(name, options)
      columns[col.name] = col
    end
    alias field column
  end

  class Column
    attr_reader :name
    attr_reader :options
    
    def initialize(name, options={})
      @options= options
      @name = name.to_s # Cassandra library does not like symbol :p
    end

    def default
      options[:default]
    end

    def validate_with
      options[:validate_with] ||= 'UTF8Type'
    end
  end
end