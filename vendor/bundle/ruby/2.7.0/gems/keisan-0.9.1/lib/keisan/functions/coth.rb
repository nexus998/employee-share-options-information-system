module Keisan
  module Functions
    class Coth < CMathFunction
      def initialize
        super("coth", Proc.new {|arg| 1 / CMath::tanh(arg)})
      end

      protected

      def self.derivative(argument)
        -AST::Exponent.new([AST::Function.new([argument], "sinh"), -2])
      end
    end
  end
end
