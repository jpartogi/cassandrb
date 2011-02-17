module Cassandrb
  module Extensions
    module Symbol
      def eq
        SymbolOperator.new(self, '==')
      end
    end
  end
end

class SymbolOperator
  include Comparable

  attr_reader :field, :operator

  def initialize(field, operator, options={})
    @field, @operator = field, operator
  end unless method_defined?(:initialize)

  def <=>(other)
    if field == other.field
      operator <=> other.operator
    else
      field.to_s <=> other.field.to_s
    end
  end

  def ==(other)
    field == other.field && operator == other.operator
  end
end

class Symbol
  include Cassandrb::Extensions::Symbol
end