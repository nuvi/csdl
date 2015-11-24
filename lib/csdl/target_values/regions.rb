module CSDL
  module TargetValues

    REGIONS_BY_COUNTRY = {
      "Argentina" => [
        "Neuquén",
        "Río Negro",
        "Salta",
        "San Juan",
        "San Luis",
        "Santa Cruz",
        "Santa Fe",
        "Santiago del Estero",
        "Tierra del Fuego",
        "Tucuman"
      ].freeze,

      "Austria" => [
        "Burgenland",
        "Kärnten",
        "Niederösterreich",
        "Oberösterreich",
        "Salzburg",
        "Steiermark",
        "Tirol",
        "Vorarlberg",
        "Wien"
      ].freeze,

      "Bahrain" => [
        "Al Muharraq"
      ].freeze,

      "Belgium" => [
        "Région De Bruxelles-Capitale"
      ].freeze,

      "Bolivia" => [
        "Chuquisaca",
        "Cochabamba",
        "El Beni",
        "Santa Cruz"
      ].freeze,

      "Brazil" => [
        "Acre",
        "Alagoas",
        "Amapa",
        "Amazonas",
        "Bahia",
        "Ceara",
        "Distrito Federal",
        "Espirito Santo",
        "Goias",
        "Maranhao",
        "Mato Grosso",
        "Mato Grosso do Sul",
        "Minas Gerais",
        "Para",
        "Paraiba",
        "Parana",
        "Pernambuco",
        "Piaui",
        "Rio de Janeiro",
        "Rio Grande do Norte",
        "Rio Grande do Sul",
        "Rondonia",
        "Roraima",
        "Santa Catarina",
        "São Paulo",
        "Sergipe",
        "Tocantins",
      ].freeze,

      "Bulgaria" => [
        "Blagoevgrad",
        "Burgas",
        "Dobrich",
        "Gabrovo",
        "Grad Sofiya",
        "Khaskovo",
        "Kurdzhali",
        "Kyustendil",
        "Lovech",
        "Montana",
        "Pazardzhik",
        "Pernik",
        "Pleven",
        "Plovdiv",
        "Razgrad",
        "Ruse",
        "Shumen",
        "Silistra",
        "Sliven",
        "Smolyan",
        "Sofiya",
        "Stara Zagora",
        "Turgovishte",
        "Varna",
        "Veliko Turnovo",
        "Vidin",
        "Vratsa",
        "Yambol"
      ].freeze,

      "Canada" => [
        "Alberta",
        "British Columbia",
        "Manitoba",
        "New Brunswick",
        "Newfoundland",
        "Nova Scotia",
        "Ontario",
        "Prince Edward Island",
        "Quebec",
        "Saskatchewan"
      ],

      "Chile" => [
        "Antofagasta",
        "Araucania",
        "Atacama",
        "Bio-Bio",
        "Coquimbo",
        "Libertador General Bernardo O'Higgins",
        "Los Lagos",
        "Magallanes y de la Antartica Chilena",
        "Maule",
        "Region Metropolitana",
        "Tarapaca",
        "Valparaiso"
      ].freeze,

      "Colombia" => [
        "Antioquia",
        "Atlantico",
        "Bolivar",
        "Boyaca",
        "Caldas",
        "Casanare",
        "Cauca",
        "Cesar",
        "Cordoba",
        "Cundinamarca",
        "Distrito Especial",
        "Huila",
        "La Guajira",
        "Magdalena",
        "Meta",
        "Narino",
        "Norte de Santander",
        "Quindio",
        "Risaralda",
        "Santander",
        "Tolima",
        "Valle del Cauca"
      ].freeze,

      "Costa Rica" => [
        "Alajuela",
        "Cartago",
        "Guanacaste",
        "Heredia",
        "Limon",
        "Puntarenas",
        "San Jose"
      ].freeze,

      "Croatia" => [
        "Bjelovarsko-Bilogorska",
        "Brodsko-Posavska",
        "Dubrovacko-Neretvanska",
        "Grad Zagreb",
        "Istarska",
        "Karlovacka",
        "Koprivnicko-Krizevacka",
        "Krapinsko-Zagorska",
        "Medimurska",
        "Osjecko-Baranjska",
        "Primorsko-Goranska",
        "Sisacko-Moslavacka",
        "Splitsko-Dalmatinska",
        "Varazdinska",
        "Viroviticko-Podravska",
        "Vukovarsko-Srijemska",
        "Zadarska",
        "Zagrebacka"
      ].freeze,

      "Cuba" => [
        "La Habana"
      ].freeze,

      "Cyprus" => [
        "Famagusta",
        "Kyrenia",
        "Larnaca",
        "Limassol",
        "Paphos"
      ].freeze,

      "Czech Republic" => [
        "Hlavni Mesto Praha",
        "Hradec Kralove",
        "Jihocesky Kraj",
        "Jihomoravsky Kraj",
        "Karlovarsky Kraj",
        "Liberecky Kraj",
        "Moravskoslezsky Kraj",
        "Olomoucky Kraj",
        "Pardubicky Kraj",
        "Plzensky Kraj",
        "Stredocesky Kraj",
        "Ustecky Kraj",
        "Vysocina",
        "Zlinsky Kraj"
      ].freeze,

      "Denmark" => [
        "Arhus",
        "Nordjylland"
      ].freeze,

      "Dominican Republic" => [
        "Duarte",
        "Espaillat",
        "La Altagracia",
        "La Romana",
        "La Vega",
        "Monsenor Nouel",
        "Monte Cristi",
        "Peravia",
        "Puerto Plata",
        "Salcedo",
        "San Cristobal",
        "San Pedro De Macoris",
        "Sanchez Ramirez",
        "Santiago",
        "Valverde"
      ].freeze,

      "Ecuador" => [
        "Azuay",
        "El Oro",
        "Guayas",
        "Manabi",
        "Pichincha",
        "Tungurahua",
      ].freeze,

      "Egypt" => [
        "Ad Daqahliyah",
        "Al Bahr al Ahmar",
        "Al Buhayrah",
        "Al Fayyum",
        "Al Gharbiyah",
        "Al Iskandariyah",
        "Al Isma'iliyah",
        "Al Jizah",
        "Al Minufiyah",
        "Al Minya",
        "Al Qahirah",
        "Al Qalyubiyah",
        "As Suways",
        "Ash Sharqiyah",
        "Aswan",
        "Asyut",
        "Bani Suwayf",
        "Bur Sa'id",
        "Dumyat",
        "Janub Sina'",
        "Kafr ash Shaykh",
        "Matruh",
        "Qina",
        "Shamal Sina'",
        "Suhaj"
      ].freeze,

      "El Salvador" => [
        "La Libertad",
        "La Union",
        "San Miguel",
        "San Salvador",
        "Santa Ana",
        "Sonsonate",
        "Usulutan"
      ].freeze,

      "Estonia" => [
        "Harjumaa",
        "Tartumaa"
      ].freeze,

      "Finland" => [
        "Åland",
        "Lapland"
      ].freeze,

      "France" => [
        "Alsace",
        "Aquitaine",
        "Auvergne",
        "Basse-Normandie",
        "Bourgogne",
        "Bretagne",
        "Centre",
        "Champagne-Ardenne",
        "Corse",
        "Franche-Comté",
        "Haute-Normandie",
        "Île-de-France",
        "Languedoc-Roussillon",
        "Limousin",
        "Lorraine",
        "Midi-Pyrénées",
        "Nord-Pas-de-Calais",
        "Pays de la Loire",
        "Picardie",
        "Poitou-Charentes",
        "Provence-Alpes-Côte d'Azur",
        "Rhône-Alpes"
      ].freeze,

      "French Guiana" => [

      ].freeze,

      "Germany" => [
        "Baden-Württemberg",
        "Bayern",
        "Berlin",
        "Brandenburg",
        "Bremen",
        "Hamburg",
        "Hessen",
        "Mecklenburg-Vorpommern",
        "Niedersachsen",
        "Nordrhein-Westfalen",
        "Rheinland-Pfalz",
        "Saarland",
        "Sachsen",
        "Sachsen-Anhalt",
        "Schleswig-Holstein",
        "Thüringen"
      ].freeze,

      "Ghana" => [
        "Ashanti",
        "Greater Accra"
      ].freeze,

      "Greece" => [
        "Attiki",
        "Thessaloniki"
      ].freeze,

      "Guadeloupe" => [

      ].freeze,

      "Guatemala" => [
        "Escuintla",
        "Guatemala",
        "Jutiapa",
        "Quetzaltenango",
        "Sacatepequez"
      ].freeze,

      "Haiti" => [
        "Ouest"
      ].freeze,

      "Honduras" => [
        "Atlantida",
        "Comayagua",
        "Copan",
        "Cortes",
        "Francisco Morazan",
        "Yoro"
      ].freeze,

      "Hungary" => [
        "Bacs-Kiskun",
        "Baranya",
        "Bekes",
        "Borsod-Abauj-Zemplen",
        "Budapest",
        "Csongrad",
        "Fejer",
        "Gyor-Moson-Sopron",
        "Hajdu-Bihar",
        "Heves",
        "Jasz-Nagykun-Szolnok",
        "Komarom-Esztergom",
        "Nograd",
        "Pest",
        "Somogy",
        "Szabolcs-Szatmar-Bereg",
        "Tolna",
        "Vas",
        "Veszprem",
        "Zala"
      ].freeze,

      "Iceland" => [].freeze,

      "Iraq" => [
        "Al Anbar",
        "Al Basrah",
        "Al Muthanna",
        "Al Qadisiyah",
        "An Najaf",
        "Arbil",
        "As Sulaymaniyah",
        "At Ta'mim",
        "Babil",
        "Baghdad",
        "Dahuk",
        "Dhi Qar",
        "Diyala",
        "Karbala'",
        "Maysan",
        "Ninawa",
        "Salah ad Din",
        "Wasit"
      ].freeze,

      "Ireland" => [
        "Carlow",
        "Cavan",
        "Clare",
        "Cork",
        "Donegal",
        "Dublin",
        "Galway",
        "Kerry",
        "Kildare",
        "Kilkenny",
        "Laois",
        "Leitrim",
        "Limerick",
        "Longford",
        "Louth",
        "Mayo",
        "Meath",
        "Monaghan",
        "Offaly",
        "Roscommon",
        "Sligo",
        "Tipperary",
        "Waterford",
        "Westmeath",
        "Wexford",
        "Wicklow"
      ].freeze,

      "Israel" => [
        "HaDarom",
        "HaMerkaz",
        "HaTzafon",
        "Heifa",
        "Tel Aviv",
        "Yerushalayim"
      ].freeze,

      "Italy" => [
        "Abruzzo",
        "Basilicata",
        "Calabria",
        "Campania",
        "Emilia-Romagna",
        "Friuli-Venezia Giulia",
        "Lazio",
        "Liguria",
        "Lombardia",
        "Marche",
        "Molise",
        "Piemonte",
        "Puglia",
        "Sardegna",
        "Sicilia",
        "Toscana",
        "Trentino-Alto Adige",
        "Umbria",
        "Valle d'Aosta",
        "Veneto"
      ].freeze,

      "Jordan" => [
        "Al Balqa'",
        "Al Karak",
        "Al Mafraq",
        "Amman",
        "At Tafilah",
        "Az Zarqa",
        "Irbid",
        "Ma"
      ].freeze,

      "Kenya" => [
        "Central",
        "Coast",
        "Nairobi",
        "Rift Valley"
      ].freeze,

      "Kuwait" => [].freeze,

      "Latvia" => [].freeze,

      "Lebanon" => [
        "Beyrouth",
        "Liban-Nord",
        "Liban-Sud",
        "Mont-Liban"
      ].freeze,

      "Lithuania" => [
        "Kauno Apskritis",
        "Klaipedos Apskritis",
        "Panevezio Apskritis",
        "Siauliu Apskritis",
        "Vilniaus Apskritis"
      ].freeze,

      "Luxembourg" => [
        "Diekirch",
        "Grevenmacher",
        "Luxembourg"
      ].freeze,

      "Macedonia, the former Yugoslav Republic of" => [
        "Kumanovo",
        "Ohrid",
        "Prilep",
        "Struga",
        "Strumica",
        "Tetovo",
        "Veles",
        "Stip",
        "Gostivar"
      ].freeze,

      "Malta" => [].freeze,

      "Martinique" => [].freeze,

      "Mauritius" => [
        "Flacq",
        "Grand Port",
        "Pamplemousses",
        "Plaines Wilhems",
        "Port Louis",
        "Riviere du Rempart"
      ].freeze,

      "Mexico" => [
        "Aguascalientes",
        "Baja California",
        "Baja California Sur",
        "Campeche",
        "Chiapas",
        "Chihuahua",
        "Coahuila de Zaragoza",
        "Colima",
        "Distrito Federal",
        "Durango",
        "Guanajuato",
        "Guerrero",
        "Hidalgo",
        "Jalisco",
        "Michoacán de Ocampo",
        "Morelos",
        "Nayarit",
        "Nuevo León",
        "Oaxaca",
        "Puebla",
        "Querétaro Arteaga",
        "Quintana Roo",
        "San Luis Potosi",
        "Sinaloa",
        "Sonora",
        "State of Mexico",
        "Tabasco",
        "Tamaulipas",
        "Tlaxcala",
        "Veracruz",
        "Yucatán",
        "Zacatecas"
      ],

      "Morocco" => [
        "Casablanca",
        "Fes",
        "Marrakech",
        "Meknes",
        "Rabat-Sale",
        "Tanger",
        "Taza"
      ].freeze,

      "Netherlands" => [
        "Drenthe",
        "Flevoland",
        "Friesland",
        "Gelderland",
        "Groningen",
        "Limburg",
        "Noord-Brabant",
        "Noord-Holland",
        "Overijssel",
        "Utrecht",
        "Zeeland",
        "Zuid-Holland"
      ].freeze,

      "Nicaragua" => [
        "Chinandega",
        "Esteli",
        "Leon",
        "Managua",
        "Masaya",
        "Matagalpa"
      ].freeze,

      "Nigeria" => [
        "Abia",
        "Akwa Ibom",
        "Anambra",
        "Benue",
        "Cross River",
        "Delta",
        "Edo",
        "Enugu",
        "Federal Capital Territory",
        "Imo",
        "Kaduna",
        "Kano",
        "Kwara",
        "Lagos",
        "Ogun",
        "Ondo",
        "Osun",
        "Oyo",
        "Plateau",
        "Rivers",
        "Niger",
        "Adamawa",
        "Ekiti"
      ].freeze,

      "Norway" => [
        "Akershus",
        "Aust-Agder",
        "Buskerud",
        "Finnmark",
        "Hedmark",
        "Hordaland",
        "Møre og Romsdal",
        "Nord-Trøndelag",
        "Nordland",
        "Oppland",
        "Oslo",
        "Østfold",
        "Rogaland",
        "Sogn og Fjordane",
        "Sør-Trøndelag",
        "Telemark",
        "Troms",
        "Vest-Agder",
        "Vestfold"
      ].freeze,

      "Oman" => [
        "Al Batinah",
        "Masqat",
        "Zufar"
      ].freeze,

      "Palestinian territories" => [].freeze,

      "Panama" => [
        "Chiriqui",
        "Colon",
        "Panama"
      ].freeze,

      "Paraguay" => [
        "Alto Parana",
        "Central",
        "Itapua",
        "Presidente Hayes"
      ].freeze,

      "Peru" => [
        "Ancash",
        "Arequipa",
        "Cusco",
        "Ica",
        "La Libertad",
        "Lambayeque",
        "Lima",
        "Piura",
        "Tacna"
      ].freeze,

      "Poland" => [
        "Dolnoslaskie",
        "Kujawsko-Pomorskie",
        "Lodzkie",
        "Lubelskie",
        "Lubuskie",
        "Malopolskie",
        "Opolskie",
        "Podkarpackie",
        "Podlaskie",
        "Pomorskie",
        "Slaskie",
        "Swietokrzyskie",
        "Warminsko-Mazurskie",
        "Wielkopolskie",
        "Zachodniopomorskie"
      ].freeze,

      "Portugal" => [
        "Aveiro",
        "Azores",
        "Beja",
        "Braga",
        "Braganca",
        "Castelo Branco",
        "Coimbra",
        "Evora",
        "Faro",
        "Guarda",
        "Leiria",
        "Lisboa",
        "Madeira",
        "Portalegre",
        "Porto",
        "Santarem",
        "Setubal",
        "Viana do Castelo",
        "Vila Real",
        "Viseu"
      ].freeze,

      "Puerto Rico" => [].freeze,

      "Qatar" => [
        "Ad Dawhah"
      ].freeze,

      "Romania" => [
        "Alba",
        "Arad",
        "Arges",
        "Bacau",
        "Bihor",
        "Bistrita-Nasaud",
        "Botosani",
        "Braila",
        "Brasov",
        "Bucuresti",
        "Buzau",
        "Calarasi",
        "Caras-Severin",
        "Cluj",
        "Constanta",
        "Covasna",
        "Dambovita",
        "Dolj",
        "Galati",
        "Giurgiu",
        "Gorj",
        "Harghita",
        "Hunedoara",
        "Ialomita",
        "Iasi",
        "Ilfov",
        "Maramures",
        "Mehedinti",
        "Mures",
        "Neamt",
        "Olt",
        "Prahova",
        "Salaj",
        "Satu Mare",
        "Sibiu",
        "Suceava",
        "Teleorman",
        "Timis",
        "Tulcea",
        "Valcea",
        "Vaslui",
        "Vrancea"
      ].freeze,

      "Saint Barthelemy" => [].freeze,

      "Saint Martin (French Part)" => [].freeze,

      "Saudi Arabia" => [
        "Al Jawf",
        "Al Madinah",
        "Al Qasim",
        "Ar Riyad",
        "Ash Sharqiyah",
        "Ha'il",
        "Jizan",
        "Makkah",
        "Tabuk"
      ].freeze,

      "Serbia" => [].freeze,

      "Slovakia" => [
        "Banska Bystrica",
        "Bratislava",
        "Kosice",
        "Nitra",
        "Presov",
        "Trencin",
        "Trnava",
        "Zilina"
      ].freeze,

      "Slovenia" => [].freeze,

      "South Africa" => [
        "Eastern Cape",
        "Free State",
        "Gauteng",
        "KwaZulu-Natal",
        "Limpopo",
        "Mpumalanga",
        "North-West",
        "Northern Cape",
        "Western Cape"
      ].freeze,

      "Spain" => [
        "Andalucía",
        "Aragón",
        "Asturias",
        "Cantabria",
        "Castilla y Leon",
        "Castilla-La Mancha",
        "Cataluña",
        "Comunidad de Madrid",
        "Comunidad Valenciana",
        "Extremadura",
        "Galicia",
        "Islas Baleares",
        "Islas Canarias",
        "La Rioja",
        "Murcia",
        "Navarra"
      ].freeze,

      "Sweden" => [
        "Blekinge Län",
        "Dalarnas Län",
        "Gävleborgs Län",
        "Gotlands Län",
        "Hallands Län",
        "Jämtlands Län",
        "Jönköpings Län",
        "Kalmar Län",
        "Kronobergs Län",
        "Norrbottens Län",
        "Örebro Län",
        "Östergötlands Län",
        "Skåne Län",
        "Södermanlands Län",
        "Stockholms Län",
        "Uppsala Län",
        "Värmlands Län",
        "Västerbottens Län",
        "Västernorrlands Län",
        "Västmanlands Län",
        "Västra Götaland"
      ].freeze,

      "Switzerland" => [
        "Aargau",
        "Basel-Landschaft",
        "Basel-Stadt",
        "Bern",
        "Fribourg",
        "Geneve",
        "Glarus",
        "Graubünden",
        "Jura",
        "Luzern",
        "Neuchâtel",
        "Schaffhausen",
        "Schwyz",
        "Solothurn",
        "St. Gallen",
        "Thurgau",
        "Ticino",
        "Valais",
        "Vaud",
        "Zug",
        "Zürich"
      ].freeze,

      "Tunisia" => [
        "Al Mahdiyah",
        "Al Munastir",
        "Al Qasrayn",
        "Al Qayrawan",
        "Bajah",
        "Banzart",
        "Bin",
        "Jundubah",
        "Kef",
        "Madanin",
        "Nabul",
        "Qabis",
        "Safaqis",
        "Sidi Bu Zayd",
        "Susah",
        "Tunis"
      ].freeze,

      "Turkey" => [
        "Adana",
        "Adiyaman",
        "Afyonkarahisar",
        "Ağrı",
        "Amasya",
        "Ankara",
        "Antalya",
        "Artvin",
        "Aydin",
        "Balikesir",
        "Batman",
        "Bilecik",
        "Bingöl",
        "Bitlis",
        "Bolu",
        "Burdur",
        "Bursa",
        "Çanakkale",
        "Cankiri",
        "Çorum",
        "Denizli",
        "Diyarbakir",
        "Edirne",
        "Elazığ",
        "Erzincan",
        "Erzurum",
        "Eskişehir",
        "Gaziantep",
        "Giresun",
        "Gumushane",
        "Hakkari",
        "Hatay",
        "Icel",
        "Isparta",
        "Istanbul",
        "Izmir",
        "Kahramanmaraş",
        "Karaman",
        "Kars",
        "Kastamonu",
        "Kayseri",
        "Kilis",
        "Kirklareli",
        "Kırşehir",
        "Kocaeli",
        "Konya",
        "Kütahya",
        "Malatya",
        "Manisa",
        "Muğla",
        "Muş",
        "Nevşehir",
        "Nigde",
        "Ordu",
        "Osmaniye",
        "Rize",
        "Sakarya",
        "Samsun",
        "Şanlıurfa",
        "Sinop",
        "Sirnak",
        "Sivas",
        "Tekirdağ",
        "Tokat",
        "Trabzon",
        "Tunceli",
        "Uşak",
        "Van",
        "Yalova",
        "Yozgat",
        "Zonguldak",
        "Ardahan"
      ].freeze,

      "Ukraine" => [
        "Dnipropetrovs'ka Oblast'",
        "Donets'ka Oblast'",
        "Ivano-Frankivs'ka Oblast'",
        "Kharkivs'ka Oblast'",
        "Krym",
        "Kyyivs'ka Oblast'",
        "L'vivs'ka Oblast'",
        "Odes'ka Oblast'",
        "Vinnyts'ka Oblast'",
        "Zakarpats'ka Oblast'",
        "Zaporiz'ka Oblast'",
        "Cherkas'ka Oblast'",
        "Chernivets'ka Oblast'",
        "Mikolayivs'ka Oblast'",
        "Poltavs'ka Oblast'",
        "Rivnens'ka Oblast'",
        "Ternopil's'ka Oblast'",
        "Volyns'ka Oblast'"
      ].freeze,

      "United Arab Emirates" => [
        "Abu Dhabi",
        "Ajman",
        "Dubai",
        "Fujairah",
        "Ras Al Khaimah",
        "Sharjah"
      ].freeze,

      "United Kingdom" => [
        "England",
        "Scotland",
        "Wales",
        "Northern Ireland"
      ].freeze,

      "United States" => [
        "Alabama",
        "Alaska",
        "Arizona",
        "Arkansas",
        "California",
        "Colorado",
        "Connecticut",
        "Delaware",
        "Florida",
        "Georgia",
        "Hawaii",
        "Idaho",
        "Illinois",
        "Indiana",
        "Iowa",
        "Kansas",
        "Kentucky",
        "Louisiana",
        "Maine",
        "Maryland",
        "Massachusetts",
        "Michigan",
        "Minnesota",
        "Mississippi",
        "Missouri",
        "Montana",
        "Nebraska",
        "Nevada",
        "New Hampshire",
        "New Jersey",
        "New Mexico",
        "New York",
        "North Carolina",
        "North Dakota",
        "Ohio",
        "Oklahoma",
        "Oregon",
        "Pennsylvania",
        "Rhode Island",
        "South Carolina",
        "South Dakota",
        "Tennessee",
        "Texas",
        "Utah",
        "Vermont",
        "Virginia",
        "Washington",
        "West Virginia",
        "Wisconsin",
        "Wyoming"
      ].freeze,

      "Uruguay" => [
        "Artigas",
        "Canelones",
        "Colonia",
        "Maldonado",
        "Montevideo",
        "Paysandu",
        "Rivera",
        "Salto",
        "San Jose",
        "Soriano"
      ].freeze,

      "Venezuela" => [
        "Anzoategui",
        "Aragua",
        "Barinas",
        "Bolivar",
        "Carabobo",
        "Distrito Federal",
        "Falcon",
        "Guarico",
        "Lara",
        "Merida",
        "Miranda",
        "Monagas",
        "Nueva Esparta",
        "Portuguesa",
        "Sucre",
        "Tachira",
        "Yaracuy",
        "Zulia",
      ].freeze,

    }.freeze

    REGIONS = REGIONS_BY_COUNTRY.values.flatten.freeze

  end
end
