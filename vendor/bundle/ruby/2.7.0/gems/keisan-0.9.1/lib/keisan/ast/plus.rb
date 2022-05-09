module Keisan
  module AST
    class Plus < ArithmeticOperator
      def initialize(children = [], parsing_operators = [])
        super
        convert_minus_to_plus!(parsing_operators)
      end

      def self.symbol
        :+
      end

      def blank_value
        0
      end

      def value(context = nil)
        children_values = children.map {|child| child.value(context)}
        # Special case of string concatenation
        if children_values.all? {|child| child.is_a?(::String)}
          children_values.join
        # Special case of array concatenation
        elsif children_values.all? {|child| child.is_a?(::Array)}
          children_values.inject([], &:+)
        elsif children_values.one? {|child| child.is_a?(::Date)}
          date_time_plus(children_values, ::Date)
        elsif children_values.one? {|child| child.is_a?(::Time)}
          date_time_plus(children_values, ::Time)
        else
          children_values.inject(0, &:+)
        end.to_node.value(context)
      end

      def evaluate(context = nil)
        children[1..-1].inject(children.first.evaluate(context)) {|total, child| total + child.evaluate(context)}
      end

      def simplify(context = nil)
        context ||= Context.new

        super(context)

        # Commutative, so pull in operands of any `Plus` operators
        @children = children.inject([]) do |new_children, cur_child|
          case cur_child
          when Plus
            new_children + cur_child.children
          else
            new_children << cur_child
          end
        end

        if children.all? {|child| child.is_a?(String)}
          return String.new(children.inject("") do |result, child|
            result + child.value
          end)
        elsif children.all? {|child| child.is_a?(List)}
          return List.new(children.inject([]) do |result, child|
            result + child.value
          end)
        end

        constants, non_constants = *children.partition {|child| child.is_a?(Number)}
        constant = constants.inject(Number.new(0), &:+).simplify(context)

        if non_constants.empty?
          constant
        else
          @children = constant.value(context) == 0 ? [] : [constant]
          @children += non_constants

          return @children.first.simplify(context) if @children.size == 1

          self
        end
      end

      def differentiate(variable, context = nil)
        Plus.new(children.map {|child| child.differentiate(variable, context)}).simplify(context)
      end

      private

      def date_time_plus(elements, klass)
        date_time = elements.select {|child| child.is_a?(klass)}.first
        others = elements.select {|child| !child.is_a?(klass)}
        date_time + others.inject(0, &:+)
      end

      def convert_minus_to_plus!(parsing_operators)
        parsing_operators.each.with_index do |parsing_operator, index|
          if parsing_operator.is_a?(Parsing::Minus)
            @children[index+1] = UnaryMinus.new(@children[index+1])
          end
        end
      end
    end
  end
end
