/**
    Developed by MO.atia  
    Version R2  1.9.22
*/

CREATE OR REPLACE PACKAGE eta_pkg
AS
    FUNCTION get_eta_json_payload_skeleton (p_trx_number IN NUMBER)
        RETURN CLOB;

    FUNCTION get_eta_json_payload (p_trx_number IN NUMBER)
        RETURN CLOB;

    FUNCTION get_eta_json_batch (p_trx_from IN NUMBER, p_trx_to NUMBER)
        RETURN CLOB;

    FUNCTION get_eta_json_batch (p_trx_from IN DATE, p_trx_to DATE)
        RETURN CLOB;

    FUNCTION get_token (p_host            VARCHAR2,
                        p_cust_id         VARCHAR2,
                        p_client_secert   VARCHAR2)
        RETURN VARCHAR2;

    FUNCTION submitDocument (p_host VARCHAR2, p_trx_number NUMBER)
        RETURN CLOB;

    FUNCTION cancelDocument (uuid VARCHAR2)
        RETURN BOOLEAN;

    FUNCTION printDocument (uuid VARCHAR2)
        RETURN BLOB;
        
    FUNCTION getRecentDocuments(p_host  varchar2,access_token varchar2)
    return clob;  
    
    FUNCTION getDocumentStatus(p_host  varchar2,documentUUID VARCHAR2,access_token varchar2)
    return varchar2;
       
END eta_pkg;

CREATE OR REPLACE PACKAGE BODY eta_pkg
AS
    FUNCTION get_eta_json_payload_skeleton (p_trx_number IN NUMBER)
        RETURN CLOB
    IS
        l_data   CLOB;

        l_temp   CLOB;
    BEGIN
        APEX_JSON.initialize_clob_output;
        APEX_JSON.open_object;
        --Object first documents object
        APEX_JSON.open_array ('documents');
        APEX_JSON.open_object;
        APEX_JSON.open_object ('issuer');
        APEX_JSON.open_object ('address');
        APEX_JSON.write ('branchID', '0');
        APEX_JSON.write ('country', 'EG');
        APEX_JSON.write ('governate', 'cairo');
        APEX_JSON.write_raw ('regionCity', '"' || 'Al Sharkia' || '"');
        APEX_JSON.write_raw ('street', '"' || '21 alazher Street ' || '"');
        APEX_JSON.write_raw ('buildingNumber', '"' || '21' || '"');
        APEX_JSON.write ('postalCode', '47700');
        APEX_JSON.write ('floor', 'Seven');
        APEX_JSON.write ('room', '3');
        APEX_JSON.write ('landmark', 'Awlad Gawd');
        APEX_JSON.write ('additionalInformation', 'love is awsome');
        APEX_JSON.close_object;
        --Close Address structure
        APEX_JSON.write ('type', 'B');
        APEX_JSON.write ('id', '124545');           -- Tax Registration Number
        APEX_JSON.write_raw ('name', '"' || 'Elsewedy Electric' || '"'); -- Name of Issuer
        APEX_JSON.close_object;
        --Close issuer strucure
        APEX_JSON.open_object ('receiver');
        APEX_JSON.open_object ('address');
        APEX_JSON.write ('country', 'Egypt');
        APEX_JSON.write ('governate', 'Cairo');
        APEX_JSON.write ('regionCity', 'Al About City');
        APEX_JSON.write_raw ('street', '"' || '8 omar ben khtab ' || '"');
        APEX_JSON.write_raw ('buildingNumber', '"' || '32' || '"');
        APEX_JSON.write ('postalCode', 'NA');
        APEX_JSON.write ('floor', 'NA');
        APEX_JSON.write ('room', 'NA');
        APEX_JSON.write ('landmark', 'NA');
        APEX_JSON.write ('additionalInformation', 'NA');
        APEX_JSON.close_object;
        --close Address  structure
        APEX_JSON.write ('type', 'B'); --B for Business P for Person F for foriegn
        APEX_JSON.write ('id', '454545');             --Tax Registrtion Number
        APEX_JSON.write_raw ('name', '"' || 'Star Sat' || '"');
        APEX_JSON.close_object;
        --close Receiver structure
        APEX_JSON.write ('documentType', 'I'); --I for Invoice  C for CreditMemo  D for DepitMemo
        APEX_JSON.write ('documentTypeVersion', '1.0'); -- 0.9 without Signature  1.0  Signature
        APEX_JSON.write ('dateTimeIssued', '2021-03-08T00:00:00Z'); --UTC Time
        APEX_JSON.write ('taxpayerActivityCode', '2420');
        APEX_JSON.write ('internalID', '997444');             --invoice number
        APEX_JSON.write ('purchaseOrderReference', 'NA');
        APEX_JSON.write ('purchaseOrderDescription', 'NA');
        APEX_JSON.write ('salesOrderReference', 'NA');
        APEX_JSON.write ('salesOrderDescription', 'NA');
        APEX_JSON.write ('proformaInvoiceNumber', 'NA');
        APEX_JSON.open_object ('payment');
        APEX_JSON.write ('bankName', 'QNB Bank');
        APEX_JSON.write ('bankAddress', '123455');
        APEX_JSON.write ('bankAccountNo', '125454');
        APEX_JSON.write ('bankAccountIBAN', '454545');
        APEX_JSON.write ('swiftCode', '4545450145');
        APEX_JSON.write ('terms', '1545455454');
        APEX_JSON.close_object;
        --close payment structure
        APEX_JSON.open_object ('delivery');
        APEX_JSON.write ('approach', 'deleivery approche');
        APEX_JSON.write ('packaging', 'Packaing ');
        APEX_JSON.write ('dateValidity', '2022-03-08T00:00:00Z');
        APEX_JSON.write ('exportPort', 'portSaid Port');
        APEX_JSON.write ('countryOfOrigin', 'Egypt');
        APEX_JSON.write_raw ('grossWeight', 0.00);
        APEX_JSON.write_raw ('netWeight', 0.00);
        APEX_JSON.write ('terms', '50% in Advance and 50% later');
        APEX_JSON.close_object;
        --close delivery structure
        APEX_JSON.open_array ('invoiceLines');
        -- Open Invoice Lines Array
        APEX_JSON.open_object;
        APEX_JSON.write_raw ('description',
                             '"' || 'Description of Item' || '"');
        APEX_JSON.write ('itemType', 'GS1');              -- TYPE : GS1 or EGS
        APEX_JSON.write ('itemCode', '454545554111214545'); --GS1  or EGS Item Code
        APEX_JSON.write ('unitType', 'EAT');
        APEX_JSON.write_raw ('quantity', 1.00000);
        APEX_JSON.open_object ('unitValue');
        APEX_JSON.write ('currencySold', 'EGP');
        APEX_JSON.write_raw ('amountEGP', 23.00000);
        APEX_JSON.write_raw ('amountSold', 0.00000);
        APEX_JSON.write_raw ('currencyExchangeRate', 0.00000);
        APEX_JSON.close_object;
        --close unit value  strucrure
        APEX_JSON.write_raw ('salesTotal', 0.00000);
        APEX_JSON.write_raw ('total', 0.00000);
        -- Eq:  (netTotal - itemsDiscount) + taxAmount
        APEX_JSON.write_raw ('valueDifference', 0.00000);
        --special case  on tax
        APEX_JSON.write_raw ('totalTaxableFees', 0.00000);
        APEX_JSON.write_raw ('netTotal', 0.00000);
        -- Eq: (salesTotals - discountAmount)
        APEX_JSON.write_raw ('itemsDiscount', 12.22785);
        APEX_JSON.open_object ('discount');
        APEX_JSON.write_raw ('rate', 5.00);       --- Item Discount Percentage
        APEX_JSON.write_raw ('amount', 23.123454);
        APEX_JSON.close_object;
        --Close invoiceLines discount
        APEX_JSON.open_array ('taxableItems');
        APEX_JSON.open_object;
        APEX_JSON.write ('taxType', 'T1');
        APEX_JSON.write ('amount', 23.12345);
        -- EQ:  (netAmount * TaxRate) / 1c_lines.00
        APEX_JSON.write ('subType', 'W004');
        -- no Sub if not aval
        APEX_JSON.write ('rate', 23.12);
        --Percentage
        APEX_JSON.close_object;
        APEX_JSON.open_object;
        APEX_JSON.write ('taxType', 'T4');
        APEX_JSON.write ('amount', 23.12345);
        -- EQ:  (netAmount * TaxRate) / 1c_lines.00
        APEX_JSON.write ('subType', 'W004');
        -- no Sub if not aval
        APEX_JSON.write ('rate', 23.12);                          --Percentage
        APEX_JSON.close_object;
        APEX_JSON.close_array;
        --close invoiceLines taxbleItems array
        APEX_JSON.write ('internalCode', 'IT-54545');
        APEX_JSON.close_object;
        --close invoiceLines structure object
        APEX_JSON.close_array;
        --close invoiceLines structure array
        APEX_JSON.write_raw ('totalSalesAmount', 23.00000); --Sum all all InvoiceLine/SalesTotal items
        APEX_JSON.write_raw ('totalDiscountAmount', 23.00000);
        APEX_JSON.write_raw ('netAmount', 23.00000); -- TotalSales  TotalDiscount
        APEX_JSON.open_array ('taxTotals');
        APEX_JSON.open_object;
        APEX_JSON.write ('taxType', 'T1');
        APEX_JSON.write ('amount', 23.00000);
        APEX_JSON.close_object;
        APEX_JSON.open_object;
        APEX_JSON.write ('taxType', 'T4');
        APEX_JSON.write ('amount', 23.000000);
        APEX_JSON.close_object;
        --close taxTotals object
        APEX_JSON.close_array;
        -- close array for taxTotals
        APEX_JSON.write_raw ('extraDiscountAmount', 23.00000);
        APEX_JSON.write_raw ('totalItemsDiscountAmount', 23.00000);
        APEX_JSON.write_raw ('totalAmount', 23.00000);
        APEX_JSON.open_array ('signatures');
        APEX_JSON.open_object;
        APEX_JSON.write ('signatureType', 'I');
        APEX_JSON.write ('value', 'No Valid Signature');
        APEX_JSON.close_object;
        -- close signatures object
        APEX_JSON.close_array;
        -- close array of signatures structure
        APEX_JSON.close_object;
        --close documents
        APEX_JSON.close_array;
        --close for documents array strcture
        APEX_JSON.close_object;
        -- close array for main object
        l_data := apex_json.get_clob_output;
        apex_json.free_output;

        RETURN l_data;
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN 'Error : ' || SQLERRM;
    END get_eta_json_payload_skeleton;

    FUNCTION get_eta_json_batch (p_trx_from IN NUMBER, p_trx_to IN NUMBER)
        RETURN CLOB
    IS
        l_data   CLOB;

        l_temp   CLOB;

        --main cursor to the header table
        CURSOR c_inv_header IS
            SELECT *
              FROM TRS_ETA_INVOICES_HEADER
             WHERE INTERNAL_ID BETWEEN p_trx_from AND p_trx_to;
    BEGIN --SQL data Query for populate tempHolder to Hold data before converted to Valid Payload JSON
        FOR c_header IN c_inv_header
        LOOP                                        --Prepare open json object
            APEX_JSON.initialize_clob_output;
            APEX_JSON.open_object;
            --Object first documents object
            APEX_JSON.open_array ('documents');
            APEX_JSON.open_object;
            APEX_JSON.open_object ('issuer');
            APEX_JSON.open_object ('address');
            APEX_JSON.write ('branchID', c_header.issuer_address_branch_id);
            APEX_JSON.write ('country', c_header.issuer_address_country);
            APEX_JSON.write ('governate', c_header.issuer_address_governate);
            APEX_JSON.write_raw (
                'regionCity',
                '"' || c_header.issuer_address_region_city || '"');
            APEX_JSON.write_raw (
                'street',
                '"' || c_header.issuer_address_street || '"');
            APEX_JSON.write_raw (
                'buildingNumber',
                '"' || c_header.issuer_address_building_number || '"');
            APEX_JSON.write ('postalCode', 'NA');
            APEX_JSON.write ('floor', 'NA');
            APEX_JSON.write ('room', 'NA');
            APEX_JSON.write ('landmark', 'NA');
            APEX_JSON.write ('additionalInformation', 'NA');
            APEX_JSON.close_object;
            --Close Address structure
            APEX_JSON.write ('type', c_header.issuer_type);
            APEX_JSON.write ('id', c_header.issuer_id);
            APEX_JSON.write_raw ('name', '"' || c_header.issuer_name || '"');
            APEX_JSON.close_object;
            --Close issuer strucure
            APEX_JSON.open_object ('receiver');
            APEX_JSON.open_object ('address');
            APEX_JSON.write ('country', c_header.receiver_address_country);
            APEX_JSON.write ('governate',
                             c_header.receiver_address_governate);
            APEX_JSON.write ('regionCity',
                             c_header.receiver_address_region_city);
            APEX_JSON.write_raw (
                'street',
                '"' || c_header.receiver_address_street || '"');
            APEX_JSON.write_raw (
                'buildingNumber',
                '"' || c_header.receiver_address_building_num || '"');
            APEX_JSON.write ('postalCode', 'NA');
            APEX_JSON.write ('floor', 'NA');
            APEX_JSON.write ('room', 'NA');
            APEX_JSON.write ('landmark', 'NA');
            APEX_JSON.write ('additionalInformation', 'NA');
            APEX_JSON.close_object;
            --close Address  structure
            APEX_JSON.write ('type', c_header.receiver_type);
            APEX_JSON.write ('id', c_header.receiver_id);
            APEX_JSON.write_raw ('name',
                                 '"' || c_header.receiver_name || '"');
            APEX_JSON.close_object;
            --close Receiver structure
            APEX_JSON.write ('documentType', c_header.document_type);
            APEX_JSON.write ('documentTypeVersion',
                             c_header.document_type_version);
            APEX_JSON.write ('dateTimeIssued', c_header.datetime_issued);
            APEX_JSON.write ('taxpayerActivityCode',
                             c_header.tax_payer_activity_code);
            APEX_JSON.write ('internalID', c_header.internal_id);
            APEX_JSON.write ('purchaseOrderReference', 'NA');
            APEX_JSON.write ('purchaseOrderDescription', 'NA');
            APEX_JSON.write ('salesOrderReference', 'NA');
            APEX_JSON.write ('salesOrderDescription', 'NA');
            APEX_JSON.write ('proformaInvoiceNumber', 'NA');
            APEX_JSON.open_object ('payment');
            APEX_JSON.write ('bankName', c_header.payment_bank_name);
            APEX_JSON.write ('bankAddress', c_header.payment_bank_address);
            APEX_JSON.write ('bankAccountNo',
                             c_header.payment_bank_accountno);
            APEX_JSON.write ('bankAccountIBAN',
                             c_header.payment_bank_account_iban);
            APEX_JSON.write ('swiftCode', c_header.payment_swift_code);
            APEX_JSON.write ('terms', c_header.payment_terms);
            APEX_JSON.close_object;
            --close payment structure
            APEX_JSON.open_object ('delivery');
            APEX_JSON.write ('approach', c_header.delivery_approach);
            APEX_JSON.write ('packaging', c_header.delivery_packaging);
            APEX_JSON.write ('dateValidity', c_header.delivery_date_validity);
            APEX_JSON.write ('exportPort', c_header.devlivery_export_port);
            APEX_JSON.write ('countryOfOrigin',
                             c_header.delivery_country_of_origin);
            APEX_JSON.write_raw ('grossWeight',
                                 c_header.delivery_gross_weight);
            APEX_JSON.write_raw ('netWeight', c_header.delivery_net_weight);
            APEX_JSON.write ('terms', c_header.delivery_terms);
            APEX_JSON.close_object;
            --close delivery structure
            APEX_JSON.open_array ('invoiceLines');

            -- Open Invoice Lines Array
            FOR c_lines
                IN (SELECT *
                      FROM TRS_ETA_INVOICES_lines eta
                     WHERE eta.CUSTOMER_TRX_ID = c_header.CUSTOMER_TRX_ID)
            LOOP
                APEX_JSON.open_object;
                APEX_JSON.write_raw ('description',
                                     '"' || c_lines.inv_lines_desc || '"');
                APEX_JSON.write ('itemType', c_lines.inv_lines_item_type);
                APEX_JSON.write ('itemCode', c_lines.inv_lines_item_code);
                APEX_JSON.write ('unitType', c_lines.inv_lines_unit_type);
                APEX_JSON.write_raw ('quantity', c_lines.inv_lines_qty);
                APEX_JSON.open_object ('unitValue');
                APEX_JSON.write ('currencySold',
                                 c_lines.inv_lines_unit_val_curr_sold);
                APEX_JSON.write_raw ('amountEGP',
                                     c_lines.inv_lines_unit_val_amount_egp);
                APEX_JSON.write_raw ('amountSold',
                                     c_lines.inv_lines_unit_val_amount_sold);
                APEX_JSON.write_raw ('currencyExchangeRate',
                                     c_lines.inv_lines_unit_val_curr_rate);
                APEX_JSON.close_object;
                --close unit value  strucrure
                APEX_JSON.write_raw ('salesTotal',
                                     c_lines.inv_lines_sales_total);
                APEX_JSON.write_raw ('total', c_lines.inv_lines_total);
                -- Eq:  (netTotal - itemsDiscount) + taxAmount
                APEX_JSON.write_raw ('valueDifference',
                                     c_lines.inv_lines_val_diff);
                --special case  on tax
                APEX_JSON.write_raw ('totalTaxableFees',
                                     c_lines.inv_lines_total_tax_fees);
                APEX_JSON.write_raw ('netTotal', c_lines.inv_lines_net_total);
                -- Eq: (salesTotals - discountAmount)
                APEX_JSON.write_raw ('itemsDiscount',
                                     c_lines.inv_lines_item_disc);
                APEX_JSON.open_object ('discount');
                APEX_JSON.write_raw (
                    'rate',
                    ROUND (c_lines.inv_lines_discount_rate, 2));
                APEX_JSON.write_raw ('amount',
                                     c_lines.inv_lines_discount_amt);
                APEX_JSON.close_object;
                --Close invoiceLines discount
                APEX_JSON.open_array ('taxableItems');
                APEX_JSON.open_object;
                APEX_JSON.write ('taxType',
                                 c_lines.inv_lines_tax_item_type_vat);
                APEX_JSON.write ('amount',
                                 c_lines.inv_lines_tax_item_amt_vat);
                -- EQ:  (netAmount * TaxRate) / 1c_lines.00
                APEX_JSON.write ('subType',
                                 c_lines.inv_lines_tax_item_subtype_vat);
                -- no Sub if not aval
                APEX_JSON.write (
                    'rate',
                    ROUND (c_lines.inv_lines_tax_item_rate_vat, 2));
                --Percentage
                APEX_JSON.close_object;
                APEX_JSON.open_object;
                APEX_JSON.write ('taxType',
                                 c_lines.inv_lines_tax_item_type_wht);
                APEX_JSON.write ('amount',
                                 c_lines.inv_lines_tax_item_amt_wht);
                -- EQ:  (netAmount * TaxRate) / 1c_lines.00
                APEX_JSON.write ('subType',
                                 c_lines.inv_lines_tax_item_subtype_wht);
                -- no Sub if not aval
                APEX_JSON.write (
                    'rate',
                    ROUND (c_lines.inv_lines_tax_item_rate_wht, 2));
                --Percentage
                APEX_JSON.close_object;

                APEX_JSON.close_array;
                --close invoiceLines taxbleItems array
                APEX_JSON.write ('internalCode',
                                 c_lines.inv_lines_internal_code);
                APEX_JSON.close_object;
            --close invoiceLines structure object
            END LOOP;

            APEX_JSON.close_array;
            --close invoiceLines structure array
            APEX_JSON.write_raw ('totalSalesAmount',
                                 c_header.total_sales_amt);
            APEX_JSON.write_raw ('totalDiscountAmount',
                                 c_header.total_discount_amt);
            APEX_JSON.write_raw ('netAmount', c_header.net_amt);

            APEX_JSON.open_array ('taxTotals');
            APEX_JSON.open_object;
            APEX_JSON.write ('taxType', c_header.tax_total_tax_type_vat);
            APEX_JSON.write ('amount', c_header.tax_total_amt_vat);
            APEX_JSON.close_object;
            APEX_JSON.open_object;
            APEX_JSON.write ('taxType', c_header.tax_total_tax_type_wht);
            APEX_JSON.write ('amount', c_header.tax_total_amt_wht);
            APEX_JSON.close_object;
            --close taxTotals object
            APEX_JSON.close_array;
            -- close array for taxTotals
            APEX_JSON.write_raw ('extraDiscountAmount',
                                 c_header.extra_disc_amount);
            APEX_JSON.write_raw ('totalItemsDiscountAmount',
                                 c_header.total_item_disc_amount);
            APEX_JSON.write_raw ('totalAmount', c_header.total_amount);
            -- Eq : total From (invoiceLines - ExtraDiscount)
            APEX_JSON.open_array ('signatures');
            APEX_JSON.open_object;
            APEX_JSON.write ('signatureType', 'I');
            APEX_JSON.write ('value', c_header.signature);
            APEX_JSON.close_object;
            -- close signatures object
            APEX_JSON.close_array;
            -- close array of signatures structure
            APEX_JSON.close_object;
            --close documents
            APEX_JSON.close_array;
            --close for documents array strcture
            APEX_JSON.close_object;
            -- close array for main object
            l_data := apex_json.get_clob_output;
            apex_json.free_output;
        END LOOP;

        RETURN l_data;
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN 'Error : ' || SQLERRM;
    END get_eta_json_batch;

    FUNCTION get_eta_json_batch (p_trx_date_from   IN DATE,
                                 p_trx_date_to     IN DATE)
        RETURN CLOB
    IS
        l_trx_date_from date  := p_trx_date_from;
        l_trx_date_to   date  := p_trx_date_to;
        l_data   CLOB;
        l_temp   CLOB;

        --main cursor to the header table
        CURSOR c_inv_header IS
            SELECT *
              FROM TRS_ETA_INVOICES_HEADER
             WHERE TO_DATE (DATETIME_ISSUED, 'DD-MON-YYYY') BETWEEN TO_DATE (
                                                                        l_trx_date_from,
                                                                        'DD-MON-YYYY')
                                                                AND TO_DATE (
                                                                        l_trx_date_to,
                                                                        'DD-MON-YYYY');
    BEGIN --SQL data Query for populate tempHolder to Hold data before converted to Valid Payload JSON
        FOR c_header IN c_inv_header
        LOOP                                        --Prepare open json object
            APEX_JSON.initialize_clob_output;
            APEX_JSON.open_object;
            --Object first documents object
            APEX_JSON.open_array ('documents');
            APEX_JSON.open_object;
            APEX_JSON.open_object ('issuer');
            APEX_JSON.open_object ('address');
            APEX_JSON.write ('branchID', c_header.issuer_address_branch_id);
            APEX_JSON.write ('country', c_header.issuer_address_country);
            APEX_JSON.write ('governate', c_header.issuer_address_governate);
            APEX_JSON.write_raw (
                'regionCity',
                '"' || c_header.issuer_address_region_city || '"');
            APEX_JSON.write_raw (
                'street',
                '"' || c_header.issuer_address_street || '"');
            APEX_JSON.write_raw (
                'buildingNumber',
                '"' || c_header.issuer_address_building_number || '"');
            APEX_JSON.write ('postalCode', 'NA');
            APEX_JSON.write ('floor', 'NA');
            APEX_JSON.write ('room', 'NA');
            APEX_JSON.write ('landmark', 'NA');
            APEX_JSON.write ('additionalInformation', 'NA');
            APEX_JSON.close_object;
            --Close Address structure
            APEX_JSON.write ('type', c_header.issuer_type);
            APEX_JSON.write ('id', c_header.issuer_id);
            APEX_JSON.write_raw ('name', '"' || c_header.issuer_name || '"');
            APEX_JSON.close_object;
            --Close issuer strucure
            APEX_JSON.open_object ('receiver');
            APEX_JSON.open_object ('address');
            APEX_JSON.write ('country', c_header.receiver_address_country);
            APEX_JSON.write ('governate',
                             c_header.receiver_address_governate);
            APEX_JSON.write ('regionCity',
                             c_header.receiver_address_region_city);
            APEX_JSON.write_raw (
                'street',
                '"' || c_header.receiver_address_street || '"');
            APEX_JSON.write_raw (
                'buildingNumber',
                '"' || c_header.receiver_address_building_num || '"');
            APEX_JSON.write ('postalCode', 'NA');
            APEX_JSON.write ('floor', 'NA');
            APEX_JSON.write ('room', 'NA');
            APEX_JSON.write ('landmark', 'NA');
            APEX_JSON.write ('additionalInformation', 'NA');
            APEX_JSON.close_object;
            --close Address  structure
            APEX_JSON.write ('type', c_header.receiver_type);
            APEX_JSON.write ('id', c_header.receiver_id);
            APEX_JSON.write_raw ('name',
                                 '"' || c_header.receiver_name || '"');
            APEX_JSON.close_object;
            --close Receiver structure
            APEX_JSON.write ('documentType', c_header.document_type);
            APEX_JSON.write ('documentTypeVersion',
                             c_header.document_type_version);
            APEX_JSON.write ('dateTimeIssued', c_header.datetime_issued);
            APEX_JSON.write ('taxpayerActivityCode',
                             c_header.tax_payer_activity_code);
            APEX_JSON.write ('internalID', c_header.internal_id);
            APEX_JSON.write ('purchaseOrderReference', 'NA');
            APEX_JSON.write ('purchaseOrderDescription', 'NA');
            APEX_JSON.write ('salesOrderReference', 'NA');
            APEX_JSON.write ('salesOrderDescription', 'NA');
            APEX_JSON.write ('proformaInvoiceNumber', 'NA');
            APEX_JSON.open_object ('payment');
            APEX_JSON.write ('bankName', c_header.payment_bank_name);
            APEX_JSON.write ('bankAddress', c_header.payment_bank_address);
            APEX_JSON.write ('bankAccountNo',
                             c_header.payment_bank_accountno);
            APEX_JSON.write ('bankAccountIBAN',
                             c_header.payment_bank_account_iban);
            APEX_JSON.write ('swiftCode', c_header.payment_swift_code);
            APEX_JSON.write ('terms', c_header.payment_terms);
            APEX_JSON.close_object;
            --close payment structure
            APEX_JSON.open_object ('delivery');
            APEX_JSON.write ('approach', c_header.delivery_approach);
            APEX_JSON.write ('packaging', c_header.delivery_packaging);
            APEX_JSON.write ('dateValidity', c_header.delivery_date_validity);
            APEX_JSON.write ('exportPort', c_header.devlivery_export_port);
            APEX_JSON.write ('countryOfOrigin',
                             c_header.delivery_country_of_origin);
            APEX_JSON.write_raw ('grossWeight',
                                 c_header.delivery_gross_weight);
            APEX_JSON.write_raw ('netWeight', c_header.delivery_net_weight);
            APEX_JSON.write ('terms', c_header.delivery_terms);
            APEX_JSON.close_object;
            --close delivery structure
            APEX_JSON.open_array ('invoiceLines');

            -- Open Invoice Lines Array
            FOR c_lines
                IN (SELECT *
                      FROM TRS_ETA_INVOICES_lines eta
                     WHERE eta.CUSTOMER_TRX_ID = c_header.CUSTOMER_TRX_ID)
            LOOP
                APEX_JSON.open_object;
                APEX_JSON.write_raw ('description',
                                     '"' || c_lines.inv_lines_desc || '"');
                APEX_JSON.write ('itemType', c_lines.inv_lines_item_type);
                APEX_JSON.write ('itemCode', c_lines.inv_lines_item_code);
                APEX_JSON.write ('unitType', c_lines.inv_lines_unit_type);
                APEX_JSON.write_raw ('quantity', c_lines.inv_lines_qty);
                APEX_JSON.open_object ('unitValue');
                APEX_JSON.write ('currencySold',
                                 c_lines.inv_lines_unit_val_curr_sold);
                APEX_JSON.write_raw ('amountEGP',
                                     c_lines.inv_lines_unit_val_amount_egp);
                APEX_JSON.write_raw ('amountSold',
                                     c_lines.inv_lines_unit_val_amount_sold);
                APEX_JSON.write_raw ('currencyExchangeRate',
                                     c_lines.inv_lines_unit_val_curr_rate);
                APEX_JSON.close_object;
                --close unit value  strucrure
                APEX_JSON.write_raw ('salesTotal',
                                     c_lines.inv_lines_sales_total);
                APEX_JSON.write_raw ('total', c_lines.inv_lines_total);
                -- Eq:  (netTotal - itemsDiscount) + taxAmount
                APEX_JSON.write_raw ('valueDifference',
                                     c_lines.inv_lines_val_diff);
                --special case  on tax
                APEX_JSON.write_raw ('totalTaxableFees',
                                     c_lines.inv_lines_total_tax_fees);
                APEX_JSON.write_raw ('netTotal', c_lines.inv_lines_net_total);
                -- Eq: (salesTotals - discountAmount)
                APEX_JSON.write_raw ('itemsDiscount',
                                     c_lines.inv_lines_item_disc);
                APEX_JSON.open_object ('discount');
                APEX_JSON.write_raw (
                    'rate',
                    ROUND (c_lines.inv_lines_discount_rate, 2));
                APEX_JSON.write_raw ('amount',
                                     c_lines.inv_lines_discount_amt);
                APEX_JSON.close_object;
                --Close invoiceLines discount
                APEX_JSON.open_array ('taxableItems');
                APEX_JSON.open_object;
                APEX_JSON.write ('taxType',
                                 c_lines.inv_lines_tax_item_type_vat);
                APEX_JSON.write ('amount',
                                 c_lines.inv_lines_tax_item_amt_vat);
                -- EQ:  (netAmount * TaxRate) / 1c_lines.00
                APEX_JSON.write ('subType',
                                 c_lines.inv_lines_tax_item_subtype_vat);
                -- no Sub if not aval
                APEX_JSON.write (
                    'rate',
                    ROUND (c_lines.inv_lines_tax_item_rate_vat, 2));
                --Percentage
                APEX_JSON.close_object;
                APEX_JSON.open_object;
                APEX_JSON.write ('taxType',
                                 c_lines.inv_lines_tax_item_type_wht);
                APEX_JSON.write ('amount',
                                 c_lines.inv_lines_tax_item_amt_wht);
                -- EQ:  (netAmount * TaxRate) / 1c_lines.00
                APEX_JSON.write ('subType',
                                 c_lines.inv_lines_tax_item_subtype_wht);
                -- no Sub if not aval
                APEX_JSON.write (
                    'rate',
                    ROUND (c_lines.inv_lines_tax_item_rate_wht, 2));
                --Percentage
                APEX_JSON.close_object;

                APEX_JSON.close_array;
                --close invoiceLines taxbleItems array
                APEX_JSON.write ('internalCode',
                                 c_lines.inv_lines_internal_code);
                APEX_JSON.close_object;
            --close invoiceLines structure object
            END LOOP;

            APEX_JSON.close_array;
            --close invoiceLines structure array
            APEX_JSON.write_raw ('totalSalesAmount',
                                 c_header.total_sales_amt);
            APEX_JSON.write_raw ('totalDiscountAmount',
                                 c_header.total_discount_amt);
            APEX_JSON.write_raw ('netAmount', c_header.net_amt);

            APEX_JSON.open_array ('taxTotals');
            APEX_JSON.open_object;
            APEX_JSON.write ('taxType', c_header.tax_total_tax_type_vat);
            APEX_JSON.write ('amount', c_header.tax_total_amt_vat);
            APEX_JSON.close_object;
            APEX_JSON.open_object;
            APEX_JSON.write ('taxType', c_header.tax_total_tax_type_wht);
            APEX_JSON.write ('amount', c_header.tax_total_amt_wht);
            APEX_JSON.close_object;
            --close taxTotals object
            APEX_JSON.close_array;
            -- close array for taxTotals
            APEX_JSON.write_raw ('extraDiscountAmount',
                                 c_header.extra_disc_amount);
            APEX_JSON.write_raw ('totalItemsDiscountAmount',
                                 c_header.total_item_disc_amount);
            APEX_JSON.write_raw ('totalAmount', c_header.total_amount);
            -- Eq : total From (invoiceLines - ExtraDiscount)
            APEX_JSON.open_array ('signatures');
            APEX_JSON.open_object;
            APEX_JSON.write ('signatureType', 'I');
            APEX_JSON.write ('value', c_header.signature);
            APEX_JSON.close_object;
            -- close signatures object
            APEX_JSON.close_array;
            -- close array of signatures structure
            APEX_JSON.close_object;
            --close documents
            APEX_JSON.close_array;
            --close for documents array strcture
            APEX_JSON.close_object;
            -- close array for main object
            l_data := apex_json.get_clob_output;
            apex_json.free_output;
        END LOOP;

        RETURN l_data;
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN 'Error : ' || SQLERRM;
    END get_eta_json_batch;

    FUNCTION get_eta_json_payload (p_trx_number IN NUMBER)
        RETURN CLOB
    IS
        l_data   CLOB;

        l_temp   CLOB;

        --main cursor to the header table
        CURSOR c_inv_header IS
            SELECT *
              FROM TRS_ETA_INVOICES_HEADER
             WHERE INTERNAL_ID = p_trx_number;
    BEGIN --SQL data Query for populate tempHolder to Hold data before converted to Valid Payload JSON
        FOR c_header IN c_inv_header
        LOOP                                        --Prepare open json object
            APEX_JSON.initialize_clob_output;
            APEX_JSON.open_object;
            --Object first documents object
            APEX_JSON.open_array ('documents');
            APEX_JSON.open_object;
            APEX_JSON.open_object ('issuer');
            APEX_JSON.open_object ('address');
            APEX_JSON.write ('branchID', c_header.issuer_address_branch_id);
            APEX_JSON.write ('country', c_header.issuer_address_country);
            APEX_JSON.write ('governate', c_header.issuer_address_governate);
            APEX_JSON.write_raw (
                'regionCity',
                '"' || c_header.issuer_address_region_city || '"');
            APEX_JSON.write_raw (
                'street',
                '"' || c_header.issuer_address_street || '"');
            APEX_JSON.write_raw (
                'buildingNumber',
                '"' || c_header.issuer_address_building_number || '"');
            APEX_JSON.write ('postalCode', 'NA');
            APEX_JSON.write ('floor', 'NA');
            APEX_JSON.write ('room', 'NA');
            APEX_JSON.write ('landmark', 'NA');
            APEX_JSON.write ('additionalInformation', 'NA');
            APEX_JSON.close_object;
            --Close Address structure
            APEX_JSON.write ('type', c_header.issuer_type);
            APEX_JSON.write ('id', c_header.issuer_id);
            APEX_JSON.write_raw ('name', '"' || c_header.issuer_name || '"');
            APEX_JSON.close_object;
            --Close issuer strucure
            APEX_JSON.open_object ('receiver');
            APEX_JSON.open_object ('address');
            APEX_JSON.write ('country', c_header.receiver_address_country);
            APEX_JSON.write ('governate',
                             c_header.receiver_address_governate);
            APEX_JSON.write ('regionCity',
                             c_header.receiver_address_region_city);
            APEX_JSON.write_raw (
                'street',
                '"' || c_header.receiver_address_street || '"');
            APEX_JSON.write_raw (
                'buildingNumber',
                '"' || c_header.receiver_address_building_num || '"');
            APEX_JSON.write ('postalCode', 'NA');
            APEX_JSON.write ('floor', 'NA');
            APEX_JSON.write ('room', 'NA');
            APEX_JSON.write ('landmark', 'NA');
            APEX_JSON.write ('additionalInformation', 'NA');
            APEX_JSON.close_object;
            --close Address  structure
            APEX_JSON.write ('type', c_header.receiver_type);
            APEX_JSON.write ('id', c_header.receiver_id);
            APEX_JSON.write_raw ('name',
                                 '"' || c_header.receiver_name || '"');
            APEX_JSON.close_object;
            --close Receiver structure
            APEX_JSON.write ('documentType', c_header.document_type);
            APEX_JSON.write ('documentTypeVersion',
                             c_header.document_type_version);
            APEX_JSON.write ('dateTimeIssued', c_header.datetime_issued);
            APEX_JSON.write ('taxpayerActivityCode',
                             c_header.tax_payer_activity_code);
            APEX_JSON.write ('internalID', c_header.internal_id);
            APEX_JSON.write ('purchaseOrderReference', 'NA');
            APEX_JSON.write ('purchaseOrderDescription', 'NA');
            APEX_JSON.write ('salesOrderReference', 'NA');
            APEX_JSON.write ('salesOrderDescription', 'NA');
            APEX_JSON.write ('proformaInvoiceNumber', 'NA');
            APEX_JSON.open_object ('payment');
            APEX_JSON.write ('bankName', c_header.payment_bank_name);
            APEX_JSON.write ('bankAddress', c_header.payment_bank_address);
            APEX_JSON.write ('bankAccountNo',
                             c_header.payment_bank_accountno);
            APEX_JSON.write ('bankAccountIBAN',
                             c_header.payment_bank_account_iban);
            APEX_JSON.write ('swiftCode', c_header.payment_swift_code);
            APEX_JSON.write ('terms', c_header.payment_terms);
            APEX_JSON.close_object;
            --close payment structure
            APEX_JSON.open_object ('delivery');
            APEX_JSON.write ('approach', c_header.delivery_approach);
            APEX_JSON.write ('packaging', c_header.delivery_packaging);
            APEX_JSON.write ('dateValidity', c_header.delivery_date_validity);
            APEX_JSON.write ('exportPort', c_header.devlivery_export_port);
            APEX_JSON.write ('countryOfOrigin',
                             c_header.delivery_country_of_origin);
            APEX_JSON.write_raw ('grossWeight',
                                 c_header.delivery_gross_weight);
            APEX_JSON.write_raw ('netWeight', c_header.delivery_net_weight);
            APEX_JSON.write ('terms', c_header.delivery_terms);
            APEX_JSON.close_object;
            --close delivery structure
            APEX_JSON.open_array ('invoiceLines');

            -- Open Invoice Lines Array
            FOR c_lines
                IN (SELECT *
                      FROM TRS_ETA_INVOICES_lines eta
                     WHERE eta.CUSTOMER_TRX_ID = c_header.CUSTOMER_TRX_ID)
            LOOP
                APEX_JSON.open_object;
                APEX_JSON.write_raw ('description',
                                     '"' || c_lines.inv_lines_desc || '"');
                APEX_JSON.write ('itemType', c_lines.inv_lines_item_type);
                APEX_JSON.write ('itemCode', c_lines.inv_lines_item_code);
                APEX_JSON.write ('unitType', c_lines.inv_lines_unit_type);
                APEX_JSON.write_raw ('quantity', c_lines.inv_lines_qty);
                APEX_JSON.open_object ('unitValue');
                APEX_JSON.write ('currencySold',
                                 c_lines.inv_lines_unit_val_curr_sold);
                APEX_JSON.write_raw ('amountEGP',
                                     c_lines.inv_lines_unit_val_amount_egp);
                APEX_JSON.write_raw ('amountSold',
                                     c_lines.inv_lines_unit_val_amount_sold);
                APEX_JSON.write_raw ('currencyExchangeRate',
                                     c_lines.inv_lines_unit_val_curr_rate);
                APEX_JSON.close_object;
                --close unit value  strucrure
                APEX_JSON.write_raw ('salesTotal',
                                     c_lines.inv_lines_sales_total);
                APEX_JSON.write_raw ('total', c_lines.inv_lines_total);
                -- Eq:  (netTotal - itemsDiscount) + taxAmount
                APEX_JSON.write_raw ('valueDifference',
                                     c_lines.inv_lines_val_diff);
                --special case  on tax
                APEX_JSON.write_raw ('totalTaxableFees',
                                     c_lines.inv_lines_total_tax_fees);
                APEX_JSON.write_raw ('netTotal', c_lines.inv_lines_net_total);
                -- Eq: (salesTotals - discountAmount)
                APEX_JSON.write_raw ('itemsDiscount',
                                     c_lines.inv_lines_item_disc);
                APEX_JSON.open_object ('discount');
                APEX_JSON.write_raw (
                    'rate',
                    ROUND (c_lines.inv_lines_discount_rate, 2));
                APEX_JSON.write_raw ('amount',
                                     c_lines.inv_lines_discount_amt);
                APEX_JSON.close_object;
                --Close invoiceLines discount
                APEX_JSON.open_array ('taxableItems');
                APEX_JSON.open_object;
                APEX_JSON.write ('taxType',
                                 c_lines.inv_lines_tax_item_type_vat);
                APEX_JSON.write ('amount',
                                 c_lines.inv_lines_tax_item_amt_vat);
                -- EQ:  (netAmount * TaxRate) / 1c_lines.00
                APEX_JSON.write ('subType',
                                 c_lines.inv_lines_tax_item_subtype_vat);
                -- no Sub if not aval
                APEX_JSON.write (
                    'rate',
                    ROUND (c_lines.inv_lines_tax_item_rate_vat, 2));
                --Percentage
                APEX_JSON.close_object;
                APEX_JSON.open_object;
                APEX_JSON.write ('taxType',
                                 c_lines.inv_lines_tax_item_type_wht);
                APEX_JSON.write ('amount',
                                 c_lines.inv_lines_tax_item_amt_wht);
                -- EQ:  (netAmount * TaxRate) / 1c_lines.00
                APEX_JSON.write ('subType',
                                 c_lines.inv_lines_tax_item_subtype_wht);
                -- no Sub if not aval
                APEX_JSON.write (
                    'rate',
                    ROUND (c_lines.inv_lines_tax_item_rate_wht, 2));
                --Percentage
                APEX_JSON.close_object;

                APEX_JSON.close_array;
                --close invoiceLines taxbleItems array
                APEX_JSON.write ('internalCode',
                                 c_lines.inv_lines_internal_code);
                APEX_JSON.close_object;
            --close invoiceLines structure object
            END LOOP;

            APEX_JSON.close_array;
            --close invoiceLines structure array
            APEX_JSON.write_raw ('totalSalesAmount',
                                 c_header.total_sales_amt);
            APEX_JSON.write_raw ('totalDiscountAmount',
                                 c_header.total_discount_amt);
            APEX_JSON.write_raw ('netAmount', c_header.net_amt);

            APEX_JSON.open_array ('taxTotals');
            APEX_JSON.open_object;
            APEX_JSON.write ('taxType', c_header.tax_total_tax_type_vat);
            APEX_JSON.write ('amount', c_header.tax_total_amt_vat);
            APEX_JSON.close_object;
            APEX_JSON.open_object;
            APEX_JSON.write ('taxType', c_header.tax_total_tax_type_wht);
            APEX_JSON.write ('amount', c_header.tax_total_amt_wht);
            APEX_JSON.close_object;
            --close taxTotals object
            APEX_JSON.close_array;
            -- close array for taxTotals
            APEX_JSON.write_raw ('extraDiscountAmount',
                                 c_header.extra_disc_amount);
            APEX_JSON.write_raw ('totalItemsDiscountAmount',
                                 c_header.total_item_disc_amount);
            APEX_JSON.write_raw ('totalAmount', c_header.total_amount);
            -- Eq : total From (invoiceLines - ExtraDiscount)
            APEX_JSON.open_array ('signatures');
            APEX_JSON.open_object;
            APEX_JSON.write ('signatureType', 'I');
            APEX_JSON.write ('value', c_header.signature);
            APEX_JSON.close_object;
            -- close signatures object
            APEX_JSON.close_array;
            -- close array of signatures structure
            APEX_JSON.close_object;
            --close documents
            APEX_JSON.close_array;
            --close for documents array strcture
            APEX_JSON.close_object;
            -- close array for main object
            l_data := apex_json.get_clob_output;
            apex_json.free_output;
        END LOOP;

        RETURN l_data;
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN 'Error : ' || SQLERRM;
    END get_eta_json_payload;



    FUNCTION get_token (p_host            VARCHAR2,
                        p_cust_id         VARCHAR2,
                        p_client_secert   VARCHAR2)
        RETURN VARCHAR2
    IS
        l_endpoint        VARCHAR2 (200) := '/connect/token';
        l_url             VARCHAR2 (200) := p_host || l_endpoint;
        l_cust_id         VARCHAR2 (2000) := p_cust_id;
        l_client_secert   VARCHAR2 (2000) := p_client_secert;
        l_token           VARCHAR2 (2000);
    BEGIN
        --making calling with restful token api
        apex_web_service.oauth_authenticate (
            p_token_url       => l_url,
            p_client_id       => l_cust_id,
            p_client_secret   => l_client_secert);

        l_token := apex_web_service.oauth_get_last_token;

        RETURN l_token;
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN 'Error : ' || SQLERRM;
    END get_token;

    FUNCTION submitDocument (p_host VARCHAR2, p_trx_number NUMBER)
        RETURN CLOB
    IS
        l_host           VARCHAR2 (200) := p_host;
        l_trx_number     VARCHAR2 (50)  := p_trx_number;
        l_token          VARCHAR2 (2000);
        l_endpoint       VARCHAR2 (200);
        l_url            VARCHAR2 (200);
        l_payload        CLOB;
        l_response       CLOB;

        --Response from the request
        lv_uuid          VARCHAR2 (200);
        lv_internal_id   VARCHAR2 (200);
    BEGIN
        l_endpoint := '/api/v1.0/documentsubmissions';

        l_token := APEX_UTIL.GET_SESSION_STATE ('ACCESS_TOKEN');
        l_url := l_host || l_endpoint;
        l_payload := TO_CLOB (eta_pkg.get_eta_json_payload (l_trx_number));

        /*delete cache*/
        apex_web_service.g_request_headers.delete ();

        /* Set Content Type */
        apex_web_service.g_request_headers (1).name := 'Authorization';
        apex_web_service.g_request_headers (1).VALUE :=
            'Bearer ' || l_token || '';

        apex_web_service.g_request_headers (2).name :=  'Content-Type';
        apex_web_service.g_request_headers (2).VALUE := 'application/json';
        apex_web_service.g_request_headers (3).name :=  'Accept';
        apex_web_service.g_request_headers (3).VALUE := 'application/json';
        apex_web_service.g_request_headers (4).name :=  'Accept-Language';
        apex_web_service.g_request_headers (4).VALUE := 'en';

        /* Calling ETA  Submit Restful API Request */
        l_response :=
            apex_web_service.make_rest_request (p_url           => l_url,
                                                p_http_method   => 'POST',
                                                p_body          => l_payload);

        /* Parsing Webservice Response as JSON */
        apex_json.parse (l_response);

        RETURN l_response;
    END submitDocument;
   
     FUNCTION cancelDocument (p_host  varchar2 ,p_document_uuid VARCHAR2 ,access_token varchar2)
        RETURN clob
       IS 
       
        l_host              VARCHAR2 (200) := p_host;
        l_document_uuid     VARCHAR2 (50) := p_document_uuid;
        l_token             VARCHAR2 (2000);
        l_endpoint          VARCHAR2 (200);
        l_url               VARCHAR2 (200);
        l_body              CLOB;
        l_response          CLOB;

        --Response from the request
        lv_uuid          VARCHAR2 (200);
        lv_internal_id   VARCHAR2 (200);
    BEGIN
        l_endpoint := '/api/v1.0/documents/state/'||l_document_uuid||'/state';

        l_token := APEX_UTIL.GET_SESSION_STATE ('ACCESS_TOKEN');
        l_url := l_host || l_endpoint;
        /*delete cache*/
        apex_web_service.g_request_headers.delete ();

        /* Set Content Type */
        apex_web_service.g_request_headers (1).name := 'Authorization';
        apex_web_service.g_request_headers (1).VALUE :=
            'Bearer ' || l_token || '';

        apex_web_service.g_request_headers (2).name :=  'Content-Type';
        apex_web_service.g_request_headers (2).VALUE := 'text/plain';
        apex_web_service.g_request_headers (3).name :=  'Accept';
        apex_web_service.g_request_headers (3).VALUE := 'application/json';
        apex_web_service.g_request_headers (4).name :=  'Accept-Language';
        apex_web_service.g_request_headers (4).VALUE := 'en';

        /* Calling ETA  Submit Restful API Request */
        l_response :=
            apex_web_service.make_rest_request (p_url           => l_url,
                                                p_http_method   => 'PUT',
                                                p_body          => l_payload);

        /* Parsing Webservice Response as JSON */
        apex_json.parse (l_response);
     
        RETURN  l_response;
        
        EXCEPTION WHEN OTHERS
        THEN RETURN 'Error : ' || SQLERRM;

    end cancelDocument ; 
       
    FUNCTION printDocument (p_host  varchar2,p_document_uuid VARCHAR2,access_token varchar2)
        RETURN clob
    is
      
        l_host              VARCHAR2 (200) := p_host;
        l_document_uuid     VARCHAR2 (50) := p_document_uuid;
        l_token             VARCHAR2 (2000);
        l_endpoint          VARCHAR2 (200);
        l_url               VARCHAR2 (200);
        l_response          CLOB;

        --Response from the request
        lv_uuid          VARCHAR2 (200);
        lv_internal_id   VARCHAR2 (200);
    BEGIN
        l_endpoint := '/api/v1/documents/'||l_document_uuid||'/pdf';

        l_token := APEX_UTIL.GET_SESSION_STATE ('ACCESS_TOKEN');
        l_url := l_host || l_endpoint;
        /*delete cache*/
        apex_web_service.g_request_headers.delete ();

        /* Set Content Type */
        apex_web_service.g_request_headers (1).name := 'Authorization';
        apex_web_service.g_request_headers (1).VALUE :=
            'Bearer ' || l_token || '';

        apex_web_service.g_request_headers (2).name :=  'Accept';
        apex_web_service.g_request_headers (2).VALUE := '*/*';
        apex_web_service.g_request_headers (3).name :=  'Accept-Language';
        apex_web_service.g_request_headers (3).VALUE := 'en';

        /* Calling ETA  Submit Restful API Request */
        l_response :=
            apex_web_service.make_rest_request (p_url           => l_url,
                                                p_http_method   => 'GET');
        
     RETURN l_response;
     
     EXCEPTION WHEN OTHERS   THEN
            RETURN 'Error : ' || SQLERRM;

    end printDocument;
    
    FUNCTION getDocumentStatus (p_host  varchar2,p_document_uuid VARCHAR2,access_token varchar2)
    return varchar2
    is 
        l_host              VARCHAR2 (200) := p_host;
        l_document_uuid     VARCHAR2 (50) := p_document_uuid;
        l_token             VARCHAR2 (2000);
        l_endpoint          VARCHAR2 (200);
        l_url               VARCHAR2 (200);
        l_response          CLOB;

        --Response from the request
        lv_uuid          VARCHAR2 (200);
        lv_internal_id   VARCHAR2 (200);
    BEGIN
        l_endpoint := '/api/v1/documents/'||l_document_uuid||'/raw';

        l_token := APEX_UTIL.GET_SESSION_STATE ('ACCESS_TOKEN');
        l_url := l_host || l_endpoint;
        /*delete cache*/
        apex_web_service.g_request_headers.delete ();

        /* Set Content Type */
        apex_web_service.g_request_headers (1).name := 'Authorization';
        apex_web_service.g_request_headers (1).VALUE :=
            'Bearer ' || l_token || '';

        apex_web_service.g_request_headers (2).name :=  'Content-Type';
        apex_web_service.g_request_headers (2).VALUE := 'application/json';
        apex_web_service.g_request_headers (3).name :=  'Accept';
        apex_web_service.g_request_headers (3).VALUE := 'application/json';
        apex_web_service.g_request_headers (4).name :=  'Accept-Language';
        apex_web_service.g_request_headers (4).VALUE := 'en';

        /* Calling ETA  Submit Restful API Request */
        l_response :=
            apex_web_service.make_rest_request (p_url           => l_url,
                                                p_http_method   => 'GET');

        /* Parsing Webservice Response as JSON */
        apex_json.parse (l_response);

        
    RETURN apex_json.get_varchar2(p_path =>'status');

   EXCEPTION  WHEN OTHERS
        THEN
            RETURN 'Error : ' || SQLERRM;   

    end getDocumentStatus ;
    
END eta_pkg;
