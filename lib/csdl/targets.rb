module CSDL

  module TargetValues

    AGES = %w( 18-24 25-34 35-44 45-54 55-64 65+ unknown ).freeze

    AUTHOR_TYPES = %w( page user ).freeze

    COUNTRY_CODES_BY_COUNTRY = {
      "Austria"        => "AT",
      "Belgium"        => "BE",
      "Denmark"        => "DK",
      "Finland"        => "FI",
      "France"         => "FR",
      "Germany"        => "DE",
      "Iceland"        => "IS",
      "Ireland"        => "IE",
      "Italy"          => "IT",
      "Luxembourg"     => "LU",
      "Netherlands"    => "NL",
      "Norway"         => "NO",
      "Portugal"       => "PT",
      "Spain"          => "ES",
      "Sweden"         => "SE",
      "Switzerland"    => "CH",
      "United Kingdom" => "GB",
      "United States"  => "US"
    }.freeze

    COUNTRIES = COUNTRY_CODES_BY_COUNTRY.keys.freeze

    COUNTRY_CODES = COUNTRY_CODES_BY_COUNTRY.values.freeze

    GENDERS = %w( female male unknown ).freeze

    INTERACTION_TYPES = %w( comment like reshare story ).freeze

    INTERFACES = %w( desktop mobile ).freeze

    LANGUAGES_BY_LANGUAGE_CODE = {
      "af" => "Afrikaans"  , "ak" => "Akan"            , "am" => "Amharic"     , "ar" => "Arabic"              ,
      "as" => "Assamese"   , "ay" => "Aymara"          , "az" => "Azerbaijani" , "be" => "Belarusian"          ,
      "bg" => "Bulgarian"  , "bn" => "Bengali"         , "br" => "Breton"      , "bs" => "Bosnian"             ,
      "ca" => "Catalan"    , "cb" => "Sorani Kurdish"  , "ck" => "Cherokee"    , "co" => "Corsican"            ,
      "cs" => "Czech"      , "cx" => "Cebuano"         , "cy" => "Welsh"       , "da" => "Danish"              ,
      "de" => "German"     , "el" => "Greek"           , "en" => "English"     , "eo" => "Esperanto"           ,
      "es" => "Spanish"    , "et" => "Estonian"        , "eu" => "Basque"      , "fa" => "Persian"             ,
      "ff" => "Fulah"      , "fi" => "Finnish"         , "fo" => "Faroese"     , "fr" => "French"              ,
      "fy" => "Frisian"    , "ga" => "Irish"           , "gl" => "Galician"    , "gn" => "Guarani"             ,
      "gu" => "Gujarati"   , "gx" => "Classical Greek" , "ha" => "Hausa"       , "he" => "Hebrew"              ,
      "hi" => "Hindi"      , "hr" => "Croatian"        , "hu" => "Hungarian"   , "hy" => "Armenian"            ,
      "id" => "Indonesian" , "ig" => "Igbo"            , "is" => "Icelandic"   , "it" => "Italian"             ,
      "ja" => "Japanese"   , "jv" => "Javanese"        , "ka" => "Georgian"    , "kk" => "Kazakh"              ,
      "km" => "Khmer"      , "kn" => "Kannada"         , "ko" => "Korean"      , "ku" => "Kurdish (Kurmanji)"  ,
      "la" => "Latin"      , "lg" => "Ganda"           , "li" => "Limburgish"  , "ln" => "Lingala"             ,
      "lo" => "Lao"        , "lt" => "Lithuanian"      , "lv" => "Latvian"     , "mg" => "Malagasy"            ,
      "mk" => "Macedonian" , "ml" => "Malayalam"       , "mn" => "Mongolian"   , "mr" => "Marathi"             ,
      "ms" => "Malay"      , "mt" => "Maltese"         , "my" => "Burmese"     , "nb" => "Norwegian (bokmal)"  ,
      "nd" => "Ndebele"    , "ne" => "Nepali"          , "nl" => "Dutch"       , "nn" => "Norwegian (nynorsk)" ,
      "ny" => "Chewa"      , "or" => "Oriya"           , "pa" => "Punjabi"     , "pl" => "Polish"              ,
      "ps" => "Pashto"     , "pt" => "Portuguese"      , "qu" => "Quechua"     , "rm" => "Romansh"             ,
      "ro" => "Romanian"   , "ru" => "Russian"         , "rw" => "Kinyarwanda" , "sa" => "Sanskrit"            ,
      "sc" => "Sardinian"  , "se" => "Northern Sámi"   , "si" => "Sinhala"     , "sk" => "Slovak"              ,
      "sl" => "Slovenian"  , "sn" => "Shona"           , "so" => "Somali"      , "sq" => "Albanian"            ,
      "sr" => "Serbian"    , "sv" => "Swedish"         , "sw" => "Swahili"     , "sy" => "Syriac"              ,
      "sz" => "Silesian"   , "ta" => "Tamil"           , "te" => "Telugu"      , "tg" => "Tajik"               ,
      "th" => "Thai"       , "tk" => "Turkmen"         , "tl" => "Filipino"    , "tr" => "Turkish"             ,
      "tt" => "Tatar"      , "tz" => "Tamazight"       , "uk" => "Ukrainian"   , "ur" => "Urdu"                ,
      "uz" => "Uzbek"      , "vi" => "Vietnamese"      , "wo" => "Wolof"       , "xh" => "Xhosa"               ,
      "yi" => "Yiddish"    , "yo" => "Yoruba"          , "zh" => "Chinese"     , "zu" => "Zulu"                ,
      "zz" => "Zazaki"
    }.freeze

    LANGUAGE_CODES = LANGUAGES_BY_LANGUAGE_CODE.keys.freeze

    LANGUAGES = LANGUAGES_BY_LANGUAGE_CODE.values.freeze

    MEDIA_TYPES = %w( link note photo post reshare video).freeze

    REGIONS_BY_COUNTRY = {
      "Austria" => [
        "Burgenland" , "Kärnten" , "Niederösterreich" , "Oberösterreich" , "Salzburg" ,
        "Steiermark" , "Tirol"   , "Vorarlberg"       , "Wien"
      ].freeze,

      "Belgium" => [
        "Région De Bruxelles-Capitale"
      ].freeze,

      "Denmark" => [
        "Arhus", "Nordjylland"
      ].freeze,

      "Finland" => [
        "Åland", "Lapland"
      ].freeze,

      "France" => [
        "Alsace"                     , "Aquitaine"        , "Auvergne"        , "Basse-Normandie"   ,
        "Bourgogne"                  , "Bretagne"         , "Centre"          , "Champagne-Ardenne" ,
        "Corse"                      , "Franche-Comté"    , "Haute-Normandie" , "Île-de-France"     ,
        "Languedoc-Roussillon"       , "Limousin"         , "Lorraine"        , "Midi-Pyrénées"     ,
        "Nord-Pas-de-Calais"         , "Pays de la Loire" , "Picardie"        , "Poitou-Charentes"  ,
        "Provence-Alpes-Côte d'Azur" , "Rhône-Alpes"
      ].freeze,

      "Germany" => [
        "Baden-Württemberg" , "Bayern"              , "Berlin"             , "Brandenburg"            ,
        "Bremen"            , "Hamburg"             , "Hessen"             , "Mecklenburg-Vorpommern" ,
        "Niedersachsen"     , "Nordrhein-Westfalen" , "Rheinland-Pfalz"    , "Saarland"               ,
        "Sachsen"           , "Sachsen-Anhalt"      , "Schleswig-Holstein" , "Thüringen"
      ].freeze,

      "Iceland" => [].freeze,

      "Ireland" => [
        "Carlow"  , "Cavan"     , "Clare"     , "Cork"      , "Donegal"   ,
        "Dublin"  , "Galway"    , "Kerry"     , "Kildare"   , "Kilkenny"  ,
        "Laois"   , "Leitrim"   , "Limerick"  , "Longford"  , "Louth"     ,
        "Mayo"    , "Meath"     , "Monaghan"  , "Offaly"    , "Roscommon" ,
        "Sligo"   , "Tipperary" , "Waterford" , "Westmeath" , "Wexford"   ,
        "Wicklow"
      ].freeze,

      "Italy" => [
        "Abruzzo"               , "Basilicata"          , "Calabria" , "Campania"      , "Emilia-Romagna" ,
        "Friuli-Venezia Giulia" , "Lazio"               , "Liguria"  , "Lombardia"     , "Marche"         ,
        "Molise"                , "Piemonte"            , "Puglia"   , "Sardegna"      , "Sicilia"        ,
        "Toscana"               , "Trentino-Alto Adige" , "Umbria"   , "Valle d'Aosta" , "Veneto"
      ].freeze,

      "Luxembourg" => [
        "Diekirch", "Grevenmacher", "Luxembourg"
      ].freeze,

      "Netherlands" => [
        "Drenthe" , "Flevoland"     , "Friesland"     , "Gelderland" , "Groningen" ,
        "Limburg" , "Noord-Brabant" , "Noord-Holland" , "Overijssel" , "Utrecht"   ,
        "Zeeland" , "Zuid-Holland"
      ].freeze,

      "Norway" => [
        "Akershus" , "Aust-Agder"       , "Buskerud"        , "Finnmark"       ,
        "Hedmark"  , "Hordaland"        , "Møre og Romsdal" , "Nord-Trøndelag" ,
        "Nordland" , "Oppland"          , "Oslo"            , "Østfold"        ,
        "Rogaland" , "Sogn og Fjordane" , "Sør-Trøndelag"   , "Telemark"       ,
        "Troms"    , "Vest-Agder"       , "Vestfold"
      ].freeze,

      "Portugal" => [
        "Aveiro"         , "Azores"  , "Beja"             , "Braga"      , "Braganca" ,
        "Castelo Branco" , "Coimbra" , "Evora"            , "Faro"       , "Guarda"   ,
        "Leiria"         , "Lisboa"  , "Madeira"          , "Portalegre" , "Porto"    ,
        "Santarem"       , "Setubal" , "Viana do Castelo" , "Vila Real"  , "Viseu"
      ].freeze,

      "Spain" => [
        "Andalucía"            , "Aragón"             , "Asturias" , "Cantabria"           ,
        "Castilla y Leon"      , "Castilla-La Mancha" , "Cataluña" , "Comunidad de Madrid" ,
        "Comunidad Valenciana" , "Extremadura"        , "Galicia"  , "Islas Baleares"      ,
        "Islas Canarias"       , "La Rioja"           , "Murcia"   , "Navarra"
      ].freeze,

      "Sweden" => [
        "Blekinge Län"    , "Dalarnas Län"      , "Gävleborgs Län"      , "Gotlands Län"      ,
        "Hallands Län"    , "Jämtlands Län"     , "Jönköpings Län"      , "Kalmar Län"        ,
        "Kronobergs Län"  , "Norrbottens Län"   , "Örebro Län"          , "Östergötlands Län" ,
        "Skåne Län"       , "Södermanlands Län" , "Stockholms Län"      , "Uppsala Län"       ,
        "Värmlands Län"   , "Västerbottens Län" , "Västernorrlands Län" , "Västmanlands Län"  ,
        "Västra Götaland"
      ].freeze,

      "Switzerland" => [
        "Aargau"   , "Basel-Landschaft" , "Basel-Stadt" , "Bern"         ,
        "Fribourg" , "Geneve"           , "Glarus"      , "Graubünden"   ,
        "Jura"     , "Luzern"           , "Neuchâtel"   , "Schaffhausen" ,
        "Schwyz"   , "Solothurn"        , "St. Gallen"  , "Thurgau"      ,
        "Ticino"   , "Valais"           , "Vaud"        , "Zug"          ,
        "Zürich"
      ].freeze,

      "United Kingdom" => [
        "England", "Scotland", "Wales", "Northern Ireland"
      ].freeze,

      "United States" => [
        "Alabama"       , "Alaska"      , "Arizona"        , "Arkansas"         , "California"     ,
        "Colorado"      , "Connecticut" , "Delaware"       , "Florida"          , "Georgia"        ,
        "Hawaii"        , "Idaho"       , "Illinois"       , "Indiana"          , "Iowa"           ,
        "Kansas"        , "Kentucky"    , "Louisiana"      , "Maine"            , "Maryland"       ,
        "Massachusetts" , "Michigan"    , "Minnesota"      , "Mississippi"      , "Missouri"       ,
        "Montana"       , "Nebraska"    , "Nevada"         , "New Hampshire"    , "New Jersey"     ,
        "New Mexico"    , "New York"    , "North Carolina" , "North Dakota"     , "Ohio"           ,
        "Oklahoma"      , "Oregon"      , "Pennsylvania"   , "Rhode Island"     , "South Carolina" ,
        "South Dakota"  , "Tennessee"   , "Texas"          , "Utah"             , "Vermont"        ,
        "Virginia"      , "Washington"  , "West Virginia"  , "Wisconsin"        , "Wyoming"
      ].freeze
    }.freeze

    REGIONS = REGIONS_BY_COUNTRY.values.flatten.freeze

    SENTIMENT = %w( positive negative neutral ).freeze

    TOPIC_CATEGORIES = [
      "Actor/Director"                      , "Aerospace/Defense"               , "Airport"                      ,
      "Album"                               , "Amateur Sports Team"             , "Anatomical Structure"         ,
      "Animal Breed"                        , "Animal"                          , "App"                          ,
      "Appliances"                          , "Art"                             , "Artist"                       ,
      "Arts/Entertainment/Nightlife"        , "Arts/Humanities"                 , "Athlete"                      ,
      "Attractions/Things to Do"            , "Author"                          , "Automobiles and Parts"        ,
      "Automotive"                          , "Baby Goods/Kids Goods"           , "Bags/Luggage"                 ,
      "Bank/Financial Institution"          , "Bank/Financial Services"         , "Bar"                          ,
      "Biotechnology"                       , "Blogger"                         , "Board Game"                   ,
      "Book Genre"                          , "Book Series"                     , "Book Store"                   ,
      "Book"                                , "Building Materials"              , "Business Person"              ,
      "Business Services"                   , "Business/Economy"                , "Camera/Photo"                 ,
      "Cars"                                , "Cause"                           , "Chef"                         ,
      "Chemicals"                           , "Church/Religious Organization"   , "City"                         ,
      "Clothing"                            , "Club"                            , "Coach"                        ,
      "Color"                               , "Comedian"                        , "Commercial Equipment"         ,
      "Community Organization"              , "Community"                       , "Community/Government"         ,
      "Company"                             , "Competition"                     , "Computers"                    ,
      "Computers/Internet"                  , "Computers/Technology"            , "Concentration or Major"       ,
      "Concert Tour"                        , "Concert Venue"                   , "Consulting/Business Services" ,
      "Country"                             , "Course"                          , "Cuisine"                      ,
      "Dancer"                              , "Degree"                          , "DESIGNER"                     ,
      "Disease"                             , "Doctor"                          , "Drink"                        ,
      "Drugs"                               , "Editor"                          , "Education"                    ,
      "Education/Work Status"               , "Electronics"                     , "Elementary School"            ,
      "Energy/Utility"                      , "Engineering/Construction"        , "Entertainer"                  ,
      "Entertainment"                       , "Entrepreneur"                    , "Episode"                      ,
      "Event Planning/Event Services"       , "Event"                           , "Farming/Agriculture"          ,
      "Fictional Character"                 , "Field of Study"                  , "Food"                         ,
      "Food/Beverages"                      , "Food/Grocery"                    , "Furniture"                    ,
      "Games/Toys"                          , "Geography_General"               , "Government Official"          ,
      "Government Organization"             , "Government"                      , "Health/Beauty"                ,
      "Health/Medical/Pharmaceuticals"      , "Health/Medical/Pharmacy"         , "Health/Wellness"              ,
      "High School Status"                  , "Holiday"                         , "Home Decor"                   ,
      "Home Improvement"                    , "Home/Garden"                     , "Hospital/Clinic"              ,
      "Hotel"                               , "Household Supplies"              , "Industrials"                  ,
      "Insurance Company"                   , "Interest"                        , "Internet/Software"            ,
      "Island"                              , "Jewelry/Watches"                 , "Journalist"                   ,
      "Just For Fun"                        , "Kitchen/Cooking"                 , "Lake"                         ,
      "Landmark"                            , "Language"                        , "Lawyer"                       ,
      "Legal/Law"                           , "Library"                         , "Local Business"               ,
      "Local/Travel"                        , "Magazine"                        , "Media/News/Publishing"        ,
      "Medical Procedure"                   , "Middle School"                   , "Mining/Materials"             ,
      "Monarch"                             , "Mountain"                        , "Movie character"              ,
      "Movie Genre"                         , "Movie Theater"                   , "Movie"                        ,
      "Museum/Art Gallery"                  , "Music Award"                     , "Music Chart"                  ,
      "Music Video"                         , "Music"                           , "Musical Genre"                ,
      "Musical Instrument"                  , "Musician/Band"                   , "Neighborhood"                 ,
      "News Personality"                    , "News/Media"                      , "Newspaper"                    ,
      "Non-Governmental Organization (NGO)" , "Non-Profit Organization"         , "Null"                         ,
      "Office Supplies"                     , "One-Time TV Program"             , "Organization"                 ,
      "Other"                               , "Outdoor Gear/Sporting Goods"     , "Patio/Garden"                 ,
      "Performance Art"                     , "Personal Blog"                   , "Personal Website"             ,
      "Pet Services"                        , "Pet Supplies"                    , "Pet"                          ,
      "Phone/Tablet"                        , "Photographer"                    , "Playlist"                     ,
      "Podcast"                             , "Political Ideology"              , "Political Organization"       ,
      "Political Party"                     , "Politician"                      , "Preschool"                    ,
      "Producer"                            , "Product/Service"                 , "Profession"                   ,
      "Professional Services"               , "Professional Sports Team"        , "Public Figure"                ,
      "Public Places"                       , "Publisher"                       , "Radio Station"                ,
      "Real Estate"                         , "Record Label"                    , "Recreation/Sports"            ,
      "Reference"                           , "Regional"                        , "Religion"                     ,
      "Restaurant/Cafe"                     , "Retail and Consumer Merchandise" , "River"                        ,
      "School Sports Team"                  , "School"                          , "Science"                      ,
      "Shopping/Retail"                     , "Small Business"                  , "Society/Culture"              ,
      "Software"                            , "Song"                            , "Spas/Beauty/Personal Care"    ,
      "Sport"                               , "Sports Event"                    , "Sports League"                ,
      "Sports Venue"                        , "Sports/Recreation/Activities"    , "State/Province/Region"        ,
      "Studio"                              , "Teacher"                         , "Teens/Kids"                   ,
      "Telecommunication"                   , "Tools/Equipment"                 , "Topic"                        ,
      "Tours/Sightseeing"                   , "Transit Stop"                    , "Transport/Freight"            ,
      "Transportation"                      , "Travel/Leisure"                  , "TV Channel"                   ,
      "TV Genre"                            , "TV Network"                      , "TV Season"                    ,
      "TV Show"                             , "TV"                              , "TV/Movie Award"               ,
      "University Status"                   , "University"                      , "Video Game"                   ,
      "Vitamins/Supplements"                , "Waterfall"                       , "Website"                      ,
      "Wine/Spirits"                        , "Work Position"                   , "Work Project"                 ,
      "Work Status"                         , "Writer"                          , "Year"
    ].freeze

    UNBOUNDED = ::Float::INFINITY
  end

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
    [ "interaction.content"               , true  , false , true  , :UNBOUNDED ] ,
    [ "interaction.hashtags"              , true  , true  , true  , :UNBOUNDED ] ,
    [ "interaction.media_type"            , true  , true  , true  , :MEDIA_TYPES ] ,
    [ "interaction.ml.categories"         , false , true  , true  , :UNBOUNDED ] ,
    [ "interaction.raw_content"           , true  , false , true  , :UNBOUNDED ] ,
    [ "interaction.subtype"               , true  , true  , true  , :INTERACTION_TYPES ] ,
    [ "interaction.tags"                  , false , true  , false , :UNBOUNDED ] ,
    [ "interaction.tag_tree"              , false , true  , true  , :UNBOUNDED ] ,
    [ "links.code"                        , true  , true  , true  , :UNBOUNDED ] ,
    [ "links.domain"                      , true  , true  , true  , :UNBOUNDED ] ,
    [ "links.normalized_url"              , true  , true  , true  , :UNBOUNDED ] ,
    [ "links.url"                         , true  , true  , true  , :UNBOUNDED ]
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

