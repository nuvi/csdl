module CSDL
  module TargetValues

    AGES = %w(
      18-24
      25-34
      35-44
      45-54
      55-64
      65+
      unknown
    ).freeze

    AUTHOR_TYPES = %w(
      page
      user
    ).freeze

    GENDERS = %w(
      female
      male
      unknown
    ).freeze

    INTERACTION_TYPES = %w(
      comment
      like
      reshare
      story
    ).freeze

    INTERFACES = %w(
      desktop
      mobile
    ).freeze

    MEDIA_TYPES = %w(
      link
      note
      photo
      post
      reshare
      video
    ).freeze

    SENTIMENT = %w(
      positive
      negative
      neutral
    ).freeze

    UNBOUNDED = ::Float::INFINITY

  end
end

require "csdl/target_values/countries"
require "csdl/target_values/languages"
require "csdl/target_values/regions"
require "csdl/target_values/topics"

