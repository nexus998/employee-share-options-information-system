module Keisan
  module Exceptions
    class BaseError < ::StandardError; end

    class InternalError < BaseError; end
    class StandardError < BaseError; end

    class NotImplementedError < InternalError; end

    class InvalidToken < StandardError; end
    class TokenizingError < StandardError; end
    class ParseError < StandardError; end
    class ASTError < StandardError; end
    class InvalidFunctionError < StandardError; end
    class UndefinedFunctionError < StandardError; end
    class UndefinedVariableError < StandardError; end
    class UnmodifiableError < StandardError; end
    class InvalidExpression < StandardError; end
    class TypeError < StandardError; end
    class NonDifferentiableError < StandardError; end

    class BreakError < StandardError; end
    class ContinueError < StandardError; end
  end
end
