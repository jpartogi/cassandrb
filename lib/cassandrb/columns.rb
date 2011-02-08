module Cassandrb
  module Columns
    def columns
      @columns ||= {}.with_indifferent_access
    end

    def column(name, options={})
      col = Column.new(name, options)
      columns[col.name] = col
    end
  end

  class Column
    attr_reader :name
    attr_reader :options
    
    def initialize(name, options={})
      @options= options
      @name = name.to_sym
    end

    def default
      options[:default]
    end
  end
end