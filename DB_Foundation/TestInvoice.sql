select  eta_pkg.get_pre_serialized_json(3196) from dual;


select   eta_pkg.get_eta_json_payload(53737) from dual;

select  * from  trs_ETA_INVOICES_HEADER 
where internal_id=3222;
 
select * from trs_ETA_INVOICES_lines
where CUSTOMER_TRX_ID =303878;

select * from trs_eta_submission_log; 

update trs_ETA_INVOICES_HEADER
set SUBMITED ='Y' ,
UUID = :uiid
where  INTERNAL_ID=:INTERNAL_ID;


SELECT CUSTOMER_TRX_ID,INTERNAL_ID,
       RECEIVER_NAME,
       NET_AMT,
       TAX_TOTAL_AMT ,
       DATETIME_ISSUED ,
       SIGNED,
       SUBMITED ,
       UUID
  FROM TRS_ETA_INVOICES_HEADER
   WHERE 
  DATETIME_ISSUED > '15-NOV-2020'
  and submited ='N'
  ORDER BY DATETIME_ISSUED desc;