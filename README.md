# CSDL

CSDL is a gem for producing Abstract Syntax Trees for the [DataSift CSDL Filter Language](http://dev.datasift.com/docs/csdl).
Working with an AST instead of raw strings provides a simpler way to test and validate any given CSDL filter.

[![Gem Version](https://badge.fury.io/rb/csdl.svg)](http://badge.fury.io/rb/csdl)
[![Build Status](https://travis-ci.org/localshred/csdl.svg)](https://travis-ci.org/localshred/csdl)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/gems/csdl)
[![Inline docs](http://inch-ci.org/github/localshred/csdl.svg?branch=master)](http://inch-ci.org/github/localshred/csdl)

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

Valid builder methods are:

- `_and` - `AND`s two or more child statements together.
- `_not` - Negates a `filter` statement.
- `_or` - `OR`s two or more child statements together.
- `_return` - Creates a return statement with an implicit `statement_scope`.
- `filter` - Builds a `target + operator + argument` group. Ensures `target` and `operator` are valid.
- `logical_group` - Create a parenthetical grouping for nested statements. Optionally takes a logical operator as the first argument since we commonly want to wrap OR'd or AND'd statements in a logical group.
- `statement_scope` - Create a braced grouping for nested statements used by tag and return blocks.
- `tag` - Builds a tag classifier (e.g. `tag "Desire" { ... }`).
- `tag_tree` - Builds a tag tree classifier (e.g. `tag.movies "Video" { ... }`).

Methods prefixed with "\_" are to avoid ruby keyword collisions.

```ruby
builder = ::CSDL::Builder.new._or do
  [
    logical_group(:and) {
      [
        logical_group(:or) {
          [
            filter("fb.content", :contains_any, "ebola"),
            filter("fb.parent.content", :contains_any, "ebola")
          ]
        },
        _not("fb.content", :contains_any, "government,politics"),
        filter("fb.author.country_code", :in, "GB")
      ]
    },
    logical_group(:and) {
      [
        logical_group(:or) {
          [
            filter("fb.content", :contains_any, "malta,malta island,#malta"),
            filter("fb.parent.content", :contains_any, "malta,malta island,#malta")
          ]
        },
        _not("fb.content", :contains_any, "vacation,poker awards")
      ]
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
  (logical_group
    (and
      (logical_group
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
  (logical_group
    (and
      (logical_group
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

