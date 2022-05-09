module Keisan
  module Parsing
    class Hash < Element
      attr_reader :key_value_pairs

      def initialize(key_value_pairs)
        key_value_pairs = Array(key_value_pairs)
        if key_value_pairs.size == 1 && key_value_pairs.first.empty?
          @key_value_pairs = []
        else
          @key_value_pairs = key_value_pairs.map {|key_value_pair|
            validate_and_extract_key_value_pair(key_value_pair)
          }
        end
      end

      private

      def validate_and_extract_key_value_pair(key_value_pair)
        filtered_key_value_pair = key_value_pair.select {|token|
          !token.is_a?(Tokens::LineSeparator)
        }
        key, value = Util.array_split(filtered_key_value_pair) {|token|
          token.is_a?(Tokens::Colon)
        }
        raise Exceptions::ParseError.new("Invalid hash") unless key.size == 1 && value.size >= 1

        key = key.first
        if allowed_key?(key)
          [Parsing::String.new(key.value), Parsing::RoundGroup.new(value)]
        else
          raise Exceptions::ParseError.new("Invalid hash (keys must be constants)")
        end
      end

      def allowed_key?(key)
        case key
        when Tokens::String, Tokens::Boolean, Tokens::Null, Tokens::Number
          true
        else
          false
        end
      end
    end
  end
end
