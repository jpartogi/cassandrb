require 'cassandrb'

module Cassandrb
  module Callbacks
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Callbacks

      define_model_callbacks :initialize, :only => :after
      define_model_callbacks :create, :update, :save, :destroy
    end

    module InstanceMethods
      def save(*options, &block)
        state = new? ? :create : :update
        run_callbacks(:save) do
          run_callbacks(state) do
            super
          end
        end
      end

      def destroy(*options, &block)
        run_callbacks(:destroy) do
          super
        end
      end
    end

  end
end