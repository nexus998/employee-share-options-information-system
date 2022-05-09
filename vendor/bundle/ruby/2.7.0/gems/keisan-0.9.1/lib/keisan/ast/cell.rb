module Keisan
  module AST
    class Cell < Node
      attr_accessor :node

      def initialize(node)
        @node = node
      end

      def unbound_variables(context = nil)
        node.unbound_variables(context)
      end

      def unbound_functions(context = nil)
        node.unbound_functions(context)
      end

      def traverse(&block)
        super(&block) || node.traverse(&block)
      end

      def deep_dup
        dupped = dup
        dupped.instance_variable_set(
          :@node,
          dupped.node.deep_dup
        )
        dupped
      end

      def freeze
        node.freeze
        super
      end

      def value(context = nil)
        node.value(context)
      end

      def true?
        node.true?
      end

      def false?
        node.false?
      end

      def evaluate(context = nil)
        node.evaluate(context)
      end

      def simplify(context = nil)
        node.simplify(context)
      end

      def evaluate_assignments(context = nil)
        node.evaluate_assignments(context)
      end

      def differentiate(variable, context = nil)
        node.differentiate(variable, context)
      end

      def replace(variable, replacement)
        node.replace(variable, replacement)
      end

      def to_cell
        self.class.new(node.to_node)
      end

      def to_s
        node.to_s
      end

      def to_node
        node
      end

      %i(< <= > >= equal not_equal).each do |sym|
        define_method(sym) {|other|
          node.send(sym, other.to_node)
        }
      end
    end
  end
end
