module Keisan
  module AST
    class Parent < Node
      attr_reader :children

      def initialize(children = [])
        children = Array(children).map do |child|
          child.is_a?(Cell) ? child : child.to_node
        end
        raise Exceptions::InternalError.new unless children.is_a?(Array)
        @children = children
      end

      def unbound_variables(context = nil)
        context ||= Context.new
        children.inject(Set.new) do |vars, child|
          vars | child.unbound_variables(context)
        end
      end

      def unbound_functions(context = nil)
        context ||= Context.new
        children.inject(Set.new) do |fns, child|
          fns | child.unbound_functions(context)
        end
      end

      def traverse(&block)
        value = super(&block)
        return value if value
        children.each do |child|
          value = child.traverse(&block)
          return value if value
        end
        false
      end

      def freeze
        children.each(&:freeze)
        super
      end

      def ==(other)
        return false unless self.class == other.class

        children.size == other.children.size && children.map.with_index {|_,i|
          children[i] == other.children[i]
        }.all? {|bool|
          bool == true
        }
      end

      def deep_dup
        dupped = dup
        dupped.instance_variable_set(
          :@children,
          dupped.children.map(&:deep_dup)
        )
        dupped
      end

      def evaluate(context = nil)
        context ||= Context.new
        @children = children.map {|child| child.evaluate(context)}
        self
      end

      def simplify(context = nil)
        context ||= Context.new
        @children = @children.map {|child| child.simplify(context)}
        self
      end

      def replace(variable, replacement)
        @children = children.map {|child| child.replace(variable, replacement)}
        self
      end

      def is_constant?
        @children.all?(&:is_constant?)
      end
    end
  end
end
