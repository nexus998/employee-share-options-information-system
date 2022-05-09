module Keisan
  module Parsing
    class Indexing < SquareGroup
      attr_reader :arguments
      def initialize(arguments)
        @arguments = arguments
      end

      def node_class
        AST::Indexing
      end
    end
  end
end
