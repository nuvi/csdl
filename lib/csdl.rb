require "ast"
require "csdl/version"

# CSDL is a library for manipulating Abstract Syntax Trees that represent raw CSDL defintions. Using an AST
# makes it much simpler to manipulate, traverse, validate, and test complex CSDL queries.
#
# Use the DSL {Builder} class to produce a tree of nodes, then process those nodes
# with {Processor}, {InteractionFilterProcessor}, or {QueryFilterProcessor}. See
# those individuals classes for usage documentation.
#
# @see http://dev.datasift.com/docs/csdl DataSift CSDL Language Documentation
#
module CSDL
end

require "csdl/error"
require "csdl/targets"
require "csdl/operators"
require "csdl/builder"
require "csdl/boolean_lexer"
require "csdl/boolean_parser"
require "csdl/optimizing_processor"
require "csdl/optimizer"
require "csdl/processor"
require "csdl/boolean_processor"
require "csdl/interaction_filter_processor"
require "csdl/query_filter_processor"
