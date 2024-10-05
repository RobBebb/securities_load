ALTER TABLE securities.ticker
DROP CONSTRAINT IF EXISTS fk_ticker_sector;
ALTER TABLE securities.ticker
DROP CONSTRAINT IF EXISTS fk_ticker_industry_group;
ALTER TABLE securities.ticker
DROP CONSTRAINT IF EXISTS fk_ticker_industry;
ALTER TABLE securities.ticker
DROP CONSTRAINT IF EXISTS fk_ticker_sub_industry;
DROP TABLE IF EXISTS securities.gics_sub_industry;
DROP TABLE IF EXISTS securities.gics_industry;
DROP TABLE IF EXISTS securities.gics_industry_group;
DROP TABLE IF EXISTS securities.gics_sector;

CREATE TABLE IF NOT EXISTS securities.gics_sector (
	id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code char(2) UNIQUE NOT NULL,
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
	('60', 'Real Estate', 'XPJ', 'The Real Estate Sector contains companies engaged in real estate development and operation. It also includes companies offering real estate related services and Equity Real Estate Investment Trusts (REITs).', '1999-01-01', NULL),
	('90', 'Class Pend', '', 'Classification Pending.', '1999-01-01', NULL),
	('95', 'Not Applic', '', 'Not Applicable', '1999-01-01', NULL);


CREATE TABLE IF NOT EXISTS securities.gics_industry_group (
	id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code char(4) UNIQUE NOT NULL,
    name varchar(255) NOT NULL,
    sector_id integer DEFAULT NULL,
    sector_code char(2) DEFAULT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT FK_gics_industry_group_gics_sector 
        FOREIGN KEY(sector_id)
        REFERENCES securities.gics_sector(id)
        ON DELETE SET NULL);

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
	('3520', 'Pharmaceuticals, Biotechnology & Life Sciences', '35', '1999-01-01', NULL),
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
	('6020', 'Real Estate Management & Development', '60', '2023-03-17', NULL),
	('9090', 'Class Pend', '90', '1999-01-01', NULL),
	('9595', 'Not Applic', '95', '1999-01-01', NULL);

WITH subquery AS (
    SELECT s.id, s.code
    FROM  securities.gics_sector s, securities.gics_industry_group i WHERE s.code = i.sector_code
)
UPDATE securities.gics_industry_group
SET sector_id = subquery.id
FROM subquery
WHERE securities.gics_industry_group.sector_code = subquery.code;

CREATE TABLE IF NOT EXISTS securities.gics_industry (
	id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code char(6) UNIQUE NOT NULL,
    name varchar(255) NOT NULL,
    industry_group_id integer DEFAULT NULL,
    industry_group_code char(4) DEFAULT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT FK_gics_industry_gics_industry_group
        FOREIGN KEY(industry_group_id)
        REFERENCES securities.gics_industry_group(id)
        ON DELETE SET NULL);

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
	('602010', 'Real Estate Management & Development', '6020', '2023-03-17', NULL),
    ('909090', 'Class Pend', '9090', '1999-01-01', NULL),
	('959595', 'Not Applic', '9595', '1999-01-01', NULL);

WITH subquery AS (
    SELECT g.id, g.code
    FROM  securities.gics_industry_group g, securities.gics_industry i WHERE g.code = i.industry_group_code 
)
UPDATE securities.gics_industry
SET industry_group_id = subquery.id
FROM subquery
WHERE securities.gics_industry.industry_group_code = subquery.code;

CREATE TABLE IF NOT EXISTS securities.gics_sub_industry (
	id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code char(8) UNIQUE NOT NULL,
    name varchar(255) NOT NULL,
    description varchar(1000) DEFAULT NULL,
    industry_id integer DEFAULT NULL,
    industry_code char(6) DEFAULT NULL,
    start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT FK_gics_sub_industry_gics_industry 
        FOREIGN KEY(industry_id)
        REFERENCES securities.gics_industry(id)
        ON DELETE SET NULL);

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
	('60201040', 'Real Estate Services', 'Real estate service providers such as real estate agents, brokers & real estate appraisers.', '602010', '2023-03-17', NULL),
    ('90909090', 'Class Pend', '', '909090', '1999-01-01', NULL),
	('95959595', 'Not Applic', '', '959595', '1999-01-01', NULL);

WITH subquery AS (
    SELECT i.id, i.code
    FROM  securities.gics_industry i, securities.gics_sub_industry s WHERE i.code = s.industry_code 
)
UPDATE securities.gics_sub_industry
SET industry_id = subquery.id
FROM subquery
WHERE securities.gics_sub_industry.industry_code = subquery.code;


ALTER TABLE securities.ticker
    ADD COLUMN IF NOT EXISTS gics_sector_id integer,
    ADD COLUMN IF NOT EXISTS gics_industry_group_id integer,
    ADD COLUMN IF NOT EXISTS gics_industry_id integer,
    ADD COLUMN IF NOT EXISTS gics_sub_industry_id integer;

ALTER TABLE securities.ticker
    DROP COLUMN IF EXISTS gics_sector_code,
    DROP COLUMN IF EXISTS gics_industry_group_code,
    DROP COLUMN IF EXISTS gics_industry_code,
    DROP COLUMN IF EXISTS gics_sub_industry_code;

ALTER TABLE securities.ticker
    ADD CONSTRAINT fk_ticker_sector
        FOREIGN KEY(gics_sector_id)
        REFERENCES securities.gics_sector(id)
        ON DELETE NO ACTION;
ALTER TABLE securities.ticker
    ADD CONSTRAINT fk_ticker_industry_group
        FOREIGN KEY(gics_industry_group_id)
        REFERENCES securities.gics_industry_group(id)
        ON DELETE NO ACTION;
ALTER TABLE securities.ticker
    ADD CONSTRAINT fk_ticker_industry
        FOREIGN KEY(gics_industry_id)
        REFERENCES securities.gics_industry(id)
        ON DELETE NO ACTION;
ALTER TABLE securities.ticker
    ADD CONSTRAINT fk_ticker_sub_industry
        FOREIGN KEY(gics_sub_industry_id)
        REFERENCES securities.gics_sub_industry(id)
        ON DELETE NO ACTION;

CREATE INDEX IF NOT EXISTS ix_ticker_exchange_id_ticker ON securities.ticker( exchange_id, ticker );
CREATE INDEX IF NOT EXISTS ix_ohlcv_ticker_id ON securities.ohlcv(ticker_id);