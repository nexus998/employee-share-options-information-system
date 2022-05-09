module Keisan
  module Parsing
    class Function < Element
      attr_reader :name, :arguments

      def initialize(name, arguments)
        @name = name
        @arguments = Array(arguments)
      end
    end
  end
end
