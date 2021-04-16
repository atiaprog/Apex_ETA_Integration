--ALTER TABLE TRS_ETA_INVOICES_HEADER
 --DROP PRIMARY KEY CASCADE;

--DROP TABLE TRS_ETA_INVOICES_HEADER CASCADE CONSTRAINTS;

CREATE TABLE TRS_ETA_INVOICES_HEADER
(
  CUSTOMER_TRX_ID                 NUMBER(15)    NOT NULL,
  ISSUER_TYPE                     VARCHAR2(100 BYTE),
  ISSUER_ID                       VARCHAR2(100 BYTE),
  ISSUER_NAME                     VARCHAR2(360 BYTE) NOT NULL,
  ISSUER_ADDRESS_BRANCH_ID        VARCHAR2(100 BYTE),
  ISSUER_ADDRESS_COUNTRY          VARCHAR2(60 BYTE),
  ISSUER_ADDRESS_GOVERNATE        VARCHAR2(30 BYTE),
  ISSUER_ADDRESS_REGION_CITY      VARCHAR2(240 BYTE),
  ISSUER_ADDRESS_STREET           VARCHAR2(240 BYTE),
  ISSUER_ADDRESS_BUILDING_NUMBER  VARCHAR2(100 BYTE),
  ISSUER_ADDRESS_POSTAL_CODE      VARCHAR2(100 BYTE),
  ISSUER_ADDRESS_FLOOR            VARCHAR2(150 BYTE),
  ISSUER_ADDRESS_ROOM             VARCHAR2(150 BYTE),
  ISSUER_ADDRESS_LANDMARK         VARCHAR2(150 BYTE),
  ISSUER_ADDRESS_ADDITIONAL_INFO  VARCHAR2(150 BYTE),
  RECEIVER_TYPE                   VARCHAR2(100 BYTE),
  RECEIVER_ID                     VARCHAR2(50 BYTE),
  RECEIVER_NAME                   VARCHAR2(360 BYTE) NOT NULL,
  RECEIVER_ADDRESS_COUNTRY        VARCHAR2(2 BYTE) NOT NULL,
  RECEIVER_ADDRESS_GOVERNATE      VARCHAR2(60 BYTE),
  RECEIVER_ADDRESS_REGION_CITY    VARCHAR2(60 BYTE),
  RECEIVER_ADDRESS_STREET         VARCHAR2(150 BYTE),
  RECEIVER_ADDRESS_BUILDING_NUM   VARCHAR2(150 BYTE),
  RECEIVER_ADDRESS_POSTAL_CODE    VARCHAR2(150 BYTE),
  RECEIVER_ADDRESS_FLOOR          VARCHAR2(150 BYTE),
  RECEIVER_ADDRESS_ROOM           VARCHAR2(150 BYTE),
  RECEIVER_ADDRESS_LANDMARK       VARCHAR2(150 BYTE),
  RECEIVER_ADDRESS_ADD_INFO       VARCHAR2(150 BYTE),
  DOCUMENT_TYPE                   VARCHAR2(1 BYTE),
  DOCUMENT_TYPE_VERSION           VARCHAR2(8 BYTE),
  DATETIME_ISSUED                 DATE          NOT NULL,
  TAX_PAYER_ACTIVITY_CODE         VARCHAR2(150 BYTE),
  INTERNAL_ID                     VARCHAR2(20 BYTE) NOT NULL,
  PURCHASE_ORDER_REFERENCE        VARCHAR2(50 BYTE),
  PURCHASE_ORDER_DESCRIPTION      VARCHAR2(150 BYTE),
  SALES_ORDER_REFERENCE           VARCHAR2(150 BYTE),
  SALES_ORDER_DESCRIPTION         VARCHAR2(150 BYTE),
  PROFORMA_INV_NUM                VARCHAR2(150 BYTE),
  PAYMENT_BANK_NAME               VARCHAR2(150 BYTE),
  PAYMENT_BANK_ADDRESS            VARCHAR2(150 BYTE),
  PAYMENT_BANK_ACCOUNTNO          VARCHAR2(150 BYTE),
  PAYMENT_BANK_ACCOUNT_IBAN       VARCHAR2(150 BYTE),
  PAYMENT_SWIFT_CODE              VARCHAR2(150 BYTE),
  PAYMENT_TERMS                   VARCHAR2(15 BYTE),
  DELIVERY_APPROACH               VARCHAR2(150 BYTE),
  DELIVERY_PACKAGING              VARCHAR2(150 BYTE),
  DELIVERY_DATE_VALIDITY          VARCHAR2(150 BYTE),
  DEVLIVERY_EXPORT_PORT           VARCHAR2(150 BYTE),
  DELIVERY_COUNTRY_OF_ORIGIN      VARCHAR2(60 BYTE),
  DELIVERY_GROSS_WEIGHT           VARCHAR2(150 BYTE),
  DELIVERY_NET_WEIGHT             VARCHAR2(150 BYTE),
  DELIVERY_TERMS                  VARCHAR2(150 BYTE),
  TOTAL_SALES_AMT                 NUMBER,
  TOTAL_DISCOUNT_AMT              NUMBER,
  NET_AMT                         NUMBER,
  TAX_TOTAL_TAX_TYPE_vat          VARCHAR2(150 BYTE),
  TAX_TOTAL_AMT_vat               NUMBER,
  TAX_TOTAL_TAX_TYPE_wht          VARCHAR2(150 BYTE),
  TAX_TOTAL_AMT_wht               NUMBER,
  EXTRA_DISC_AMOUNT               NUMBER,
  TOTAL_ITEM_DISC_AMOUNT          NUMBER,
  TOTAL_AMOUNT                    NUMBER,
  BILL_TO_CUSTOMER_NUM            VARCHAR2(100 BYTE),
  SHIP_TO_CUSTOMER_NUM            VARCHAR2(100 BYTE),
  UUID                            VARCHAR2(200 BYTE),
  SUBMITED                        VARCHAR2(100 BYTE),
  SIGNED                          VARCHAR2(100 BYTE),
  SIGNEDID                        VARCHAR2(100 BYTE),
  SIGNATURE                       CLOB
);

CREATE INDEX TRS_ETA_INV_CUSTOMER_TRX_ID ON TRS_ETA_INVOICES_HEADER
(CUSTOMER_TRX_ID);


ALTER TABLE TRS_ETA_INVOICES_HEADER ADD (
  CONSTRAINT TRS_ETA_INVOICES_HEADER_PK
  PRIMARY KEY
  (CUSTOMER_TRX_ID)
  USING INDEX TRS_ETA_INV_CUSTOMER_TRX_ID
  ENABLE VALIDATE);
