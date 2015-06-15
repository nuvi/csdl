module CSDL
  class Error                            < ::StandardError; end

  class InvalidInteractionTargetError    < Error; end
  class InvalidQueryTargetError          < Error; end
  class MissingChildNodesError           < Error; end
  class MissingReturnStatementScopeError < Error; end
  class MissingTagClassError             < Error; end
  class MissingTagNodesError             < Error; end
  class MissingTagStatementScopeError    < Error; end
  class UnknownOperatorError             < Error; end
  class UnknownTargetError               < Error; end
end

