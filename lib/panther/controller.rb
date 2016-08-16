# frozen_string_literal: true
module Panther
  # Controller mixin
  #
  # This module should be included in all controllers calling Panther operations. It provides
  # out of the box configuration for JSON APIs and helper methods for delegating to operations.
  #
  # @author Alessandro Desantis <desa.alessandro@gmail.com>
  module Controller
    # Included hook
    #
    # When including this module in a controller, <code>protect_from_forgery</code> is called with the
    # <code>null_session</code> and the controller is marked as responding to JSON.
    def self.included(klass)
      klass.class_eval do
        @actions = []

        protect_from_forgery with: :null_session
        respond_to :json
      end

      klass.extend ClassMethods
    end

    module ClassMethods
      # Returns whether this controller supports an action
      #
      # @param action [String|Symbol] The action to check
      #
      # @return [Boolean] Whether the action is supported
      def supports?(action)
        @actions.include?(action.to_sym)
      end

      # Returns the module encapsulating the resource
      #
      # If the controller's name is <code>API::V1::UsersController</code>, the default module name
      # will be <code>API::V1::User</code>. Basically, the method appends {#resource_name} to the
      # namespace.
      #
      # @return [Module] The resource module
      #
      # @see #resource_name
      def resource_module
        (name.to_s.split('::')[0..-2] << resource_name).join('::').constantize
      end

      # Returns the resource name
      #
      # If the controller's name is <code>API::V1::UsersController</code>, the default resource name
      # will be <code>User</code>.
      #
      # @return [String] The resource name
      def resource_name
        name.to_s.chomp('Controller').demodulize.singularize
      end

      # Returns the class handling an operation
      #
      # If the controller's name is <code>API::V1::UsersController</code>, the default class of the
      # <code>create</code> operation will be <code>API::V1::User::Operation::Create</code>.
      #
      # @param operation [String|Symbol] Operation name
      #
      # @return [Operation::Base] The operation
      #
      # @see #resource_module
      def operation_klass(operation)
        (resource_module.to_s << "::Operation::#{operation.to_s.camelcase}").constantize
      end

      protected

      # Sets the actions supported by the controller
      #
      # This method should be used at the class level to specify which actions the controller (thus,
      # the resource) supports.
      #
      # @example Specify the provided actions
      #   class API::V1::UsersController < ApplicationController
      #     include Panther::Controller
      #     actions :index, :show, :create
      #   end
      #
      # @return [Array] The supported actions
      def actions(*new_actions)
        @actions = new_actions.map(&:to_sym)
      end
    end

    %i(index show create update destroy).each do |action|
      define_method action do
        fail NotImplementedError unless self.class.supports?(action)
        run self.class.operation_klass(action)
      end
    end

    protected

    # Runs a Panther operation
    #
    # Runs the provided operation by calling {#call} on it and passing <code>operation_params</code>
    # as the <code>params</code> parameter.
    #
    # By default, <code>operation_params</code> simply returns Rails' <code>params</code>, but it
    # can be overridden to provide additional context.
    #
    # Responds with the <code>status</code> HTTP status of the context returned by the operation. If
    # the context returned by the operation has a <code>resource</code> attribute, then the resource
    # is also rendered as JSON.
    #
    # @param klass [Panther::Operation] The operation to run
    def run(klass)
      result = klass.call(params: operation_params)

      if result.resource
        render json: result.resource, status: result.status
      else
        head result.status
      end
    end

    private

    def operation_params
      params
    end
  end
end
