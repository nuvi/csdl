%%machine lexer;

module CSDL
  class BooleanLexer
    %% write data;

    CONVERSION = {
        :T_INT => :to_i,
      }

    def initialize
      reset
    end

    def reset
      @data     = nil
      @ts       = nil
      @te       = nil
      @tokens   = []
    end

    # @ts, @te -> token start, token end
    # had to use @te-1 for token range end because 1 digit token (eg.: ',(,),+) and no whitespace between will
    # break the tokenization
    def data(start = @ts, stop = (@te-1))
      return @data[start..stop].pack('U*')
    end

    def emit(symbol, start = @ts, stop = (@te-1))
      value = data(start, stop)

      if symbol.eql?(:T_INT)
        value = value.send(CONVERSION[symbol])
      end

      @tokens << [ symbol, value ]
    end

    def lex(data)
      @data = data.unpack("U*")
      lexer_start = self.class.lexer_start
      eof = data.length

      _lexer_eof_trans          = self.class.send(:_lexer_eof_trans)
      _lexer_from_state_actions = self.class.send(:_lexer_from_state_actions)
      _lexer_index_offsets      = self.class.send(:_lexer_index_offsets)
      _lexer_indicies           = self.class.send(:_lexer_indicies)
      _lexer_key_spans          = self.class.send(:_lexer_key_spans)
      _lexer_to_state_actions   = self.class.send(:_lexer_to_state_actions)
      _lexer_trans_actions      = self.class.send(:_lexer_trans_actions)
      _lexer_trans_keys         = self.class.send(:_lexer_trans_keys)
      _lexer_trans_targs        = self.class.send(:_lexer_trans_targs)

      %% write init;
      %% write exec;

      tokens = @tokens

      reset

      return tokens
    end

    %%{
      access @;

      T_INT         = [0-9]+;
      T_IDENTIFIER  = [a-zA-Z_][a-zA-Z_0-9]*;
      T_TILDE       = '~';
      T_LPAREN      = '(';
      T_RPAREN      = ')';
      T_COMMA       = ',';

      main := |*

        T_INT => {
          emit(:T_INT)
        };

        T_IDENTIFIER => {
          emit(:T_IDENTIFIER)
        };

        T_TILDE => {
          emit(:T_TILDE)
        };

        T_LPAREN => {
          emit(:T_LPAREN)
        };

        T_RPAREN => {
          emit(:T_RPAREN)
        };

        T_COMMA => {
          emit(:T_COMMA)
        };

        space;

      *|;

    }%%
  end # BooleanLexer
end # CSDL
