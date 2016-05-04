require "csdl/target_values"

module CSDL

  # A CSDL Target definition with indication as to where the target can be used.
  #
  # @attr name [String] The name of the target.
  # @attr interaction? [Boolean] True if the target is availble for use in an Interaction Filter.
  # @attr analysis? [Boolean] True if the target is availble for use as an Analysis Target.
  # @attr query? [Boolean] True if the target is availble for use in a Query Filter.
  #
  # @see TARGETS
  #
  Target = Struct.new(:name, :interaction?, :analysis?, :query?, :values)

  # A raw array of targets with their usage flags.
  #
  # @return [Array<String, Boolean, Boolean, Boolean>] Array of targets used to produce {TARGETS} hash.
  #
  RAW_TARGETS = [

    [ "fb.author.age"                     , true  , true  , true  , :AGES ] ,
    [ "fb.author.country"                 , true  , true  , true  , :COUNTRIES ] ,
    [ "fb.author.country_code"            , true  , true  , true  , :COUNTRY_CODES ] ,
    [ "fb.author.gender"                  , true  , true  , true  , :GENDERS ] ,
    [ "fb.author.region"                  , true  , true  , true  , :REGIONS ] ,
    [ "fb.author.type"                    , true  , true  , true  , :AUTHOR_TYPES ] ,
    [ "fb.content"                        , true  , false , true  , :UNBOUNDED ] ,
    [ "fb.hashtags"                       , true  , true  , true  , :UNBOUNDED ] ,
    [ "fb.language"                       , true  , true  , true  , :LANGUAGE_CODES ] ,
    [ "fb.link"                           , true  , true  , true  , :UNBOUNDED ] ,
    [ "fb.media_type"                     , true  , true  , true  , :MEDIA_TYPES ] ,
    [ "fb.parent.author.age"              , true  , true  , true  , :AGES ] ,
    [ "fb.parent.author.country"          , true  , true  , true  , :COUNTRIES ] ,
    [ "fb.parent.author.country_code"     , true  , true  , true  , :COUNTRY_CODES ] ,
    [ "fb.parent.author.gender"           , true  , true  , true  , :GENDERS ] ,
    [ "fb.parent.author.type"             , true  , true  , true  , :AUTHOR_TYPES ] ,
    [ "fb.parent.content"                 , true  , false , true  , :UNBOUNDED ] ,
    [ "fb.parent.hashtags"                , true  , true  , true  , :UNBOUNDED ] ,
    [ "fb.parent.interface"               , true  , true  , true  , :INTERFACES ] ,
    [ "fb.parent.language"                , true  , true  , true  , :LANGUAGE_CODES ] ,
    [ "fb.parent.link"                    , true  , true  , true  , :UNBOUNDED ] ,
    [ "fb.parent.media_type"              , true  , true  , true  , :MEDIA_TYPES ] ,
    [ "fb.parent.sentiment"               , true  , true  , true  , :SENTIMENT ] ,
    [ "fb.parent.topics.about"            , true  , false , false , :UNBOUNDED ] ,
    [ "fb.parent.topics.category"         , true  , true  , true  , :TOPIC_CATEGORIES ] ,
    [ "fb.parent.topics.company_overview" , true  , false , false , :UNBOUNDED ] ,
    [ "fb.parent.topics.location_city"    , true  , false , false , :UNBOUNDED ] ,
    [ "fb.parent.topics.location_street"  , true  , false , false , :UNBOUNDED ] ,
    [ "fb.parent.topics.mission"          , true  , false , false , :UNBOUNDED ] ,
    [ "fb.parent.topics.name"             , true  , true  , true  , :UNBOUNDED ] ,
    [ "fb.parent.topics.products"         , true  , false , false , :UNBOUNDED ] ,
    [ "fb.parent.topics.release_date"     , true  , false , false , :UNBOUNDED ] ,
    [ "fb.parent.topics.username"         , true  , false , false , :UNBOUNDED ] ,
    [ "fb.parent.topics.website"          , true  , false , false , :UNBOUNDED ] ,
    [ "fb.parent.topic_ids"               , true  , true  , true  , :UNBOUNDED ] ,
    [ "fb.sentiment"                      , true  , true  , true  , :SENTIMENT ] ,
    [ "fb.topics.about"                   , true  , false , false , :UNBOUNDED ] ,
    [ "fb.topics.category"                , true  , true  , true  , :TOPIC_CATEGORIES ] ,
    [ "fb.topics.company_overview"        , true  , false , false , :UNBOUNDED ] ,
    [ "fb.topics.location_city"           , true  , false , false , :UNBOUNDED ] ,
    [ "fb.topics.location_street"         , true  , false , false , :UNBOUNDED ] ,
    [ "fb.topics.mission"                 , true  , false , false , :UNBOUNDED ] ,
    [ "fb.topics.name"                    , true  , true  , true  , :UNBOUNDED ] ,
    [ "fb.topics.products"                , true  , false , false , :UNBOUNDED ] ,
    [ "fb.topics.release_date"            , true  , false , false , :UNBOUNDED ] ,
    [ "fb.topics.username"                , true  , false , false , :UNBOUNDED ] ,
    [ "fb.topics.website"                 , true  , false , false , :UNBOUNDED ] ,
    [ "fb.topic_ids"                      , true  , true  , true  , :UNBOUNDED ] ,
    [ "fb.type"                           , true  , true  , true  , :INTERACTION_TYPES ] ,
    [ "instagram.from.username"           , true  , true  , true  , :UNBOUNDED ] ,
    [ "instagram.type"                    , true  , true  , true  , :INTERACTION_TYPES ] ,
    [ "interaction.author.username"       , true  , true  , true  , :UNBOUNDED ] ,
    [ "interaction.content"               , true  , false , true  , :UNBOUNDED ] ,
    [ "interaction.hashtags"              , true  , true  , true  , :UNBOUNDED ] ,
    [ "interaction.mentions"              , true  , true  , true  , :UNBOUNDED ] ,
    [ "interaction.media_type"            , true  , true  , true  , :MEDIA_TYPES ] ,
    [ "interaction.ml.categories"         , false , true  , true  , :UNBOUNDED ] ,
    [ "interaction.raw_content"           , true  , false , true  , :UNBOUNDED ] ,
    [ "interaction.subtype"               , true  , true  , true  , :INTERACTION_TYPES ] ,
    [ "interaction.tags"                  , false , true  , false , :UNBOUNDED ] ,
    [ "interaction.tag_tree"              , false , true  , true  , :UNBOUNDED ] ,
    [ "links.code"                        , true  , true  , true  , :UNBOUNDED ] ,
    [ "links.domain"                      , true  , true  , true  , :UNBOUNDED ] ,
    [ "links.normalized_url"              , true  , true  , true  , :UNBOUNDED ] ,
    [ "links.url"                         , true  , true  , true  , :UNBOUNDED ] ,
    [ "tumblr.blog_name"                  , true  , true  , true  , :UNBOUNDED ]

  ]

  # All possible targets.
  #
  # @return [Hash<String, Target>] Hash of {Target} structs, keyed by the string name of the target.
  #
  TARGETS = RAW_TARGETS.reduce({}) do |accumulator, (target_name, interaction, analysis, query, values_constant)|
    accumulator[target_name] = Target.new(target_name, interaction, analysis, query, TargetValues.const_get(values_constant))
    accumulator
  end.freeze

  INTERACTION_TARGETS = TARGETS.select { |_, target| target.interaction? }
  ANALYSIS_TARGETS    = TARGETS.select { |_, target| target.analysis? }
  QUERY_TARGETS       = TARGETS.select { |_, target| target.query? }

  # Check if the given target is a valid target.
  #
  # @example
  #   CSDL.target?("fake") # => false
  #   CSDL.target?("fb.content") # => true
  #
  # @param target_name [String] The name of the target.
  #
  # @return [Boolean] Whether or not the value is a valid CSDL Target.
  #
  def self.target?(target_name)
    TARGETS.key?(target_name)
  end

  # Check if the given target is a valid interaction target.
  #
  # @example
  #   CSDL.interaction_target?("interaction.tags") # => false
  #   CSDL.interaction_target?("interaction.content") # => true
  #
  # @param target_name [String] The name of the target.
  #
  # @return [Boolean] Whether or not the value is a valid CSDL Interaction Filter Target.
  #
  def self.interaction_target?(target_name)
    INTERACTION_TARGETS.key?(target_name)
  end

  # Check if the given target is a valid analysis target.
  #
  # @example
  #   CSDL.analysis_target?("interaction.content") # => false
  #   CSDL.analysis_target?("interaction.tags") # => true
  #
  # @param target_name [String] The name of the target.
  #
  # @return [Boolean] Whether or not the value is a valid CSDL Analysis Target.
  #
  def self.analysis_target?(target_name)
    ANALYSIS_TARGETS.key?(target_name)
  end

  # Check if the given target is a valid query target.
  #
  # @example
  #   CSDL.query_target?("fb.topics.website") # => false
  #   CSDL.query_target?("fb.topic_ids") # => true
  #
  # @example Verifying an interaction.tag_tree target
  #   CSDL.query_target?("interaction.tag_tree.foo") # => true
  #
  # @param target_name [String] The name of the target.
  #
  # @return [Boolean] Whether or not the value is a valid CSDL Query Filter Target.
  #
  def self.query_target?(target_name)
    QUERY_TARGETS.key?(target_name) || target_name =~ /^interaction\.tag_tree\..+$/
  end

end

