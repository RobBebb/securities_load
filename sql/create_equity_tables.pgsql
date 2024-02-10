-- The equity schema contains data that has been cleaned and transforned.
-- This script is dependent on create_polygon_tables.sql as for some tables
-- rows are populated from the polygon tables.

DROP TABLE IF EXISTS equity.daily_price;
DROP TABLE IF EXISTS equity.ticker;
DROP TABLE IF EXISTS equity.data_vendor;
DROP TABLE IF EXISTS equity.exchange;
DROP TABLE IF EXISTS equity.dividend;
DROP TABLE IF EXISTS equity.split;
DROP TABLE IF EXISTS equity.dividend_type;
DROP TABLE IF EXISTS equity.market;
DROP TABLE IF EXISTS equity.ticker_type;
DROP TABLE IF EXISTS equity.asset_class;
DROP TABLE IF EXISTS equity.exchange_type;
DROP TABLE IF EXISTS equity.gics;
DROP TABLE IF EXISTS equity.gics_sub_industry;
DROP TABLE IF EXISTS equity.gics_industry;
DROP TABLE IF EXISTS equity.gics_industry_group;
DROP TABLE IF EXISTS equity.gics_sector;
DROP TABLE IF EXISTS equity.country;
DROP TABLE IF EXISTS equity.currency;

DROP SCHEMA IF EXISTS equity;

CREATE SCHEMA IF NOT EXISTS equity AUTHORIZATION securities;

CREATE TABLE IF NOT EXISTS equity.currency (
	country varchar(100) NOT NULL,
    currency varchar(100) NOT NULL,
    code char(4) NOT NULL,
	minor_unit smallint,
	symbol varchar(100),
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

INSERT INTO equity.currency (country, currency, code, minor_unit, symbol) VALUES 
	('Afghanistan', 'Afghani', 'AFN', 2, '؋'),
	('Åland Islands', 'Euro', 'EUR', 2, '€'),
	('Albania', 'Lek', 'ALL', 2, 'Lek'),
	('Algeria', 'Algerian Dinar', 'DZD', 2, NULL),
	('American Samoa', 'US Dollar', 'USD', 2, '$'),
	('Andorra', 'Euro', 'EUR', 2, '€'),
	('Angola', 'Kwanza', 'AOA', 2, NULL),
	('Anguilla', 'East Caribbean Dollar', 'XCD', 2, NULL),
	('Antigua and Barbuda', 'East Caribbean Dollar', 'XCD', 2, NULL),
	('Argentina', 'Argentine Peso', 'ARS', 2, '$'),
	('Armenia', 'Armenian Dram', 'AMD', 2, NULL),
	('Aruba', 'Aruban Florin', 'AWG', 2, NULL),
	('Australia', 'Australian Dollar', 'AUD', 2, '$'),
	('Austria', 'Euro', 'EUR', 2, '€'),
	('Azerbaijan', 'Azerbaijan Manat', 'AZN', 2, NULL),
	('Bahamas', 'Bahamian Dollar', 'BSD', 2, '$'),
	('Bahrain', 'Bahraini Dinar', 'BHD', 3, NULL),
	('Bangladesh', 'Taka', 'BDT', 2, '৳'),
	('Barbados', 'Barbados Dollar', 'BBD', 2, '$'),
	('Belarus', 'Belarusian Ruble', 'BYN', 2, NULL),
	('Belgium', 'Euro', 'EUR', 2, '€'),
	('Belize', 'Belize Dollar', 'BZD', 2, 'BZ$'),
	('Benin', 'CFA Franc BCEAO', 'XOF', 0, NULL),
	('Bermuda', 'Bermudian Dollar', 'BMD', 2, NULL),
	('Bhutan', 'Indian Rupee', 'INR', 2, '₹'),
	('Bhutan', 'Ngultrum', 'BTN', 2, NULL),
	('Bolivia', 'Boliviano', 'BOB', 2, NULL),
	('Bolivia', 'Mvdol', 'BOV', 2, NULL),
	('Bonaire, Sint Eustatius And Saba', 'US Dollar', 'USD', 2, '$'),
	('Bosnia and Herzegovina', 'Convertible Mark', 'BAM', 2, NULL),
	('Botswana', 'Pula', 'BWP', 2, NULL),
	('Bouvet Island', 'Norwegian Krone', 'NOK', 2, NULL),
	('Brazil', 'Brazilian Real', 'BRL', 2, 'R$'),
	('British Indian Ocean Territory', 'US Dollar', 'USD', 2, '$'),
	('Brunei Darussalam', 'Brunei Dollar', 'BND', 2, NULL),
	('Bulgaria', 'Bulgarian Lev', 'BGN', 2, 'лв'),
	('Burkina Faso', 'CFA Franc BCEAO', 'XOF', 0, NULL),
	('Burundi', 'Burundi Franc', 'BIF', 0, NULL),
	('Cabo Verde', 'Cabo Verde Escudo', 'CVE', 2, NULL),
	('Cambodia', 'Riel', 'KHR', 2, '៛'),
	('Cameroon', 'CFA Franc BEAC', 'XAF', 0, NULL),
	('Canada', 'Canadian Dollar', 'CAD', 2, '$'),
	('Cayman Islands', 'Cayman Islands Dollar', 'KYD', 2, NULL),
	('Central African Republic', 'CFA Franc BEAC', 'XAF', 0, NULL),
	('Chad', 'CFA Franc BEAC', 'XAF', 0, NULL),
	('Chile', 'Chilean Peso', 'CLP', 0, '$'),
	('Chile', 'Unidad de Fomento', 'CLF', 4,NULL),
	('China', 'Yuan Renminbi', 'CNY', 2, '¥'),
	('Christmas Island', 'Australian Dollar', 'AUD', 2, NULL),
	('Cocos (keeling) Islands', 'Australian Dollar', 'AUD', 2, NULL),
	('Colombia', 'Colombian Peso', 'COP', 2, '$'),
	('Colombia', 'Unidad de Valor Real', 'COU', 2, NULL),
	('Comoros', 'Comorian Franc ', 'KMF', 0, NULL),
	('Congo, Democratic Republic of the', 'Congolese Franc', 'CDF', 2, NULL),
	('Congo', 'CFA Franc BEAC', 'XAF', 0, NULL),
	('Cook Islands', 'New Zealand Dollar', 'NZD', 2, '$'),
	('Costa Rica', 'Costa Rican Colon', 'CRC', 2, NULL),
	('Côte d''Ivoire', 'CFA Franc BCEAO', 'XOF', 0, NULL),
	('Croatia', 'Kuna', 'HRK', 2, 'kn'),
	('Cuba', 'Cuban Peso', 'CUP', 2, NULL),
	('Cuba', 'Peso Convertible', 'CUC', 2, NULL),
	('Curaçao', 'Netherlands Antillean Guilder', 'ANG', 2, NULL),
	('Cyprus', 'Euro', 'EUR', 2, '€'),
	('Czechia', 'Czech Koruna', 'CZK', 2, 'Kč'),
	('Denmark', 'Danish Krone', 'DKK', 2, 'kr'),
	('Djibouti', 'Djibouti Franc', 'DJF', 0, NULL),
	('Dominica', 'East Caribbean Dollar', 'XCD', 2, NULL),
	('Dominican Republic', 'Dominican Peso', 'DOP', 2, NULL),
	('Ecuador', 'US Dollar', 'USD', 2, '$'),
	('Egypt', 'Egyptian Pound', 'EGP', 2, NULL),
	('El Salvador', 'El Salvador Colon', 'SVC', 2, NULL),
	('El Salvador', 'US Dollar', 'USD', 2, '$'),
	('Equatorial Guinea', 'CFA Franc BEAC', 'XAF', 0, NULL),
	('Eritrea', 'Nakfa', 'ERN', 2, NULL),
	('Estonia', 'Euro', 'EUR', 2, '€'),
	('Eswatini', 'Lilangeni', 'SZL', 2, NULL),
	('Ethiopia', 'Ethiopian Birr', 'ETB', 2, NULL),
	('European Union', 'Euro', 'EUR', 2, '€'),
	('Falkland Islands [Malvinas]', 'Falkland Islands Pound', 'FKP', 2, NULL),
	('Faroe Islands', 'Danish Krone', 'DKK', 2, NULL),
	('Fiji', 'Fiji Dollar', 'FJD', 2, NULL),
	('Finland', 'Euro', 'EUR', 2, '€'),
	('France', 'Euro', 'EUR', 2, '€'),
	('French Guiana', 'Euro', 'EUR', 2, '€'),
	('French Polynesia', 'CFP Franc', 'XPF', 0, NULL),
	('French Southern Territories', 'Euro', 'EUR', 2, '€'),
	('Gabon', 'CFA Franc BEAC', 'XAF', 0, NULL),
	('Gambia', 'Dalasi', 'GMD', 2, NULL),
	('Georgia', 'Lari', 'GEL', 2, '₾'),
	('Germany', 'Euro', 'EUR', 2, '€'),
	('Ghana', 'Ghana Cedi', 'GHS', 2, NULL),
	('Gibraltar', 'Gibraltar Pound', 'GIP', 2, NULL),
	('Greece', 'Euro', 'EUR', 2, '€'),
	('Greenland', 'Danish Krone', 'DKK', 2, NULL),
	('Grenada', 'East Caribbean Dollar', 'XCD', 2, NULL),
	('Guadeloupe', 'Euro', 'EUR', 2, '€'),
	('Guam', 'US Dollar', 'USD', 2, '$'),
	('Guatemala', 'Quetzal', 'GTQ', 2, NULL),
	('Guernsey', 'Pound Sterling', 'GBP', 2, '£'),
	('Guinea', 'Guinean Franc', 'GNF', 0, NULL),
	('Guinea-Bissau', 'CFA Franc BCEAO', 'XOF', 0, NULL),
	('Guyana', 'Guyana Dollar', 'GYD', 2, NULL),
	('Haiti', 'Gourde', 'HTG', 2, NULL),
	('Haiti', 'US Dollar', 'USD', 2, '$'),
	('Heard Island And Mcdonald Islands', 'Australian Dollar', 'AUD', 2, NULL),
	('Holy See (Vatican)', 'Euro', 'EUR', 2, '€'),
	('Honduras', 'Lempira', 'HNL', 2, NULL),
	('Hong Kong', 'Hong Kong Dollar', 'HKD', 2, '$'),
	('Hungary', 'Forint', 'HUF', 2, 'ft'),
	('Iceland', 'Iceland Krona', 'ISK', 0, NULL),
	('India', 'Indian Rupee', 'INR', 2, '₹'),
	('Indonesia', 'Rupiah', 'IDR', 2, 'Rp'),
	('International Monetary Fund (IMF)', 'SDR (Special Drawing Right)', 'XDR', 0, NULL),
	('Iran (Islamic Republic of)', 'Iranian Rial', 'IRR', 2, NULL),
	('Iraq', 'Iraqi Dinar', 'IQD', 3, NULL),
	('Ireland', 'Euro', 'EUR', 2, '€'),
	('Isle Of Man', 'Pound Sterling', 'GBP', 2, '£'),
	('Israel', 'New Israeli Sheqel', 'ILS', 2, '₪'),
	('Italy', 'Euro', 'EUR', 2, '€'),
	('Jamaica', 'Jamaican Dollar', 'JMD', 2, NULL),
	('Japan', 'Yen', 'JPY', 0, '¥'),
	('Jersey', 'Pound Sterling', 'GBP', 2, '£'),
	('Jordan', 'Jordanian Dinar', 'JOD', 3, NULL),
	('Kazakhstan', 'Tenge', 'KZT', 2, NULL),
	('Kenya', 'Kenyan Shilling', 'KES', 2, 'Ksh'),
	('Kiribati', 'Australian Dollar', 'AUD', 2, NULL),
	('Korea (Democratic People''s Republic of)', 'North Korean Won', 'KPW', 2, NULL),
	('Korea, Republic of', 'Won', 'KRW', 0, '₩'),
	('Kuwait', 'Kuwaiti Dinar', 'KWD', 3, NULL),
	('Kyrgyzstan', 'Som', 'KGS', 2, NULL),
	('Lao People''s Democratic Republic', 'Lao Kip', 'LAK', 2, NULL),
	('Latvia', 'Euro', 'EUR', 2, '€'),
	('Lebanon', 'Lebanese Pound', 'LBP', 2, NULL),
	('Lesotho', 'Loti', 'LSL', 2, NULL),
	('Lesotho', 'Rand', 'ZAR', 2, NULL),
	('Liberia', 'Liberian Dollar', 'LRD', 2, NULL),
	('Libya', 'Libyan Dinar', 'LYD', 3, NULL),
	('Liechtenstein', 'Swiss Franc', 'CHF', 2, NULL),
	('Lithuania', 'Euro', 'EUR', 2, '€'),
	('Luxembourg', 'Euro', 'EUR', 2, '€'),
	('Macao', 'Pataca', 'MOP', 2, NULL),
	('North Macedonia', 'Denar', 'MKD', 2, NULL),
	('Madagascar', 'Malagasy Ariary', 'MGA', 2, NULL),
	('Malawi', 'Malawi Kwacha', 'MWK', 2, NULL),
	('Malaysia', 'Malaysian Ringgit', 'MYR', 2, 'RM'),
	('Maldives', 'Rufiyaa', 'MVR', 2, NULL),
	('Mali', 'CFA Franc BCEAO', 'XOF', 0, NULL),
	('Malta', 'Euro', 'EUR', 2, '€'),
	('Marshall Islands', 'US Dollar', 'USD', 2, '$'),
	('Martinique', 'Euro', 'EUR', 2, '€'),
	('Mauritania', 'Ouguiya', 'MRU', 2, NULL),
	('Mauritius', 'Mauritius Rupee', 'MUR', 2, NULL),
	('Mayotte', 'Euro', 'EUR', 2, '€'),
	('Member Countries Of The African Development Bank Group', 'ADB Unit of Account', 'XUA', 0, NULL),
	('Mexico', 'Mexican Peso', 'MXN', 2, '$'),
	('Mexico', 'Mexican Unidad de Inversion (UDI)', 'MXV', 2, NULL),
	('Micronesia (Federated States of)', 'US Dollar', 'USD', 2, '$'),
	('Moldova, Republic of', 'Moldovan Leu', 'MDL', 2, NULL),
	('Monaco', 'Euro', 'EUR', 2, '€'),
	('Mongolia', 'Tugrik', 'MNT', 2, NULL),
	('Montenegro', 'Euro', 'EUR', 2, '€'),
	('Montserrat', 'East Caribbean Dollar', 'XCD', 2, NULL),
	('Morocco', 'Moroccan Dirham', 'MAD', 2, ' .د.م '),
	('Mozambique', 'Mozambique Metical', 'MZN', 2, NULL),
	('Myanmar', 'Kyat', 'MMK', 2, NULL),
	('Namibia', 'Namibia Dollar', 'NAD', 2, NULL),
	('Namibia', 'Rand', 'ZAR', 2, NULL),
	('Nauru', 'Australian Dollar', 'AUD', 2, NULL),
	('Nepal', 'Nepalese Rupee', 'NPR', 2, NULL),
	('Netherlands', 'Euro', 'EUR', 2, '€'),
	('New Caledonia', 'CFP Franc', 'XPF', 0, NULL),
	('New Zealand', 'New Zealand Dollar', 'NZD', 2, '$'),
	('Nicaragua', 'Cordoba Oro', 'NIO', 2, NULL),
	('Niger', 'CFA Franc BCEAO', 'XOF', 0, NULL),
	('Nigeria', 'Naira', 'NGN', 2, '₦'),
	('Niue', 'New Zealand Dollar', 'NZD', 2, '$'),
	('Norfolk Island', 'Australian Dollar', 'AUD', 2, NULL),
	('Northern Mariana Islands', 'US Dollar', 'USD', 2, '$'),
	('Norway', 'Norwegian Krone', 'NOK', 2, 'kr'),
	('Oman', 'Rial Omani', 'OMR', 3, NULL),
	('Pakistan', 'Pakistan Rupee', 'PKR', 2, 'Rs'),
	('Palau', 'US Dollar', 'USD', 2, '$'),
	('Panama', 'Balboa', 'PAB', 2, NULL),
	('Panama', 'US Dollar', 'USD', 2, '$'),
	('Papua New Guinea', 'Kina', 'PGK', 2, NULL),
	('Paraguay', 'Guarani', 'PYG', 0, NULL),
	('Peru', 'Sol', 'PEN', 2, 'S'),
	('Philippines', 'Philippine Peso', 'PHP', 2, '₱'),
	('Pitcairn', 'New Zealand Dollar', 'NZD', 2, '$'),
	('Poland', 'Zloty', 'PLN', 2, 'zł'),
	('Portugal', 'Euro', 'EUR', 2, '€'),
	('Puerto Rico', 'US Dollar', 'USD', 2, '$'),
	('Qatar', 'Qatari Rial', 'QAR', 2, NULL),
	('Réunion', 'Euro', 'EUR', 2, '€'),
	('Romania', 'Romanian Leu', 'RON', 2, 'lei'),
	('Russian Federation', 'Russian Ruble', 'RUB', 2, '₽'),
	('Rwanda', 'Rwanda Franc', 'RWF', 0, NULL),
	('Saint Barthélemy', 'Euro', 'EUR', 2, '€'),
	('Saint Helena, Ascension And Tristan Da Cunha', 'Saint Helena Pound', 'SHP', 2, NULL),
	('Saint Kitts and Nevis', 'East Caribbean Dollar', 'XCD', 2, NULL),
	('Saint Lucia', 'East Caribbean Dollar', 'XCD', 2, NULL),
	('Saint Martin (French Part)', 'Euro', 'EUR', 2, '€'),
	('Saint Pierre and Miquelon', 'Euro', 'EUR', 2, '€'),
	('Saint Vincent and the Grenadines', 'East Caribbean Dollar', 'XCD', 2, NULL),
	('Samoa', 'Tala', 'WST', 2, NULL),
	('San Marino', 'Euro', 'EUR', 2, '€'),
	('Sao Tome and Principe', 'Dobra', 'STN', 2, NULL),
	('Saudi Arabia', 'Saudi Riyal', 'SAR', 2, NULL),
	('Senegal', 'CFA Franc BCEAO', 'XOF', 0, NULL),
	('Serbia', 'Serbian Dinar', 'RSD', 2, NULL),
	('Seychelles', 'Seychelles Rupee', 'SCR', 2, NULL),
	('Sierra Leone', 'Leone', 'SLL', 2, NULL),
	('Singapore', 'Singapore Dollar', 'SGD', 2, '$'),
	('Sint Maarten (Dutch Part)', 'Netherlands Antillean Guilder', 'ANG', 2, NULL),
	('Sistema Unitario De Compensacion Regional De Pagos', 'Sucre', 'XSU', 0, NULL),
	('Slovakia', 'Euro', 'EUR', 2, '€'),
	('Slovenia', 'Euro', 'EUR', 2, '€'),
	('Solomon Islands', 'Solomon Islands Dollar', 'SBD', 2, NULL),
	('Somalia', 'Somali Shilling', 'SOS', 2, NULL),
	('South Africa', 'Rand', 'ZAR', 2, 'R'),
	('South Sudan', 'South Sudanese Pound', 'SSP', 2, NULL),
	('Spain', 'Euro', 'EUR', 2, '€'),
	('Sri Lanka', 'Sri Lanka Rupee', 'LKR', 2, 'Rs'),
	('Sudan', 'Sudanese Pound', 'SDG', 2, NULL),
	('Suriname', 'Surinam Dollar', 'SRD', 2, NULL),
	('Svalbard and Jan Mayen', 'Norwegian Krone', 'NOK', 2, NULL),
	('Sweden', 'Swedish Krona', 'SEK', 2, 'kr'),
	('Switzerland', 'Swiss Franc', 'CHF', 2, NULL),
	('Switzerland', 'WIR Euro', 'CHE', 2, NULL),
	('Switzerland', 'WIR Franc', 'CHW', 2, NULL),
	('Syrian Arab Republic', 'Syrian Pound', 'SYP', 2, NULL),
	('Taiwan', 'New Taiwan Dollar', 'TWD', 2, NULL),
	('Tajikistan', 'Somoni', 'TJS', 2, NULL),
	('Tanzania, United Republic of', 'Tanzanian Shilling', 'TZS', 2, NULL),
	('Thailand', 'Baht', 'THB', 2, '฿'),
	('Timor-Leste', 'US Dollar', 'USD', 2, '$'),
	('Togo', 'CFA Franc BCEAO', 'XOF', 0, NULL),
	('Tokelau', 'New Zealand Dollar', 'NZD', 2, '$'),
	('Tonga', 'Pa’anga', 'TOP', 2, NULL),
	('Trinidad and Tobago', 'Trinidad and Tobago Dollar', 'TTD', 2, NULL),
	('Tunisia', 'Tunisian Dinar', 'TND', 3, NULL),
	('Türkiye', 'Turkish Lira', 'TRY', 2, '₺'),
	('Turkmenistan', 'Turkmenistan New Manat', 'TMT', 2, NULL),
	('Turks and Caicos Islands', 'US Dollar', 'USD', 2, '$'),
	('Tuvalu', 'Australian Dollar', 'AUD', 2, NULL),
	('Uganda', 'Uganda Shilling', 'UGX', 0, NULL),
	('Ukraine', 'Hryvnia', 'UAH', 2, '₴'),
	('United Arab Emirates', 'UAE Dirham', 'AED', 2, 'د.إ'),
	('United Kingdom of Great Britain and Northern Ireland', 'Pound Sterling', 'GBP', 2, '£'),
	('United States Minor Outlying Islands', 'US Dollar', 'USD', 2, '$'),
	('United States of America', 'US Dollar', 'USD', 2, '$'),
	('United States of America', 'US Dollar (Next day)', 'USN', 2, NULL),
	('Uruguay', 'Peso Uruguayo', 'UYU', 2, NULL),
	('Uruguay', 'Uruguay Peso en Unidades Indexadas (UI)', 'UYI', 0, NULL),
	('Uruguay', 'Unidad Previsional', 'UYW', 4,NULL),
	('Uzbekistan', 'Uzbekistan Sum', 'UZS', 2, NULL),
	('Vanuatu', 'Vatu', 'VUV', 0, NULL),
	('Venezuela', 'Bolívar Soberano', 'VES', 2, NULL),
	('Vietnam', 'Dong', 'VND', 0, '₫'),
	('Virgin Islands (British)', 'US Dollar', 'USD', 2, '$'),
	('Virgin Islands (U.S.)', 'US Dollar', 'USD', 2, '$'),
	('Wallis and Futuna', 'CFP Franc', 'XPF', 0, NULL),
	('Western Sahara', 'Moroccan Dirham', 'MAD', 2, NULL),
	('Yemen', 'Yemeni Rial', 'YER', 2, NULL),
	('Zambia', 'Zambian Kwacha', 'ZMW', 2, NULL),
	('Zimbabwe', 'Zimbabwe Dollar', 'ZWL', 2, NULL);

CREATE TABLE IF NOT EXISTS equity.country (
    id int PRIMARY KEY,
	alpha_2 char(2) NOT NULL,
    alpha_3 char(3) NOT NULL,
    name varchar(75) NOT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

INSERT INTO equity.country (id, alpha_2, alpha_3, name) VALUES
	(4,'af','afg','Afghanistan'),
	(8,'al','alb','Albania'),
	(12,'dz','dza','Algeria'),
	(20,'ad','and','Andorra'),
	(24,'ao','ago','Angola'),
	(28,'ag','atg','Antigua and Barbuda'),
	(32,'ar','arg','Argentina'),
	(51,'am','arm','Armenia'),
	(533,'aw','abw','Aruba'),
	(36,'au','aus','Australia'),
	(40,'at','aut','Austria'),
	(31,'az','aze','Azerbaijan'),
	(44,'bs','bhs','Bahamas'),
	(48,'bh','bhr','Bahrain'),
	(50,'bd','bgd','Bangladesh'),
	(52,'bb','brb','Barbados'),
	(112,'by','blr','Belarus'),
	(56,'be','bel','Belgium'),
	(84,'bz','blz','Belize'),
	(204,'bj','ben','Benin'),
	(64,'bt','btn','Bhutan'),
	(68,'bo','bol','Bolivia'),
	(70,'ba','bih','Bosnia and Herzegovina'),
	(72,'bw','bwa','Botswana'),
	(76,'br','bra','Brazil'),
	(96,'bn','brn','Brunei Darussalam'),
	(100,'bg','bgr','Bulgaria'),
	(854,'bf','bfa','Burkina Faso'),
	(108,'bi','bdi','Burundi'),
	(132,'cv','cpv','Cabo Verde'),
	(116,'kh','khm','Cambodia'),
	(120,'cm','cmr','Cameroon'),
	(124,'ca','can','Canada'),
	(140,'cf','caf','Central African Republic'),
	(148,'td','tcd','Chad'),
	(152,'cl','chl','Chile'),
	(156,'cn','chn','China'),
	(170,'co','col','Colombia'),
	(174,'km','com','Comoros'),
	(178,'cg','cog','Congo'),
	(180,'cd','cod','Congo, Democratic Republic of the'),
	(188,'cr','cri','Costa Rica'),
	(384,'ci','civ','Côte d''Ivoire'),
	(191,'hr','hrv','Croatia'),
	(192,'cu','cub','Cuba'),
	(196,'cy','cyp','Cyprus'),
	(203,'cz','cze','Czechia'),
	(208,'dk','dnk','Denmark'),
	(262,'dj','dji','Djibouti'),
	(212,'dm','dma','Dominica'),
	(214,'do','dom','Dominican Republic'),
	(218,'ec','ecu','Ecuador'),
	(818,'eg','egy','Egypt'),
	(222,'sv','slv','El Salvador'),
	(226,'gq','gnq','Equatorial Guinea'),
	(232,'er','eri','Eritrea'),
	(233,'ee','est','Estonia'),
	(748,'sz','swz','Eswatini'),
	(231,'et','eth','Ethiopia'),
	(242,'fj','fji','Fiji'),
	(246,'fi','fin','Finland'),
	(250,'fr','fra','France'),
	(266,'ga','gab','Gabon'),
	(270,'gm','gmb','Gambia'),
	(268,'ge','geo','Georgia'),
	(276,'de','deu','Germany'),
	(288,'gh','gha','Ghana'),
	(292,'gi','gib','Gibraltar'),
	(300,'gr','grc','Greece'),
	(308,'gd','grd','Grenada'),
	(312,'gp','glp','Guadeloupe'),
	(320,'gt','gtm','Guatemala'),
	(316,'gu','gum','Guam'),
	(831,'gg','ggy','Guernsey'),
	(324,'gn','gin','Guinea'),
	(624,'gw','gnb','Guinea-Bissau'),
	(328,'gy','guy','Guyana'),
	(332,'ht','hti','Haiti'),
	(336,'va','vat','Holy See (Vatican)'),
	(340,'hn','hnd','Honduras'),
	(344,'hk','hkg','Hong Kong'),
	(348,'hu','hun','Hungary'),
	(352,'is','isl','Iceland'),
	(356,'in','ind','India'),
	(360,'id','idn','Indonesia'),
	(364,'ir','irn','Iran (Islamic Republic of)'),
	(368,'iq','irq','Iraq'),
	(372,'ie','irl','Ireland'),
	(376,'il','isr','Israel'),
	(380,'it','ita','Italy'),
	(388,'jm','jam','Jamaica'),
	(392,'jp','jpn','Japan'),
	(400,'jo','jor','Jordan'),
	(398,'kz','kaz','Kazakhstan'),
	(404,'ke','ken','Kenya'),
	(296,'ki','kir','Kiribati'),
	(408,'kp','prk','Korea (Democratic People''s Republic of)'),
	(410,'kr','kor','Korea, Republic of'),
	(414,'kw','kwt','Kuwait'),
	(417,'kg','kgz','Kyrgyzstan'),
	(418,'la','lao','Lao People''s Democratic Republic'),
	(428,'lv','lva','Latvia'),
	(422,'lb','lbn','Lebanon'),
	(426,'ls','lso','Lesotho'),
	(430,'lr','lbr','Liberia'),
	(434,'ly','lby','Libya'),
	(438,'li','lie','Liechtenstein'),
	(440,'lt','ltu','Lithuania'),
	(442,'lu','lux','Luxembourg'),
	(450,'mg','mdg','Madagascar'),
	(454,'mw','mwi','Malawi'),
	(458,'my','mys','Malaysia'),
	(462,'mv','mdv','Maldives'),
	(466,'ml','mli','Mali'),
	(470,'mt','mlt','Malta'),
	(584,'mh','mhl','Marshall Islands'),
	(478,'mr','mrt','Mauritania'),
	(480,'mu','mus','Mauritius'),
	(484,'mx','mex','Mexico'),
	(583,'fm','fsm','Micronesia (Federated States of)'),
	(498,'md','mda','Moldova, Republic of'),
	(492,'mc','mco','Monaco'),
	(496,'mn','mng','Mongolia'),
	(499,'me','mne','Montenegro'),
	(504,'ma','mar','Morocco'),
	(508,'mz','moz','Mozambique'),
	(104,'mm','mmr','Myanmar'),
	(516,'na','nam','Namibia'),
	(520,'nr','nru','Nauru'),
	(524,'np','npl','Nepal'),
	(528,'nl','nld','Netherlands'),
	(554,'nz','nzl','New Zealand'),
	(558,'ni','nic','Nicaragua'),
	(562,'ne','ner','Niger'),
	(566,'ng','nga','Nigeria'),
	(807,'mk','mkd','North Macedonia'),
	(578,'no','nor','Norway'),
	(512,'om','omn','Oman'),
	(586,'pk','pak','Pakistan'),
	(585,'pw','plw','Palau'),
	(591,'pa','pan','Panama'),
	(598,'pg','png','Papua New Guinea'),
	(600,'py','pry','Paraguay'),
	(604,'pe','per','Peru'),
	(608,'ph','phl','Philippines'),
	(616,'pl','pol','Poland'),
	(620,'pt','prt','Portugal'),
	(634,'qa','qat','Qatar'),
	(642,'ro','rou','Romania'),
	(643,'ru','rus','Russian Federation'),
	(646,'rw','rwa','Rwanda'),
	(652,'bl','blm','Saint Barthélemy'),
	(659,'kn','kna','Saint Kitts and Nevis'),
	(662,'lc','lca','Saint Lucia'),
	(670,'vc','vct','Saint Vincent and the Grenadines'),
	(882,'ws','wsm','Samoa'),
	(674,'sm','smr','San Marino'),
	(678,'st','stp','Sao Tome and Principe'),
	(682,'sa','sau','Saudi Arabia'),
	(686,'sn','sen','Senegal'),
	(688,'rs','srb','Serbia'),
	(690,'sc','syc','Seychelles'),
	(694,'sl','sle','Sierra Leone'),
	(702,'sg','sgp','Singapore'),
	(703,'sk','svk','Slovakia'),
	(705,'si','svn','Slovenia'),
	(90,'sb','slb','Solomon Islands'),
	(706,'so','som','Somalia'),
	(710,'za','zaf','South Africa'),
	(728,'ss','ssd','South Sudan'),
	(724,'es','esp','Spain'),
	(144,'lk','lka','Sri Lanka'),
	(729,'sd','sdn','Sudan'),
	(740,'sr','sur','Suriname'),
	(744,'sj','sjm','Svalbard and Jan Mayen'),
	(752,'se','swe','Sweden'),
	(756,'ch','che','Switzerland'),
	(760,'sy','syr','Syrian Arab Republic'),
	(762,'tj','tjk','Tajikistan'),
	(834,'tz','tza','Tanzania, United Republic of'),
	(764,'th','tha','Thailand'),
	(626,'tl','tls','Timor-Leste'),
	(768,'tg','tgo','Togo'),
	(776,'to','ton','Tonga'),
	(780,'tt','tto','Trinidad and Tobago'),
	(788,'tn','tun','Tunisia'),
	(792,'tr','tur','Türkiye'),
	(795,'tm','tkm','Turkmenistan'),
	(796,'tc','tca','Turks and Caicos Islands'),
	(798,'tv','tuv','Tuvalu'),
	(800,'ug','uga','Uganda'),
	(804,'ua','ukr','Ukraine'),
	(784,'ae','are','United Arab Emirates'),
	(826,'gb','gbr','United Kingdom of Great Britain and Northern Ireland'),
	(840,'us','usa','United States of America'),
	(858,'uy','ury','Uruguay'),
	(860,'uz','uzb','Uzbekistan'),
	(548,'vu','vut','Vanuatu'),
	(862,'ve','ven','Venezuela'),
	(704,'vn','vnm','Vietnam'),
	(092,'vg','vgb','Virgin Islands (British)'),
	(850,'vi','vir','Virgin Islands (U.S.)'),
	(876,'wf','wlf','Wallis and Futuna'),
	(732,'eh','esh','Western Sahara'),
	(887,'ye','yem','Yemen'),
	(894,'zm','zmb','Zambia'),
	(716,'zw','zwe','Zimbabwe');

CREATE TABLE IF NOT EXISTS equity.gics_sector (
    code integer PRIMARY KEY,
    name varchar(255) NOT NULL,
    definition varchar(1000) DEFAULT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

INSERT INTO equity.gics_sector (code, name, definition, start_date, end_date) VALUES
	(10, 'Energy', 'The Energy Sector comprises companies engaged in exploration & production, refining & marketing, and storage & transportation of oil & gas and coal & consumable fuels. It also includes companies that offer oil & gas equipment and services.', '1999-01-01', NULL),
	(15, 'Materials', 'The Materials Sector includes companies that manufacture chemicals, construction materials, glass, paper, forest products and related packaging products, and metals, minerals and mining companies, including producers of steel.', '1999-01-01', NULL),
	(20, 'Industrials', 'The Industrials Sector includes manufacturers and distributors of capital goods such as aerospace & defense, building products, electrical equipment and machinery and companies that offer construction & engineering services. It also includes providers of commercial & professional services including printing, environmental and facilities services, office services & supplies, security & alarm services, human resource & employment services, research & consulting services. It also includes companies that provide transportation services.', '1999-01-01', NULL),
	(25, 'Consumer Discretionary', 'The Consumer Discretionary Sector encompasses those businesses that tend to be the most sensitive to economic cycles. Its manufacturing segment includes automotive, household durable goods, leisure equipment and textiles & apparel. The services segment includes hotels, restaurants and other leisure facilities, media production and services, and consumer retailing and services. ', '1999-01-01', NULL),
	(30, 'Consumer Staples', 'The Consumer Staples Sector comprises companies whose businesses are less sensitive to economic cycles. It includes manufacturers and distributors of food, beverages and tobacco and producers of non-durable household goods and personal products. It also includes food & drug retailing companies as well as hypermarkets and consumer super centers.', '1999-01-01', NULL),
	(35, 'Health Care', 'The Health Care Sector includes health care providers & services, companies that manufacture and distribute health care equipment & supplies, and health care technology companies. It also includes companies involved in the research, development, production and marketing of pharmaceuticals and biotechnology products.', '1999-01-01', NULL),
	(40, 'Financials', 'The Financials Sector contains companies involved in banking, thrifts & mortgage finance, specialized finance, consumer finance, asset management and custody banks, investment banking and brokerage and insurance. It also includes Financial Exchanges & Data and Mortgage REITs.', '1999-01-01', NULL),
	(45, 'Information Technology', 'The Information Technology Sector comprises companies that offer software and information technology services, manufacturers and distributors of technology hardware & equipment such as communications equipment, cellular phones, computers & peripherals, electronic equipment and related instruments, and semiconductors.', '1999-01-01', NULL),
	(50, 'Communication Services', 'The Communication Services Sector includes companies that facilitate communication and offer related content and information through various mediums. It includes telecom and media & entertainment companies including producers of interactive gaming products and companies engaged in content and information creation or distribution through proprietary platforms.', '1999-01-01', NULL),
	(55, 'Utilities', 'The Utilities Sector comprises utility companies such as electric, gas and water utilities. It also includes independent power producers & energy traders and companies that engage in generation and distribution of electricity using renewable sources.', '1999-01-01', NULL),
	(60, 'Real Estate', 'The Real Estate Sector contains companies engaged in real estate development and operation. It also includes companies offering real estate related services and Equity Real Estate Investment Trusts (REITs).', '1999-01-01', NULL);


CREATE TABLE IF NOT EXISTS equity.gics_industry_group (
    code integer PRIMARY KEY,
    name varchar(255) NOT NULL,
    sector_code int NOT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT FK_gics_industry_group_gics_sector 
        FOREIGN KEY(sector_code)
        REFERENCES equity.gics_sector 
        ON DELETE CASCADE);

INSERT INTO equity.gics_industry_group (code, name, sector_code, start_date, end_date) VALUES
	(1010, 'Energy', 10, '1999-01-01', NULL),
	(1510, 'Materials', 15, '1999-01-01', NULL),
	(2010, 'Capital Goods', 20, '1999-01-01', NULL),
	(2020, 'Commercial & Professional Services', 20, '1999-01-01', NULL),
	(2030, 'Transportation', 20, '1999-01-01', NULL),
	(2510, 'Automobiles & Components', 25, '1999-01-01', NULL),
	(2520, 'Consumer Durables & Apparel', 25, '1999-01-01', NULL),
	(2530, 'Consumer Services', 25, '1999-01-01', NULL),
	(2540, 'Media (discontinued effective close of September 28, 2018)', 25, '1999-01-01', '2018-09-28'),
	(2550, 'Retailing', 25, '1999-01-01', NULL),
	(3010, 'Food & Staples Retailing', 30, '1999-01-01', NULL),
	(3020, 'Food, Beverage & Tobacco', 30, '1999-01-01', NULL),
	(3030, 'Household & Personal Products', 30, '1999-01-01', NULL),
	(3510, 'Health Care Equipment & Services', 35, '1999-01-01', NULL),
	(3520, 'Pharmaceuticals, BioTechnology & Life Sciences', 35, '1999-01-01', NULL),
	(4010, 'Banks', 40, '1999-01-01', NULL),
	(4020, 'Diversified Financials', 40, '1999-01-01', NULL),
	(4030, 'Insurance', 40, '1999-01-01', NULL),
	(4040, 'Real Estate - - discontinued effective close of Aug 31, 2016', 40, '1999-01-01', '2016-08-31'),
	(4510, 'Software & Services', 45, '1999-01-01', NULL),
	(4520, 'Technology Hardware & Equipment', 45, '1999-01-01', NULL),
	(4530, 'Semiconductors & Semiconductor Equipment', 45, '1999-01-01', NULL),
	(5010, 'Telecommunication Services', 50, '1999-01-01', NULL),
	(5020, 'Media & Entertainment', 50, '2018-09-29', NULL),
	(5510, 'Utilities', 55, '1999-01-01', NULL),
	(6010, 'Real Estate', 60, '1999-01-01', NULL);

CREATE TABLE IF NOT EXISTS equity.gics_industry (
    code integer PRIMARY KEY,
    name varchar(255) NOT NULL,
    industry_group_code int NOT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT FK_gics_industry_gics_industry_group
        FOREIGN KEY(industry_group_code)
        REFERENCES equity.gics_industry_group 
        ON DELETE CASCADE);

INSERT INTO equity.gics_industry (code, name, industry_group_code, start_date, end_date) VALUES
	(101010, 'Energy Equipment & Services', 1010, '1999-01-01', NULL),
	(101020, 'Oil, Gas & Consumable Fuels', 1010, '1999-01-01', NULL),
	(151010, 'Chemicals', 1510, '1999-01-01', NULL),
	(151020, 'Construction Materials', 1510, '1999-01-01', NULL),
	(151030, 'Containers & Packaging', 1510, '1999-01-01', NULL),
	(151040, 'Metals & Mining', 1510, '1999-01-01', NULL),
	(151050, 'Paper & Forest Products', 1510, '1999-01-01', NULL),
	(201010, 'Aerospace & Defense', 2010, '1999-01-01', NULL),
	(201020, 'Building Products', 2010, '1999-01-01', NULL),
	(201030, 'Construction & Engineering', 2010, '1999-01-01', NULL),
	(201040, 'Electrical Equipment', 2010, '1999-01-01', NULL),
	(201050, 'Industrial Conglomerates', 2010, '1999-01-01', NULL),
	(201060, 'Machinery', 2010, '1999-01-01', NULL),
	(201070, 'Trading Companies & Distributors', 2010, '1999-01-01', NULL),
	(202010, 'Commercial Services & Supplies', 2020, '1999-01-01', NULL),
	(202020, 'Professional Services', 2020, '1999-01-01', NULL),
	(203010, 'Air Freight & Logistics', 2030, '1999-01-01', NULL),
	(203020, 'Airlines', 3010, '1999-01-01', NULL),
	(203030, 'Marine', 2030, '1999-01-01', NULL),
	(203040, 'Road & Rail', 2030, '1999-01-01', NULL),
	(203050, 'Transportation Infrastructure', 2030, '1999-01-01', NULL),
	(251010, 'Auto Components', 2510, '1999-01-01', NULL),
	(251020, 'Automobiles', 2510, '1999-01-01', NULL),
	(252010, 'Household Durables', 2520, '1999-01-01', NULL),
	(252020, 'Leisure Products', 2520, '1999-01-01', NULL),
	(252030, 'Textiles, Apparel & Luxury Goods', 2520, '1999-01-01', NULL),
	(253010, 'Hotels, Restaurants & Leisure', 2530, '1999-01-01', NULL),
	(253020, 'Diversified Consumer Services', 2530, '1999-01-01', NULL),
	(254010, 'Media  (discontinued effective close of September 28, 2018)', 2540, '1999-01-01', '2018-09-28'),
	(255010, 'Distributors', 2550, '1999-01-01', NULL),
	(255020, 'Internet & Direct Marketing Retail', 2550, '1999-01-01', NULL),
	(255030, 'Multiline Retail', 2550, '1999-01-01', NULL),
	(255040, 'Specialty Retail', 2550, '1999-01-01', NULL),
	(301010, 'Food & Staples Retailing', 3010, '1999-01-01', NULL),
	(302010, 'Beverages', 3020, '1999-01-01', NULL),
	(302020, 'Food Products', 3020, '1999-01-01', NULL),
	(302030, 'Tobacco', 3020, '1999-01-01', NULL),
	(303010, 'Household Products', 3030, '1999-01-01', NULL),
	(303020, 'Personal Products', 3030, '1999-01-01', NULL),
	(351010, 'Health Care Equipment & Supplies', 3510, '1999-01-01', NULL),
	(351020, 'Health Care Providers & Services', 3510, '1999-01-01', NULL),
	(351030, 'Health Care Technology', 3510, '1999-01-01', NULL),
	(352010, 'Biotechnology', 3520, '1999-01-01', NULL),
	(352020, 'Pharmaceuticals', 3520, '1999-01-01', NULL),
	(352030, 'Life Sciences Tools & Services', 3520, '1999-01-01', NULL),
	(401010, 'Banks', 4010, '1999-01-01', NULL),
	(401020, 'Thrifts & Mortgage Finance', 4010, '1999-01-01', NULL),
	(402010, 'Diversified Financial Services', 4020, '1999-01-01', NULL),
	(402020, 'Consumer Finance', 4020, '1999-01-01', NULL),
	(402030, 'Capital Markets', 4020, '1999-01-01', NULL),
	(402040, 'Mortgage Real Estate Investment Trusts (REITs)', 4020, '1999-01-01', NULL),
	(403010, 'Insurance', 4030, '1999-01-01', NULL),
	(404010, 'Real Estate -- Discontinued effective 04/28/2006', 4040, '1999-01-01', '2006-04-28'),
	(404020, 'Real Estate Investment Trusts (REITs) - discontinued effective close of Aug 31, 2016', 4040, '1999-01-01', '2016-08-31'),
	(404030, 'Real Estate Management & Development (discontinued effective close of August 31, 2016)', 4040, '1999-01-01', '2016-08-31'),
	(451010, 'Internet Software & Services (discontinued effective close of September 28, 2018)', 4510, '1999-01-01', '2018-09-28'),
	(451020, 'IT Services', 4510, '1999-01-01', NULL),
	(451030, 'Software', 4510, '1999-01-01', NULL),
	(452010, 'Communications Equipment', 4520, '1999-01-01', NULL),
	(452020, 'Technology Hardware, Storage & Peripherals', 4520, '1999-01-01', NULL),
	(452030, 'Electronic Equipment, Instruments & Components', 4520, '1999-01-01', NULL),
	(452040, 'Office Electronics - Discontinued effective 02/28/2014', 4520, '1999-01-01', '2014-02-28'),
	(452050, 'Semiconductor Equipment & Products -- Discontinued effective 04/30/2003.', 4520, '1999-01-01', '2003-04-30'),
	(453010, 'Semiconductors & Semiconductor Equipment', 4530, '1999-01-01', NULL),
	(501010, 'Diversified Telecommunication Services', 5010, '1999-01-01', NULL),
	(501020, 'Wireless Telecommunication Services', 5010, '1999-01-01', NULL),
	(502010, 'Media', 5020, '1999-01-01', NULL),
	(502020, 'Entertainment', 5020, '1999-01-01', NULL),
	(502030, 'Interactive Media & Services', 5020, '1999-01-01', NULL),
	(551010, 'Electric Utilities', 5510, '1999-01-01', NULL),
	(551020, 'Gas Utilities', 5510, '1999-01-01', NULL),
	(551030, 'Multi-Utilities', 5510, '1999-01-01', NULL),
	(551040, 'Water Utilities', 5510, '1999-01-01', NULL),
	(551050, 'Independent Power and Renewable Electricity Producers', 5510, '1999-01-01', NULL),
	(601010, 'Equity Real Estate Investment Trusts (REITs)', 6010, '1999-01-01', NULL),
	(601020, 'Real Estate Management & Development', 6010, '1999-01-01', NULL);

CREATE TABLE IF NOT EXISTS equity.gics_sub_industry (
    code integer PRIMARY KEY,
    name varchar(255) NOT NULL,
    description varchar(1000) DEFAULT NULL,
    industry_code int NOT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT FK_gics_sub_industry_gics_industry 
        FOREIGN KEY(industry_code)
        REFERENCES equity.gics_industry 
        ON DELETE CASCADE
);

INSERT INTO equity.gics_sub_industry (code, name, description, industry_code, start_date, end_date) VALUES
	(10101020, 'Oil & Gas Equipment & Services', 'Manufacturers of equipment, including drilling rigs and equipment, and providers of supplies and services to companies involved in the drilling, evaluation and completion of oil and gas wells.', 101010, '1999-01-01', NULL),
	(10102010, 'Integrated Oil & Gas', 'Integrated oil companies engaged in the exploration & production of oil and gas, as well as at least one other significant activity in either refining, marketing and transportation, or chemicals.', 101020, '1999-01-01', NULL),
	(10102020, 'Oil & Gas Exploration & Production', 'Companies engaged in the exploration and production of oil and gas not classified elsewhere.', 101020, '1999-01-01', NULL),
	(10102030, 'Oil & Gas Refining & Marketing', 'Companies engaged in the refining and marketing of oil, gas and/or refined products not classified in the Integrated Oil & Gas or Independent Power Producers & Energy Traders Sub-Industries.', 101020, '1999-01-01', NULL),
	(10102040, 'Oil & Gas Storage & Transportation', 'Companies engaged in the storage and/or transportation of oil, gas and/or refined products. Includes diversified midstream natural gas companies, oil and refined product pipelines, coal slurry pipelines and oil & gas shipping companies.', 101020, '1999-01-01', NULL),
	(10102050, 'Coal & Consumable Fuels', 'Companies primarily involved in the production and mining of coal, related products and other consumable fuels related to the generation of energy.  Excludes companies primarily producing gases classified in the Industrial Gases sub-industry and companies primarily mining for metallurgical (coking) coal used for steel production.', 101020, '1999-01-01', NULL),
	(15101010, 'Commodity Chemicals', 'Companies that primarily produce industrial chemicals and basic chemicals. Including but not limited to plastics, synthetic fibers, films, commodity-based paints & pigments, explosives and petrochemicals. Excludes chemical companies classified in the Diversified Chemicals, Fertilizers & Agricultural Chemicals, Industrial Gases, or Specialty Chemicals Sub-Industries.', 151010, '1999-01-01', NULL),
	(15101020, 'Diversified Chemicals', 'Manufacturers of a diversified range of chemical products not classified in the Industrial Gases, Commodity Chemicals, Specialty Chemicals or Fertilizers & Agricultural Chemicals Sub-Industries.', 151010, '1999-01-01', NULL),
	(15101030, 'Fertilizers & Agricultural Chemicals', 'Producers of fertilizers, pesticides, potash or other agriculture-related chemicals not classified elsewhere.', 151010, '1999-01-01', NULL),
	(15101040, 'Industrial Gases', 'Manufacturers of industrial gases.', 151010, '1999-01-01', NULL),
	(15101050, 'Specialty Chemicals', 'Companies that primarily produce high value-added chemicals used in the manufacture of a wide variety of products, including but not limited to fine chemicals, additives, advanced polymers, adhesives, sealants and specialty paints, pigments and coatings.', 151010, '1999-01-01', NULL),
	(15102010, 'Construction Materials', 'Manufacturers of construction materials including sand, clay, gypsum, lime, aggregates, cement, concrete and bricks. Other finished or semi-finished building materials are classified  in the Building Products Sub-Industry.', 151020, '1999-01-01', NULL),
	(15103010, 'Metal & Glass Containers', 'Manufacturers of metal, glass or plastic containers. Includes corks and caps.', 151030, '1999-01-01', NULL),
	(15103020, 'Paper Packaging', 'Manufacturers of paper and cardboard containers and packaging.', 151030, '1999-01-01', NULL),
	(15104010, 'Aluminum', 'Producers of aluminum and related products, including companies that mine or process bauxite and companies that recycle aluminum to produce finished or semi-finished products. Excludes companies that primarily produce aluminum building materials classified in the Building Products Sub-Industry.', 151040, '1999-01-01', NULL),
	(15104020, 'Diversified Metals & Mining', 'Companies engaged in the diversified production or extraction of metals and minerals not classified elsewhere. Including, but not limited to, nonferrous metal mining (except bauxite), salt and borate mining, phosphate rock mining, and diversified mining operations. Excludes iron ore mining, classified in the Steel Sub-Industry, bauxite mining, classified in the Aluminum Sub-Industry, and coal mining, classified in either the Steel or Coal & Consumable Fuels Sub-Industries.', 151040, '1999-01-01', NULL),
	(15104025, 'Copper', 'Companies involved primarily in copper ore mining. ', 151040, '1999-01-01', NULL),
	(15104030, 'Gold', 'Producers of gold and related products, including companies that mine or process gold and the South African finance houses which primarily invest in, but do not operate, gold mines.', 151040, '1999-01-01', NULL),
	(15104040, 'Precious Metals & Minerals', 'Companies mining precious metals and minerals not classified in the Gold Sub-Industry. Includes companies primarily mining platinum.', 151040, '1999-01-01', NULL),
	(15104045, 'Silver', 'Companies primarily mining silver. Excludes companies classified in the Gold or Precious Metals & Minerals Sub-Industries.', 151040, '1999-01-01', NULL),
	(15104050, 'Steel', 'Producers of iron and steel and related products, including metallurgical (coking) coal mining used for steel production.', 151040, '1999-01-01', NULL),
	(15105010, 'Forest Products', 'Manufacturers of timber and related wood products. Includes lumber for the building industry.', 151050, '1999-01-01', NULL),
	(15105020, 'Paper Products', 'Manufacturers of all grades of paper. Excludes companies specializing in paper packaging classified in the Paper Packaging Sub-Industry.', 151050, '1999-01-01', NULL),
	(20101010, 'Aerospace & Defense', 'Manufacturers of civil or military aerospace and defense equipment, parts or products. Includes defense electronics and space equipment.', 201010, '1999-01-01', NULL),
	(20102010, 'Building Products', 'Manufacturers of building components and home improvement products and equipment. Excludes lumber and plywood classified under Forest Products and cement and other materials classified in the Construction Materials Sub-Industry.', 201020, '1999-01-01', NULL),
	(20103010, 'Construction & Engineering', 'Companies engaged in primarily non-residential construction. Includes civil engineering companies and large-scale contractors. Excludes companies classified in the Homebuilding Sub-Industry.', 201030, '1999-01-01', NULL),
	(20104010, 'Electrical Components & Equipment', 'Companies that produce electric cables and wires, electrical components or equipment not classified in the Heavy Electrical Equipment Sub-Industry.', 201040, '1999-01-01', NULL),
	(20104020, 'Heavy Electrical Equipment', 'Manufacturers of power-generating equipment and other heavy electrical equipment, including power turbines, heavy electrical machinery intended for fixed-use and large electrical systems. Excludes cables and wires, classified in the Electrical Components & Equipment Sub-Industry.', 201040, '1999-01-01', NULL),
	(20105010, 'Industrial Conglomerates', 'Diversified industrial companies with business activities in three or more sectors, none of which contributes a majority of revenues. Stakes held are predominantly of a controlling nature and stake holders maintain an operational interest in the running of the subsidiaries.', 201050, '1999-01-01', NULL),
	(20106010, 'Construction Machinery & Heavy Trucks', 'Manufacturers of heavy duty trucks, rolling machinery, earth-moving and construction equipment, and manufacturers of related parts. Includes non-military shipbuilding.', 201060, '1999-01-01', NULL),
	(20106015, 'Agricultural & Farm Machinery', 'Companies manufacturing agricultural machinery, farm machinery, and their related parts. Includes machinery used for the production of crops and agricultural livestock, agricultural tractors, planting and fertilizing machinery, fertilizer and chemical application equipment, and grain dryers and blowers.', 201060, '1999-01-01', NULL),
	(20106020, 'Industrial Machinery', 'Manufacturers of industrial machinery and industrial components. Includes companies that manufacture presses, machine tools, compressors, pollution control equipment, elevators, escalators, insulators, pumps, roller bearings and other metal fabrications.', 201060, '1999-01-01', NULL),
	(20107010, 'Trading Companies & Distributors', 'Trading companies and other distributors of industrial equipment and products.', 201070, '1999-01-01', NULL),
	(20201010, 'Commercial Printing', 'Companies providing commercial printing services. Includes printers primarily serving the media industry.', 202010, '1999-01-01', NULL),
	(20201020, 'Data Processing Services  (discontinued effective close of April 30, 2003)', 'Providers of commercial electronic data processing services.', 202010, '1999-01-01', '2003-04-30'),
	(20201030, 'Diversified Commercial & Professional Services (discontinued effective close of August 31, 2008)', 'Companies primarily providing commercial, industrial and professional services to businesses and governments not classified elsewhere.  Includes commercial cleaning services, consulting services, correctional facilities, dining & catering services, document & communication services, equipment repair services, security & alarm services, storage & warehousing, and uniform rental services.', 202010, '1999-01-01', '2008-08-31'),
	(20201040, 'Human Resource & Employment Services (discontinued effective close of August 31, 2008)', 'Companies providing business support services relating to human capital management. Includes employment agencies, employee training, payroll & benefit support services, retirement support services and temporary agencies.', 202010, '1999-01-01', '2008-08-31'),
	(20201050, 'Environmental & Facilities Services', 'Companies providing environmental and facilities maintenance services. Includes waste management, facilities management and pollution control services.  Excludes large-scale water treatment systems classified in the Water Utilities Sub-Industry.', 202010, '1999-01-01', NULL),
	(20201060, 'Office Services & Supplies', 'Providers of office services and manufacturers of office supplies and equipment not classified elsewhere.', 202010, '1999-01-01', NULL),
	(20201070, 'Diversified Support Services', 'Companies primarily providing labor oriented support services to businesses and governments.  Includes commercial cleaning services, dining & catering services, equipment repair services, industrial maintenance services, industrial auctioneers, storage & warehousing, transaction services, uniform rental services, and other business support services.', 202010, '1999-01-01', NULL),
	(20201080, 'Security & Alarm Services', 'Companies providing security and protection services to business and governments. Includes companies providing services such as correctional facilities, security & alarm services, armored transportation & guarding.  Excludes companies providing security software classified under the Systems Software Sub-Industry and home security services classified under the Specialized Consumer Services Sub-Industry. Also excludes companies manufacturing security system equipment classified under the Electronic Equipment & Instruments Sub-Industry. ', 202010, '1999-01-01', NULL),
	(20202010, 'Human Resource & Employment Services', 'Companies providing business support services relating to human capital management. Includes employment agencies, employee training, payroll & benefit support services, retirement support services and temporary agencies.', 202020, '1999-01-01', NULL),
	(20202020, 'Research & Consulting Services', 'Companies primarily providing research and consulting services to businesses and governments not classified elsewhere.  Includes companies involved in management consulting services, architectural design, business information or scientific research, marketing, and testing & certification services. Excludes companies providing information technology consulting services classified in the IT Consulting & Other Services Sub-Industry.', 202020, '1999-01-01', NULL),
	(20301010, 'Air Freight & Logistics', 'Companies providing air freight transportation, courier and logistics services, including package and mail delivery and customs agents. Excludes those companies classified in the Airlines, Marine or Trucking Sub-Industries.', 203010, '1999-01-01', NULL),
	(20302010, 'Airlines', 'Companies providing primarily passenger air transportation.', 203020, '1999-01-01', NULL),
	(20303010, 'Marine', 'Companies providing goods or passenger maritime transportation. Excludes cruise-ships classified in the Hotels, Resorts & Cruise Lines Sub-Industry.', 203030, '1999-01-01', NULL),
	(20304010, 'Railroads', 'Companies providing primarily goods and passenger rail  transportation.', 203040, '1999-01-01', NULL),
	(20304020, 'Trucking', 'Companies providing primarily goods and passenger land transportation. Includes vehicle rental and taxi companies.', 203040, '1999-01-01', NULL),
	(20305010, 'Airport Services', 'Operators of airports and companies providing related services.', 203050, '1999-01-01', NULL),
	(20305020, 'Highways & Railtracks', 'Owners and operators of roads, tunnels and railtracks.', 203050, '1999-01-01', NULL),
	(20305030, 'Marine Ports & Services', 'Owners and operators of marine ports and related services.', 203050, '1999-01-01', NULL),
	(25101010, 'Auto Parts & Equipment', 'Manufacturers of parts and accessories for  automobiles and motorcycles. Excludes companies classified in the Tires & Rubber Sub-Industry.', 251010, '1999-01-01', NULL),
	(25101020, 'Tires & Rubber', 'Manufacturers of tires and rubber.', 251010, '1999-01-01', NULL),
	(25102010, 'Automobile Manufacturers', 'Companies that produce mainly passenger automobiles and light trucks. Excludes companies producing mainly motorcycles and three-wheelers classified in the Motorcycle Manufacturers Sub-Industry and heavy duty trucks classified in the Construction Machinery & Heavy Trucks Sub-Industry.', 251020, '1999-01-01', NULL),
	(25102020, 'Motorcycle Manufacturers', 'Companies that produce motorcycles, scooters or three-wheelers. Excludes bicycles classified in the Leisure Products Sub-Industry. ', 251020, '1999-01-01', NULL),
	(25201010, 'Consumer Electronics', 'Manufacturers of consumer electronics products including TVs, home audio equipment, game consoles, digital cameras, and related products. Excludes personal home computer manufacturers classified in the Technology Hardware, Storage & Peripherals Sub-Industry, and electric household appliances classified in the Household Appliances Sub-Industry.', 252010, '1999-01-01', NULL),
	(25201020, 'Home Furnishings', 'Manufacturers of soft home furnishings or furniture, including upholstery, carpets and wall-coverings.', 252010, '1999-01-01', NULL),
	(25201030, 'Homebuilding', 'Residential construction companies. Includes manufacturers of prefabricated houses and semi-fixed manufactured homes.', 252010, '1999-01-01', NULL),
	(25201040, 'Household Appliances', 'Manufacturers of electric household appliances and related products.  Includes manufacturers of power and hand tools, including garden improvement tools.  Excludes TVs and other audio and video products classified in the Consumer Electronics Sub-Industry and personal computers classified in the Technology Hardware, Storage & Peripherals Sub-Industry.', 252010, '1999-01-01', NULL),
	(25201050, 'Housewares & Specialties', 'Manufacturers of durable household products, including cutlery, cookware, glassware, crystal, silverware, utensils, kitchenware and consumer specialties not classified elsewhere.', 252010, '1999-01-01', NULL),
	(25202010, 'Leisure Products', 'Manufacturers of leisure products and equipment including sports equipment, bicycles and toys.', 252020, '1999-01-01', NULL),
	(25202020, 'Photographic Products (discontinued effective close of February 28, 2014)', 'Manufacturers of photographic equipment and related products.', 252020, '1999-01-01', '2014-02-28'),
	(25203010, 'Apparel, Accessories & Luxury Goods', 'Manufacturers of apparel, accessories & luxury goods. Includes companies primarily producing designer handbags, wallets, luggage, jewelry and watches. Excludes shoes classified in the Footwear Sub-Industry.', 252030, '1999-01-01', NULL),
	(25203020, 'Footwear', 'Manufacturers of footwear. Includes sport and leather shoes.', 252030, '1999-01-01', NULL),
	(25203030, 'Textiles', 'Manufacturers of textile and related products not classified in the Apparel, Accessories & Luxury Goods, Footwear or Home Furnishings Sub-Industries.', 252030, '1999-01-01', NULL),
	(25301010, 'Casinos & Gaming', 'Owners and operators of casinos and gaming facilities. Includes companies providing lottery and betting services.', 253010, '1999-01-01', NULL),
	(25301020, 'Hotels, Resorts & Cruise Lines', 'Owners and operators of hotels, resorts and cruise-ships. Includes travel agencies, tour operators and related services not classified elsewhere . Excludes casino-hotels classified in the Casinos & Gaming Sub-Industry.', 253010, '1999-01-01', NULL),
	(25301030, 'Leisure Facilities', 'Owners and operators of leisure facilities, including sport and fitness centers, stadiums, golf courses and amusement parks not classified in the Movies & Entertainment Sub-Industry.', 253010, '1999-01-01', NULL),
	(25301040, 'Restaurants', 'Owners and operators of restaurants, bars, pubs, fast-food or take-out facilities. Includes companies that provide food catering services.', 253010, '1999-01-01', NULL),
	(25302010, 'Education Services', 'Companies providing educational services, either on-line or through conventional teaching methods. Includes, private universities, correspondence teaching, providers of educational seminars, educational materials and technical education. Excludes companies providing employee education programs classified in the Human Resources & Employment Services Sub-Industry', 253020, '1999-01-01', NULL),
	(25302020, 'Specialized Consumer Services', 'Companies providing consumer services not classified elsewhere.  Includes residential services, home security, legal services, personal services, renovation & interior design services, consumer auctions and wedding & funeral services.', 253020, '1999-01-01', NULL),
	(25401010, 'Advertising (discontinued effective close of September 28, 2018)', 'Companies providing advertising, marketing or public relations services.', 254010, '1999-01-01', '2018-09-28'),
	(25401020, 'Broadcasting (discontinued effective close of September 28, 2018)', 'Owners and operators of television or radio broadcasting systems, including programming. Includes, radio and television broadcasting, radio networks, and radio stations.', 254010, '1999-01-01', '2018-09-28'),
	(25401025, 'Cable & Satellite (discontinued effective close of September 28, 2018)', 'Providers of cable or satellite television services. Includes cable networks and program distribution.', 254010, '1999-01-01', '2018-09-28'),
	(25401030, 'Movies & Entertainment (discontinued effective close of September 28, 2018)', 'Companies that engage in producing and selling entertainment products and services, including companies engaged in the production, distribution and screening of movies and television shows, producers and distributors of music, entertainment theaters and sports teams.', 254010, '1999-01-01', '2018-09-28'),
	(25401040, 'Publishing (discontinued effective close of September 28, 2018)', 'Publishers of newspapers, magazines and books, and providers of information in print or electronic formats.', 254010, '1999-01-01', '2018-09-28'),
	(25501010, 'Distributors', 'Distributors and wholesalers of general merchandise not classified elsewhere. Includes vehicle distributors.', 255010, '1999-01-01', NULL),
	(25502010, 'Catalog Retail (discontinued effective close of August 31, 2016)', 'Mail order and TV home shopping retailers. Includes companies that provide door-to-door retail.', 255020, '1999-01-01', '2016-08-31'),
	(25502020, 'Internet & Direct Marketing Retail', 'Companies  providing  retail  services  primarily  on  the Internet, through mail order, and TV home shopping retailers. Also includes companies providing online marketplaces for consumer products and services.', 255020, '1999-01-01', NULL),
	(25503010, 'Department Stores', 'Owners and operators of department stores.', 255030, '1999-01-01', NULL),
	(25503020, 'General Merchandise Stores', 'Owners and operators of stores offering diversified general merchandise. Excludes hypermarkets and large-scale super centers classified in the Hypermarkets & Super Centers Sub-Industry.', 255030, '1999-01-01', NULL),
	(25504010, 'Apparel Retail', 'Retailers specialized mainly in apparel and accessories.', 255040, '1999-01-01', NULL),
	(25504020, 'Computer & Electronics Retail', 'Owners and operators of consumer electronics, computers, video and related products retail stores.', 255040, '1999-01-01', NULL),
	(25504030, 'Home Improvement Retail', 'Owners and operators of home and garden improvement retail stores. Includes stores offering building materials and supplies.', 255040, '1999-01-01', NULL),
	(25504040, 'Specialty Stores', 'Owners and operators of specialty retail stores not classified elsewhere. Includes jewelry stores, toy stores, office supply stores, health & vision care stores, and book & entertainment stores.', 255040, '1999-01-01', NULL),
	(25504050, 'Automotive Retail', 'Owners and operators of stores specializing in automotive retail.  Includes auto dealers, gas stations, and retailers of auto accessories, motorcycles & parts, automotive glass, and automotive equipment & parts.', 255040, '1999-01-01', NULL),
	(25504060, 'Homefurnishing Retail', 'Owners and operators of furniture and home furnishings retail stores.  Includes residential furniture, homefurnishings, housewares, and interior design.  Excludes home and garden improvement stores, classified in the Home Improvement Retail Sub-Industry.', 255040, '1999-01-01', NULL),
	(30101010, 'Drug Retail', 'Owners and operators of primarily drug retail stores and pharmacies.', 301010, '1999-01-01', NULL),
	(30101020, 'Food Distributors', 'Distributors of food products to other companies and not directly to the consumer.', 301010, '1999-01-01', NULL),
	(30101030, 'Food Retail', 'Owners and operators of primarily food retail stores.', 301010, '1999-01-01', NULL),
	(30101040, 'Hypermarkets & Super Centers', 'Owners and operators of hypermarkets and super centers selling food and a wide-range of consumer staple products.  Excludes Food and Drug Retailers classified in the Food Retail and Drug Retail Sub-Industries, respectively.', 301010, '1999-01-01', NULL),
	(30201010, 'Brewers', 'Producers of beer and malt liquors. Includes breweries not classified in the Restaurants Sub-Industry.', 302010, '1999-01-01', NULL),
	(30201020, 'Distillers & Vintners', 'Distillers, vintners and producers of alcoholic beverages not classified in the Brewers Sub-Industry.', 302010, '1999-01-01', NULL),
	(30201030, 'Soft Drinks', 'Producers of non-alcoholic beverages including mineral waters. Excludes producers of milk classified in the Packaged Foods Sub-Industry.', 302010, '1999-01-01', NULL),
	(30202010, 'Agricultural Products', 'Producers of agricultural products. Includes crop growers, owners of plantations and companies that produce and process foods but do not package and market them. Excludes companies classified in the Forest Products Sub-Industry and those that package and market the food products classified in the Packaged Foods Sub-Industry.', 302020, '1999-01-01', NULL),
	(30202020, 'Meat, Poultry & Fish (discontinued effective close of March 28 2002)', 'Companies that raise livestock or poultry, fishing companies and other producers of meat, poultry or fish products.', 302020, '1999-01-01', '2002-03-28'),
	(30202030, 'Packaged Foods & Meats', 'Producers of packaged foods including dairy products, fruit juices, meats, poultry, fish and pet foods.', 302020, '1999-01-01', NULL),
	(30203010, 'Tobacco', 'Manufacturers of cigarettes and other tobacco products.', 302030, '1999-01-01', NULL),
	(30301010, 'Household Products', 'Producers of non-durable household products, including detergents, soaps, diapers and other tissue and household paper products not classified in the Paper Products Sub-Industry.', 303010, '1999-01-01', NULL),
	(30302010, 'Personal Products', 'Manufacturers of personal and beauty care products, including cosmetics and perfumes.', 303020, '1999-01-01', NULL),
	(35101010, 'Health Care Equipment', 'Manufacturers of health care equipment and devices. Includes medical instruments, drug delivery systems, cardiovascular & orthopedic devices, and diagnostic equipment.', 351010, '1999-01-01', NULL),
	(35101020, 'Health Care Supplies', 'Manufacturers of health care supplies and medical products not classified elsewhere. Includes eye care products, hospital supplies, and safety needle & syringe devices.', 351010, '1999-01-01', NULL),
	(35102010, 'Health Care Distributors', 'Distributors and wholesalers of health care products not classified elsewhere. ', 351020, '1999-01-01', NULL),
	(35102015, 'Health Care  Services', 'Providers of patient health care services not classified elsewhere. Includes dialysis centers, lab testing services, and pharmacy management services. Also includes companies providing business support services to health care providers, such as clerical support services, collection agency services, staffing services and outsourced sales & marketing services', 351020, '1999-01-01', NULL),
	(35102020, 'Health Care Facilities', 'Owners and operators of health care facilities, including hospitals, nursing homes, rehabilitation centers and animal hospitals.', 351020, '1999-01-01', NULL),
	(35102030, 'Managed Health Care', 'Owners and operators of Health Maintenance Organizations (HMOs) and other managed plans.', 351020, '1999-01-01', NULL),
	(35103010, 'Health Care Technology', 'Companies providing information technology services primarily to health care providers.  Includes companies providing application, systems and/or data processing software, internet-based tools, and IT consulting services to doctors, hospitals or businesses operating primarily in the Health Care Sector', 351030, '1999-01-01', NULL),
	(35201010, 'Biotechnology', 'Companies primarily engaged in the research, development, manufacturing and/or marketing of products based on genetic analysis and genetic engineering.  Includes companies specializing in protein-based therapeutics to treat human diseases. Excludes companies manufacturing products using biotechnology but without a health care application.', 352010, '1999-01-01', NULL),
	(35202010, 'Pharmaceuticals', 'Companies engaged in the research, development or production of pharmaceuticals. Includes veterinary drugs.', 352020, '1999-01-01', NULL),
	(35203010, 'Life Sciences Tools & Services', 'Companies enabling the drug discovery, development and production continuum by providing analytical tools, instruments, consumables & supplies, clinical trial services and contract research services.  Includes firms primarily servicing the pharmaceutical and biotechnology industries.', 352030, '1999-01-01', NULL),
	(40101010, 'Diversified Banks', 'Large, geographically diverse banks with a national footprint whose revenues are derived primarily from conventional banking operations, have significant business activity in retail banking and small and medium corporate lending, and provide a diverse range of financial services.  Excludes banks classified in the Regional Banks and Thrifts & Mortgage Finance Sub-Industries. Also excludes investment banks classified in the Investment Banking & Brokerage Sub-Industry.', 401010, '1999-01-01', NULL),
	(40101015, 'Regional Banks', 'Commercial banks whose businesses are derived primarily from conventional banking operations and have significant business activity in retail banking and small and medium corporate lending. Regional banks tend to operate in limited geographic regions. Excludes companies classified in the Diversified Banks and Thrifts & Mortgage Banks sub-industries. Also excludes investment banks classified in the Investment Banking & Brokerage Sub-Industry.', 401010, '1999-01-01', NULL),
	(40102010, 'Thrifts & Mortgage Finance', 'Financial institutions providing mortgage and mortgage related services.  These include financial institutions whose assets are primarily mortgage related, savings & loans, mortgage lending institutions, building societies and companies providing insurance to mortgage banks.', 401020, '1999-01-01', NULL),
	(40201010, 'Consumer Finance (discontinued effective close of April 30, 2003)', 'Providers of consumer finance services, including personal credit, credit cards, lease financing, mortgage lenders, travel-related money services and pawn shops.', 402010, '1999-01-01', '2003-04-30'),
	(40201020, 'Other Diversified Financial Services', 'Providers of a diverse range of financial services and/or with some interest in a wide range of financial services including banking, insurance and capital markets, but with no dominant business line. Excludes companies classified in the Regional Banks and Diversified Banks Sub-Industries.', 402010, '1999-01-01', NULL),
	(40201030, 'Multi-Sector Holdings', 'A company with significantly diversified holdings across three or more sectors, none of which contributes a majority of profit and/or sales. Stakes held are predominantly of a non-controlling nature.  Includes diversified financial companies where stakes held are of a controlling nature. Excludes other diversified companies classified in the Industrials Conglomerates Sub-Industry.', 402010, '1999-01-01', NULL),
	(40201040, 'Specialized Finance', 'Providers  of  specialized  financial  services  not  classified  elsewhere. Companies  in  this  sub-industry  derive  a  majority  of  revenue  from  one  specialized  line  of  business. Includes,  but  not  limited  to,  commercial  financing  companies,  central  banks,  leasing  institutions, factoring services, and specialty boutiques. Excludes companies classified in the Financial Exchanges & Data sub-industry.', 402010, '1999-01-01', NULL),
	(40202010, 'Consumer Finance', 'Providers of consumer finance services, including personal credit, credit cards, lease financing, travel-related money services and pawn shops.  Excludes mortgage lenders classified in the Thrifts & Mortgage Finance Sub-Industry.', 402020, '1999-01-01', NULL),
	(40203010, 'Asset Management & Custody Banks', 'Financial institutions primarily engaged in investment management and/or related custody and securities fee-based services. Includes companies operating mutual funds, closed-end funds and unit investment trusts.  Excludes banks and other financial institutions primarily involved in commercial lending, investment banking, brokerage and other specialized financial activities. ', 402030, '1999-01-01', NULL),
	(40203020, 'Investment Banking & Brokerage', 'Financial institutions primarily engaged in investment banking & brokerage services, including equity and debt underwriting, mergers and acquisitions, securities lending and advisory services. Excludes banks and other financial institutions primarily involved in commercial lending, asset management and specialized financial activities. ', 402030, '1999-01-01', NULL),
	(40203030, 'Diversified Capital Markets', 'Financial institutions primarily engaged in diversified capital markets activities, including a significant presence in at least two of the following area: large/major corporate lending, investment banking, brokerage and asset management. Excludes less diversified companies classified in the Asset Management & Custody Banks or Investment Banking & Brokerage sub-industries.  Also excludes companies classified in the Banks or Insurance industry groups or the Consumer Finance Sub-Industry. ', 402030, '1999-01-01', NULL),
	(40203040, 'Financial Exchanges & Data', 'Financial  exchanges  for  securities,  commodities,  derivatives and other financial instruments, and providers of financial decision support tools and products  including ratings agencies', 402030, '1999-01-01', NULL),
	(40204010, 'Mortgage REITs', 'Companies or Trusts that service, originate, purchase and/or securitize residential and/or commercial mortgage loans.  Includes trusts that invest in mortgage-backed securities and other mortgage related assets.', 402040, '1999-01-01', NULL),
	(40301010, 'Insurance Brokers', 'Insurance and reinsurance brokerage firms.', 403010, '1999-01-01', NULL),
	(40301020, 'Life & Health Insurance', 'Companies providing primarily life, disability, indemnity or supplemental health insurance. Excludes managed care companies classified in the Managed Health Care Sub-Industry.', 403010, '1999-01-01', NULL),
	(40301030, 'Multi-line Insurance', 'Insurance companies with diversified interests in life, health and property and casualty insurance.', 403010, '1999-01-01', NULL),
	(40301040, 'Property & Casualty Insurance', 'Companies providing primarily property and casualty insurance.', 403010, '1999-01-01', NULL),
	(40301050, 'Reinsurance', 'Companies providing primarily reinsurance.', 403010, '1999-01-01', NULL),
	(40401010, 'Real Estate Investment Trusts (discontinued effective close of April 28, 2006)', 'Real estate investment trusts (REITs).  Includes Property Trusts.', 404010, '1999-01-01', '2006-04-28'),
	(40401020, 'Real Estate Management & Development (discontinued effective close of April 28, 2006)', 'Companies engaged in real estate ownership, development or  management.', 404010, '1999-01-01', '2006-04-28'),
	(40402010, 'Diversified REITs (discontinued effective close of August 31, 2016)', 'A company or Trust with significantly diversified operations across two or more property types.', 404020, '1999-01-01', '2016-08-31'),
	(40402020, 'Industrial REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of industrial properties. Includes companies operating industrial warehouses and distribution properties.', 404020, '1999-01-01', '2016-08-31'),
	(40402030, 'Mortgage REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts that service, originate, purchase and/or securitize residential and/or commercial mortgage loans.  Includes trusts that invest in mortgage-backed securities and other mortgage related assets.', 404020, '1999-01-01', '2016-08-31'),
	(40402035, 'Hotel & Resort REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of hotel and resort properties. ', 404020, '1999-01-01', '2016-08-31'),
	(40402040, 'Office REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of office properties.. ', 404020, '1999-01-01', '2016-08-31'),
	(40402045, 'Health Care REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of properties serving the health care industry, including hospitals, nursing homes, and assisted living properties.', 404020, '1999-01-01', '2016-08-31'),
	(40402050, 'Residential REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of residential properties including multifamily homes, apartments, manufactured homes and student housing properties', 404020, '1999-01-01', '2016-08-31'),
	(40402060, 'Retail REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of shopping malls, outlet malls, neighborhood and community shopping centers.', 404020, '1999-01-01', '2016-08-31'),
	(40402070, 'Specialized REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of properties not classified elsewhere. Includes trusts that operate and invest in storage properties. It also includes REITs that do not generate a majority of their revenues and income from real estate rental and leasing operations.', 404020, '1999-01-01', '2016-08-31'),
	(40403010, 'Diversified Real Estate Activities (discontinued effective close of August 31, 2016)', 'Companies engaged in a diverse spectrum of real estate activities including real estate development & sales, real estate management, or real estate services, but with no dominant business line.', 404030, '1999-01-01', '2016-08-31'),
	(40403020, 'Real Estate Operating Companies (discontinued effective close of August 31, 2016)', 'Companies engaged in operating real estate properties for the purpose of leasing & management.', 404030, '1999-01-01', '2016-08-31'),
	(40403030, 'Real Estate Development (discontinued effective close of August 31, 2016)', 'Companies that develop real estate and sell the properties after development. Excludes companies classified in the Homebuilding Sub-Industry.', 404030, '1999-01-01', '2016-08-31'),
	(40403040, 'Real Estate Services (discontinued effective close of August 31, 2016)', 'Real estate service providers such as real estate agents, brokers & real estate appraisers.', 404030, '1999-01-01', '2016-08-31'),
	(45101010, 'Internet Software & Services (discontinued effective close of September 28, 2018)', 'Companies developing and marketing internet software and/or providing internet services including online databases and interactive services, as well as companies deriving a majority of their revenues from online advertising. Excludes companies classified in the Internet Retail Sub-Industry.', 451010, '1999-01-01', '2018-09-28'),
	(45102010, 'IT Consulting & Other Services', 'Providers of information technology and systems integration services not classified in the Data Processing & Outsourced Services Sub-Industry.  Includes information technology consulting and information management services.', 451020, '1999-01-01', NULL),
	(45102020, 'Data Processing & Outsourced Services', 'Providers of commercial electronic data processing and/or business process outsourcing services.  Includes companies that provide services for back-office automation.', 451020, '1999-01-01', NULL),
	(45102030, 'Internet Services & Infrastructure', 'Companies providing services and infrastructure for the internet industry including data centers and cloud networking and storage infrastructure. Also includes companies providing web hosting services. Excludes companies classified in the Software Industry.', 451020, '1999-01-01', NULL),
	(45103010, 'Application Software', 'Companies engaged in developing and producing software designed for specialized applications for the business or consumer market. Includes enterprise and technical software, as well as cloud-based software. Excludes companies classified in the Interactive Home Entertainment Sub-Industry. Also excludes companies producing systems or database management software classified in the Systems Software Sub-Industry.', 451030, '1999-01-01', NULL),
	(45103020, 'Systems Software', 'Companies engaged in developing and producing systems and database management software.', 451030, '1999-01-01', NULL),
	(45103030, 'Home Entertainment Software  (discontinued effective close of September 28, 2018)', 'Manufacturers of home entertainment software and educational software used primarily in the home.', 451030, '1999-01-01', '2018-09-28'),
	(45201010, 'Networking Equipment (discontinued effective close of April 30, 2003)', 'Manufacturers of computer networking equipment and products, including LANs, WANs and routers.', 452010, '1999-01-01', '2003-04-30'),
	(45201020, 'Communications Equipment', 'Manufacturers of communication equipment and products, including LANs, WANs, routers, telephones, switchboards and exchanges. Excludes cellular phone manufacturers classified in the Technology Hardware, Storage & Peripherals Sub-Industry.', 452010, '1999-01-01', NULL),
	(45202010, 'Computer Hardware (discontinued effective close of February 28, 2014)', 'Manufacturers of personal computers, servers, mainframes and workstations. Includes manufacturers of Automatic Teller Machines (ATMs). Excludes manufacturers of copiers, faxes and related products classified in the Office Electronics Sub-Industry.', 452020, '1999-01-01', '2014-02-28'),
	(45202020, 'Computer Storage & Peripherals (discontinued effective close of February 28, 2014)', 'Manufacturers of electronic computer components and peripherals. Includes data storage components, motherboards, audio and video cards, monitors, keyboards, printers and other peripherals. Excludes semiconductors classified in the Semiconductors Sub-Industry.', 452020, '1999-01-01', '2014-02-28'),
	(45202030, 'Technology Hardware, Storage & Peripherals', 'Manufacturers of cellular phones, personal computers, servers, electronic computer components and peripherals. Includes data storage components, motherboards, audio and video cards, monitors, keyboards, printers, and other peripherals. Excludes semiconductors classified in the Semiconductors Sub-Industry.', 452020, '1999-01-01', NULL),
	(45203010, 'Electronic Equipment & Instruments ', 'Manufacturers of electronic equipment and instruments including analytical, electronic test and measurement instruments, scanner/barcode products, lasers, display screens, point-of-sales machines, and security system equipment.', 452030, '1999-01-01', NULL),
	(45203015, 'Electronic Components', 'Manufacturers of electronic components. Includes electronic components, connection devices, electron tubes, electronic capacitors and resistors, electronic coil, printed circuit board, transformer and other inductors, signal processing technology/components.', 452030, '1999-01-01', NULL),
	(45203020, 'Electronic Manufacturing Services', 'Producers of electronic equipment mainly for the OEM (Original Equipment Manufacturers) markets.', 452030, '1999-01-01', NULL),
	(45203030, 'Technology Distributors', 'Distributors of technology hardware and equipment. Includes distributors of communications equipment, computers & peripherals, semiconductors, and electronic equipment and components.', 452030, '1999-01-01', NULL),
	(45204010, 'Office Electronics (discontinued effective close of February 28, 2014)', 'Manufacturers of office electronic equipment including copiers and faxes.', 452040, '1999-01-01', '2014-02-28'),
	(45205010, 'Semiconductor Equipment (discontinued effective close of April 30, 2003)', 'Manufacturers of semiconductor equipment.', 452050, '1999-01-01', '2003-04-30'),
	(45205020, 'Semiconductors (discontinued effective close of April 30, 2003)', 'Manufacturers of semiconductors and related products.', 452050, '1999-01-01', '2003-04-30'),
	(45301010, 'Semiconductor Equipment ', 'Manufacturers of semiconductor equipment, including manufacturers of the raw material and equipment used in the solar power industry.', 453010, '1999-01-01', NULL),
	(45301020, 'Semiconductors', 'Manufacturers of semiconductors and related products, including manufacturers of solar modules and cells.', 453010, '1999-01-01', NULL),
	(50101010, 'Alternative Carriers', 'Providers of communications and high-density data transmission services primarily through a high bandwidth/fiber-optic cable network.', 501010, '1999-01-01', NULL),
	(50101020, 'Integrated Telecommunication Services', 'Operators of primarily fixed-line telecommunications networks and companies providing both wireless and fixed-line telecommunications services not classified elsewhere. Also includes internet service providers offering internet access to end users.', 501010, '1999-01-01', NULL),
	(50102010, 'Wireless Telecommunication Services', 'Providers of primarily cellular or wireless telecommunication services.', 501020, '1999-01-01', NULL),
	(50201010, 'Advertising', 'Companies providing advertising, marketing or public relations services.', 502010, '1999-01-01', NULL),
	(50201020, 'Broadcasting', 'Owners and operators of television or radio broadcasting systems, including programming. Includes radio and television broadcasting, radio networks, and radio stations.', 502010, '1999-01-01', NULL),
	(50201030, 'Cable & Satellite', 'Providers of cable or satellite television services. Includes cable networks and program distribution.', 502010, '1999-01-01', NULL),
	(50201040, 'Publishing', 'Publishers of newspapers, magazines and books in print or electronic formats.', 502010, '1999-01-01', NULL),
	(50202010, 'Movies & Entertainment', 'Companies that engage in producing and selling entertainment products and services, including companies engaged in the production, distribution and screening of movies and television shows, producers and distributors of music, entertainment theaters and sports teams. Also includes companies offering and/or producing entertainment content streamed online.', 502020, '1999-01-01', NULL),
	(50202020, 'Interactive Home Entertainment', 'Producers of interactive gaming products, including mobile gaming applications. Also includes educational software used primarily in the home. Excludes online gambling companies classified in the Casinos & Gaming Sub-Industry.', 502020, '1999-01-01', NULL),
	(50203010, 'Interactive Media & Services', 'Companies engaging in content and information creation or distribution through proprietary platforms, where revenues are derived primarily through pay-per-click advertisements. Includes search engines, social media and networking platforms, online classifieds, and online review companies. Excludes companies operating online marketplaces classified in Internet & Direct Marketing Retail. ', 502030, '1999-01-01', NULL),
	(55101010, 'Electric Utilities', 'Companies that produce or distribute electricity. Includes both nuclear and non-nuclear facilities.', 551010, '1999-01-01', NULL),
	(55102010, 'Gas Utilities', 'Companies whose main charter is to distribute and transmit natural and manufactured gas. Excludes companies primarily involved in gas exploration or production classified in the Oil & Gas Exploration & Production Sub-Industry. Also excludes companies engaged in the storage and/or transportation of oil, gas, and/or refined products classified in the Oil & Gas Storage & Transportation Sub-Industry.', 551020, '1999-01-01', NULL),
	(55103010, 'Multi-Utilities', 'Utility companies with significantly diversified activities in addition to core Electric Utility, Gas Utility and/or Water Utility operations.', 551030, '1999-01-01', NULL),
	(55104010, 'Water Utilities', 'Companies that purchase and redistribute water to the end-consumer. Includes large-scale water treatment systems.', 551040, '1999-01-01', NULL),
	(55105010, 'Independent Power Producers & Energy Traders', 'Companies that operate as Independent Power Producers (IPPs), Gas & Power Marketing & Trading Specialists and/or Integrated Energy Merchants. Excludes producers of electricity using renewable sources, such as solar power, hydropower, and wind power. Also excludes electric transmission companies and utility distribution companies classified in the Electric Utilities Sub-Industry.', 551050, '1999-01-01', NULL),
	(55105020, 'Renewable Electricity ', 'Companies that engage in the generation and distribution of electricity using renewable sources, including, but not limited to, companies that produce electricity using biomass, geothermal energy, solar energy, hydropower, and wind power. Excludes companies manufacturing capital equipment used to generate electricity using renewable sources, such as manufacturers of solar power systems, installers of photovoltaic cells,  and companies involved in the provision of technology, components, and services mainly to this market. ', 551050, '1999-01-01', NULL),
	(60101010, 'Diversified REITs', 'A company or Trust with significantly diversified operations across two or more property types.', 601010, '1999-01-01', NULL),
	(60101020, 'Industrial REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of industrial properties. Includes companies operating industrial warehouses and distribution properties.', 601010, '1999-01-01', NULL),
	(60101030, 'Hotel & Resort REITs ', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of hotel and resort properties. ', 601010, '1999-01-01', NULL),
	(60101040, 'Office REITs ', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of office properties.', 601010, '1999-01-01', NULL),
	(60101050, 'Health Care REITs ', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of properties serving the health care industry, including hospitals, nursing homes, and assisted living properties.', 601010, '1999-01-01', NULL),
	(60101060, 'Residential REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of residential properties including multifamily homes, apartments, manufactured homes and student housing properties', 601010, '1999-01-01', NULL),
	(60101070, 'Retail REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of shopping malls, outlet malls, neighborhood and community shopping centers.', 601010, '1999-01-01', NULL),
	(60101080, 'Specialized REITs ', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of properties not classified elsewhere. Includes trusts that operate and invest in storage properties. It also includes REITs that do not generate a majority of their revenues and income from real estate rental and leasing operations.', 601010, '1999-01-01', NULL),
	(60102010, 'Diversified Real Estate Activities ', 'Companies engaged in a diverse spectrum of real estate activities including real estate development & sales, real estate management, or real estate services, but with no dominant business line.', 601020, '1999-01-01', NULL),
	(60102020, 'Real Estate Operating Companies', 'Companies engaged in operating real estate properties for the purpose of leasing & management.', 601020, '1999-01-01', NULL),
	(60102030, 'Real Estate Development ', 'Companies that develop real estate and sell the properties after development. Excludes companies classified in the Homebuilding Sub-Industry.', 601020, '1999-01-01', NULL),
	(60102040, 'Real Estate Services ', 'Real estate service providers such as real estate agents, brokers & real estate appraisers.', 601020, '1999-01-01', NULL);

CREATE TABLE IF NOT EXISTS equity.gics (
    code integer PRIMARY KEY,
    parent_code integer,
    name varchar(255) NOT NULL,
    definition varchar(1000) DEFAULT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT FK_gics_gics 
        FOREIGN KEY(parent_code)
        REFERENCES equity.gics);

INSERT INTO equity.gics (code, name, definition, start_date, end_date) 
    SELECT code, name, definition, start_date, end_date
    FROM equity.gics_sector;

INSERT INTO equity.gics (code, parent_code, name, start_date, end_date) 
    SELECT code, sector_code, name, start_date, end_date
    FROM equity.gics_industry_group;

INSERT INTO equity.gics (code, parent_code, name, start_date, end_date) 
    SELECT code, industry_group_code, name, start_date, end_date
    FROM equity.gics_industry;

INSERT INTO equity.gics (code, parent_code, name, definition, start_date, end_date) 
    SELECT code, industry_code, name, description, start_date, end_date
    FROM equity.gics_sub_industry;

CREATE TABLE equity.exchange_type (
    type varchar(32) PRIMARY KEY,
    description varchar(255),
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

COMMENT ON TABLE equity.exchange_type IS 'Represents the type of exchange';

INSERT INTO equity.exchange_type (type, description) 
    SELECT type, description
    FROM polygon.exchange_type;

CREATE TABLE equity.asset_class (
    type varchar(32) PRIMARY KEY,
    description varchar(255),
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

COMMENT ON TABLE equity.asset_class IS 'An identifier for a group of similar financial instruments.';

INSERT INTO equity.asset_class (type, description) 
    SELECT type, description
	FROM polygon.asset_class;

CREATE TABLE equity.ticker_type (
    code varchar(32) PRIMARY KEY,
    description varchar(255),
    asset_class_type varchar(32),
    locale varchar(32),
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

COMMENT ON TABLE equity.ticker_type IS 'The type of the tickers.';

COMMENT ON COLUMN equity.ticker_type.code IS 'A code used by polygon.io to refer to this ticker type.';
COMMENT ON COLUMN equity.ticker_type.description IS 'A short description of this ticker type.';
COMMENT ON COLUMN equity.ticker_type.asset_class_type IS 'An identifier for a group of similar financial instruments. (stocks, options, crypto, fx, indices)';
COMMENT ON COLUMN equity.ticker_type.locale IS 'An identifier for a geographical location. (us, global)';

CREATE TABLE equity.market (
    type varchar(32) PRIMARY KEY,
    description varchar(255),
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

COMMENT ON TABLE equity.market IS 'The type of market.';

COMMENT ON COLUMN equity.market.type IS 'A code used by to refer to this market type.';
COMMENT ON COLUMN equity.market.description IS 'A short description of this market type.';

INSERT INTO equity.market (type, description) 
    SELECT type, description
	FROM polygon.market;

CREATE TABLE equity.dividend_type (
    type char(2) PRIMARY KEY,
    description varchar(255),
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

COMMENT ON TABLE equity.dividend_type IS 'The type of market.';

COMMENT ON COLUMN equity.dividend_type.type IS 'A code used by to refer to this dividend type.';
COMMENT ON COLUMN equity.dividend_type.description IS 'A short description of this dividend type.';

INSERT INTO equity.dividend_type (type, description) 
    SELECT type, description
	FROM polygon.dividend_type;

CREATE TABLE equity.split (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    execution_date timestamp NULL,
    split_from integer NULL,
    split_to integer NULL,
	ticker_id integer NULL,
    ticker varchar(32) NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT unique_split
		UNIQUE (ticker, execution_date));

COMMENT ON TABLE equity.split IS 'Split contains data for a historical stock split, including the ticker symbol, the execution date, and the factors of the split ratio.';

COMMENT ON COLUMN equity.split.execution_date IS 'The execution date of the stock split. On this date the stock split was applied.';
COMMENT ON COLUMN equity.split.split_from IS 'The second number in the split ratio. For example: In a 2-for-1 split, split_from would be 1.';
COMMENT ON COLUMN equity.split.split_to IS 'The first number in the split ratio. For example: In a 2-for-1 split, split_to would be 2.';
COMMENT ON COLUMN equity.split.ticker IS 'The ticker symbol of the stock split.';

CREATE TABLE equity.dividend (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    cash_amount numeric(19,4) NULL,
    currency varchar(50) NULL,
    declaration_date timestamp NULL,
    dividend_type varchar(32) NULL,
    ex_dividend_date timestamp NULL,
    frequency integer NULL,
    pay_date timestamp NULL,
    record_date timestamp NULL,
	ticker_id integer NULL,
    ticker varchar(32) NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT unique_dividend 
		UNIQUE (cash_amount, ticker_id, ex_dividend_date, dividend_type));

COMMENT ON COLUMN equity.dividend.cash_amount IS 'The cash amount of the dividend per share owned.';
COMMENT ON COLUMN equity.dividend.currency IS 'The currency in which the dividend is paid.';
COMMENT ON COLUMN equity.dividend.declaration_date IS 'The date that the dividend was announced.';
COMMENT ON COLUMN equity.dividend.dividend_type IS 'The type of dividend. Dividends that have been paid and/or are expected to be paid on consistent schedules are denoted as CD. Special Cash dividends that have been paid that are infrequent or unusual, and/or can not be expected to occur in the future are denoted as SC. Long-Term and Short-Term capital gain distributions are denoted as LT and ST, respectively.';
COMMENT ON COLUMN equity.dividend.ex_dividend_date IS 'The date that the stock first trades without the dividend, determined by the exchange.';
COMMENT ON COLUMN equity.dividend.frequency IS 'The number of times per year the dividend is paid out. Possible values are 0 (one-time), 1 (annually), 2 (bi-annually), 4 (quarterly), and 12 (monthly).';
COMMENT ON COLUMN equity.dividend.pay_date IS 'The date that the dividend is paid out.';
COMMENT ON COLUMN equity.dividend.record_date IS 'The date that the stock must be held to receive the dividend, set by the company.';
COMMENT ON COLUMN equity.dividend.ticker IS 'The ticker symbol of the dividend.';


CREATE TABLE equity.exchange (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    acronym varchar(32) NULL,
    asset_class varchar(32) NULL,
    polygon_exchange_id integer NOT NULL,
    locale varchar(32) NULL,
    mic varchar(32) NULL,
    name varchar(255) UNIQUE NULL,
    operating_mic varchar(32) NULL,
    participant_id varchar(32) NULL,
    type varchar(32) NULL,
    url varchar(255) NULL,
    city varchar(255) NULL,
    country varchar(255) NULL,
    currency varchar(64) NULL,
    timezone_offset time NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

COMMENT ON COLUMN equity.exchange.acronym IS 'A commonly used abbreviation for this exchange.';
COMMENT ON COLUMN equity.exchange.asset_class IS 'An identifier for a group of similar financial instruments. (stocks, options, crypto, fx)';
COMMENT ON COLUMN equity.exchange.polygon_exchange_id IS 'A unique identifier used by polygon.io for this exchange.';
COMMENT ON COLUMN equity.exchange.locale IS 'An identifier for a geographical location. (us, global)';
COMMENT ON COLUMN equity.exchange.mic IS 'The Market Identifer Code of this exchange (see ISO 10383).';
COMMENT ON COLUMN equity.exchange.name IS 'Name of this exchange.';
COMMENT ON COLUMN equity.exchange.operating_mic IS 'The MIC of the entity that operates this exchange.';
COMMENT ON COLUMN equity.exchange.participant_id IS 'The ID used by SIP"s to represent this exchange.';
COMMENT ON COLUMN equity.exchange.type IS 'Represents the type of exchange. (exchange, TRF, SIP)';
COMMENT ON COLUMN equity.exchange.url IS 'A link to this exchange"s website, if one exists.';

CREATE TABLE equity.ticker (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    sector varchar(255) NULL,
    currency varchar(32) NULL,
	active boolean NULL,
    cik varchar(32) NULL,
    composite_figi varchar(32) NULL,
    currency_name varchar(50) NULL,
    delisted_utc timestamp NULL,
    last_updated_utc timestamp NULL,
    locale varchar(32) NULL,
    market varchar(32) NULL,
    name varchar (255) NULL,
    primary_exchange varchar(32) NULL,
    share_class_figi varchar(32) NULL,
	ticker varchar(32) UNIQUE NOT NULL,
    type varchar(32) NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

COMMENT ON COLUMN equity.ticker.active IS 'Whether or not the asset is actively traded. False means the asset has been delisted.';
COMMENT ON COLUMN equity.ticker.cik IS 'The CIK number for this ticker.';
COMMENT ON COLUMN equity.ticker.composite_figi IS 'The composite OpenFIGI number for this ticker. Find more information here';
COMMENT ON COLUMN equity.ticker.currency_name IS 'The name of the currency that this asset is traded with.';
COMMENT ON COLUMN equity.ticker.delisted_utc IS 'The last date that the asset was traded.';
COMMENT ON COLUMN equity.ticker.last_updated_utc IS 'The information is accurate up to this time.';
COMMENT ON COLUMN equity.ticker.locale IS 'The information is accurate up to this time. (us, global)';
COMMENT ON COLUMN equity.ticker.market IS 'The market type of the asset.';
COMMENT ON COLUMN equity.ticker.name IS 'The name of the asset. For stocks/equities this will be the companies registered name. For crypto/fx this will be the name of the currency or coin pair.';
COMMENT ON COLUMN equity.ticker.primary_exchange IS 'The ISO code of the primary listing exchange for this asset.';
COMMENT ON COLUMN equity.ticker.share_class_figi IS 'The share Class OpenFIGI number for this ticker. Find more information here';
COMMENT ON COLUMN equity.ticker.ticker IS 'The exchange symbol that this item is traded under.';
COMMENT ON COLUMN equity.ticker.type IS 'The type of the asset.';

CREATE TABLE equity.data_vendor (
    id integer PRIMARY KEY,
    name varchar(64) NOT NULL,
    website_url varchar(255) NULL,
    support_email varchar(255) NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

INSERT INTO equity.data_vendor (id, name, website_url, support_email) VALUES
	(1, 'Yahoo', 'https://au.finance.yahoo.com/', Null),
	(2, 'polygon.io', 'https://polygon.io/', 'support@polygon.io'),
	(3, 'Interactive Brokers', 'https://www.interactivebrokers.com.au/en/home.php', Null);

CREATE TABLE equity.daily_price (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    data_vendor_id integer NOT NULL,
    ticker_id integer NULL,
    ticker varchar(32) NOT NULL,
    polygon_timestamp timestamp NOT NULL,
    open_price numeric(19,4) NULL,
    high_price numeric(19,4) NULL,
    low_price numeric(19,4) NULL,
    close_price numeric(19,4) NULL,
    adj_close_price numeric(19,4) NULL,
    volume bigint NULL,
    volume_weighted_average_price numeric(19,4) NULL,
	transactions integer NULL,
    otc boolean NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
    price_date date NOT NULL,
	CONSTRAINT fk_data_vendor
        FOREIGN KEY(data_vendor_id)
        REFERENCES equity.data_vendor(id)
        ON DELETE NO ACTION,
    CONSTRAINT fk_ticker
        FOREIGN KEY(ticker_id)
        REFERENCES equity.ticker(id)
        ON DELETE CASCADE,
	CONSTRAINT unique_daily_price 
		UNIQUE (data_vendor_id, ticker, price_date));

COMMENT ON COLUMN equity.daily_price.ticker IS 'The exchange symbol that this item is traded under.';
COMMENT ON COLUMN equity.daily_price.close_price IS 'The close price for the symbol in the given time period.';
COMMENT ON COLUMN equity.daily_price.high_price IS 'The highest price for the symbol in the given time period.';
COMMENT ON COLUMN equity.daily_price.low_price IS 'The lowest price for the symbol in the given time period.';
COMMENT ON COLUMN equity.daily_price.transactions IS 'The number of transactions in the aggregate window.';
COMMENT ON COLUMN equity.daily_price.open_price IS 'The open price for the symbol in the given time period.';
COMMENT ON COLUMN equity.daily_price.otc IS 'Whether or not this aggregate is for an OTC ticker. This field will be left off if false.';
COMMENT ON COLUMN equity.daily_price.polygon_timestamp IS 'The Unix Msec timestamp for the start of the aggregate window converted to a timestamp.';
COMMENT ON COLUMN equity.daily_price.volume IS 'The trading volume of the symbol in the given time period.';
COMMENT ON COLUMN equity.daily_price.volume_weighted_average_price IS 'The volume weighted average price.';
COMMENT ON COLUMN equity.daily_price_temp.price_date IS 'The date the prices and volume are for.';
