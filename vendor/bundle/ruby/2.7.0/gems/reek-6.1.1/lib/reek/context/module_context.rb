# frozen_string_literal: true

require_relative 'code_context'
require_relative 'attribute_context'
require_relative 'method_context'
require_relative 'visibility_tracker'

module Reek
  module Context
    #
    # A context wrapper for any module found in a syntax tree.
    #
    class ModuleContext < CodeContext
      attr_reader :visibility_tracker

      def initialize(exp)
        super
        @visibility_tracker = VisibilityTracker.new
      end

      # Register a child context. The child's parent context should be equal to
      # the current context.
      #
      # This makes the current context responsible for setting the child's
      # visibility.
      #
      # @param child [CodeContext] the child context to register
      def append_child_context(child)
        visibility_tracker.apply_visibility(child)
        super
      end

      # Return the correct class for child method contexts (representing nodes
      # of type `:def`). For ModuleContext, this is the class that represents
      # instance methods.
      def method_context_class
        MethodContext
      end

      # Return the correct class for child attribute contexts. For
      # ModuleContext, this is the class that represents instance attributes.
      def attribute_context_class
        AttributeContext
      end

      def defined_instance_methods(visibility: :any)
        return instance_method_children if visibility == :any

        instance_method_children.select { |child| child.visibility == visibility }
      end

      def instance_method_calls
        instance_method_children.flat_map do |context|
          context.children.grep(SendContext)
        end
      end

      def instance_method_names_via_to_call
        instance_method_calls.flat_map(&:method_name_called_to_call).compact
      end

      #
      # @deprecated use `defined_instance_methods` instead
      #
      def node_instance_methods
        local_nodes(:def).to_a
      end

      def descriptively_commented?
        CodeComment.new(comment: exp.leading_comment).descriptive?
      end

      CONSTANT_SEXP_TYPES = [:casgn, :class, :module].freeze

      # A namespace module is a module (or class) that is only there for namespacing
      # purposes, and thus contains only nested constants, modules or classes.
      #
      # However, if the module is empty, it is not considered a namespace module.
      #
      # @return true if the module is a namespace module
      #
      # @quality :reek:FeatureEnvy
      def namespace_module?
        return false if exp.type == :casgn

        children = exp.direct_children
        children.any? && children.all? { |child| CONSTANT_SEXP_TYPES.include? child.type }
      end

      def track_visibility(visibility, names)
        visibility_tracker.track_visibility children: instance_method_children,
                                            visibility: visibility,
                                            names: names
        visibility_tracker.track_singleton_visibility children: singleton_method_children,
                                                      visibility: visibility,
                                                      names: names
      end

      private

      def instance_method_children
        children.select(&:instance_method?)
      end

      def singleton_method_children
        children.select(&:singleton_method?)
      end
    end
  end
end
