# frozen_string_literal: true
module Panther
  module Operation
    # Default show operation
    #
    # This can be used as the starting point for show operations or standalone.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    #
    # @abstract Subclass to implement a show operation
    #
    # @example A basic show operation
    #   module API
    #     module V1
    #       module Post
    #         module Operation
    #           class Show < ::Panther::Operation::Show
    #           end
    #         end
    #       end
    #     end
    #   end
    #
    # @example A show operation with custom find logic
    #   module API
    #     module V1
    #       module Post
    #         module Operation
    #           class Show < ::Panther::Operation::Show
    #             protected
    #
    #             def find_record
    #               ::Post.find_by!(slug: params[:id])
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    class Show < Base
      # Finds the record with {#find_record}, authorizes it and exposes it.
      #
      # @see #find_record
      def call
        load_record

        authorize context.record

        respond_with resource: self.class.representer_klass.new(context.record)
      end

      protected

      # Returns the scope to use for finding the resource.
      #
      # @return [ActiveRecord::Relation]
      def scope
        self.class.resource_model.all
      end

      # Finds the resource. By default, uses the +id+ parameter.
      #
      # @return [ActiveRecord::Base]
      def find_record
        scope.find(params[:id])
      end

      def load_record
        context.record ||= find_record
      end
    end
  end
end
