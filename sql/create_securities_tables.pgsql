-- The securities schema contains data that has been cleaned and transforned.

DROP TABLE IF EXISTS securities.ohlcv;
DROP TABLE IF EXISTS securities.watchlist_ticker;
DROP TABLE IF EXISTS securities.transaction;
DROP TABLE IF EXISTS securities.leg;
DROP TABLE IF EXISTS securities.order;
DROP TABLE IF EXISTS securities.trade;
DROP TABLE IF EXISTS securities.ticker;
DROP TABLE IF EXISTS securities.dividend;
DROP TABLE IF EXISTS securities.split;
DROP TABLE IF EXISTS securities.dividend_type;
DROP TABLE IF EXISTS securities.ticker_type;
DROP TABLE IF EXISTS securities.exchange;
DROP TABLE IF EXISTS securities.country_currency;
DROP TABLE IF EXISTS securities.country;
DROP TABLE IF EXISTS securities.currency;
DROP TABLE IF EXISTS securities.gics;
DROP TABLE IF EXISTS securities.gics_sub_industry;
DROP TABLE IF EXISTS securities.gics_industry;
DROP TABLE IF EXISTS securities.gics_industry_group;
DROP TABLE IF EXISTS securities.gics_sector;
DROP TABLE IF EXISTS securities.data_vendor;
DROP TABLE IF EXISTS securities.watchlist;
DROP TABLE IF EXISTS securities.leg_status;
DROP TABLE IF EXISTS securities.trade_status;
DROP TABLE IF EXISTS securities.order_status;
DROP TABLE IF EXISTS securities.trade_type;
DROP TABLE IF EXISTS securities.strategy;
DROP TABLE IF EXISTS securities.action;
DROP TABLE IF EXISTS securities.newsletter;
DROP TABLE IF EXISTS securities.analyst;
DROP TABLE IF EXISTS securities.account;
DROP TABLE IF EXISTS securities.portfolio;
DROP TABLE IF EXISTS securities.broker;
DROP TABLE IF EXISTS securities.watchlist_type;

DROP SCHEMA IF EXISTS securities;

CREATE SCHEMA IF NOT EXISTS securities AUTHORIZATION securities;

CREATE TABLE IF NOT EXISTS securities.gics_sector (
    code char(2) PRIMARY KEY,
    name varchar(255) NOT NULL,
	aus_index_ticker varchar(32) DEFAULT NULL,
	us_index_ticker varchar(32) DEFAULT NULL,
    definition varchar(1000) DEFAULT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

INSERT INTO securities.gics_sector (code, name, aus_index_ticker, definition, start_date, end_date) VALUES
	('10', 'Energy', 'XEJ', 'The Energy Sector comprises companies engaged in exploration & production, refining & marketing, and storage & transportation of oil & gas and coal & consumable fuels. It also includes companies that offer oil & gas equipment and services.', '1999-01-01', NULL),
	('15', 'Materials', 'XMJ', 'The Materials Sector includes companies that manufacture chemicals, construction materials, glass, paper, forest products and related packaging products, and metals, minerals and mining companies, including producers of steel.', '1999-01-01', NULL),
	('20', 'Industrials', 'XNJ', 'The Industrials Sector includes manufacturers and distributors of capital goods such as aerospace & defense, building products, electrical equipment and machinery and companies that offer construction & engineering services. It also includes providers of commercial & professional services including printing, environmental and facilities services, office services & supplies, security & alarm services, human resource & employment services, research & consulting services. It also includes companies that provide transportation services.', '1999-01-01', NULL),
	('25', 'Consumer Discretionary', 'XDJ', 'The Consumer Discretionary Sector encompasses those businesses that tend to be the most sensitive to economic cycles. Its manufacturing segment includes automotive, household durable goods, leisure equipment and textiles & apparel. The services segment includes hotels, restaurants and other leisure facilities, media production and services, and consumer retailing and services. ', '1999-01-01', NULL),
	('30', 'Consumer Staples', 'XSJ', 'The Consumer Staples Sector comprises companies whose businesses are less sensitive to economic cycles. It includes manufacturers and distributors of food, beverages and tobacco and producers of non-durable household goods and personal products. It also includes food & drug retailing companies as well as hypermarkets and consumer super centers.', '1999-01-01', NULL),
	('35', 'Health Care', 'XHJ', 'The Health Care Sector includes health care providers & services, companies that manufacture and distribute health care equipment & supplies, and health care technology companies. It also includes companies involved in the research, development, production and marketing of pharmaceuticals and biotechnology products.', '1999-01-01', NULL),
	('40', 'Financials', 'XFJ', 'The Financials Sector contains companies involved in banking, thrifts & mortgage finance, specialized finance, consumer finance, asset management and custody banks, investment banking and brokerage and insurance. It also includes Financial Exchanges & Data and Mortgage REITs.', '1999-01-01', NULL),
	('45', 'Information Technology', 'XIJ', 'The Information Technology Sector comprises companies that offer software and information technology services, manufacturers and distributors of technology hardware & equipment such as communications equipment, cellular phones, computers & peripherals, electronic equipment and related instruments, and semiconductors.', '1999-01-01', NULL),
	('50', 'Communication Services', 'XTJ', 'The Communication Services Sector includes companies that facilitate communication and offer related content and information through various mediums. It includes telecom and media & entertainment companies including producers of interactive gaming products and companies engaged in content and information creation or distribution through proprietary platforms.', '1999-01-01', NULL),
	('55', 'Utilities', 'XUJ', 'The Utilities Sector comprises utility companies such as electric, gas and water utilities. It also includes independent power producers & energy traders and companies that engage in generation and distribution of electricity using renewable sources.', '1999-01-01', NULL),
	('60', 'Real Estate', 'XPJ', 'The Real Estate Sector contains companies engaged in real estate development and operation. It also includes companies offering real estate related services and Equity Real Estate Investment Trusts (REITs).', '1999-01-01', NULL);


CREATE TABLE IF NOT EXISTS securities.gics_industry_group (
    code char(4) PRIMARY KEY,
    name varchar(255) NOT NULL,
    sector_code char(2) NOT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT FK_gics_industry_group_gics_sector 
        FOREIGN KEY(sector_code)
        REFERENCES securities.gics_sector 
        ON DELETE CASCADE);

INSERT INTO securities.gics_industry_group (code, name, sector_code, start_date, end_date) VALUES
	('1010', 'Energy', '10', '1999-01-01', NULL),
	('1510', 'Materials', '15', '1999-01-01', NULL),
	('2010', 'Capital Goods', '20', '1999-01-01', NULL),
	('2020', 'Commercial & Professional Services', '20', '1999-01-01', NULL),
	('2030', 'Transportation', '20', '1999-01-01', NULL),
	('2510', 'Automobiles & Components', '25', '1999-01-01', NULL),
	('2520', 'Consumer Durables & Apparel', '25', '1999-01-01', NULL),
	('2530', 'Consumer Services', '25', '1999-01-01', NULL),
	('2540', 'Media (discontinued effective close of September 28, 2018)', '25', '1999-01-01', '2018-09-28'),
	('2550', 'Consumer Discretionary Distribution & Retail', '25', '2023-03-17', NULL),
	('3010', 'Consumer Staples Distribution & Retail', '30', '2023-03-17', NULL),
	('3020', 'Food, Beverage & Tobacco', '30', '1999-01-01', NULL),
	('3030', 'Household & Personal Products', '30', '1999-01-01', NULL),
	('3510', 'Health Care Equipment & Services', '35', '1999-01-01', NULL),
	('3520', 'Pharmaceuticals, BioTechnology & Life Sciences', '35', '1999-01-01', NULL),
	('4010', 'Banks', '40', '1999-01-01', NULL),
	('4020', 'Financial Services', '40', '2023-03-17', NULL),
	('4030', 'Insurance', '40', '1999-01-01', NULL),
	('4040', 'Real Estate - - discontinued effective close of Aug 31, 2016', '40', '1999-01-01', '2016-08-31'),
	('4510', 'Software & Services', '45', '1999-01-01', NULL),
	('4520', 'Technology Hardware & Equipment', '45', '1999-01-01', NULL),
	('4530', 'Semiconductors & Semiconductor Equipment', '45', '1999-01-01', NULL),
	('5010', 'Telecommunication Services', '50', '1999-01-01', NULL),
	('5020', 'Media & Entertainment', '50', '2018-09-29', NULL),
	('5510', 'Utilities', '55', '1999-01-01', NULL),
	('6010', 'Equity Real Estate Investment Trusts (REITs)', '60', '2023-03-17', NULL),
	('6020', 'Real Estate Management & Development', '60', '2023-03-17', NULL);

CREATE TABLE IF NOT EXISTS securities.gics_industry (
    code char(6) PRIMARY KEY,
    name varchar(255) NOT NULL,
    industry_group_code char(4) NOT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT FK_gics_industry_gics_industry_group
        FOREIGN KEY(industry_group_code)
        REFERENCES securities.gics_industry_group 
        ON DELETE CASCADE);

INSERT INTO securities.gics_industry (code, name, industry_group_code, start_date, end_date) VALUES
	('101010', 'Energy Equipment & Services', '1010', '1999-01-01', NULL),
	('101020', 'Oil, Gas & Consumable Fuels', '1010', '1999-01-01', NULL),
	('151010', 'Chemicals', '1510', '1999-01-01', NULL),
	('151020', 'Construction Materials', '1510', '1999-01-01', NULL),
	('151030', 'Containers & Packaging', '1510', '1999-01-01', NULL),
	('151040', 'Metals & Mining', '1510', '1999-01-01', NULL),
	('151050', 'Paper & Forest Products', '1510', '1999-01-01', NULL),
	('201010', 'Aerospace & Defense', '2010', '1999-01-01', NULL),
	('201020', 'Building Products', '2010', '1999-01-01', NULL),
	('201030', 'Construction & Engineering', '2010', '1999-01-01', NULL),
	('201040', 'Electrical Equipment', '2010', '1999-01-01', NULL),
	('201050', 'Industrial Conglomerates', '2010', '1999-01-01', NULL),
	('201060', 'Machinery', '2010', '1999-01-01', NULL),
	('201070', 'Trading Companies & Distributors', '2010', '1999-01-01', NULL),
	('202010', 'Commercial Services & Supplies', '2020', '1999-01-01', NULL),
	('202020', 'Professional Services', '2020', '1999-01-01', NULL),
	('203010', 'Air Freight & Logistics', '2030', '1999-01-01', NULL),
	('203020', 'Passenger Airlines', '2030', '2023-03-17', NULL),
	('203030', 'Marine Transportation', '2030', '2023-03-17', NULL),
	('203040', 'Ground Transportation', '2030', '2023-03-17', NULL),
	('203050', 'Transportation Infrastructure', '2030', '1999-01-01', NULL),
	('251010', 'Automobile Components', '2510', '2023-03-17', NULL),
	('251020', 'Automobiles', '2510', '1999-01-01', NULL),
	('252010', 'Household Durables', '2520', '1999-01-01', NULL),
	('252020', 'Leisure Products', '2520', '1999-01-01', NULL),
	('252030', 'Textiles, Apparel & Luxury Goods', '2520', '1999-01-01', NULL),
	('253010', 'Hotels, Restaurants & Leisure', '2530', '1999-01-01', NULL),
	('253020', 'Diversified Consumer Services', '2530', '1999-01-01', NULL),
	('254010', 'Media  (discontinued effective close of September 28, 2018)', '2540', '1999-01-01', '2018-09-28'),
	('255010', 'Distributors', '2550', '1999-01-01', NULL),
	('255020', 'Internet & Direct Marketing Retail', '2550', '1999-01-01', NULL),
	('255030', 'Broadline Retail', '2550', '2023-03-17', NULL),
	('255040', 'Specialty Retail', '2550', '1999-01-01', NULL),
	('301010', 'Consumer Staples Distribution & Retail', '3010', '2023-03-17', NULL),
	('302010', 'Beverages', '3020', '1999-01-01', NULL),
	('302020', 'Food Products', '3020', '1999-01-01', NULL),
	('302030', 'Tobacco', '3020', '1999-01-01', NULL),
	('303010', 'Household Products', '3030', '1999-01-01', NULL),
	('303020', 'Personal Care Products', '3030', '2023-03-17', NULL),
	('351010', 'Health Care Equipment & Supplies', '3510', '1999-01-01', NULL),
	('351020', 'Health Care Providers & Services', '3510', '1999-01-01', NULL),
	('351030', 'Health Care Technology', '3510', '1999-01-01', NULL),
	('352010', 'Biotechnology', '3520', '1999-01-01', NULL),
	('352020', 'Pharmaceuticals', '3520', '1999-01-01', NULL),
	('352030', 'Life Sciences Tools & Services', '3520', '1999-01-01', NULL),
	('401010', 'Banks', '4010', '1999-01-01', NULL),
	('401020', 'Thrifts & Mortgage Finance (Discontinued)', '4010', '1999-01-01', '2023-03-17'),
	('402010', 'Financial Services', '4020', '2023-03-17', NULL),
	('402020', 'Consumer Finance', '4020', '1999-01-01', NULL),
	('402030', 'Capital Markets', '4020', '1999-01-01', NULL),
	('402040', 'Mortgage Real Estate Investment Trusts (REITs)', '4020', '1999-01-01', NULL),
	('403010', 'Insurance', '4030', '1999-01-01', NULL),
	('404010', 'Real Estate -- Discontinued effective 04/28/2006', '4040', '1999-01-01', '2006-04-28'),
	('404020', 'Real Estate Investment Trusts (REITs) - discontinued effective close of Aug 31, 2016', '4040', '1999-01-01', '2016-08-31'),
	('404030', 'Real Estate Management & Development (discontinued effective close of August 31, 2016)', '4040', '1999-01-01', '2016-08-31'),
	('451010', 'Internet Software & Services (discontinued effective close of September 28, 2018)', '4510', '1999-01-01', '2018-09-28'),
	('451020', 'IT Services', '4510', '1999-01-01', NULL),
	('451030', 'Software', '4510', '1999-01-01', NULL),
	('452010', 'Communications Equipment', '4520', '1999-01-01', NULL),
	('452020', 'Technology Hardware, Storage & Peripherals', '4520', '1999-01-01', NULL),
	('452030', 'Electronic Equipment, Instruments & Components', '4520', '1999-01-01', NULL),
	('452040', 'Office Electronics - Discontinued effec-tive 02/28/2014', '4520', '1999-01-01', '2014-02-28'),
	('452050', 'Semiconductor Equipment & Products -- Discontinued effective 04/30/2003.', '4520', '1999-01-01', '2003-04-30'),
	('453010', 'Semiconductors & Semiconductor Equipment', '4530', '1999-01-01', NULL),
	('501010', 'Diversified Telecommunication Services', '5010', '1999-01-01', NULL),
	('501020', 'Wireless Telecommunication Services', '5010', '1999-01-01', NULL),
	('502010', 'Media', '5020', '1999-01-01', NULL),
	('502020', 'Entertainment', '5020', '1999-01-01', NULL),
	('502030', 'Interactive Media & Services', '5020', '1999-01-01', NULL),
	('551010', 'Electric Utilities', '5510', '1999-01-01', NULL),
	('551020', 'Gas Utilities', '5510', '1999-01-01', NULL),
	('551030', 'Multi-Utilities', '5510', '1999-01-01', NULL),
	('551040', 'Water Utilities', '5510', '1999-01-01', NULL),
	('551050', 'Independent Power and Renewable Electricity Producers', '5510', '1999-01-01', NULL),
	('601010', 'Diversified REITs', '6010', '2023-03-17', NULL),
	('601025', 'Industrial REITs', '6010', '2023-03-17', NULL),
	('601030', 'Hotel & Resort REITs', '6010', '2023-03-17', NULL),
	('601040', 'Office REITs', '6010', '2023-03-17', NULL),
	('601050', 'Health Care REITs', '6010', '2023-03-17', NULL),
	('601060', 'Residential REITs', '6010', '2023-03-17', NULL),
	('601070', 'Retail REITs', '6010', '2023-03-17', NULL),
	('601080', 'Specialized REITs', '6010', '2023-03-17', NULL),
	('602010', 'Real Estate Management & Development', '6020', '2023-03-17', NULL);

CREATE TABLE IF NOT EXISTS securities.gics_sub_industry (
    code char(8) PRIMARY KEY,
    name varchar(255) NOT NULL,
    description varchar(1000) DEFAULT NULL,
    industry_code char(6) NOT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT FK_gics_sub_industry_gics_industry 
        FOREIGN KEY(industry_code)
        REFERENCES securities.gics_industry 
        ON DELETE CASCADE);

INSERT INTO securities.gics_sub_industry (code, name, description, industry_code, start_date, end_date) VALUES
	('10101010', 'Oil & Gas Drilling', 'Drilling contractors or owners of drilling rigs that contract their services for drilling wells.', '101010', '1999-01-01', NULL),
	('10101020', 'Oil & Gas Equipment & Services', 'Manufacturers of equipment, including drilling rigs and equipment, and providers of supplies and services to companies involved in the drilling, evaluation and completion of oil and gas wells.', '101010', '1999-01-01', NULL),
	('10102010', 'Integrated Oil & Gas', 'Integrated oil companies engaged in the exploration & production of oil and gas, as well as at least one other significant activity in either refining, marketing and transportation, or chemicals.', '101020', '1999-01-01', NULL),
	('10102020', 'Oil & Gas Exploration & Production', 'Companies engaged in the exploration and production of oil and gas not classified elsewhere.', '101020', '1999-01-01', NULL),
	('10102030', 'Oil & Gas Refining & Marketing', 'Companies engaged in the refining and marketing of oil, gas and/or refined products not classified in the Integrated Oil & Gas or Independent Power Producers & Energy Traders Sub-Industries.', '101020', '1999-01-01', NULL),
	('10102040', 'Oil & Gas Storage & Transportation', 'Companies engaged in the storage and/or transportation of oil, gas and/or refined products. Includes diversified midstream natural gas companies, oil and refined product pipelines, coal slurry pipelines and oil & gas shipping companies.', '101020', '1999-01-01', NULL),
	('10102050', 'Coal & Consumable Fuels', 'Companies primarily involved in the production and mining of coal, related products and other consumable fuels related to the generation of energy.  Excludes companies primarily producing gases classified in the Industrial Gases sub-industry and companies primarily mining for metallurgical (coking) coal used for steel production.', '101020', '1999-01-01', NULL),
	('15101010', 'Commodity Chemicals', 'Companies that primarily produce industrial chemicals and basic chemicals. Including but not limited to plastics, synthetic fibers, films, commodity-based paints & pigments, explosives and petrochemicals. Excludes chemical companies classified in the Diversified Chemicals, Fertilizers & Agricultural Chemicals, Industrial Gases, or Specialty Chemicals Sub-Industries.', '151010', '1999-01-01', NULL),
	('15101020', 'Diversified Chemicals', 'Manufacturers of a diversified range of chemical products not classified in the Industrial Gases, Commodity Chemicals, Specialty Chemicals or Fertilizers & Agricultural Chemicals Sub-Industries.', '151010', '1999-01-01', NULL),
	('15101030', 'Fertilizers & Agricultural Chemicals', 'Producers of fertilizers, pesticides, potash or other agriculture-related chemicals not classified elsewhere.', '151010', '1999-01-01', NULL),
	('15101040', 'Industrial Gases', 'Manufacturers of industrial gases.', '151010', '1999-01-01', NULL),
	('15101050', 'Specialty Chemicals', 'Companies that primarily produce high value-added chemicals used in the manufacture of a wide variety of products, including but not limited to fine chemicals, additives, advanced polymers, adhesives, sealants and specialty paints, pigments and coatings.', '151010', '1999-01-01', NULL),
	('15102010', 'Construction Materials', 'Manufacturers of construction materials including sand, clay, gypsum, lime, aggregates, cement, concrete and bricks. Other finished or semi-finished building materials are classified  in the Building Products Sub-Industry.', '151020', '1999-01-01', NULL),
	('15103010', 'Metal, Glass & Plastic Containers', 'Manufacturers of metal, glass or plastic containers. Includes corks and caps.', '151030', '2023-03-17', NULL),
	('15103020', 'Paper & Plastic Packaging Products & Materials', 'Manufacturers of paper and cardboard containers and packaging.', '151030', '2023-03-17', NULL),
	('15104010', 'Aluminum', 'Producers of aluminum and related products, including companies that mine or process bauxite and companies that recycle aluminum to produce finished or semi-finished products. Excludes companies that primarily produce aluminum building materials classified in the Building Products Sub-Industry.', '151040', '1999-01-01', NULL),
	('15104020', 'Diversified Metals & Mining', 'Companies engaged in the diversified production or extraction of metals and minerals not classified elsewhere. Including, but not limited to, nonferrous metal mining (except bauxite), salt and borate mining, phosphate rock mining, and diversified mining operations. Excludes iron ore mining, classified in the Steel Sub-Industry, bauxite mining, classified in the Aluminum Sub-Industry, and coal mining, classified in either the Steel or Coal & Consumable Fuels Sub-Industries.', '151040', '1999-01-01', NULL),
	('15104025', 'Copper', 'Companies involved primarily in copper ore mining. ', '151040', '1999-01-01', NULL),
	('15104030', 'Gold', 'Producers of gold and related products, including companies that mine or process gold and the South African finance houses which primarily invest in, but do not operate, gold mines.', '151040', '1999-01-01', NULL),
	('15104040', 'Precious Metals & Minerals', 'Companies mining precious metals and minerals not classified in the Gold Sub-Industry. Includes companies primarily mining platinum.', '151040', '1999-01-01', NULL),
	('15104045', 'Silver', 'Companies primarily mining silver. Excludes companies classified in the Gold or Precious Metals & Minerals Sub-Industries.', '151040', '1999-01-01', NULL),
	('15104050', 'Steel', 'Producers of iron and steel and related products, including metallurgical (coking) coal mining used for steel production.', '151040', '1999-01-01', NULL),
	('15105010', 'Forest Products', 'Manufacturers of timber and related wood products. Includes lumber for the building industry.', '151050', '1999-01-01', NULL),
	('15105020', 'Paper Products', 'Manufacturers of all grades of paper. Excludes companies specializing in paper packaging classified in the Paper Packaging Sub-Industry.', '151050', '1999-01-01', NULL),
	('20101010', 'Aerospace & Defense', 'Manufacturers of civil or military aerospace and defense equipment, parts or products. Includes defense electronics and space equipment.', '201010', '1999-01-01', NULL),
	('20102010', 'Building Products', 'Manufacturers of building components and home improvement products and equipment. Excludes lumber and plywood classified under Forest Products and cement and other materials classified in the Construction Materials Sub-Industry.', '201020', '1999-01-01', NULL),
	('20103010', 'Construction & Engineering', 'Companies engaged in primarily non-residential construction. Includes civil engineering companies and large-scale contractors. Excludes companies classified in the Homebuilding Sub-Industry.', '201030', '1999-01-01', NULL),
	('20104010', 'Electrical Components & Equipment', 'Companies that produce electric cables and wires, electrical components or equipment not classified in the Heavy Electrical Equipment Sub-Industry.', '201040', '1999-01-01', NULL),
	('20104020', 'Heavy Electrical Equipment', 'Manufacturers of power-generating equipment and other heavy electrical equipment, including power turbines, heavy electrical machinery intended for fixed-use and large electrical systems. Excludes cables and wires, classified in the Electrical Components & Equipment Sub-Industry.', '201040', '1999-01-01', NULL),
	('20105010', 'Industrial Conglomerates', 'Diversified industrial companies with business activities in three or more sectors, none of which contributes a majority of revenues. Stakes held are predominantly of a controlling nature and stake holders maintain an operational interest in the running of the subsidiaries.', '201050', '1999-01-01', NULL),
	('20106010', 'Construction Machinery & Heavy Transportation Equipment', 'Manufacturers of heavy duty trucks, rolling machinery, earth-moving and construction equipment, and manufacturers of related parts. Includes non-military shipbuilding.', '201060', '2023-03-17', NULL),
	('20106015', 'Agricultural & Farm Machinery', 'Companies manufacturing agricultural machinery, farm machinery, and their related parts. Includes machinery used for the production of crops and agricultural livestock, agricultural tractors, planting and fertilizing machinery, fertilizer and chemical application equipment, and grain dryers and blowers.', '201060', '1999-01-01', NULL),
	('20106020', 'Industrial Machinery & Supplies & Components', 'Manufacturers of industrial machinery and industrial components. Includes companies that manufacture presses, machine tools, compressors, pollution control equipment, elevators, escalators, insulators, pumps, roller bearings and other metal fabrications.', '201060', '2023-03-17', NULL),
	('20107010', 'Trading Companies & Distributors', 'Trading companies and other distributors of industrial equipment and products.', '201070', '1999-01-01', NULL),
	('20201010', 'Commercial Printing', 'Companies providing commercial printing services. Includes printers primarily serving the media industry.', '202010', '1999-01-01', NULL),
	('20201020', 'Data Processing Services  (discontinued effective close of April 30, 2003)', 'Providers of commercial electronic data processing services.', '202010', '1999-01-01', '2003-04-30'),
	('20201030', 'Diversified Commercial & Professional Services (discontinued effective close of August 31, 2008)', 'Companies primarily providing commercial, industrial and professional services to businesses and governments not classified elsewhere.  Includes commercial cleaning services, consulting services, correctional facilities, dining & catering services, document & communication services, equipment repair services, security & alarm services, storage & warehousing, and uniform rental services.', '202010', '1999-01-01', '2008-08-31'),
	('20201040', 'Human Resource & Employment Services (discontinued effective close of August 31, 2008)', 'Companies providing business support services relating to human capital management. Includes employment agencies, employee training, payroll & benefit support services, retirement support services and temporary agencies.', '202010', '1999-01-01', '2008-08-31'),
	('20201050', 'Environmental & Facilities Services', 'Companies providing environmental and facilities maintenance services. Includes waste management, facilities management and pollution control services.  Excludes large-scale water treatment systems classified in the Water Utilities Sub-Industry.', '202010', '1999-01-01', NULL),
	('20201060', 'Office Services & Supplies', 'Providers of office services and manufacturers of office supplies and equipment not classified elsewhere.', '202010', '1999-01-01', NULL),
	('20201070', 'Diversified Support Services', 'Companies primarily providing labor oriented support services to businesses and governments.  Includes commercial cleaning services, dining & catering services, equipment repair services, industrial maintenance services, industrial auctioneers, storage & warehousing, transaction services, uniform rental services, and other business support services.', '202010', '1999-01-01', NULL),
	('20201080', 'Security & Alarm Services', 'Companies providing security and protection services to business and governments. Includes companies providing services such as correctional facilities, security & alarm services, armored transportation & guarding.  Excludes companies providing security software classified under the Systems Software Sub-Industry and home security services classified under the Specialized Consumer Services Sub-Industry. Also excludes companies manufacturing security system equipment classified under the Electronic Equipment & Instruments Sub-Industry. ', '202010', '1999-01-01', NULL),
	('20202010', 'Human Resource & Employment Services', 'Companies providing business support services relating to human capital management. This Sub-Industry includes employment agencies, employee training, payroll processing, benefit & retirement support services, corporate & job seeker recruitment services, and online job portals generating revenue from fees or commissions for offering recruitment services to companies or job seekers.', '202020', '2023-03-17', NULL),
	('20202020', 'Research & Consulting Services', 'Companies primarily providing research and consulting services to businesses and governments not classified elsewhere.  Includes companies involved in management consulting services, architectural design, business information or scientific research, marketing, and testing & certification services. Excludes companies providing information technology consulting services classified in the IT Consulting & Other Services Sub-Industry.', '202020', '1999-01-01', NULL),
	('20202030', 'Data Processing & Outsourced Services', 'Providers of commercial data processing and/or business process outsourcing services. This Sub-Industry includes companies providing services for customer experience management, back-office automation, call center management, and investor communications.', '202020', '2023-03-17', NULL),
	('20301010', 'Air Freight & Logistics', 'Companies providing air freight transportation, courier and logistics services, including package and mail delivery and customs agents. Excludes those companies classified in the Airlines, Marine or Trucking Sub-Industries.', '203010', '1999-01-01', NULL),
	('20302010', 'Passenger Airlines', 'Companies providing primarily passenger air transportation.', '203020', '2023-03-17', NULL),
	('20303010', 'Marine Transportation', 'Companies providing goods or passenger maritime transportation. Excludes cruise-ships classified in the Hotels, Resorts & Cruise Lines Sub-Industry.', '203030', '2023-03-17', NULL),
	('20304010', 'Rail Transportation', 'Companies providing primarily goods and passenger rail  transportation.', '203040', '2023-03-17', NULL),
	('20304020', 'Trucking(Discontinued)', 'Companies providing primarily goods and passenger land transportation. Includes vehicle rental and taxi companies.', '203040', '2023-03-17', NULL),
	('20304030', 'Cargo Ground Transportation', 'Companies providing ground transportation services for goods and freight.', '203040', '2023-03-17', NULL),
	('20304040', 'Passenger Ground Transportation', 'Companies providing passenger ground transportation and related services, including bus, taxi, vehicle rental, ride sharing and on-demand ride sharing platforms, and other passenger logistics.', '203040', '2023-03-17', NULL),
	('20305010', 'Airport Services', 'Operators of airports and companies providing related services.', '203050', '1999-01-01', NULL),
	('20305020', 'Highways & Railtracks', 'Owners and operators of roads, tunnels and railtracks.', '203050', '1999-01-01', NULL),
	('20305030', 'Marine Ports & Services', 'Owners and operators of marine ports and related services.', '203050', '1999-01-01', NULL),
	('25101010', 'Automotive Parts & Equipment', 'Manufacturers of parts and accessories for  automobiles and motorcycles. Excludes companies classified in the Tires & Rubber Sub-Industry.', '251010', '2023-03-17', NULL),
	('25101020', 'Tires & Rubber', 'Manufacturers of tires and rubber.', '251010', '1999-01-01', NULL),
	('25102010', 'Automobile Manufacturers', 'Companies that produce mainly passenger automobiles and light trucks. Excludes companies producing mainly motorcycles and three-wheelers classified in the Motorcycle Manufacturers Sub-Industry and heavy duty trucks classified in the Construction Machinery & Heavy Trucks Sub-Industry.', '251020', '1999-01-01', NULL),
	('25102020', 'Motorcycle Manufacturers', 'Companies that produce motorcycles, scooters or three-wheelers. Excludes bicycles classified in the Leisure Products Sub-Industry. ', '251020', '1999-01-01', NULL),
	('25201010', 'Consumer Electronics', 'Manufacturers of consumer electronics products including TVs, home audio equipment, game consoles, digital cameras, and related products. Excludes personal home computer manufacturers classified in the Technology Hardware, Storage & Peripherals Sub-Industry, and electric household appliances classified in the Household Appliances Sub-Industry.', '252010', '1999-01-01', NULL),
	('25201020', 'Home Furnishings', 'Manufacturers of soft home furnishings or furniture, including upholstery, carpets and wall-coverings.', '252010', '1999-01-01', NULL),
	('25201030', 'Homebuilding', 'Residential construction companies. Includes manufacturers of prefabricated houses and semi-fixed manufactured homes.', '252010', '1999-01-01', NULL),
	('25201040', 'Household Appliances', 'Manufacturers of electric household appliances and related products.  Includes manufacturers of power and hand tools, including garden improvement tools.  Excludes TVs and other audio and video products classified in the Consumer Electronics Sub-Industry and personal computers classified in the Technology Hardware, Storage & Peripherals Sub-Industry.', '252010', '1999-01-01', NULL),
	('25201050', 'Housewares & Specialties', 'Manufacturers of durable household products, including cutlery, cookware, glassware, crystal, silverware, utensils, kitchenware and consumer specialties not classified elsewhere.', '252010', '1999-01-01', NULL),
	('25202010', 'Leisure Products', 'Manufacturers of leisure products and equipment including sports equipment, bicycles and toys.', '252020', '1999-01-01', NULL),
	('25202020', 'Photographic Products (discontinued effective close of February 28, 2014)', 'Manufacturers of photographic equipment and related products.', '252020', '1999-01-01', '2014-02-28'),
	('25203010', 'Apparel, Accessories & Luxury Goods', 'Manufacturers of apparel, accessories & luxury goods. Includes companies primarily producing designer handbags, wallets, luggage, jewelry and watches. Excludes shoes classified in the Footwear Sub-Industry.', '252030', '1999-01-01', NULL),
	('25203020', 'Footwear', 'Manufacturers of footwear. Includes sport and leather shoes.', '252030', '1999-01-01', NULL),
	('25203030', 'Textiles', 'Manufacturers of textile and related products not classified in the Apparel, Accessories & Luxury Goods, Footwear or Home Furnishings Sub-Industries.', '252030', '1999-01-01', NULL),
	('25301010', 'Casinos & Gaming', 'Owners and operators of casinos and gaming facilities. Includes companies providing lottery and betting services.', '253010', '1999-01-01', NULL),
	('25301020', 'Hotels, Resorts & Cruise Lines', 'Owners and operators of hotels, resorts and cruise-ships. Includes travel agencies, tour operators and related services not classified elsewhere . Excludes casino-hotels classified in the Casinos & Gaming Sub-Industry.', '253010', '1999-01-01', NULL),
	('25301030', 'Leisure Facilities', 'Owners and operators of leisure facilities, including sport and fitness centers, stadiums, golf courses and amusement parks not classified in the Movies & Entertainment Sub-Industry.', '253010', '1999-01-01', NULL),
	('25301040', 'Restaurants', 'Owners and operators of restaurants, bars, pubs, fast-food or take-out facilities. Includes companies that provide food catering services.', '253010', '1999-01-01', NULL),
	('25302010', 'Education Services', 'Companies providing educational services, either on-line or through conventional teaching methods. Includes, private universities, correspondence teaching, providers of educational seminars, educational materials and technical education. Excludes companies providing employee education programs classified in the Human Resources & Employment Services Sub-Industry', '253020', '1999-01-01', NULL),
	('25302020', 'Specialized Consumer Services', 'Companies providing consumer services not classified elsewhere.  Includes residential services, home security, legal services, personal services, renovation & interior design services, consumer auctions and wedding & funeral services.', '253020', '1999-01-01', NULL),
	('25401010', 'Advertising (discontinued effective close of September 28, 2018)', 'Companies providing advertising, marketing or public relations services.', '254010', '1999-01-01', '2018-09-28'),
	('25401020', 'Broadcasting (discontinued effective close of September 28, 2018)', 'Owners and operators of television or radio broadcasting systems, including programming. Includes, radio and television broadcasting, radio networks, and radio stations.', '254010', '1999-01-01', '2018-09-28'),
	('25401025', 'Cable & Satellite (discontinued effective close of September 28, 2018)', 'Providers of cable or satellite television services. Includes cable networks and program distribution.', '254010', '1999-01-01', '2018-09-28'),
	('25401030', 'Movies & Entertainment (discontinued effective close of September 28, 2018)', 'Companies that engage in producing and selling entertainment products and services, including companies engaged in the production, distribution and screening of movies and television shows, producers and distributors of music, entertainment theaters and sports teams.', '254010', '1999-01-01', '2018-09-28'),
	('25401040', 'Publishing (discontinued effective close of September 28, 2018)', 'Publishers of newspapers, magazines and books, and providers of information in print or electronic formats.', '254010', '1999-01-01', '2018-09-28'),
	('25501010', 'Distributors', 'Distributors and wholesalers of general merchandise not classified elsewhere. Includes vehicle distributors.', '255010', '1999-01-01', NULL),
	('25502010', 'Catalog Retail (discontinued effective close of August 31, 2016)', 'Mail order and TV home shopping retailers. Includes companies that provide door-to-door retail.', '255020', '1999-01-01', '2016-08-31'),
	('25502020', 'Internet & Direct Marketing Retail(Discontinued)', 'Companies  providing  retail  services  primarily  on  the Internet, through mail order, and TV home shopping retailers. Also includes companies providing online marketplaces for consumer products and services.', '255020', '1999-01-01', '2023-03-17'),
	('25503010', 'Department Stores(Discontinued)', 'Owners and operators of department stores.', '255030', '1999-01-01', '2023-03-17'),
	('25503020', 'General Merchandise Stores(Discontinued)', 'Owners and operators of stores offering diversified general merchandise. Excludes hypermarkets and large-scale super centers classified in the Hypermarkets & Super Centers Sub-Industry.', '255030', '1999-01-01', '2023-03-17'),
	('25503030', 'Broadline Retail', 'Retailers offering a wide range of consumer discretionary merchandise. This Sub-Industry includes general and discount merchandise retailers, department stores and on-line retailers and marketplaces selling mostly consumer discretionary merchandise.', '255030', '1999-01-01', NULL),
	('25504010', 'Apparel Retail', 'Retailers specialized mainly in apparel and accessories.', '255040', '1999-01-01', NULL),
	('25504020', 'Computer & Electronics Retail', 'Owners and operators of consumer electronics, computers, video and related products retail stores.', '255040', '1999-01-01', NULL),
	('25504030', 'Home Improvement Retail', 'Owners and operators of home and garden improvement retail stores. Includes stores offering building materials and supplies.', '255040', '1999-01-01', NULL),
	('25504040', 'Other Specialty Retail', 'Owners and operators of specialty retail stores not classified elsewhere. Includes jewelry stores, toy stores, office supply stores, health & vision care stores, and book & entertainment stores.', '255040', '12023-03-17', NULL),
	('25504050', 'Automotive Retail', 'Owners and operators of stores specializing in automotive retail.  Includes auto dealers, gas stations, and retailers of auto accessories, motorcycles & parts, automotive glass, and automotive equipment & parts.', '255040', '1999-01-01', NULL),
	('25504060', 'Homefurnishing Retail', 'Owners and operators of furniture and home furnishings retail stores.  Includes residential furniture, homefurnishings, housewares, and interior design.  Excludes home and garden improvement stores, classified in the Home Improvement Retail Sub-Industry.', '255040', '1999-01-01', NULL),
	('30101010', 'Drug Retail', 'Owners and operators of primarily drug retail stores and pharmacies.', '301010', '1999-01-01', NULL),
	('30101020', 'Food Distributors', 'Distributors of food products to other companies and not directly to the consumer.', '301010', '1999-01-01', NULL),
	('30101030', 'Food Retail', 'Owners and operators of primarily food retail stores.', '301010', '1999-01-01', NULL),
	('30101040', 'Consumer Staples Merchandise Retail', 'Retailers offering a wide range of consumer staples merchandise such as food, household, and personal care products. This Sub-Industry includes hypermarkets, super centers and other consumer staples retailers such as discount retail spaces and on-line marketplaces selling mostly consumer staples goods.', '301010', '2023-03-17', NULL),
	('30201010', 'Brewers', 'Producers of beer and malt liquors. Includes breweries not classified in the Restaurants Sub-Industry.', '302010', '1999-01-01', NULL),
	('30201020', 'Distillers & Vintners', 'Distillers, vintners and producers of alcoholic beverages not classified in the Brewers Sub-Industry.', '302010', '1999-01-01', NULL),
	('30201030', 'Soft Drinks & Non-alcoholic Beverages', 'Producers of non-alcoholic beverages including mineral waters. Excludes producers of milk classified in the Packaged Foods Sub-Industry.', '302010', '2023-03-17', NULL),
	('30202010', 'Agricultural Products & Services', 'Producers of agricultural products. Includes crop growers, owners of plantations and companies that produce and process foods but do not package and market them. Excludes companies classified in the Forest Products Sub-Industry and those that package and market the food products classified in the Packaged Foods Sub-Industry.', '302020', '2023-03-17', NULL),
	('30202020', 'Meat, Poultry & Fish (discontinued effective close of March 28 2002)', 'Companies that raise livestock or poultry, fishing companies and other producers of meat, poultry or fish products.', '302020', '1999-01-01', '2002-03-28'),
	('30202030', 'Packaged Foods & Meats', 'Producers of packaged foods including dairy products, fruit juices, meats, poultry, fish and pet foods.', '302020', '1999-01-01', NULL),
	('30203010', 'Tobacco', 'Manufacturers of cigarettes and other tobacco products.', '302030', '1999-01-01', NULL),
	('30301010', 'Household Products', 'Producers of non-durable household products, including detergents, soaps, diapers and other tissue and household paper products not classified in the Paper Products Sub-Industry.', '303010', '1999-01-01', NULL),
	('30302010', 'Personal Care Products', 'Manufacturers of personal and beauty care products, including cosmetics and perfumes.', '303020', '2023-03-17', NULL),
	('35101010', 'Health Care Equipment', 'Manufacturers of health care equipment and devices. Includes medical instruments, drug delivery systems, cardiovascular & orthopedic devices, and diagnostic equipment.', '351010', '1999-01-01', NULL),
	('35101020', 'Health Care Supplies', 'Manufacturers of health care supplies and medical products not classified elsewhere. Includes eye care products, hospital supplies, and safety needle & syringe devices.', '351010', '1999-01-01', NULL),
	('35102010', 'Health Care Distributors', 'Distributors and wholesalers of health care products not classified elsewhere. ', '351020', '1999-01-01', NULL),
	('35102015', 'Health Care Services', 'Providers of patient health care services not classified elsewhere. Includes dialysis centers, lab testing services, and pharmacy management services. Also includes companies providing business support services to health care providers, such as clerical support services, collection agency services, staffing services and outsourced sales & marketing services', '351020', '1999-01-01', NULL),
	('35102020', 'Health Care Facilities', 'Owners and operators of health care facilities, including hospitals, nursing homes, rehabilitation centers and animal hospitals.', '351020', '1999-01-01', NULL),
	('35102030', 'Managed Health Care', 'Owners and operators of Health Maintenance Organizations (HMOs) and other managed plans.', '351020', '1999-01-01', NULL),
	('35103010', 'Health Care Technology', 'Companies providing information technology services primarily to health care providers.  Includes companies providing application, systems and/or data processing software, internet-based tools, and IT consulting services to doctors, hospitals or businesses operating primarily in the Health Care Sector', '351030', '1999-01-01', NULL),
	('35201010', 'Biotechnology', 'Companies primarily engaged in the research, development, manufacturing and/or marketing of products based on genetic analysis and genetic engineering.  Includes companies specializing in protein-based therapeutics to treat human diseases. Excludes companies manufacturing products using biotechnology but without a health care application.', '352010', '1999-01-01', NULL),
	('35202010', 'Pharmaceuticals', 'Companies engaged in the research, development or production of pharmaceuticals. Includes veterinary drugs.', '352020', '1999-01-01', NULL),
	('35203010', 'Life Sciences Tools & Services', 'Companies enabling the drug discovery, development and production continuum by providing analytical tools, instruments, consumables & supplies, clinical trial services and contract research services.  Includes firms primarily servicing the pharmaceutical and biotechnology industries.', '352030', '1999-01-01', NULL),
	('40101010', 'Diversified Banks', 'Large, geographically diverse banks with a national footprint whose revenues are derived primarily from conventional banking operations, have significant business activity in retail banking and small and medium corporate lending, and provide a diverse range of financial services.  Excludes banks classified in the Regional Banks and Thrifts & Mortgage Finance Sub-Industries. Also excludes investment banks classified in the Investment Banking & Brokerage Sub-Industry.', '401010', '1999-01-01', NULL),
	('40101015', 'Regional Banks', 'Commercial banks, savings banks and thrifts whose business are derived primarily from conventional banking operations such as retail banking, corporate lending and originating various residential and commercial mortgage loans funded mainly through deposits. Regional banks tend to operate in limited geographic regions. Excludes companies classified in the Diversified Banks and Commercial & Residential Mortgage Finance Sub-Industries. Also excludes investment banks classified in the Investment Banking & Brokerage Sub-Industry.', '401010', '2023-03-17', NULL),
	('40102010', 'Thrifts & Mortgage Finance(Discontinued)', 'Financial institutions providing mortgage and mortgage related services.  These include financial institutions whose assets are primarily mortgage related, savings & loans, mortgage lending institutions, building societies and companies providing insurance to mortgage banks.', '401020', '1999-01-01', '2023-03-17'),
	('40201010', 'Consumer Finance (discontinued effective close of April 30, 2003)', 'Providers of consumer finance services, including personal credit, credit cards, lease financing, mortgage lenders, travel-related money services and pawn shops.', '402010', '1999-01-01', '2003-04-30'),
	('40201020', 'Diversified Financial Services', 'Providers of a diverse range of financial services and/or with some interest in a wide range of financial services including banking, insurance and capital markets, but with no dominant business line. Excludes companies classified in the Regional Banks and Diversified Banks Sub-Industries.', '402010', '2023-03-17', NULL),
	('40201030', 'Multi-Sector Holdings', 'A company with significantly diversified holdings across three or more sectors, none of which contributes a majority of profit and/or sales. Stakes held are predominantly of a non-controlling nature.  Includes diversified financial companies where stakes held are of a controlling nature. Excludes other diversified companies classified in the Industrials Conglomerates Sub-Industry.', '402010', '1999-01-01', NULL),
	('40201040', 'Specialized Finance', 'Providers  of  specialized  financial  services  not  classified  elsewhere. Companies  in  this  sub-industry  derive  a  majority  of  revenue  from  one  specialized  line  of  business. Includes,  but  not  limited  to,  commercial  financing  companies,  central  banks,  leasing  institutions, factoring services, and specialty boutiques. Excludes companies classified in the Financial Exchanges & Data sub-industry.', '402010', '1999-01-01', NULL),
	('40201050', 'Commercial & Residential Mortgage Finance', 'Financial companies providing commercial and residential mortgage financing and related mortgage services. This Sub-Industry includes non-deposit funded mortgage lending institutions, building societies, companies providing real estate financing products, loan servicing, mortgage broker services, and mortgage insurance. ', '402010', '2023-03-17', NULL),
	('40201060', 'Transaction & Payment Processing Services', 'Providers of transaction & payment processing services and related payment services including digital/mobile payment processors, payment service providers & gateways, and digital wallet providers.', '402010', '2023-03-17', NULL),
	('40202010', 'Consumer Finance', 'Providers of consumer finance services, including personal credit, credit cards, lease financing, travel-related money services and pawn shops.  Excludes mortgage lenders classified in the Thrifts & Mortgage Finance Sub-Industry.', '402020', '1999-01-01', NULL),
	('40203010', 'Asset Management & Custody Banks', 'Financial institutions primarily engaged in investment management and/or related custody and securities fee-based services. Includes companies operating mutual funds, closed-end funds and unit investment trusts.  Excludes banks and other financial institutions primarily involved in commercial lending, investment banking, brokerage and other specialized financial activities. ', '402030', '1999-01-01', NULL),
	('40203020', 'Investment Banking & Brokerage', 'Financial institutions primarily engaged in investment banking & brokerage services, including securities and debt underwriting, mergers and acquisitions, securities lending and advisory services. Excludes banks and other financial institutions primarily involved in commercial lending, asset management and specialized financial activities. ', '402030', '1999-01-01', NULL),
	('40203030', 'Diversified Capital Markets', 'Financial institutions primarily engaged in diversified capital markets activities, including a significant presence in at least two of the following area: large/major corporate lending, investment banking, brokerage and asset management. Excludes less diversified companies classified in the Asset Management & Custody Banks or Investment Banking & Brokerage sub-industries.  Also excludes companies classified in the Banks or Insurance industry groups or the Consumer Finance Sub-Industry. ', '402030', '1999-01-01', NULL),
	('40203040', 'Financial Exchanges & Data', 'Financial  exchanges  for  securities,  commodities,  derivatives and other financial instruments, and providers of financial decision support tools and products  including ratings agencies', '402030', '1999-01-01', NULL),
	('40204010', 'Mortgage REITs', 'Companies or Trusts that service, originate, purchase and/or securitize residential and/or commercial mortgage loans.  Includes trusts that invest in mortgage-backed securities and other mortgage related assets.', '402040', '1999-01-01', NULL),
	('40301010', 'Insurance Brokers', 'Insurance and reinsurance brokerage firms.', '403010', '1999-01-01', NULL),
	('40301020', 'Life & Health Insurance', 'Companies providing primarily life, disability, indemnity or supplemental health insurance. Excludes managed care companies classified in the Managed Health Care Sub-Industry.', '403010', '1999-01-01', NULL),
	('40301030', 'Multi-line Insurance', 'Insurance companies with diversified interests in life, health and property and casualty insurance.', '403010', '1999-01-01', NULL),
	('40301040', 'Property & Casualty Insurance', 'Companies providing primarily property and casualty insurance.', '403010', '1999-01-01', NULL),
	('40301050', 'Reinsurance', 'Companies providing primarily reinsurance.', '403010', '1999-01-01', NULL),
	('40401010', 'Real Estate Investment Trusts (discontinued effective close of April 28, 2006)', 'Real estate investment trusts (REITs).  Includes Property Trusts.', '404010', '1999-01-01', '2006-04-28'),
	('40401020', 'Real Estate Management & Development (discontinued effective close of April 28, 2006)', 'Companies engaged in real estate ownership, development or  management.', '404010', '1999-01-01', '2006-04-28'),
	('40402010', 'Diversified REITs (discontinued effective close of August 31, 2016)', 'A company or Trust with significantly diversified operations across two or more property types.', '404020', '1999-01-01', '2016-08-31'),
	('40402020', 'Industrial REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of industrial properties. Includes companies operating industrial warehouses and distribution properties.', '404020', '1999-01-01', '2016-08-31'),
	('40402030', 'Mortgage REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts that service, originate, purchase and/or securitize residential and/or commercial mortgage loans.  Includes trusts that invest in mortgage-backed securities and other mortgage related assets.', '404020', '1999-01-01', '2016-08-31'),
	('40402035', 'Hotel & Resort REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of hotel and resort properties. ', '404020', '1999-01-01', '2016-08-31'),
	('40402040', 'Office REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of office properties.. ', '404020', '1999-01-01', '2016-08-31'),
	('40402045', 'Health Care REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of properties serving the health care industry, including hospitals, nursing homes, and assisted living properties.', '404020', '1999-01-01', '2016-08-31'),
	('40402050', 'Residential REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of residential properties including multifamily homes, apartments, manufactured homes and student housing properties', '404020', '1999-01-01', '2016-08-31'),
	('40402060', 'Retail REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of shopping malls, outlet malls, neighborhood and community shopping centers.', '404020', '1999-01-01', '2016-08-31'),
	('40402070', 'Specialized REITs (discontinued effective close of August 31, 2016)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of properties not classified elsewhere. Includes trusts that operate and invest in storage properties. It also includes REITs that do not generate a majority of their revenues and income from real estate rental and leasing operations.', '404020', '1999-01-01', '2016-08-31'),
	('40403010', 'Diversified Real Estate Activities (discontinued effective close of August 31, 2016)', 'Companies engaged in a diverse spectrum of real estate activities including real estate development & sales, real estate management, or real estate services, but with no dominant business line.', '404030', '1999-01-01', '2016-08-31'),
	('40403020', 'Real Estate Operating Companies (discontinued effective close of August 31, 2016)', 'Companies engaged in operating real estate properties for the purpose of leasing & management.', '404030', '1999-01-01', '2016-08-31'),
	('40403030', 'Real Estate Development (discontinued effective close of August 31, 2016)', 'Companies that develop real estate and sell the properties after development. Excludes companies classified in the Homebuilding Sub-Industry.', '404030', '1999-01-01', '2016-08-31'),
	('40403040', 'Real Estate Services (discontinued effective close of August 31, 2016)', 'Real estate service providers such as real estate agents, brokers & real estate appraisers.', '404030', '1999-01-01', '2016-08-31'),
	('45101010', 'Internet Software & Services (discontinued effective close of September 28, 2018)', 'Companies developing and marketing internet software and/or providing internet services including online databases and interactive services, as well as companies deriving a majority of their revenues from online advertising. Excludes companies classified in the Internet Retail Sub-Industry.', '451010', '1999-01-01', '2018-09-28'),
	('45102010', 'IT Consulting & Other Services', 'Providers of information technology and systems integration services not classified in the Data Processing & Outsourced Services Sub-Industry.  Includes information technology consulting and information management services.', '451020', '1999-01-01', NULL),
	('45102020', 'Data Processing & Outsourced Services(Discontinued)', 'Providers of commercial electronic data processing and/or business process outsourcing services.  Includes companies that provide services for back-office automation.', '451020', '1999-01-01', '2023-03-17'),
	('45102030', 'Internet Services & Infrastructure', 'Companies providing services and infrastructure for the internet industry including data centers and cloud networking and storage infrastructure. Also includes companies providing web hosting services. Excludes companies classified in the Software Industry.', '451020', '1999-01-01', NULL),
	('45103010', 'Application Software', 'Companies engaged in developing and producing software designed for specialized applications for the business or consumer market. Includes enterprise and technical software, as well as cloud-based software. Excludes companies classified in the Interactive Home Entertainment Sub-Industry. Also excludes companies producing systems or database management software classified in the Systems Software Sub-Industry.', '451030', '1999-01-01', NULL),
	('45103020', 'Systems Software', 'Companies engaged in developing and producing systems and database management software.', '451030', '1999-01-01', NULL),
	('45103030', 'Home Entertainment Software  (discontinued effective close of September 28, 2018)', 'Manufacturers of home entertainment software and educational software used primarily in the home.', '451030', '1999-01-01', '2018-09-28'),
	('45201010', 'Networking Equipment (discontinued effective close of April 30, 2003)', 'Manufacturers of computer networking equipment and products, including LANs, WANs and routers.', '452010', '1999-01-01', '2003-04-30'),
	('45201020', 'Communications Equipment', 'Manufacturers of communication equipment and products, including LANs, WANs, routers, telephones, switchboards and exchanges. Excludes cellular phone manufacturers classified in the Technology Hardware, Storage & Peripherals Sub-Industry.', '452010', '1999-01-01', NULL),
	('45202010', 'Computer Hardware (discontinued effective close of February 28, 2014)', 'Manufacturers of personal computers, servers, mainframes and workstations. Includes manufacturers of Automatic Teller Machines (ATMs). Excludes manufacturers of copiers, faxes and related products classified in the Office Electronics Sub-Industry.', '452020', '1999-01-01', '2014-02-28'),
	('45202020', 'Computer Storage & Peripherals (discontinued effective close of February 28, 2014)', 'Manufacturers of electronic computer components and peripherals. Includes data storage components, motherboards, audio and video cards, monitors, keyboards, printers and other peripherals. Excludes semiconductors classified in the Semiconductors Sub-Industry.', '452020', '1999-01-01', '2014-02-28'),
	('45202030', 'Technology Hardware, Storage & Peripherals', 'Manufacturers of cellular phones, personal computers, servers, electronic computer components and peripherals. Includes data storage components, motherboards, audio and video cards, monitors, keyboards, printers, and other peripherals. Excludes semiconductors classified in the Semiconductors Sub-Industry.', '452020', '1999-01-01', NULL),
	('45203010', 'Electronic Equipment & Instruments', 'Manufacturers of electronic equipment and instruments including analytical, electronic test and measurement instruments, scanner/barcode products, lasers, display screens, point-of-sales machines, and security system equipment.', '452030', '1999-01-01', NULL),
	('45203015', 'Electronic Components', 'Manufacturers of electronic components. Includes electronic components, connection devices, electron tubes, electronic capacitors and resistors, electronic coil, printed circuit board, transformer and other inductors, signal processing technology/components.', '452030', '1999-01-01', NULL),
	('45203020', 'Electronic Manufacturing Services', 'Producers of electronic equipment mainly for the OEM (Original Equipment Manufacturers) markets.', '452030', '1999-01-01', NULL),
	('45203030', 'Technology Distributors', 'Distributors of technology hardware and equipment. Includes distributors of communications equipment, computers & peripherals, semiconductors, and electronic equipment and components.', '452030', '1999-01-01', NULL),
	('45204010', 'Office Electronics (discontinued effective close of February 28, 2014)', 'Manufacturers of office electronic equipment including copiers and faxes.', '452040', '1999-01-01', '2014-02-28'),
	('45205010', 'Semiconductor Equipment (discontinued effective close of April 30, 2003)', 'Manufacturers of semiconductor equipment.', '452050', '1999-01-01', '2003-04-30'),
	('45205020', 'Semiconductors (discontinued effective close of April 30, 2003)', 'Manufacturers of semiconductors and related products.', '452050', '1999-01-01', '2003-04-30'),
	('45301010', 'Semiconductor Materials & Equipment', 'Manufacturers of semiconductor equipment, including manufacturers of the raw material and equipment used in the solar power industry.', '453010', '2023-03-17', NULL),
	('45301020', 'Semiconductors', 'Manufacturers of semiconductors and related products, including manufacturers of solar modules and cells.', '453010', '1999-01-01', NULL),
	('50101010', 'Alternative Carriers', 'Providers of communications and high-density data transmission services primarily through a high bandwidth/fiber-optic cable network.', '501010', '1999-01-01', NULL),
	('50101020', 'Integrated Telecommunication Services', 'Operators of primarily fixed-line telecommunications networks and companies providing both wireless and fixed-line telecommunications services not classified elsewhere. Also includes internet service providers offering internet access to end users.', '501010', '1999-01-01', NULL),
	('50102010', 'Wireless Telecommunication Services', 'Providers of primarily cellular or wireless telecommunication services.', '501020', '1999-01-01', NULL),
	('50201010', 'Advertising', 'Companies providing advertising, marketing or public relations services.', '502010', '1999-01-01', NULL),
	('50201020', 'Broadcasting', 'Owners and operators of television or radio broadcasting systems, including programming. Includes radio and television broadcasting, radio networks, and radio stations.', '502010', '1999-01-01', NULL),
	('50201030', 'Cable & Satellite', 'Providers of cable or satellite television services. Includes cable networks and program distribution.', '502010', '1999-01-01', NULL),
	('50201040', 'Publishing', 'Publishers of newspapers, magazines and books in print or electronic formats.', '502010', '1999-01-01', NULL),
	('50202010', 'Movies & Entertainment', 'Companies that engage in producing and selling entertainment products and services, including companies engaged in the production, distribution and screening of movies and television shows, producers and distributors of music, entertainment theaters and sports teams. Also includes companies offering and/or producing entertainment content streamed online.', '502020', '1999-01-01', NULL),
	('50202020', 'Interactive Home Entertainment', 'Producers of interactive gaming products, including mobile gaming applications. Also includes educational software used primarily in the home. Excludes online gambling companies classified in the Casinos & Gaming Sub-Industry.', '502020', '1999-01-01', NULL),
	('50203010', 'Interactive Media & Services', 'Companies engaging in content and information creation or distribution through proprietary platforms, where revenues are derived primarily through pay-per-click advertisements. Includes search engines, social media and networking platforms, online classifieds, and online review companies. Excludes companies operating online marketplaces classified in Internet & Direct Marketing Retail. ', '502030', '1999-01-01', NULL),
	('55101010', 'Electric Utilities', 'Companies that produce or distribute electricity. Includes both nuclear and non-nuclear facilities.', '551010', '1999-01-01', NULL),
	('55102010', 'Gas Utilities', 'Companies whose main charter is to distribute and transmit natural and manufactured gas. Excludes companies primarily involved in gas exploration or production classified in the Oil & Gas Exploration & Production Sub-Industry. Also excludes companies engaged in the storage and/or transportation of oil, gas, and/or refined products classified in the Oil & Gas Storage & Transportation Sub-Industry.', '551020', '1999-01-01', NULL),
	('55103010', 'Multi-Utilities', 'Utility companies with significantly diversified activities in addition to core Electric Utility, Gas Utility and/or Water Utility operations.', '551030', '1999-01-01', NULL),
	('55104010', 'Water Utilities', 'Companies that purchase and redistribute water to the end-consumer. Includes large-scale water treatment systems.', '551040', '1999-01-01', NULL),
	('55105010', 'Independent Power Producers & Energy Traders', 'Companies that operate as Independent Power Producers (IPPs), Gas & Power Marketing & Trading Specialists and/or Integrated Energy Merchants. Excludes producers of electricity using renewable sources, such as solar power, hydropower, and wind power. Also excludes electric transmission companies and utility distribution companies classified in the Electric Utilities Sub-Industry.', '551050', '1999-01-01', NULL),
	('55105020', 'Renewable Electricity', 'Companies that engage in the generation and distribution of electricity using renewable sources, including, but not limited to, companies that produce electricity using biomass, geothermal energy, solar energy, hydropower, and wind power. Excludes companies manufacturing capital equipment used to generate electricity using renewable sources, such as manufacturers of solar power systems, installers of photovoltaic cells,  and companies involved in the provision of technology, components, and services mainly to this market. ', '551050', '1999-01-01', NULL),
	('60101010', 'Diversified REITs', 'A company or Trust with significantly diversified operations across two or more property types.', '601010', '1999-01-01', NULL),
	('60102510', 'Industrial REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of industrial properties. Includes companies operating industrial warehouses and distribution properties.', '601025', '1999-01-01', NULL),
	('60103010', 'Hotel & Resort REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of hotel and resort properties. ', '601030', '1999-01-01', NULL),
	('60104010', 'Office REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of office properties.', '601040', '1999-01-01', NULL),
	('60105010', 'Health Care REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of properties serving the health care industry, including hospitals, nursing homes, and assisted living properties.', '601050', '1999-01-01', NULL),
	('60101060', 'Residential REITs(Discontinued)', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of residential properties including multifamily homes, apartments, manufactured homes and student housing properties', '601010', '1999-01-01', '2023-03-17'),
	('60106010', 'Multi-Family Residential REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of apartments and other multi-family housing including student housing.', '601060', '2023-03-17', NULL),
	('60106020', 'Single-Family Residential REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of single-family residential housing including manufactured homes.', '601060', '2023-03-17', NULL),
	('60107010', 'Retail REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of shopping malls, outlet malls, neighborhood and community shopping centers.', '601070', '2023-03-17', NULL),
	('60108010', 'Other Specialized REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of properties not classified elsewhere. This Sub-Industry includes REITs that manage and own properties such as natural gas and crude oil pipelines, gas stations, fiber optic cables, prisons, automobile parking, and automobile dealerships.', '601080', '2023-03-17', NULL),
	('60108020', 'Self-Storage REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of self storage properties.', '601080', '2023-03-17', NULL),
	('60108030', 'Telecom Tower REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of telecom towers and related structures that support wireless telecommunications.', '601080', '2023-03-17', NULL),
	('60108040', 'Timber REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of timberland and timber-related properties.', '601080', '2023-03-17', NULL),
	('60108050', 'Data Center REITs', 'Companies or Trusts engaged in the acquisition, development, ownership, leasing, management and operation of data center properties.', '601080', '2023-03-17', NULL),
	('60201010', 'Diversified Real Estate Activities', 'Companies engaged in a diverse spectrum of real estate activities including real estate development & sales, real estate management, or real estate services, but with no dominant business line.', '602010', '2023-03-17', NULL),
	('60201020', 'Real Estate Operating Companies', 'Companies engaged in operating real estate properties for the purpose of leasing & management.', '602010', '2023-03-17', NULL),
	('60201030', 'Real Estate Development', 'Companies that develop real estate and sell the properties after development. Excludes companies classified in the Homebuilding Sub-Industry.', '602010', '2023-03-17', NULL),
	('60201040', 'Real Estate Services', 'Real estate service providers such as real estate agents, brokers & real estate appraisers.', '602010', '2023-03-17', NULL);

CREATE TABLE IF NOT EXISTS securities.gics (
    code char(8) PRIMARY KEY,
    parent_code char(8),
    name varchar(255) NOT NULL,
    definition varchar(1000) DEFAULT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT FK_gics_gics 
        FOREIGN KEY(parent_code)
        REFERENCES securities.gics);

INSERT INTO securities.gics (code, name, definition, start_date, end_date) 
    SELECT code, name, definition, start_date, end_date
    FROM securities.gics_sector;

INSERT INTO securities.gics (code, parent_code, name, start_date, end_date) 
    SELECT code, sector_code, name, start_date, end_date
    FROM securities.gics_industry_group;

INSERT INTO securities.gics (code, parent_code, name, start_date, end_date) 
    SELECT code, industry_group_code, name, start_date, end_date
    FROM securities.gics_industry;

INSERT INTO securities.gics (code, parent_code, name, definition, start_date, end_date) 
    SELECT code, industry_code, name, description, start_date, end_date
    FROM securities.gics_sub_industry;

CREATE TABLE IF NOT EXISTS securities.currency (
    code char(4) PRIMARY KEY,
    currency varchar(100) NOT NULL,
	minor_unit smallint,
	symbol varchar(100),
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

INSERT INTO securities.currency (code,currency,minor_unit,symbol) VALUES
	 ('AED ','UAE Dirham',2,'د.إ'),
	 ('AFN ','Afghani',2,'؋'),
	 ('ALL ','Lek',2,'Lek'),
	 ('AMD ','Armenian Dram',2,NULL),
	 ('ANG ','Netherlands Antillean Guilder',2,NULL),
	 ('AOA ','Kwanza',2,NULL),
	 ('ARS ','Argentine Peso',2,'$'),
	 ('AUD ','Australian Dollar',2,'$'),
	 ('AWG ','Aruban Florin',2,NULL),
	 ('AZN ','Azerbaijan Manat',2,NULL),
	 ('BAM ','Convertible Mark',2,NULL),
	 ('BBD ','Barbados Dollar',2,'$'),
	 ('BDT ','Taka',2,'৳'),
	 ('BGN ','Bulgarian Lev',2,'лв'),
	 ('BHD ','Bahraini Dinar',3,NULL),
	 ('BIF ','Burundi Franc',0,NULL),
	 ('BMD ','Bermudian Dollar',2,NULL),
	 ('BND ','Brunei Dollar',2,NULL),
	 ('BOB ','Boliviano',2,NULL),
	 ('BOV ','Mvdol',2,NULL),
	 ('BRL ','Brazilian Real',2,'R$'),
	 ('BSD ','Bahamian Dollar',2,'$'),
	 ('BTN ','Ngultrum',2,NULL),
	 ('BWP ','Pula',2,NULL),
	 ('BYN ','Belarusian Ruble',2,NULL),
	 ('BZD ','Belize Dollar',2,'BZ$'),
	 ('CAD ','Canadian Dollar',2,'$'),
	 ('CDF ','Congolese Franc',2,NULL),
	 ('CHE ','WIR Euro',2,NULL),
	 ('CHF ','Swiss Franc',2,NULL),
	 ('CHW ','WIR Franc',2,NULL),
	 ('CLF ','Unidad de Fomento',4,NULL),
	 ('CLP ','Chilean Peso',0,'$'),
	 ('CNY ','Yuan Renminbi',2,'¥'),
	 ('COP ','Colombian Peso',2,'$'),
	 ('COU ','Unidad de Valor Real',2,NULL),
	 ('CRC ','Costa Rican Colon',2,NULL),
	 ('CUC ','Peso Convertible',2,NULL),
	 ('CUP ','Cuban Peso',2,NULL),
	 ('CVE ','Cabo Verde Escudo',2,NULL),
	 ('CZK ','Czech Koruna',2,'Kč'),
	 ('DJF ','Djibouti Franc',0,NULL),
	 ('DKK ','Danish Krone',2,'kr'),
	 ('DOP ','Dominican Peso',2,NULL),
	 ('DZD ','Algerian Dinar',2,NULL),
	 ('EGP ','Egyptian Pound',2,NULL),
	 ('ERN ','Nakfa',2,NULL),
	 ('ETB ','Ethiopian Birr',2,NULL),
	 ('EUR ','Euro',2,'€'),
	 ('FJD ','Fiji Dollar',2,NULL),
	 ('FKP ','Falkland Islands Pound',2,NULL),
	 ('GBP ','Pound Sterling',2,'£'),
	 ('GEL ','Lari',2,'₾'),
	 ('GHS ','Ghana Cedi',2,NULL),
	 ('GIP ','Gibraltar Pound',2,NULL),
	 ('GMD ','Dalasi',2,NULL),
	 ('GNF ','Guinean Franc',0,NULL),
	 ('GTQ ','Quetzal',2,NULL),
	 ('GYD ','Guyana Dollar',2,NULL),
	 ('HKD ','Hong Kong Dollar',2,'$'),
	 ('HNL ','Lempira',2,NULL),
	 ('HRK ','Kuna',2,'kn'),
	 ('HTG ','Gourde',2,NULL),
	 ('HUF ','Forint',2,'ft'),
	 ('IDR ','Rupiah',2,'Rp'),
	 ('ILS ','New Israeli Sheqel',2,'₪'),
	 ('INR ','Indian Rupee',2,'₹'),
	 ('IQD ','Iraqi Dinar',3,NULL),
	 ('IRR ','Iranian Rial',2,NULL),
	 ('ISK ','Iceland Krona',0,NULL),
	 ('JMD ','Jamaican Dollar',2,NULL),
	 ('JOD ','Jordanian Dinar',3,NULL),
	 ('JPY ','Yen',0,'¥'),
	 ('KES ','Kenyan Shilling',2,'Ksh'),
	 ('KGS ','Som',2,NULL),
	 ('KHR ','Riel',2,'៛'),
	 ('KMF ','Comorian Franc ',0,NULL),
	 ('KPW ','North Korean Won',2,NULL),
	 ('KRW ','Won',0,'₩'),
	 ('KWD ','Kuwaiti Dinar',3,NULL),
	 ('KYD ','Cayman Islands Dollar',2,NULL),
	 ('KZT ','Tenge',2,NULL),
	 ('LAK ','Lao Kip',2,NULL),
	 ('LBP ','Lebanese Pound',2,NULL),
	 ('LKR ','Sri Lanka Rupee',2,'Rs'),
	 ('LRD ','Liberian Dollar',2,NULL),
	 ('LSL ','Loti',2,NULL),
	 ('LYD ','Libyan Dinar',3,NULL),
	 ('MAD ','Moroccan Dirham',2,' .د.م '),
	 ('MDL ','Moldovan Leu',2,NULL),
	 ('MGA ','Malagasy Ariary',2,NULL),
	 ('MKD ','Denar',2,NULL),
	 ('MMK ','Kyat',2,NULL),
	 ('MNT ','Tugrik',2,NULL),
	 ('MOP ','Pataca',2,NULL),
	 ('MRU ','Ouguiya',2,NULL),
	 ('MUR ','Mauritius Rupee',2,NULL),
	 ('MVR ','Rufiyaa',2,NULL),
	 ('MWK ','Malawi Kwacha',2,NULL),
	 ('MXN ','Mexican Peso',2,'$');
INSERT INTO securities.currency (code,currency,minor_unit,symbol) VALUES
	 ('MXV ','Mexican Unidad de Inversion (UDI)',2,NULL),
	 ('MYR ','Malaysian Ringgit',2,'RM'),
	 ('MZN ','Mozambique Metical',2,NULL),
	 ('NAD ','Namibia Dollar',2,NULL),
	 ('NGN ','Naira',2,'₦'),
	 ('NIO ','Cordoba Oro',2,NULL),
	 ('NOK ','Norwegian Krone',2,'kr'),
	 ('NPR ','Nepalese Rupee',2,NULL),
	 ('NZD ','New Zealand Dollar',2,'$'),
	 ('OMR ','Rial Omani',3,NULL),
	 ('PAB ','Balboa',2,NULL),
	 ('PEN ','Sol',2,'S'),
	 ('PGK ','Kina',2,NULL),
	 ('PHP ','Philippine Peso',2,'₱'),
	 ('PKR ','Pakistan Rupee',2,'Rs'),
	 ('PLN ','Zloty',2,'zł'),
	 ('PYG ','Guarani',0,NULL),
	 ('QAR ','Qatari Rial',2,NULL),
	 ('RON ','Romanian Leu',2,'lei'),
	 ('RSD ','Serbian Dinar',2,NULL),
	 ('RUB ','Russian Ruble',2,'₽'),
	 ('RWF ','Rwanda Franc',0,NULL),
	 ('SAR ','Saudi Riyal',2,NULL),
	 ('SBD ','Solomon Islands Dollar',2,NULL),
	 ('SCR ','Seychelles Rupee',2,NULL),
	 ('SDG ','Sudanese Pound',2,NULL),
	 ('SEK ','Swedish Krona',2,'kr'),
	 ('SGD ','Singapore Dollar',2,'$'),
	 ('SHP ','Saint Helena Pound',2,NULL),
	 ('SLL ','Leone',2,NULL),
	 ('SOS ','Somali Shilling',2,NULL),
	 ('SRD ','Surinam Dollar',2,NULL),
	 ('SSP ','South Sudanese Pound',2,NULL),
	 ('STN ','Dobra',2,NULL),
	 ('SVC ','El Salvador Colon',2,NULL),
	 ('SYP ','Syrian Pound',2,NULL),
	 ('SZL ','Lilangeni',2,NULL),
	 ('THB ','Baht',2,'฿'),
	 ('TJS ','Somoni',2,NULL),
	 ('TMT ','Turkmenistan New Manat',2,NULL),
	 ('TND ','Tunisian Dinar',3,NULL),
	 ('TOP ','Pa’anga',2,NULL),
	 ('TRY ','Turkish Lira',2,'₺'),
	 ('TTD ','Trinidad and Tobago Dollar',2,NULL),
	 ('TWD ','New Taiwan Dollar',2,NULL),
	 ('TZS ','Tanzanian Shilling',2,NULL),
	 ('UAH ','Hryvnia',2,'₴'),
	 ('UGX ','Uganda Shilling',0,NULL),
	 ('USD ','US Dollar',2,'$'),
	 ('USN ','US Dollar (Next day)',2,NULL),
	 ('UYI ','Uruguay Peso en Unidades Indexadas (UI)',0,NULL),
	 ('UYU ','Peso Uruguayo',2,NULL),
	 ('UYW ','Unidad Previsional',4,NULL),
	 ('UZS ','Uzbekistan Sum',2,NULL),
	 ('VES ','Bolívar Soberano',2,NULL),
	 ('VND ','Dong',0,'₫'),
	 ('VUV ','Vatu',0,NULL),
	 ('WST ','Tala',2,NULL),
	 ('XAF ','CFA Franc BEAC',0,NULL),
	 ('XBT ','Bitcoin',8,'₿'),
	 ('XCD ','East Caribbean Dollar',2,NULL),
	 ('XDR ','SDR (Special Drawing Right)',0,NULL),
	 ('XOF ','CFA Franc BCEAO',0,NULL),
	 ('XPF ','CFP Franc',0,NULL),
	 ('XSU ','Sucre',0,NULL),
	 ('XUA ','ADB Unit of Account',0,NULL),
	 ('YER ','Yemeni Rial',2,NULL),
	 ('ZAR ','Rand',2,'R'),
	 ('ZMW ','Zambian Kwacha',2,NULL),
	 ('ZWL ','Zimbabwe Dollar',2,NULL);

CREATE TABLE IF NOT EXISTS securities.country (
    alpha_3 char(3) PRIMARY KEY,
    id integer NOT NULL,
	alpha_2 char(2) NOT NULL,
    name varchar(75) NOT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

INSERT INTO securities.country (alpha_3,id,alpha_2,"name") VALUES
	 ('AFG',4,'AF','Afghanistan'),
	 ('ALB',8,'AL','Albania'),
	 ('DZA',12,'DZ','Algeria'),
	 ('AND',20,'AD','Andorra'),
	 ('AGO',24,'AO','Angola'),
	 ('ATG',28,'AG','Antigua and Barbuda'),
	 ('ARG',32,'AR','Argentina'),
	 ('ARM',51,'AM','Armenia'),
	 ('ABW',533,'AW','Aruba'),
	 ('AUS',36,'AU','Australia'),
	 ('AUT',40,'AT','Austria'),
	 ('AZE',31,'AZ','Azerbaijan'),
	 ('BHS',44,'BS','Bahamas'),
	 ('BHR',48,'BH','Bahrain'),
	 ('BGD',50,'BD','Bangladesh'),
	 ('BRB',52,'BB','Barbados'),
	 ('BLR',112,'BY','Belarus'),
	 ('BEL',56,'BE','Belgium'),
	 ('BLZ',84,'BZ','Belize'),
	 ('BEN',204,'BJ','Benin'),
	 ('BTN',64,'BT','Bhutan'),
	 ('BOL',68,'BO','Bolivia'),
	 ('BIH',70,'BA','Bosnia and Herzegovina'),
	 ('BWA',72,'BW','Botswana'),
	 ('BRA',76,'BR','Brazil'),
	 ('BRN',96,'BN','Brunei Darussalam'),
	 ('BGR',100,'BG','Bulgaria'),
	 ('BFA',854,'BF','Burkina Faso'),
	 ('BDI',108,'BI','Burundi'),
	 ('CPV',132,'CV','Cabo Verde'),
	 ('KHM',116,'KH','Cambodia'),
	 ('CMR',120,'CM','Cameroon'),
	 ('CAN',124,'CA','Canada'),
	 ('CAF',140,'CF','Central African Republic'),
	 ('TCD',148,'TD','Chad'),
	 ('CHL',152,'CL','Chile'),
	 ('CHN',156,'CN','China'),
	 ('COL',170,'CO','Colombia'),
	 ('COM',174,'KM','Comoros'),
	 ('COG',178,'CG','Congo'),
	 ('COD',180,'CD','Congo, Democratic Republic of the'),
	 ('CRI',188,'CR','Costa Rica'),
	 ('CIV',384,'CI','Côte d''Ivoire'),
	 ('HRV',191,'HR','Croatia'),
	 ('CUB',192,'CU','Cuba'),
	 ('CYP',196,'CY','Cyprus'),
	 ('CZE',203,'CZ','Czechia'),
	 ('DNK',208,'DK','Denmark'),
	 ('DJI',262,'DJ','Djibouti'),
	 ('DMA',212,'DM','Dominica'),
	 ('DOM',214,'DO','Dominican Republic'),
	 ('ECU',218,'EC','Ecuador'),
	 ('EGY',818,'EG','Egypt'),
	 ('SLV',222,'SV','El Salvador'),
	 ('GNQ',226,'GQ','Equatorial Guinea'),
	 ('ERI',232,'ER','Eritrea'),
	 ('EST',233,'EE','Estonia'),
	 ('SWZ',748,'SZ','Eswatini'),
	 ('ETH',231,'ET','Ethiopia'),
	 ('FJI',242,'FJ','Fiji'),
	 ('FIN',246,'FI','Finland'),
	 ('FRA',250,'FR','France'),
	 ('GAB',266,'GA','Gabon'),
	 ('GMB',270,'GM','Gambia'),
	 ('GEO',268,'GE','Georgia'),
	 ('DEU',276,'DE','Germany'),
	 ('GHA',288,'GH','Ghana'),
	 ('GIB',292,'GI','Gibraltar'),
	 ('GRC',300,'GR','Greece'),
	 ('GRD',308,'GD','Grenada'),
	 ('GLP',312,'GP','Guadeloupe'),
	 ('GTM',320,'GT','Guatemala'),
	 ('GUM',316,'GU','Guam'),
	 ('GGY',831,'GG','Guernsey'),
	 ('GIN',324,'GN','Guinea'),
	 ('GNB',624,'GW','Guinea-Bissau'),
	 ('GUY',328,'GY','Guyana'),
	 ('HTI',332,'HT','Haiti'),
	 ('VAT',336,'VA','Holy See (Vatican)'),
	 ('HND',340,'HN','Honduras'),
	 ('HKG',344,'HK','Hong Kong'),
	 ('HUN',348,'HU','Hungary'),
	 ('ISL',352,'IS','Iceland'),
	 ('IND',356,'IN','India'),
	 ('IDN',360,'ID','Indonesia'),
	 ('IRN',364,'IR','Iran (Islamic Republic of)'),
	 ('IRQ',368,'IQ','Iraq'),
	 ('IRL',372,'IE','Ireland'),
	 ('ISR',376,'IL','Israel'),
	 ('ITA',380,'IT','Italy'),
	 ('JAM',388,'JM','Jamaica'),
	 ('JPN',392,'JP','Japan'),
	 ('JOR',400,'JO','Jordan'),
	 ('KAZ',398,'KZ','Kazakhstan'),
	 ('KEN',404,'KE','Kenya'),
	 ('KIR',296,'KI','Kiribati'),
	 ('PRK',408,'KP','Korea (Democratic People''s Republic of)'),
	 ('KOR',410,'KR','Korea, Republic of'),
	 ('KWT',414,'KW','Kuwait'),
	 ('KGZ',417,'KG','Kyrgyzstan');
INSERT INTO securities.country (alpha_3,id,alpha_2,"name") VALUES
	 ('LAO',418,'LA','Lao People''s Democratic Republic'),
	 ('LVA',428,'LV','Latvia'),
	 ('LBN',422,'LB','Lebanon'),
	 ('LSO',426,'LS','Lesotho'),
	 ('LBR',430,'LR','Liberia'),
	 ('LBY',434,'LY','Libya'),
	 ('LIE',438,'LI','Liechtenstein'),
	 ('LTU',440,'LT','Lithuania'),
	 ('LUX',442,'LU','Luxembourg'),
	 ('MDG',450,'MG','Madagascar'),
	 ('MWI',454,'MW','Malawi'),
	 ('MYS',458,'MY','Malaysia'),
	 ('MDV',462,'MV','Maldives'),
	 ('MLI',466,'ML','Mali'),
	 ('MLT',470,'MT','Malta'),
	 ('MHL',584,'MH','Marshall Islands'),
	 ('MRT',478,'MR','Mauritania'),
	 ('MUS',480,'MU','Mauritius'),
	 ('MEX',484,'MX','Mexico'),
	 ('FSM',583,'FM','Micronesia (Federated States of)'),
	 ('MDA',498,'MD','Moldova, Republic of'),
	 ('MCO',492,'MC','Monaco'),
	 ('MNG',496,'MN','Mongolia'),
	 ('MNE',499,'ME','Montenegro'),
	 ('MAR',504,'MA','Morocco'),
	 ('MOZ',508,'MZ','Mozambique'),
	 ('MMR',104,'MM','Myanmar'),
	 ('NAM',516,'NA','Namibia'),
	 ('NRU',520,'NR','Nauru'),
	 ('NPL',524,'NP','Nepal'),
	 ('NLD',528,'NL','Netherlands'),
	 ('NZL',554,'NZ','New Zealand'),
	 ('NIC',558,'NI','Nicaragua'),
	 ('NER',562,'NE','Niger'),
	 ('NGA',566,'NG','Nigeria'),
	 ('MKD',807,'MK','North Macedonia'),
	 ('NOR',578,'NO','Norway'),
	 ('OMN',512,'OM','Oman'),
	 ('PAK',586,'PK','Pakistan'),
	 ('PLW',585,'PW','Palau'),
	 ('PAN',591,'PA','Panama'),
	 ('PNG',598,'PG','Papua New Guinea'),
	 ('PRY',600,'PY','Paraguay'),
	 ('PER',604,'PE','Peru'),
	 ('PHL',608,'PH','Philippines'),
	 ('POL',616,'PL','Poland'),
	 ('PRT',620,'PT','Portugal'),
	 ('QAT',634,'QA','Qatar'),
	 ('ROU',642,'RO','Romania'),
	 ('RUS',643,'RU','Russian Federation'),
	 ('RWA',646,'RW','Rwanda'),
	 ('BLM',652,'BL','Saint Barthélemy'),
	 ('KNA',659,'KN','Saint Kitts and Nevis'),
	 ('LCA',662,'LC','Saint Lucia'),
	 ('VCT',670,'VC','Saint Vincent and the Grenadines'),
	 ('WSM',882,'WS','Samoa'),
	 ('SMR',674,'SM','San Marino'),
	 ('STP',678,'ST','Sao Tome and Principe'),
	 ('SAU',682,'SA','Saudi Arabia'),
	 ('SEN',686,'SN','Senegal'),
	 ('SRB',688,'RS','Serbia'),
	 ('SYC',690,'SC','Seychelles'),
	 ('SLE',694,'SL','Sierra Leone'),
	 ('SGP',702,'SG','Singapore'),
	 ('SVK',703,'SK','Slovakia'),
	 ('SVN',705,'SI','Slovenia'),
	 ('SLB',90,'SB','Solomon Islands'),
	 ('SOM',706,'SO','Somalia'),
	 ('ZAF',710,'ZA','South Africa'),
	 ('SSD',728,'SS','South Sudan'),
	 ('ESP',724,'ES','Spain'),
	 ('LKA',144,'LK','Sri Lanka'),
	 ('SDN',729,'SD','Sudan'),
	 ('SUR',740,'SR','Suriname'),
	 ('SJM',744,'SJ','Svalbard and Jan Mayen'),
	 ('SWE',752,'SE','Sweden'),
	 ('CHE',756,'CH','Switzerland'),
	 ('SYR',760,'SY','Syrian Arab Republic'),
	 ('TJK',762,'TJ','Tajikistan'),
	 ('TZA',834,'TZ','Tanzania, United Republic of'),
	 ('THA',764,'TH','Thailand'),
	 ('TLS',626,'TL','Timor-Leste'),
	 ('TGO',768,'TG','Togo'),
	 ('TON',776,'TO','Tonga'),
	 ('TTO',780,'TT','Trinidad and Tobago'),
	 ('TUN',788,'TN','Tunisia'),
	 ('TUR',792,'TR','Türkiye'),
	 ('TKM',795,'TM','Turkmenistan'),
	 ('TCA',796,'TC','Turks and Caicos Islands'),
	 ('TUV',798,'TV','Tuvalu'),
	 ('UGA',800,'UG','Uganda'),
	 ('UKR',804,'UA','Ukraine'),
	 ('ARE',784,'AE','United Arab Emirates'),
	 ('GBR',826,'GB','United Kingdom of Great Britain and Northern Ireland'),
	 ('USA',840,'US','United States of America'),
	 ('URY',858,'UY','Uruguay'),
	 ('UZB',860,'UZ','Uzbekistan'),
	 ('VUT',548,'VU','Vanuatu'),
	 ('VEN',862,'VE','Venezuela'),
	 ('VNM',704,'VN','Vietnam');
INSERT INTO securities.country (alpha_3,id,alpha_2,"name") VALUES
	 ('VGB',92,'VG','Virgin Islands (British)'),
	 ('VIR',850,'VI','Virgin Islands (U.S.)'),
	 ('WLF',876,'WF','Wallis and Futuna'),
	 ('ESH',732,'EH','Western Sahara'),
	 ('YEM',887,'YE','Yemen'),
	 ('ZMB',894,'ZM','Zambia'),
	 ('ZWE',716,'ZW','Zimbabwe');

CREATE TABLE IF NOT EXISTS securities.country_currency (
    country_alpha_3 char(3) NOT NULL,
    currency_code char(4) NOT NULL,
	country_currency char(8) default
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
    CONSTRAINT pk_country_currency
    PRIMARY KEY(country_alpha_3, currency_code),
    CONSTRAINT fk_country_currency_currency
        FOREIGN KEY(currency_code)
        REFERENCES securities.currency(code)
        ON DELETE NO ACTION,
    CONSTRAINT fk_country_currency_country
        FOREIGN KEY(country_alpha_3)
        REFERENCES securities.country(alpha_3)
        ON DELETE NO ACTION
    );

INSERT INTO securities.country_currency (country_alpha_3,currency_code) VALUES
	 ('ABW','AWG '),
	 ('AFG','AFN '),
	 ('AGO','AOA '),
	 ('ALB','ALL '),
	 ('AND','EUR '),
	 ('ARE','AED '),
	 ('ARG','ARS '),
	 ('ARM','AMD '),
	 ('ATG','XCD '),
	 ('AUS','AUD '),
	 ('AUT','EUR '),
	 ('AZE','AZN '),
	 ('BDI','BIF '),
	 ('BEL','EUR '),
	 ('BEN','XOF '),
	 ('BFA','XOF '),
	 ('BGD','BDT '),
	 ('BGR','BGN '),
	 ('BHR','BHD '),
	 ('BHS','BSD '),
	 ('BIH','BAM '),
	 ('BLM','EUR '),
	 ('BLR','BYN '),
	 ('BLZ','BZD '),
	 ('BOL','BOB '),
	 ('BOL','BOV '),
	 ('BRA','BRL '),
	 ('BRB','BBD '),
	 ('BRN','BND '),
	 ('BTN','BTN '),
	 ('BTN','INR '),
	 ('BWA','BWP '),
	 ('CAF','XAF '),
	 ('CAN','CAD '),
	 ('CHE','CHE '),
	 ('CHE','CHF '),
	 ('CHE','CHW '),
	 ('CHL','CLF '),
	 ('CHL','CLP '),
	 ('CHN','CNY '),
	 ('CIV','XOF '),
	 ('CMR','XAF '),
	 ('COD','CDF '),
	 ('COG','XAF '),
	 ('COL','COP '),
	 ('COL','COU '),
	 ('COM','KMF '),
	 ('CPV','CVE '),
	 ('CRI','CRC '),
	 ('CUB','CUC '),
	 ('CUB','CUP '),
	 ('CYP','EUR '),
	 ('CZE','CZK '),
	 ('DEU','EUR '),
	 ('DJI','DJF '),
	 ('DMA','XCD '),
	 ('DNK','DKK '),
	 ('DOM','DOP '),
	 ('DZA','DZD '),
	 ('ECU','USD '),
	 ('EGY','EGP '),
	 ('ERI','ERN '),
	 ('ESH','MAD '),
	 ('ESP','EUR '),
	 ('EST','EUR '),
	 ('ETH','ETB '),
	 ('FIN','EUR '),
	 ('FJI','FJD '),
	 ('FRA','EUR '),
	 ('FSM','USD '),
	 ('GAB','XAF '),
	 ('GBR','GBP '),
	 ('GEO','GEL '),
	 ('GGY','GBP '),
	 ('GHA','GHS '),
	 ('GIB','GIP '),
	 ('GIN','GNF '),
	 ('GLP','EUR '),
	 ('GMB','GMD '),
	 ('GNB','XOF '),
	 ('GNQ','XAF '),
	 ('GRC','EUR '),
	 ('GRD','XCD '),
	 ('GTM','GTQ '),
	 ('GUM','USD '),
	 ('GUY','GYD '),
	 ('HKG','HKD '),
	 ('HND','HNL '),
	 ('HRV','HRK '),
	 ('HTI','HTG '),
	 ('HTI','USD '),
	 ('HUN','HUF '),
	 ('IDN','IDR '),
	 ('IND','INR '),
	 ('IRL','EUR '),
	 ('IRN','IRR '),
	 ('IRQ','IQD '),
	 ('ISL','ISK '),
	 ('ISR','ILS '),
	 ('ITA','EUR ');
INSERT INTO securities.country_currency (country_alpha_3,currency_code) VALUES
	 ('JAM','JMD '),
	 ('JOR','JOD '),
	 ('JPN','JPY '),
	 ('KAZ','KZT '),
	 ('KEN','KES '),
	 ('KGZ','KGS '),
	 ('KHM','KHR '),
	 ('KIR','AUD '),
	 ('KNA','XCD '),
	 ('KOR','KRW '),
	 ('KWT','KWD '),
	 ('LAO','LAK '),
	 ('LBN','LBP '),
	 ('LBR','LRD '),
	 ('LBY','LYD '),
	 ('LCA','XCD '),
	 ('LIE','CHF '),
	 ('LKA','LKR '),
	 ('LSO','LSL '),
	 ('LSO','ZAR '),
	 ('LTU','EUR '),
	 ('LUX','EUR '),
	 ('LVA','EUR '),
	 ('MAR','MAD '),
	 ('MCO','EUR '),
	 ('MDA','MDL '),
	 ('MDG','MGA '),
	 ('MDV','MVR '),
	 ('MEX','MXN '),
	 ('MEX','MXV '),
	 ('MHL','USD '),
	 ('MKD','MKD '),
	 ('MLI','XOF '),
	 ('MLT','EUR '),
	 ('MMR','MMK '),
	 ('MNE','EUR '),
	 ('MNG','MNT '),
	 ('MOZ','MZN '),
	 ('MRT','MRU '),
	 ('MUS','MUR '),
	 ('MWI','MWK '),
	 ('MYS','MYR '),
	 ('NAM','NAD '),
	 ('NAM','ZAR '),
	 ('NER','XOF '),
	 ('NGA','NGN '),
	 ('NIC','NIO '),
	 ('NLD','EUR '),
	 ('NOR','NOK '),
	 ('NPL','NPR '),
	 ('NRU','AUD '),
	 ('NZL','NZD '),
	 ('OMN','OMR '),
	 ('PAK','PKR '),
	 ('PAN','PAB '),
	 ('PAN','USD '),
	 ('PER','PEN '),
	 ('PHL','PHP '),
	 ('PLW','USD '),
	 ('PNG','PGK '),
	 ('POL','PLN '),
	 ('PRK','KPW '),
	 ('PRT','EUR '),
	 ('PRY','PYG '),
	 ('QAT','QAR '),
	 ('ROU','RON '),
	 ('RUS','RUB '),
	 ('RWA','RWF '),
	 ('SAU','SAR '),
	 ('SDN','SDG '),
	 ('SEN','XOF '),
	 ('SGP','SGD '),
	 ('SJM','NOK '),
	 ('SLB','SBD '),
	 ('SLE','SLL '),
	 ('SLV','SVC '),
	 ('SLV','USD '),
	 ('SMR','EUR '),
	 ('SOM','SOS '),
	 ('SRB','RSD '),
	 ('SSD','SSP '),
	 ('STP','STN '),
	 ('SUR','SRD '),
	 ('SVK','EUR '),
	 ('SVN','EUR '),
	 ('SWE','SEK '),
	 ('SWZ','SZL '),
	 ('SYC','SCR '),
	 ('SYR','SYP '),
	 ('TCA','USD '),
	 ('TCD','XAF '),
	 ('TGO','XOF '),
	 ('THA','THB '),
	 ('TJK','TJS '),
	 ('TKM','TMT '),
	 ('TLS','USD '),
	 ('TON','TOP '),
	 ('TTO','TTD '),
	 ('TUN','TND '),
	 ('TUR','TRY ');
INSERT INTO securities.country_currency (country_alpha_3,currency_code) VALUES
	 ('TUV','AUD '),
	 ('TZA','TZS '),
	 ('UGA','UGX '),
	 ('UKR','UAH '),
	 ('URY','UYI '),
	 ('URY','UYU '),
	 ('URY','UYW '),
	 ('USA','USD '),
	 ('USA','USN '),
	 ('UZB','UZS '),
	 ('VAT','EUR '),
	 ('VCT','XCD '),
	 ('VEN','VES '),
	 ('VGB','USD '),
	 ('VIR','USD '),
	 ('VNM','VND '),
	 ('VUT','VUV '),
	 ('WLF','XPF '),
	 ('WSM','WST '),
	 ('YEM','YER '),
	 ('ZAF','ZAR '),
	 ('ZMB','ZMW '),
	 ('ZWE','ZWL ');

UPDATE securities.country_currency SET country_currency = CONCAT(country_alpha_3, '-', currency_code);

CREATE TABLE IF NOT EXISTS securities.exchange (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code char(8) UNIQUE NOT NULL,
    acronym varchar(32) NULL,
    name varchar(255) NOT NULL,
    definition varchar(1000) DEFAULT NULL,
    country_alpha_3 char(3) NOT NULL,
    currency_code char(4) NOT NULL,
    city varchar(255) NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    timezone_offset time NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
    CONSTRAINT fk_exchange_country_currency
        FOREIGN KEY(country_alpha_3, currency_code)
        REFERENCES securities.country_currency(country_alpha_3, currency_code)
        ON DELETE NO ACTION);

COMMENT ON COLUMN securities.exchange.code IS 'This is the market identifier code (MIC). https://www.iso20022.org/market-identifier-codes';

INSERT INTO securities.exchange (code, acronym, city, name, definition, country_alpha_3, currency_code, start_date, end_date) VALUES
	('XASX', 'ASX', 'SYDNEY', 'Australian Securities Exchange', 'ASX stands for Australian Securities Exchange. It was created by the merger of the Australian Stock Exchange and the Sydney Futures Exchange in July 2006 and is one of the world’s top-10 listed exchange groups measured by market capitalisation.', 'AUS', 'AUD', '2012-05-28', NULL),
	('XNAS', 'NASDAQ', 'NEW YORK', 'NASDAQ', 'A global electronic marketplace for buying and selling securities', 'USA', 'USD', '2005-06-27', NULL),
	('XNYS', 'NYSE', 'NEW YORK', 'New York Stock Exchange', 'The New York Stock Exchange (NYSE) is a stock exchange located in New York City that is the largest equities-based exchange in the world, based on the total market capitalization of its listed securities.', 'USA', 'USD', '2005-05-23', NULL),
	('XASE', 'AMEX', 'NEW YORK', 'NYSE Market, LLC', 'Drawing on its heritage as the American Stock Exchange, NYSE American is an exchange designed for growing companies, and offers investors greater choice in how they trade. NYSE American is a competitively priced venue that blends unique features derived from the NYSE, such as electronic Designated Market Makers (e-DMMs) with quoting obligations for each NYSE American-listed company, with NYSE Arcas fully electronic price/time priority execution model.', 'USA', 'USD', '2009-05-25', NULL),
	('BATS', 'BATS', 'CHICAGO', 'CBOE BZX', 'BZX Exchange (previously BATS Exchange). is located in United States and is regulated by the Securities and Exchange Commission (SEC) and FINRA.', 'USA', 'USD', '2008-11-24', NULL),
	('ARCX', 'NYSE', 'NEW YORK', 'NYSE Arca, Inc.', 'NYSE Arca is an electronic securities exchange in the U.S. on which exchange-traded products (ETPs) and equities are listed. The exchange specializes in ETP listings, which include exchange-traded funds (ETFs), exchange-traded notes (ETNs), and exchange-traded vehicles (ETVs).', 'USA', 'USD', '2006-09-25', NULL),
	('XCBO', 'CBOE', 'CHICAGO', 'CBOE GLOBAL MARKETS INC.', 'CBOE Options Exchange.', 'USA', 'USD', '2008-07-28', NULL);

CREATE TABLE securities.ticker_type (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    description varchar(255),
	start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

COMMENT ON TABLE securities.ticker_type IS 'An identifier for a group of similar financial instruments.';

INSERT INTO securities.ticker_type (code, description) VALUES
    ('crypto', Null),
    ('fx', Null),
    ('index', Null),
    ('option', Null),
    ('stock', Null),
    ('bullion', Null),
    ('etp', Null);

CREATE TABLE securities.watchlist_type (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    description varchar(255) UNIQUE NOT NULL,
    start_date date NULL,
    end_date date NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE securities.watchlist_type IS 'Used to define the category for a watchlist. e.g. Index, Investment style (for ETPs), Portfolio';

DELETE FROM securities.watchlist_type;
INSERT INTO securities.watchlist_type (code, description, start_date, end_date) VALUES
    ('Sector', 'Stocks that are in a specific Sector', '2024-07-08', NULL),
    ('Summary', 'Summary', '2024-07-08', NULL),
    ('Market indices', 'Indexes that reflect a specific market', '2024-07-08', NULL),
	('GICS Sector Indices', 'Indices that reflect a specific GICS sectors.', '2024-07-08', NULL),
	('Broker accounts', 'Stocks held under specifc brokers.', '2024-07-08', NULL);

CREATE TABLE IF NOT EXISTS securities.watchlist (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    watchlist_type_id integer NOT NULL,
    description varchar(1000) NULL,
    start_date date NULL,
    end_date date NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT fk_watchlist_watchlist_type
        FOREIGN KEY(watchlist_type_id)
        REFERENCES securities.watchlist_type(id)
        ON DELETE NO ACTION);

COMMENT ON TABLE securities.watchlist IS 'Used to group a set of securities together. Securities may be in multiple watchlists.';

DELETE FROM securities.watchlist;
INSERT INTO securities.watchlist (code, watchlist_type_id, description, start_date, end_date)
	SELECT 'AUS Stock Sectors', id, 'Indices that reflect the AUS GICS sectors.', '2024-07-08', NULL FROM securities.watchlist_type where code = 'GICS Sector Indices';
INSERT INTO securities.watchlist (code, watchlist_type_id, description, start_date, end_date)
	SELECT 'US Stock Sectors', id, 'Indices that reflect the US sectors.', '2024-07-08', NULL FROM securities.watchlist_type where code = 'GICS Sector Indices';
INSERT INTO securities.watchlist (code, watchlist_type_id, description, start_date, end_date)
	SELECT 'AUS Indices', id, 'Indices that reflect the AUS market.', '2024-07-08', NULL FROM securities.watchlist_type where code = 'Market indices';
INSERT INTO securities.watchlist (code, watchlist_type_id, description, start_date, end_date)
	SELECT 'US Indices', id, 'Indices that reflect the US market.', '2024-07-08', NULL FROM securities.watchlist_type where code = 'Market indices';
INSERT INTO securities.watchlist (code, watchlist_type_id, description, start_date, end_date)
	SELECT 'AUS Summary', id, 'A summary of the AUS market.', '2024-07-08', NULL FROM securities.watchlist_type where code = 'Summary';
INSERT INTO securities.watchlist (code, watchlist_type_id, description, start_date, end_date)
	SELECT 'US Summary', id, 'A summary of the AUS market.', '2024-07-08', NULL FROM securities.watchlist_type where code = 'Summary';
INSERT INTO securities.watchlist (code, watchlist_type_id, description, start_date, end_date)
	SELECT 'Interactive Brokers', id, 'Stocks held at Interactive Brokers.', '2024-07-08', NULL FROM securities.watchlist_type where code = 'Broker accounts';
INSERT INTO securities.watchlist (code, watchlist_type_id, description, start_date, end_date)
	SELECT 'CommSec - Rob & Sue', id, 'Stocks held at CommSec under Rob & Sue.', '2024-07-08', NULL FROM securities.watchlist_type where code = 'Broker accounts';
INSERT INTO securities.watchlist (code, watchlist_type_id, description, start_date, end_date)
	SELECT 'CommSec - SuperBebbs', id, 'Stocks held at CommSec under SuperBebbs.', '2024-07-08', NULL FROM securities.watchlist_type where code = 'Broker accounts';
INSERT INTO securities.watchlist (code, watchlist_type_id, description, start_date, end_date)
	SELECT 'eBroker - SuperBebbs', id, 'Stocks held at eBroker under SuperBebbs.', '2024-07-08', NULL FROM securities.watchlist_type where code = 'Broker accounts';

CREATE TABLE securities.ticker (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    ticker varchar(32) NOT NULL,
    yahoo_ticker varchar(32) NULL,
    figi char(12) NULL,
    name varchar(255) NULL,
	currency_code char(4) NULL,
    gics_sector_code char(2) NULL,
    gics_industry_group_code char(4) NULL,
    gics_industry_code char(6) NULL,
    gics_sub_industry_code char(8) NULL,
    exchange_id integer NULL,
    listed_date date NULL,
    delisted_utc timestamp NULL, 
    listcorp_url varchar(255) NULL,
    ticker_type_id integer NOT NULL,
	underlying_ticker varchar(32),
	call_put char(1) NULL,
	strike numeric(19,4) NULL,
	expiry_date date NULL,
    start_date date NULL,
    end_date date NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT unique_ticker 
		UNIQUE (exchange_id, ticker),
    CONSTRAINT fk_ticker_exchange
        FOREIGN KEY(exchange_id)
        REFERENCES securities.exchange(id)
        ON DELETE NO ACTION,
    CONSTRAINT fk_ticker_ticker_type
        FOREIGN KEY(ticker_type_id)
        REFERENCES securities.ticker_type(id)
        ON DELETE NO ACTION,
    CONSTRAINT fk_ticker_sector
        FOREIGN KEY(gics_sector_code)
        REFERENCES securities.gics_sector(code)
        ON DELETE NO ACTION,
    CONSTRAINT fk_ticker_industry_group
        FOREIGN KEY(gics_industry_group_code)
        REFERENCES securities.gics_industry_group(code)
        ON DELETE NO ACTION,        
    CONSTRAINT fk_ticker_industry
        FOREIGN KEY(gics_industry_code)
        REFERENCES securities.gics_industry(code)
        ON DELETE NO ACTION,
    CONSTRAINT fk_ticker_sub_industry
        FOREIGN KEY(gics_sub_industry_code)
        REFERENCES securities.gics_sub_industry(code)
        ON DELETE NO ACTION);

COMMENT ON COLUMN securities.ticker.name IS 'The name of the asset. For stocks/equities this will be the companies registered name. For crypto/fx this will be the name of the currency or coin pair.';
COMMENT ON COLUMN securities.ticker.ticker IS 'The exchange symbol that this item is traded under.';

CREATE TABLE IF NOT EXISTS securities.watchlist_ticker (
	id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    watchlist_id integer NOT NULL,
    ticker_id integer NOT NULL,
    start_date date NULL,
    end_date date NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
    CONSTRAINT fk_watchlist_ticker_watchlist
        FOREIGN KEY(watchlist_id) 
        REFERENCES securities.watchlist(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_watchlist_ticker_ticker
        FOREIGN KEY(ticker_id) 
        REFERENCES securities.ticker(id)
        ON DELETE SET NULL,
    CONSTRAINT unique_watchlist_ticker
		UNIQUE (watchlist_id, ticker_id));

COMMENT ON TABLE securities.watchlist_ticker IS 'Used to store the tickers in each watchlist.';

CREATE TABLE securities.data_vendor (
    id integer PRIMARY KEY,
    name varchar(64) NOT NULL,
    website_url varchar(255) NULL,
    support_email varchar(255) NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

INSERT INTO securities.data_vendor (id, name, website_url, support_email) VALUES
	(1, 'Yahoo', 'https://au.finance.yahoo.com/', Null),
	(2, 'polygon.io', 'https://polygon.io/', 'support@polygon.io'),
	(3, 'Interactive Brokers', 'https://www.interactivebrokers.com.au/en/home.php', Null);

CREATE TABLE securities.ohlcv (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    data_vendor_id integer NOT NULL,
    ticker_id integer NULL,
    date date NOT NULL,
    open numeric(19,4) NULL,
    high numeric(19,4) NULL,
    low numeric(19,4) NULL,
    close numeric(19,4) NULL,
    adj_close numeric(19,4) NULL,
    volume bigint NULL,
    volume_weighted_average_price numeric(19,4) NULL,
	transactions integer NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT fk_ohlcv_data_vendor
        FOREIGN KEY(data_vendor_id)
        REFERENCES securities.data_vendor(id)
        ON DELETE NO ACTION,
    CONSTRAINT fk_ohlcv_ticker
        FOREIGN KEY(ticker_id)
        REFERENCES securities.ticker(id)
        ON DELETE CASCADE,
	CONSTRAINT unique_ohlcv 
		UNIQUE (data_vendor_id, ticker_id, date));

COMMENT ON COLUMN securities.ohlcv.close IS 'The close price for the symbol in the given time period.';
COMMENT ON COLUMN securities.ohlcv.high IS 'The highest price for the symbol in the given time period.';
COMMENT ON COLUMN securities.ohlcv.low IS 'The lowest price for the symbol in the given time period.';
COMMENT ON COLUMN securities.ohlcv.open IS 'The open price for the symbol in the given time period.';
COMMENT ON COLUMN securities.ohlcv.volume IS 'The trading volume of the symbol in the given time period.';
COMMENT ON COLUMN securities.ohlcv.volume_weighted_average_price IS 'The volume weighted average price.';

CREATE TABLE securities.dividend_type (
    code char(2) PRIMARY KEY,
    description varchar(255),
	start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone);

COMMENT ON TABLE securities.dividend_type IS 'The type of dividend.';

COMMENT ON COLUMN securities.dividend_type.code IS 'A code used by to refer to this dividend type.';
COMMENT ON COLUMN securities.dividend_type.description IS 'A short description of this dividend type.';

INSERT INTO securities.dividend_type (code, description) VALUES
    ('CD', 'Dividend on consistent schedule'),
    ('SC', 'Special cash dividend'),
    ('LT', 'Long-Term capital gain distribution'),
    ('ST', 'Short-Term capital gain distribution');

CREATE TABLE securities.split (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    execution_date timestamp NULL,
    split_from integer NULL,
    split_to integer NULL,
	ticker_id integer NULL,
    ticker varchar(32) NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT unique_split
		UNIQUE (ticker, execution_date, split_from, split_to));

COMMENT ON TABLE securities.split IS 'Split contains data for a historical stock split, including the ticker symbol, the execution date, and the factors of the split ratio.';
COMMENT ON COLUMN securities.split.execution_date IS 'The execution date of the stock split. On this date the stock split was applied.';
COMMENT ON COLUMN securities.split.split_from IS 'The second number in the split ratio. For example: In a 2-for-1 split, split_from would be 1.';
COMMENT ON COLUMN securities.split.split_to IS 'The first number in the split ratio. For example: In a 2-for-1 split, split_to would be 2.';
COMMENT ON COLUMN securities.split.ticker IS 'The ticker symbol of the stock split.';

CREATE TABLE securities.dividend (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    cash_amount numeric(19,4) NULL,
    currency varchar(50) NULL,
    declaration_date timestamp NULL,
    type varchar(32) NULL,
    ex_dividend_date timestamp NULL,
    frequency integer NULL,
    pay_date timestamp NULL,
    record_date timestamp NULL,
	ticker_id integer NULL,
    ticker varchar(32) NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT fk_dividend_dividend_type
        FOREIGN KEY(type)
        REFERENCES securities.broker(id)
        ON DELETE SET NULL,

	CONSTRAINT unique_dividend 
		UNIQUE (cash_amount, ticker_id, ex_dividend_date, type));

COMMENT ON COLUMN securities.dividend.cash_amount IS 'The cash amount of the dividend per share owned.';
COMMENT ON COLUMN securities.dividend.currency IS 'The currency in which the dividend is paid.';
COMMENT ON COLUMN securities.dividend.declaration_date IS 'The date that the dividend was announced.';
COMMENT ON COLUMN securities.dividend.type IS 'The type of dividend. Dividends that have been paid and/or are expected to be paid on consistent schedules are denoted as CD. Special Cash dividends that have been paid that are infrequent or unusual, and/or can not be expected to occur in the future are denoted as SC. Long-Term and Short-Term capital gain distributions are denoted as LT and ST, respectively.';
COMMENT ON COLUMN securities.dividend.ex_dividend_date IS 'The date that the stock first trades without the dividend, determined by the exchange.';
COMMENT ON COLUMN securities.dividend.frequency IS 'The number of times per year the dividend is paid out. Possible values are 0 (one-time), 1 (annually), 2 (bi-annually), 4 (quarterly), and 12 (monthly).';
COMMENT ON COLUMN securities.dividend.pay_date IS 'The date that the dividend is paid out.';
COMMENT ON COLUMN securities.dividend.record_date IS 'The date that the stock must be held to receive the dividend, set by the company.';
COMMENT ON COLUMN securities.dividend.ticker IS 'The ticker symbol of the dividend.';

CREATE TABLE securities.broker (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    description varchar(255),
    start_date date NULL,
    end_date date NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE securities.broker IS 'An entity through which you can buy and sell securities.';

DELETE FROM securities.broker;
INSERT INTO securities.broker (code, description) VALUES
    ('IB', 'Interactive Brokers'),
    ('Commsec', 'Commonwealth Securities'),
    ('ABC', 'ABC Bullion'),
    ('Swyft', 'Swyft'),
    ('eBroker', 'eBroker');

CREATE TABLE securities.portfolio (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    description varchar(255),
    start_date date NULL,
    end_date date NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE securities.portfolio IS 'A grouping of accounts for specific purpose.';

DELETE FROM securities.portfolio;
INSERT INTO securities.portfolio (code, description) VALUES
    ('Rob and Sue', 'Rob and Sue'),
    ('Paper Trade', 'Paper Trade'),
    ('Superbebbs', 'Superbebbs');

CREATE TABLE securities.account (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    broker_id integer NULL, 
    portfolio_id integer NULL,
    description varchar(255),
    start_date date NULL,
    end_date date NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp,
    CONSTRAINT fk_account_broker
        FOREIGN KEY(broker_id)
        REFERENCES securities.broker(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_account_portfolio
        FOREIGN KEY(portfolio_id)
        REFERENCES securities.portfolio(id)
        ON DELETE SET NULL,
        CONSTRAINT unique_account
		UNIQUE (broker_id, portfolio_id));

COMMENT ON TABLE securities.account IS 'An account at a broker for a specific portfolio.';

DELETE FROM securities.account;
INSERT INTO securities.account (code, broker_id, description)
	SELECT 'Rob and Sue', id, Null FROM securities.broker where code = 'Commsec';
INSERT INTO securities.account (code, broker_id, description)
	SELECT 'Superbebbs Commsec', id, Null FROM securities.broker where code = 'Commsec';
INSERT INTO securities.account (code, broker_id, description)
	SELECT 'Superbebbs eBroker', id, Null FROM securities.broker where code = 'eBroker';
INSERT INTO securities.account (code, broker_id, description)
	SELECT 'Rob', id, Null FROM securities.broker where code = 'IB';
INSERT INTO securities.account (code, broker_id, description)
	SELECT 'Bullion', id, Null FROM securities.broker where code = 'ABC';
INSERT INTO securities.account (code, broker_id, description)
	SELECT 'Crypto', id, Null FROM securities.broker where code = 'Swyft';
INSERT INTO securities.account (code, broker_id, description)
	SELECT 'Paper Trade', id, Null FROM securities.broker where code = 'IB';

CREATE TABLE securities.analyst (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    description varchar(255),
    start_date date NULL,
    end_date date NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE securities.analyst IS 'An entity that gives stock recommendation.';

DELETE FROM securities.analyst;
INSERT INTO securities.analyst (code, description) VALUES
    ('Stock Earnings', Null),
    ('InvestorPlace', Null),
    ('Fat Tail Investment Research', Null),
    ('Motley Fool', Null);

CREATE TABLE securities.newsletter (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    analyst_id integer NULL, 
    description varchar(255),
    start_date date NULL,
    end_date date NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp,
    CONSTRAINT fk_newsletter_analyst
        FOREIGN KEY(analyst_id)
        REFERENCES securities.analyst(id)
        ON DELETE SET NULL);

COMMENT ON TABLE securities.newsletter IS 'A stock recommendation newsletter.';

DELETE FROM securities.newsletter;
INSERT INTO securities.newsletter (code, analyst_id, description)
	SELECT 'Weekly Winners', id, Null FROM securities.analyst where code = 'Stock Earnings';
INSERT INTO securities.newsletter (code, analyst_id, description)
	SELECT 'Innovation Investor', id, Null FROM securities.analyst where code = 'InvestorPlace';        
INSERT INTO securities.newsletter (code, analyst_id, description)
	SELECT 'Exponential Stock Investor', id, Null FROM securities.analyst where code = 'Fat Tail Investment Research';
INSERT INTO securities.newsletter (code, analyst_id, description)
	SELECT 'Income Extra', id, Null FROM securities.analyst where code = 'Motley Fool';
INSERT INTO securities.newsletter (code, analyst_id, description)
	SELECT 'Preferred Spotlight', id, Null FROM securities.analyst where code = 'InvestorPlace';


CREATE TABLE securities.action (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    description varchar(255),
    start_date date NULL,
    end_date date NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE securities.action IS 'The type of order being submitted.';

DELETE FROM securities.action;
INSERT INTO securities.action (code, description) VALUES
    ('Buy to Open', Null),
    ('Sell to Open', Null),
    ('Buy to Close', Null),
    ('Sell to Close', Null),
    ('Buy to Cover', Null),
    ('Sell Short', Null);

CREATE TABLE IF NOT EXISTS securities.trade_type
(
    id integer PRIMARY KEY  GENERATED ALWAYS AS IDENTITY,
    code character varying(64) UNIQUE NOT NULL,
    description character varying(1000),
    created_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_updated_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    the_options_playbook_url character varying(254),
    market_outlook character varying(64),
    risk character varying(64),
    reward character varying(64),
    increase_in_volatility character varying(64),
    options_trading_iq_url character varying(254),
    quantified_strategies_url character varying(254),
    options_industry_council_url character varying(254),
    tasty_live_url character varying(254),
    option_alpha_url character varying(254),
    time_erosion character varying(64),
    break_even_point character varying(1000)
)

COMMENT ON TABLE securities.trade_type IS 'The trade_type being used for the trade.';

CREATE TABLE securities.strategy (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    description varchar(255),
    start_date date NULL,
    end_date date NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE securities.strategy IS 'The strategy being used for the trade.';

DELETE FROM securities.strategy;
INSERT INTO securities.strategy (code, description) VALUES
    ('MA Crossover', Null),
    ('Dividend Income', Null),
    ('Momentum', Null);

CREATE TABLE securities.trade_status (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    description varchar(255),
    start_date date NULL,
    end_date date NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE securities.trade_status IS 'Represents the current stage of the trade. A trade can one or several legs (especially for options)';

DELETE FROM securities.trade_status;
INSERT INTO securities.trade_status (code, description) VALUES
    ('Planning', 'Still working out the details of the trade'),
    ('Ready to order', 'The trade is ready to for orders to be placed'),
    ('In progress', 'Initial orders for the trade have been submitted'),
    ('Finalised', 'All orders and legs are closed');

CREATE TABLE securities.order_status (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    description varchar(255),
    start_date date NULL,
    end_date date NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE securities.order_status IS 'Represents the current stage of the order';

DELETE FROM securities.order_status;
INSERT INTO securities.order_status (code, description) VALUES
    ('Not ready to order', 'Still working out the details of the order.'),
    ('Not ordered', 'The order has not been submitted to the exchange.'),
    ('Ordered', 'The order has been submitted but has not been filled.'),
    ('Open', 'The order has been filled.'),
    ('Closed', 'The order has been finalised.');

CREATE TABLE securities.leg_status (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    description varchar(255),
    start_date date NULL,
    end_date date NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE securities.leg_status IS 'Represents the current stage of a leg of a trade.';

DELETE FROM securities.leg_status;
INSERT INTO securities.leg_status (code, description) VALUES
    ('Not ready to order', 'Still working out the details of the leg.'),
    ('Ready to order', 'The leg is ready to be submitted'),
    ('Ordered', 'The leg has been submitted'),
    ('Filled', 'The leg has been filled'),
    ('Closed', 'The leg has been finalised.');

CREATE TABLE securities.trade (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    portfolio_id integer NOT NULL,
    strategy_id integer NOT NULL,
    trade_type_id integer NOT NULL,
    trade_status_id integer NOT NULL,
    name varchar(32) NOT NULL,
    description varchar(1000) NULL,
    entry_reason varchar(1000) NULL,
    exit_criteria varchar(1000) NULL,
    notes varchar(255) NULL,
    mistake char(1) null,
    risk_amount numeric(19,4) NULL,
    risk_percent numeric(4,1) NULL,
    return_amount numeric(19,4) NULL,
    return_percent numeric(4,1) NULL,  
    return_r varchar(32) NULL,
    risk_reward_ratio varchar(32) NULL,
    newsletter_id integer NULL,
    newsletter_date date NULL,
    newsletter_time time NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp, 
    CONSTRAINT fk_trade_strategy
        FOREIGN KEY(strategy_id)
        REFERENCES securities.strategy(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_trade_trade_type
        FOREIGN KEY(trade_type_id)
        REFERENCES securities.trade_type(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_trade_portfolio
        FOREIGN KEY(portfolio_id)
        REFERENCES securities.portfolio(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_trade_status
        FOREIGN KEY(trade_status_id)
        REFERENCES securities.trade_status(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_trade_newsletter
        FOREIGN KEY(newsletter_id)
        REFERENCES securities.newsletter(id)
        ON DELETE SET NULL);

COMMENT ON TABLE securities.trade IS 'The trading plan. See https://investor.com/trading/best-trading-journals';

CREATE TABLE securities.order (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    trade_id integer NOT NULL,
    account_id integer NOT NULL,
    order_status_id integer NOT NULL,
    action_id integer NOT NULL,
	name varchar(32) NOT NULL,
	description varchar(255) NULL,
    limit_price numeric(19,4) NULL,
    quantity numeric(19,0) NULL,
	stop_price numeric(19,4) NULL,
	target_price numeric(19,4) NULL,
    order_date date NULL,
    order_time time NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp,
    CONSTRAINT fk_order_trade
        FOREIGN KEY(trade_id)
        REFERENCES securities.trade(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_order_account
        FOREIGN KEY(account_id)
        REFERENCES securities.account(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_order_order_status
        FOREIGN KEY(order_status_id)
        REFERENCES securities.order_status(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_order_action
        FOREIGN KEY(action_id)
        REFERENCES securities.action(id)
        ON DELETE SET NULL);

COMMENT ON TABLE securities.order IS 'An order placed on a specific account at a broker';

CREATE TABLE securities.leg (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    trade_id integer NOT NULL,
    order_id integer NOT NULL,
    ticker_id integer NOT NULL,
    leg_status_id integer NOT NULL,
    action_id integer NOT NULL,
    request_price numeric(19,4) NULL,
    request_quantity numeric(19,0) NULL,
	request_date timestamp NULL,
	stop_price numeric(19,4) NULL,
	target_price numeric(19,4) NULL,
    description varchar(255) NULL,
	actual_unit_price numeric(19,4) NULL,
    actual_quantity numeric(19,0) NULL,
    actual_date timestamp NULL,
    stock_total numeric(19,4) NULL,
    commission numeric(19,4) NULL,
    tax numeric(19,4) NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp,
    CONSTRAINT fk_leg_trade
        FOREIGN KEY(trade_id)
        REFERENCES securities.trade(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_leg_order
        FOREIGN KEY(order_id)
        REFERENCES securities.order(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_leg_ticker
        FOREIGN KEY(ticker_id)
        REFERENCES securities.ticker(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_leg_status
        FOREIGN KEY(leg_status_id)
        REFERENCES securities.leg_status(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_leg_action
        FOREIGN KEY(action_id)
        REFERENCES securities.action(id)
        ON DELETE SET NULL);

COMMENT ON TABLE securities.leg IS 'A trade is made up of one or more legs';

CREATE TABLE securities.transaction (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    trade_id integer NOT NULL,
	order_id integer NOT NULL,
    leg_id integer NOT NULL,
    ticker_id integer NOT NULL,
    action_id integer NOT NULL,
    unit_price numeric(19,4) NULL,
    quantity numeric(19,0) NULL,
    stock_total numeric(19,4) NULL,
    commission numeric(19,4) NULL,
    tax numeric(19,4) NULL,
    transaction_date date NULL,
    transaction_time time NULL,
    description varchar(255) NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp,
    CONSTRAINT fk_transaction_order
        FOREIGN KEY(order_id)
        REFERENCES securities.order(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_transaction_leg
        FOREIGN KEY(leg_id)
        REFERENCES securities.leg(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_transaction_trade
        FOREIGN KEY(trade_id)
        REFERENCES securities.trade(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_transaction_ticker
        FOREIGN KEY(ticker_id)
        REFERENCES securities.ticker(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_transaction_action
        FOREIGN KEY(action_id)
        REFERENCES securities.action(id)
        ON DELETE SET NULL);

COMMENT ON TABLE securities.transaction IS 'The actual transactions that take place to fill an order';
