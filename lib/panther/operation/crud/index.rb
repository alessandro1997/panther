# frozen_string_literal: true
module Panther
  module Operation
    class Index < Base
      def call
        relation = collection(params).paginate(page: params[:page])
        respond_with resource: self.class.collection_representer_klass.new(relation)
      end

      private

      def collection(_params)
        fail NotImplementedError
      end
    end
  end
end