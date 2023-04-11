-- Create Database
CREATE DATABASE house_rental_database_system;
GO
USE house_rental_database_system;
GO
--********************************************************************************************************--

-- Create the APP_USER table
CREATE TABLE app_user
  (
     user_id   INTEGER NOT NULL,
     user_name VARCHAR(25),
     user_type VARCHAR(20) CHECK(user_type IN ('LANDLORD', 'MANAGEMENT_COMPANY','BROKER_FIRM')), --Check1
	 password VARCHAR(50) NOT NULL,
     CONSTRAINT userid_pk PRIMARY KEY (user_id)
  );
GO
--********************************************************************************************************--

-- Create the LANDLORD table
CREATE TABLE landlords
  (
     landlord_id   INTEGER NOT NULL,
     price         DECIMAL(10, 2),
     city          VARCHAR(50),
     state         VARCHAR(50),
     zip           VARCHAR(10),
     landlord_type VARCHAR(20) CHECK(landlord_type IN ('INDIVIDUALLY_MANAGED','MANAGEMENT_DRIVEN')), --Check2
     user_id       INT NOT NULL,
     CONSTRAINT landlordid_pk PRIMARY KEY (landlord_id),
     CONSTRAINT useridlandlords_fk FOREIGN KEY (user_id) REFERENCES app_user(
     user_id)
  );
GO
--********************************************************************************************************--

-- Create the MANAGEMENT_COMPANY table
CREATE TABLE management_company
  (
     company_id INT NOT NULL,
     price      DECIMAL(10, 2),
     user_id    INT NOT NULL,
     CONSTRAINT companyid_pk PRIMARY KEY (company_id),
     CONSTRAINT useridmgmt_fk FOREIGN KEY (user_id) REFERENCES app_user(user_id)
  );
GO
--********************************************************************************************************--

-- Create the BROKER_FIRM table
CREATE TABLE broker_firm
  (
     firm_id         INT NOT NULL,
     brokerage_rates DECIMAL(10, 2),
     company_id      INT,
     user_id         INT NOT NULL,
     CONSTRAINT firmid_pk PRIMARY KEY (firm_id),
     CONSTRAINT companyidbrokerfirm_fk FOREIGN KEY (company_id) REFERENCES
     management_company(company_id),
     CONSTRAINT useridbrfirm_fk FOREIGN KEY (user_id) REFERENCES app_user(
     user_id)
  );
GO
--********************************************************************************************************--

-- Create the PROPERTY_DETAILS table
CREATE TABLE property_details
  (
     property_id    INT NOT NULL,
     property_type  VARCHAR(50),
     property_owner VARCHAR(100) CONSTRAINT propertyowner_nn CHECK(property_owner IS NOT NULL), --Check3
     city           VARCHAR(50),
     state          VARCHAR(50),
     zip            VARCHAR(10),
     company_id     INT,
     landlord_id    INT,
     firm_id        INT,
     CONSTRAINT propertyid_pk PRIMARY KEY (property_id),
     CONSTRAINT companyidpropdet_fk FOREIGN KEY (company_id) REFERENCES
     management_company(company_id),
     CONSTRAINT landlordidpropdet_fk FOREIGN KEY (landlord_id) REFERENCES
     landlords(landlord_id),
     CONSTRAINT firmidpropdet_fk FOREIGN KEY (firm_id) REFERENCES broker_firm(
     firm_id)
  );
GO
--********************************************************************************************************--

-- Create the INDIVIDUALLY_MANAGED table
CREATE TABLE individually_managed
  (
     indmgmt_lid      INT NOT NULL,
     firm_id          INT,
     agreement_period VARCHAR(50),
     landlord_id      INT NOT NULL,
     CONSTRAINT indmgmtlid_pk PRIMARY KEY (indmgmt_lid),
     CONSTRAINT firmidindmgmt_fk FOREIGN KEY (firm_id) REFERENCES broker_firm(
     firm_id),
     CONSTRAINT landlordidindmgmt_fk FOREIGN KEY (landlord_id) REFERENCES
     landlords(landlord_id)
  );
GO
--********************************************************************************************************--

-- Create the MANAGEMENT_DRIVEN table
CREATE TABLE management_driven
  (
     mgmtdriven_lid INT NOT NULL,
     company_id     INT,
     landlord_id    INT NOT NULL,
     CONSTRAINT mgmtdrivenlid_pk PRIMARY KEY (mgmtdriven_lid),
     CONSTRAINT companyidmgmtdr_fk FOREIGN KEY (company_id) REFERENCES
     management_company(company_id),
     CONSTRAINT landlordidmgmtdr_fk FOREIGN KEY (landlord_id) REFERENCES
     landlords(landlord_id)
  );
GO
--********************************************************************************************************--

-- Create the CUSTOMERS table
CREATE TABLE customers
  (
     customer_id   INT NOT NULL,
     NAME          VARCHAR(100),
     city          VARCHAR(50),
     state         VARCHAR(50),
     zip           VARCHAR(10),
     company_id    INT,
     firm_id       INT,
     date_of_brith DATE,
     CONSTRAINT customerid_pk PRIMARY KEY (customer_id),
     CONSTRAINT companyidcust_fk FOREIGN KEY (company_id) REFERENCES
     management_company(company_id),
     CONSTRAINT firmidcust_fk FOREIGN KEY (firm_id) REFERENCES broker_firm(
     firm_id)
  ); 
GO
--********************************************************************************************************--

-- Create the BROKERS table
CREATE TABLE brokers
  (
     broker_id INT NOT NULL,
     NAME      VARCHAR(100),
     city      VARCHAR(50),
     state     VARCHAR(50),
     zip       VARCHAR(10),
     firm_id   INT,
     CONSTRAINT brokerid_pk PRIMARY KEY (broker_id),
     CONSTRAINT firmidbrok_fk FOREIGN KEY (firm_id) REFERENCES broker_firm(
     firm_id)
  );
GO
--********************************************************************************************************--

-- Create the AST_BROKERS table
CREATE TABLE ast_brokers
  (
     astbroker_id INT NOT NULL,
     NAME         VARCHAR(100),
     broker_id    INT,
     CONSTRAINT astbrokerid_pk PRIMARY KEY (astbroker_id),
     CONSTRAINT brokerid_fk FOREIGN KEY (broker_id) REFERENCES brokers(broker_id
     )
  ); 