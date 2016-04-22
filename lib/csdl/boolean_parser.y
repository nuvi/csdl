class CSDL::BooleanParser
  token T_INTEGER T_LPAREN T_RPAREN
        T_TILDE T_COMMA T_IDENTIFIER

  prechigh
    right    T_TILDE
  preclow

  rule
    expression: expr
                  {
                    result = val[0]
                  }

          expr: T_TILDE expr
                  {
                    result = val[1].type == :condition ? val[1].updated(:not) : s(:not, val[1])
                  }
              | arg

           arg: T_INTEGER
              | var_ref
              | T_LPAREN expr T_RPAREN
                  {
                    result = [ val[1] ]
                  }
              | method_call

       var_ref: variable
                  {
                  }

      variable: T_IDENTIFIER
                  {
                    result = @conditions_origins[val[0]].clone
                  }

   method_call: T_IDENTIFIER paren_args
                  {
                    lparen_t, args, rparen_t = val[1]
                    result = s(val[0].downcase.to_sym, *args)
                  }

    paren_args: T_LPAREN none T_RPAREN
                  {
                    result = [ val[0], [], val[2] ]
                  }
              | T_LPAREN args T_RPAREN
                  {
                    result = [ val[0], val[1], val[3] ]
                  }

          args: expr
                  {
                    result = [ val[0] ]
                  }
              | args T_COMMA expr
                  {
                    result = val[0] << val[2]
                  }

          none: # nothing
                  {
                    result = nil
                  }
---- inner
  include ::AST::Sexp

  def initialize(conditions_origins)
    @conditions_origins = conditions_origins
  end

  def parse(tokens)
    @tokens = tokens

    do_parse
  end

  #
  # Returns the next token to process
  # @return [Array]
  #
  def next_token
    @tokens.shift
  end

  def on_error(t, value, stack)
    raise Racc::ParseError, "Error parsing boolean expression: #{value.inspect} (#{token_to_str(t)}), current stack = #{stack.inspect}"
  end

