require "test_helper"

class BuilderTest < ::MiniTest::Unit::TestCase
# csdl_sexp = s(:closure,
#               s(:or,
#                 s(:where,
#                   s(:target, "fb.content"),
#                   s(:operator, :contains_any),
#                   s(:argument,
#                     s(:string, "foo")
#                    )
#                  ),
#                  s(:where,
#                    s(:target, "fb.parent.content"),
#                    s(:operator, :contains_any),
#                    s(:argument,
#                      s(:string, "foo")
#                     )
#                   )
#                )
#              )
#
# puts
# puts csdl_sexp.to_sexp
#
# puts
# puts "processing..."
# processed = CSDL.new.process(csdl_sexp)
# puts processed
#
# builder = CSDLBuilder.new._or do
#   [
#     CSDLBuilder.new.closure {
#       CSDLBuilder.new._and {
#         [
#           CSDLBuilder.new.closure {
#             CSDLBuilder.new._or {
#               [
#                 CSDLBuilder.new.where("fb.content", :contains_any, "ebola"),
#                 CSDLBuilder.new.where("fb.parent.content", :contains_any, "ebola")
#               ]
#             }
#           },
#           CSDLBuilder.new._not("fb.content", :contains_any, "government,politics"),
#           CSDLBuilder.new.where("fb.author.country_code", :in, "GB")
#         ]
#       }
#     },
#     CSDLBuilder.new.closure {
#       CSDLBuilder.new._and {
#         [
#           CSDLBuilder.new.closure {
#             CSDLBuilder.new._or {
#               [
#                 CSDLBuilder.new.where("fb.content", :contains_any, "malta,malta island,#malta"),
#                 CSDLBuilder.new.where("fb.parent.content", :contains_any, "malta,malta island,#malta")
#               ]
#             }
#           },
#           CSDLBuilder.new._not("fb.content", :contains_any, "vacation,suicide,poker awards")
#         ]
#       }
#     }
#   ]
# end
#
# puts
# puts "Builder sexp..."
# puts builder.to_sexp
#
# puts
# puts "processing built sexp..."
# puts CSDL.new.process(builder)

end
