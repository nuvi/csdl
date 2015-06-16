require "csdl/operator"

module CSDL

  # A CSDL Operator definition with indication as to valid data types to be used with the operator.
  #
  # @attr name [String] The name of the operator.
  # @attr argument_types [Array<Symbol>] List of valid argument node types that can be associated with an operator.
  #
  # @see OPERATORS
  #
  Operator = Struct.new(:name, :argument_types)

  # A raw array of operators with their valid argument types.
  #
  # @return [Array<String, Array<Symbol>>] Array of operators used to produce {OPERATORS} hash.
  #
  RAW_OPERATORS = [
    [ "contains"         , [ :string ] ],
    [ "cs contains"      , [ :string ] ],
    [ "substr"           , [ :string ] ],
    [ "cs substr"        , [ :string ] ],
    [ "contains_any"     , [ :string ] ],
    [ "cs contains_any"  , [ :string ] ],
    [ "any"              , [ :string ] ],
    [ "cs any"           , [ :string ] ],
    [ "wildcard"         , [ :string ] ],
    [ "cs wildcard"      , [ :string ] ],
    [ "wild"             , [ :string ] ],
    [ "cs wild"          , [ :string ] ],
    [ "contains_all"     , [ :string ] ],
    [ "cs contains_all"  , [ :string ] ],
    [ "all"              , [ :string ] ],
    [ "cs all"           , [ :string ] ],
    [ "contains_near"    , [ :string ] ],
    [ "cs contains_near" , [ :string ] ],
    [ "exists"           , [ :string ] ],
    [ "in"               , [ :string ] ],
    [ "url_in"           , [ :string ] ],
    [ "=="               , [ :string ] ],
    [ "!="               , [ :string ] ],
    [ "cs =="            , [ :string ] ],
    [ "cs !="            , [ :string ] ],
    [ ">"                , [ :string ] ],
    [ ">="               , [ :string ] ],
    [ "<"                , [ :string ] ],
    [ "<="               , [ :string ] ],
    [ "regex_partial"    , [ :string ] ],
    [ "regex_exact"      , [ :string ] ],
    [ "geo_box"          , [ :string ] ],
    [ "geo_radius"       , [ :string ] ],
    [ "geo_polygon"      , [ :string ] ]
  ]

  # All possible operators.
  #
  # @return [Hash<String, Operator>] Hash of {Operator} structs, keyed by the string name of the operator.
  #
  OPERATORS = RAW_OPERATORS.reduce({}) do |accumulator, (operator_name, argument_types)|
    accumulator[operator_name] = Operator.new(operator_name, argument_types)
    accumulator
  end.freeze

  # Check if the given target is a valid operator.
  #
  # @example
  #   CSDL.operator?("fake") # => false
  #   CSDL.operator?("contains") # => true
  #   CSDL.operator?(">=") # => true
  #
  # @param target_name [String] The name of the target.
  #
  # @return [Boolean] Whether or not the value is a valid CSDL Operator.
  #
  def self.operator?(operator)
    OPERATORS.key?(operator)
  end

end

