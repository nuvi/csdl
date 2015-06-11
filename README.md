# CSDL

CSDL is a gem for producing Abstract Syntax Trees for the [DataSift CSDL Filter Language](http://dev.datasift.com/docs/csdl).
Working with an AST instead of raw strings provides a simpler way to test and validate any given CSDL filter.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "csdl"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csdl

## Usage

Use the DSL provided by `CSDL::Builder` to produce an AST representation of your query, and use `CSDL::Processor` to turn your AST into a raw CSDL string.

Valid builder methods are `closure`, `filter`, `_and`, `_or`, and `_not`. The last three are prefixed to avoid keyword collision.

```ruby
builder = ::CSDL::Builder.new._or do
  [
    closure {
      _and {
        [
          closure {
            _or {
              [
                filter("fb.content", :contains_any, "ebola"),
                filter("fb.parent.content", :contains_any, "ebola")
              ]
            }
          },
          _not("fb.content", :contains_any, "government,politics"),
          filter("fb.author.country_code", :in, "GB")
        ]
      }
    },
    closure {
      _and {
        [
          closure {
            _or {
              [
                filter("fb.content", :contains_any, "malta,malta island,#malta"),
                filter("fb.parent.content", :contains_any, "malta,malta island,#malta")
              ]
            }
          },
          _not("fb.content", :contains_any, "vacation,poker awards")
        ]
      }
    }
  ]
end

puts
puts "Builder..."
puts builder.to_sexp

puts
puts "Processing AST..."
puts ::CSDL::Processor.new.process(builder)
```

The previous script produces the following output:

```
Builder...
(or
  (closure
    (and
      (closure
        (or
          (filter
            (target "fb.content")
            (operator :contains_any)
            (argument
              (string "ebola")))
          (filter
            (target "fb.parent.content")
            (operator :contains_any)
            (argument
              (string "ebola")))))
      (not
        (target "fb.content")
        (operator :contains_any)
        (argument
          (string "government,politics")))
      (filter
        (target "fb.author.country_code")
        (operator :in)
        (argument
          (string "GB")))))
  (closure
    (and
      (closure
        (or
          (filter
            (target "fb.content")
            (operator :contains_any)
            (argument
              (string "malta,malta island,#malta")))
          (filter
            (target "fb.parent.content")
            (operator :contains_any)
            (argument
              (string "malta,malta island,#malta")))))
      (not
        (target "fb.content")
        (operator :contains_any)
        (argument
          (string "vacation,poker awards"))))))

Processing AST...
((fb.content contains_any "ebola" OR fb.parent.content contains_any "ebola") AND NOT fb.content contains_any "government,politics" AND fb.author.country_code in "GB") OR ((fb.content contains_any "malta,malta island,#malta" OR fb.parent.content contains_any "malta,malta island,#malta") AND NOT fb.content contains_any "vacation,poker awards")
```

The processed AST looks like this (manually expanded):

```
(
  (
    fb.content contains_any "ebola"
    OR fb.parent.content contains_any "ebola"
  )
  AND NOT fb.content contains_any "government,politics"
  AND fb.author.country_code in "GB"
)
OR
(
  (
    fb.content contains_any "malta,malta island,#malta"
    OR fb.parent.content contains_any "malta,malta island,#malta"
  )
  AND NOT fb.content contains_any "vacation,poker awards"
)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/localshred/csdl](https://github.com/localshred/csdl).

