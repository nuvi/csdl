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
  Target = Struct.new(:name, :interaction?, :analysis?, :query?)

  # A raw array of targets with their usage flags.
  #
  # @return [Array<String, Boolean, Boolean, Boolean>] Array of targets used to produce {TARGETS} hash.
  #
  RAW_TARGETS = [

    [ "fb.author.age"                     , true  , true  , true  ] ,
    [ "fb.author.country"                 , true  , true  , true  ] ,
    [ "fb.author.country_code"            , true  , true  , true  ] ,
    [ "fb.author.gender"                  , true  , true  , true  ] ,
    [ "fb.author.region"                  , true  , true  , true  ] ,
    [ "fb.author.type"                    , true  , true  , true  ] ,
    [ "fb.content"                        , true  , false , true  ] ,
    [ "fb.hashtags"                       , true  , true  , true  ] ,
    [ "fb.language"                       , true  , true  , true  ] ,
    [ "fb.link"                           , true  , true  , true  ] ,
    [ "fb.media_type"                     , true  , true  , true  ] ,
    [ "fb.parent.author.age"              , true  , true  , true  ] ,
    [ "fb.parent.author.country"          , true  , true  , true  ] ,
    [ "fb.parent.author.country_code"     , true  , true  , true  ] ,
    [ "fb.parent.author.gender"           , true  , true  , true  ] ,
    [ "fb.parent.author.type"             , true  , true  , true  ] ,
    [ "fb.parent.content"                 , true  , false , true  ] ,
    [ "fb.parent.hashtags"                , true  , true  , true  ] ,
    [ "fb.parent.interface"               , true  , true  , true  ] ,
    [ "fb.parent.language"                , true  , true  , true  ] ,
    [ "fb.parent.link"                    , true  , true  , true  ] ,
    [ "fb.parent.media_type"              , true  , true  , true  ] ,
    [ "fb.parent.sentiment"               , true  , true  , true  ] ,
    [ "fb.parent.topics.about"            , true  , false , false ] ,
    [ "fb.parent.topics.category"         , true  , true  , true  ] ,
    [ "fb.parent.topics.company_overview" , true  , false , false ] ,
    [ "fb.parent.topics.location_city"    , true  , false , false ] ,
    [ "fb.parent.topics.location_street"  , true  , false , false ] ,
    [ "fb.parent.topics.mission"          , true  , false , false ] ,
    [ "fb.parent.topics.name"             , true  , true  , true  ] ,
    [ "fb.parent.topics.products"         , true  , false , false ] ,
    [ "fb.parent.topics.release_date"     , true  , false , false ] ,
    [ "fb.parent.topics.username"         , true  , false , false ] ,
    [ "fb.parent.topics.website"          , true  , false , false ] ,
    [ "fb.parent.topic_ids"               , true  , true  , true  ] ,
    [ "fb.sentiment"                      , true  , true  , true  ] ,
    [ "fb.topics.about"                   , true  , false , false ] ,
    [ "fb.topics.category"                , true  , true  , true  ] ,
    [ "fb.topics.company_overview"        , true  , false , false ] ,
    [ "fb.topics.location_city"           , true  , false , false ] ,
    [ "fb.topics.location_street"         , true  , false , false ] ,
    [ "fb.topics.mission"                 , true  , false , false ] ,
    [ "fb.topics.name"                    , true  , true  , true  ] ,
    [ "fb.topics.products"                , true  , false , false ] ,
    [ "fb.topics.release_date"            , true  , false , false ] ,
    [ "fb.topics.username"                , true  , false , false ] ,
    [ "fb.topics.website"                 , true  , false , false ] ,
    [ "fb.topic_ids"                      , true  , true  , true  ] ,
    [ "fb.type"                           , true  , true  , true  ] ,
    [ "interaction.content"               , true  , false , true  ] ,
    [ "interaction.hashtags"              , true  , true  , true  ] ,
    [ "interaction.media_type"            , true  , true  , true  ] ,
    [ "interaction.ml.categories"         , false , true  , true  ] ,
    [ "interaction.raw_content"           , true  , false , true  ] ,
    [ "interaction.subtype"               , true  , true  , true  ] ,
    [ "interaction.tags"                  , false , true  , false ] ,
    [ "interaction.tag_tree"              , false , true  , true  ] ,
    [ "links.code"                        , true  , true  , true  ] ,
    [ "links.domain"                      , true  , true  , true  ] ,
    [ "links.normalized_url"              , true  , true  , true  ] ,
    [ "links.url"                         , true  , true  , true  ]
  ]

  # All possible targets.
  #
  # @return [Hash<String, Target>] Hash of {Target} structs, keyed by the string name of the target.
  #
  TARGETS = RAW_TARGETS.reduce({}) do |accumulator, (target_name, interaction, analysis, query)|
    accumulator[target_name] = Target.new(target_name, interaction, analysis, query)
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

