module Cassandrb
  module AttributeMethods
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload
    include ActiveModel::AttributeMethods

    included do
      include ActiveModel::MassAssignmentSecurity

      attribute_method_suffix "" # This is for read
      attribute_method_suffix "=" # This is for write
    end

    module ClassMethods
      def column(name, options={})
        undefine_attribute_methods
        super
      end

      def define_attribute_methods
        super(columns.keys)
      end
    end
    
    module InstanceMethods

      def initialize(attrs={})
        super()
        @attributes = attributes_from_property_defaults
        self.attributes = attrs
      end
      
      def attributes
        self.class.columns.values.inject({}) do |hash, col|
          hash[col.name] = attribute(col.name)
          hash
        end.with_indifferent_access
      end

      def attributes=(attrs)
        sanitize_for_mass_assignment(attrs).each do |k,v|
          next if k.to_sym == :column
          if respond_to?("#{k}=")
            __send__("#{k}=",v)
          else
            __send__(:attribute=,k,v)
          end
        end
      end

      def attribute=(attr_name, value)
        @attributes[attr_name] = value
      end

      def attribute(attr_name)
        if @attributes.include?(attr_name)
          @attributes[attr_name]
        else
          nil
        end
      end

      def respond_to?(*args)
        self.class.define_attribute_methods
        super
      end

      def attributes_from_property_defaults
        self.class.columns.values.inject({}) do |hash, col|
          hash[col.name] = col.default unless col.default.nil?
          hash
        end.with_indifferent_access
      end
    end
  end
end