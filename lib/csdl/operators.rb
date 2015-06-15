module CSDL

  Operator = Struct.new(:name, :argument_types)

  raw_operators = [
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

  OPERATORS = raw_operators.reduce({}) do |accumulator, (operator_name, argument_types)|
    accumulator[operator_name] = Operator.new(operator_name, argument_types)
    accumulator
  end.freeze

  def self.operator?(operator)
    OPERATORS.key?(operator)
  end

end

