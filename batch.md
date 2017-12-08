# provider directory batch

this repository contains a series of node programs designed to ingest and manipulate physician data acquired from multiple government managed sources.

[![XO code style](https://img.shields.io/badge/code_style-XO-5ed9c7.svg)](https://github.com/sindresorhus/xo)

- primary datasets:
  1. [Medicare Physician Compare](https://data.medicare.gov/data/physician-compare)
  1. [CMS NPI Registry](http://download.cms.gov/nppes/NPI_Files.html)
  1. [Health Care Provider Taxonomy Code Set](http://www.nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57)
- auxiliary datasets
  1. [hospitals](https://www.medicare.gov/hospitalcompare/)
  1. [nursing homes](https://www.medicare.gov/NursingHomeCompare/)
  1. [dialysis](https://www.medicare.gov/Dialysisfacilitycompare/)
  1. [home health](https://www.medicare.gov/homehealthcompare/search.html)
  1. [hospice](https://data.medicare.gov/data/hospice-directory)

> initial observations about this data include:
- the physician-compare data provides more information about locations that a provider works
- the npi-registry data provides better specialty information in the form of taxonomy codes

## data-flow

### initial imports

these data sets are imported into mongo collections using the [mongoimport](https://docs.mongodb.com/manual/reference/program/mongoimport/) facility.

> we use the `--columnsHaveTypes` (available in `v3.4+`) and `--fieldsFile` flags to specify field types.

#### cms physician compare
- commands
```
tail -n +2 data/Physician_Compare_National_Downloadable_File.csv | mongoimport --verbose --db test --ignoreBlanks --type csv --collection cmsOriginalProviderLocations --drop --stopOnError --fieldFile data/physician-compare-fields.dat --columnsHaveTypes --parseGrace=autoCast
```
- sample
```
> db.cmsOriginalProviderLocations.find().limit(1).pretty()
{
	"_id" : ObjectId("57b67ef7454ead5d7fefa3f1"),
	"npi" : "1245208719",
	"pac" : "0547333676",
	"pei" : "I20080722000571",
	"lastName" : "SPARROW",
	"firstName" : "JOHN",
	"gender" : "M",
	"school" : "UNIVERSITY OF MISSISSIPPI SCHOOL OF MEDICINE",
	"gradYear" : 1982,
	"specialty" : "PLASTIC AND RECONSTRUCTIVE SURGERY",
	"orgName" : "JACKSON CLINIC PA",
	"groupPac" : "2668376872",
	"groupMemberCount" : 227,
	"addressLine1" : "87 MURRAY GUARD DR",
	"addressLine2" : "B",
	"city" : "JACKSON",
	"state" : "TN",
	"zip" : "383053775",
	"phone" : "7316641375",
	"hospitalCcn1" : "440002",
	"hospitalLbn1" : "JACKSON MADISON COUNTY GENERAL HOSPITAL",
	"medicareFlag" : "Y",
	"measuresFlag" : "Y"
}
```

#### npi registry

- commands
```
tail -n +2 data/npidata_20050523-20160612.csv | mongoimport --verbose --db test --ignoreBlanks --type csv --collection npiOriginalProviderLocations --drop --stopOnError --fieldFile data/npi-fields.dat --columnsHaveTypes --parseGrace=autoCast
```
- sample
```
> db.npiOriginalProviderLocations.find().limit(1).pretty()
{
	"_id" : ObjectId("57b687f1454ead5d7f0f655d"),
	"NPI" : "1679576722",
	"Entity_Type_Code" : 1,
	"Provider_Last_Name" : "WIEBE",
	"Provider_First_Name" : "DAVID",
	"Provider_Middle_Name" : "A",
	"Provider_Credential_Text" : "M.D.",
	"Provider_First_Line_Business_Mailing_Address" : "PO BOX 2168",
	"Provider_Business_Mailing_Address_City_Name" : "KEARNEY",
	"Provider_Business_Mailing_Address_State_Name" : "NE",
	"Provider_Business_Mailing_Address_Postal_Code" : "688482168",
	"Provider_Business_Mailing_Address_Country_Code" : "US",
	"Provider_Business_Mailing_Address_Telephone_Number" : "3088652512",
	"Provider_Business_Mailing_Address_Fax_Number" : "3088652506",
	"Provider_First_Line_Business_Practice_Location_Address" : "3500 CENTRAL AVE",
	"Provider_Business_Practice_Location_Address_City_Name" : "KEARNEY",
	"Provider_Business_Practice_Location_Address_State_Name" : "NE",
	"Provider_Business_Practice_Location_Address_Postal_Code" : "688472944",
	"Provider_Business_Practice_Location_Address_Country_Code" : "US",
	"Provider_Business_Practice_Location_Address_Telephone_Number" : "3088652512",
	"Provider_Business_Practice_Location_Address_Fax_Number" : "3088652506",
	"Provider_Enumeration_Date" : "05/23/2005",
	"Last_Update_Date" : "07/08/2007",
	"Provider_Gender_Code" : "M",
	"Healthcare_Provider_Taxonomy_Code_1" : "207X00000X",
	"Provider_License_Number_1" : "12637",
	"Provider_License_Number_State_Code_1" : "NE",
	"Healthcare_Provider_Primary_Taxonomy_Switch_1" : "Y",
	"Other_Provider_Identifier_1" : "46969",
	"Other_Provider_Identifier_Type_Code_1" : 1,
	"Other_Provider_Identifier_State_1" : "KS",
	"Other_Provider_Identifier_Issuer_1" : "BCBS",
	"Other_Provider_Identifier_2" : "645540",
	"Other_Provider_Identifier_Type_Code_2" : 1,
	"Other_Provider_Identifier_State_2" : "KS",
	"Other_Provider_Identifier_Issuer_2" : "FIRSTGUARD",
	"Other_Provider_Identifier_3" : "B67599",
	"Other_Provider_Identifier_Type_Code_3" : 2,
	"Other_Provider_Identifier_4" : "1553",
	"Other_Provider_Identifier_Type_Code_4" : 1,
	"Other_Provider_Identifier_State_4" : "NE",
	"Other_Provider_Identifier_Issuer_4" : "BCBS",
	"Other_Provider_Identifier_5" : "046969WI",
	"Other_Provider_Identifier_Type_Code_5" : 4,
	"Other_Provider_Identifier_State_5" : "KS",
	"Other_Provider_Identifier_6" : "93420WI",
	"Other_Provider_Identifier_Type_Code_6" : 4,
	"Other_Provider_Identifier_State_6" : "NE",
	"Is_Sole_Proprietor" : "X"
}
```

#### cms hospital compare

- commands
```
tail -n +2 data/Hospital-General-Information.csv | mongoimport --verbose --db test --ignoreBlanks --type csv --collection cmsOriginalHospitalLocations --drop --stopOnError --fieldFile data/hospital-compare-fields.dat --columnsHaveTypes --parseGrace=autoCast
```
- sample
```
> db.getCollection('cmsOriginalHospitalLocations').find().limit(1).pretty()
{
	"_id" : ObjectId("584c9f8a66c66811dcd6cdd4"),
	"Provider_ID" : "010001",
	"Hospital_Name" : "SOUTHEAST ALABAMA MEDICAL CENTER",
	"Address" : "1108 ROSS CLARK CIRCLE",
	"City" : "DOTHAN",
	"State" : "AL",
	"ZIP_Code" : "36301",
	"County_Name" : "HOUSTON",
	"Phone_Number" : "3347938701",
	"Hospital_Type" : "Acute Care Hospitals",
	"Hospital_Ownership" : "Government - Hospital District or Authority",
	"Emergency_Services" : "Yes",
	"Meets_criteria_for_meaningful_use_of_EHRs" : "Y",
	"Hospital_overall_rating" : "3",
	"Mortality_national_comparison" : "Same as the National average",
	"Safety_of_care_national_comparison" : "Above the National average",
	"Readmission_national_comparison" : "Same as the National average",
	"Patient_experience_national_comparison" : "Below the National average",
	"Effectiveness_of_care_national_comparison" : "Same as the National average",
	"Timeliness_of_care_national_comparison" : "Same as the National average",
	"Efficient_use_of_medical_imaging_national_comparison" : "Same as the National average"
}
```

#### cms nursing home compare

- commands
```
tail -n +2 data/ProviderInfo_Download.csv | mongoimport --verbose --ignoreBlanks --type csv --collection cmsOriginalNursingHomes --drop --stopOnError --fieldFile data/nursing-home-fields.dat --columnsHaveTypes --parseGrace=autoCast
```
- sample
```
> db.getCollection('cmsOriginalNursingHomes').find().limit(1).pretty()
{
	"_id" : ObjectId("584abe5666c66811dca40874"),
	"provnum" : "015009",
	"PROVNAME" : "BURNS NURSING HOME, INC.",
	"ADDRESS" : "701 MONROE STREET NW",
	"CITY" : "RUSSELLVILLE",
	"STATE" : "AL",
	"ZIP" : "35653",
	"PHONE" : "2563324110",
	"COUNTY_SSA" : "290",
	"COUNTY_NAME" : "Franklin",
	"OWNERSHIP" : "For profit - Corporation",
	"BEDCERT" : "57",
	"RESTOT" : "45",
	"CERTIFICATION" : "Medicare and Medicaid",
	"INHOSP" : "NO",
	"LBN" : "BURNS NURSING HOME, INC.",
	"PARTICIPATION_DATE" : "1969-09-01",
	"CCRC_FACIL" : "N",
	"SFF" : "N",
	"OLDSURVEY" : "N",
	"CHOW_LAST_12MOS" : "N",
	"resfamcouncil" : "Both",
	"sprinkler_status" : "Yes",
	"overall_rating" : "5",
	"survey_rating" : "5",
	"quality_rating" : "3",
	"staffing_rating" : "5",
	"RN_staffing_rating" : "5",
	"AIDHRD" : "2.74667",
	"VOCHRD" : "1.12667",
	"RNHRD" : "1.08000",
	"TOTLICHRD" : "2.20667",
	"TOTHRD" : "4.95334",
	"PTHRD" : "0.01222",
	"exp_aide" : "2.64279",
	"exp_lpn" : "0.70611",
	"exp_rn" : "1.08992",
	"exp_total" : "4.43882",
	"adj_aide" : "2.55015",
	"adj_lpn" : "1.32434",
	"adj_rn" : "0.74040",
	"adj_total" : "4.49813",
	"cycle_1_defs" : "2",
	"cycle_1_nfromdefs" : "2",
	"cycle_1_nfromcomp" : "0",
	"cycle_1_defs_score" : "8",
	"CYCLE_1_SURVEY_DATE" : "2016-08-25",
	"CYCLE_1_NUMREVIS" : "1",
	"CYCLE_1_REVISIT_SCORE" : "0",
	"CYCLE_1_TOTAL_SCORE" : "8",
	"cycle_2_defs" : "1",
	"cycle_2_nfromdefs" : "1",
	"cycle_2_nfromcomp" : "0",
	"cycle_2_defs_score" : "16",
	"CYCLE_2_SURVEY_DATE" : "2015-07-23",
	"CYCLE_2_NUMREVIS" : "1",
	"CYCLE_2_REVISIT_SCORE" : "0",
	"CYCLE_2_TOTAL_SCORE" : "16",
	"cycle_3_defs" : "4",
	"cycle_3_nfromdefs" : "4",
	"cycle_3_nfromcomp" : "0",
	"cycle_3_defs_score" : "16",
	"CYCLE_3_SURVEY_DATE" : "2014-09-11",
	"CYCLE_3_NUMREVIS" : "1",
	"CYCLE_3_REVISIT_SCORE" : "0",
	"CYCLE_3_TOTAL_SCORE" : "16",
	"WEIGHTED_ALL_CYCLES_SCORE" : "12.000",
	"incident_cnt" : "0",
	"cmplnt_cnt" : "0",
	"FINE_CNT" : "0",
	"FINE_TOT" : "0",
	"PAYDEN_CNT" : "0",
	"TOT_PENLTY_CNT" : "0",
	"FILEDATE" : "2016-11-01"
}
```


#### cms dialysis compare

- commands
```
tail -n +2 data/DFC_SOCRATA_FAC_DATA.csv | mongoimport --verbose --ignoreBlanks --type csv --collection cmsOriginalDialysisFacilities --drop --stopOnError --fieldFile data/dialysis-fields.dat --columnsHaveTypes --parseGrace=autoCast
```
- sample
```
> db.getCollection('cmsOriginalDialysisFacilities').find().limit(1).pretty()
{
	"_id" : ObjectId("584b8c8c66c66811dca759cd"),
	"Provider_number" : "012500",
	"Network" : "08",
	"Facility_name" : "FMC CAPITOL CITY",
	"Five_star_date" : "01/01/2012-12/31/2015",
	"Five_star" : "3",
	"Five_star_data_availability_code" : "001",
	"Address_line_1" : "255 S JACKSON STREET",
	"City" : "MONTGOMERY",
	"STATE" : "AL",
	"Zip" : "36104",
	"County" : "MONTGOMERY",
	"Phone_number" : "(334) 263-1028",
	"Profit_or_Non-Profit" : "Profit",
	"Chain_owned" : "Yes",
	"Chain_organization" : "FRESENIUS MEDICAL CARE",
	"Late_shift" : "0",
	"no_of_dialysis_stations" : "34",
	"Offers_in-center_hemodialysis" : "1",
	"Offers_in-center_peritoneal_dialysis" : "1",
	"Offers_home_hemodialysis_training" : "1",
	"Certification_date" : "1976-09-01 00:00:00",
	"Claims_date" : "01/01/2015-12/31/2015",
	"Mineral_and_Bone_Disorder_Date" : "01/01/2015-12/31/2015",
	"STrR_Date" : "01/01/2015-12/31/2015",
	"Percentage_of_Medicare_patients_with_Hgblt_10_g_per_dL" : "21",
	"Hgb_lt_10_data_availability_code" : "001",
	"Percentage_of_Medicare_patients_with_Hgbgt_12_g_per_dL" : "2",
	"Hgb_gt_12_data_availability_code" : "001",
	"Number_of_dialysis_patients_with_Hgb_data" : "57",
	"Patient_transfusion_data_availability_Code" : "001",
	"Patient_transfusion_category_text" : "As Expected",
	"Lists_the_number_of_patients_included_in_the_facilitys_transfusion_summary_facility" : "73",
	"Percent_of_adult_HD_patients_with_Kt_per_V_gte_1_2" : "96",
	"Adult_HD_Kt_per_V_data_availability_code" : "001",
	"Adult_PD_Kt_per_V_data_availability_code" : "199",
	"Pediatric_PD_Kt_per_V_Data_Availability_Code" : "259",
	"Pediatric_HD_Kt_per_V_data_availability_code" : "259",
	"Number_of_adult_HD_patients_with_Kt_per_V_data" : "115",
	"Number_of_adult_HD_patient-months_with_Kt_per_V_data" : "1037",
	"Number_of_adult_PD_patients_with_Kt_per_V_data" : "1",
	"Number_of_adult_PD_patient-months_with_Kt_per_V_data" : "6",
	"Number_of_pediatric_HD_patients_with_Kt_per_V_data" : "0",
	"Number_of_pediatric_HD_patient-months_with_Kt_per_V_data" : "0",
	"Percentage_of_patients_with_arteriovenous_fistulae_in_place" : "54",
	"Arteriovenous_fistulae_in_place_data_availability_code" : "001",
	"Percentage_of_patients_with_vascular_catheter_in_use_for_90_days_or_longer" : "12",
	"Vascular_catheter_data_availability_code" : "001",
	"Number_of_adult_patients_included_in_arterial_venous_fistula_and_catheter_summaries" : "99",
	"Number_of_adult_patient-months_included_in_arterial_venous_fistula_and_catheter_summaries" : "762",
	"Hypercalcemia_data_availability_code" : "001",
	"Lists_the_number_of_patients_included_in_the_facilitys_hypercalcemia_summary_facility" : "118",
	"Lists_the_number_of_patient-months_included_in_the_facilitys_hypercalcemia_summary_facility" : "1090",
	"Lists_the_percentage_of_adult_patients_with_hypercalcemia_serum_calcium_greater_than_10_2_mg_per_dL_facility" : "1",
	"Lists_the_number_of_patients_included_in_the_facilitys_serum_phosphorus_summary_facility" : "120",
	"Lists_the_number_of_patient-months_included_in_the_facilitys_serum_phosphorus_summary_facility" : "1111",
	"Serum_phosphorus_data_availability_code" : "001",
	"Lists_the_percentage_of_adult_patients_with_serum_phosphorus_less_than_3_5_mg_per_dL_facility" : "12",
	"Lists_the_percentage_of_adult_patients_with_serum_phosphorus_between_3_5-4_5_mg_per_dL_facility" : "24",
	"Lists_the_percentage_of_adult_patients_with_serum_phosphorus_between_4_6-5_5_mg_per_dL_facility" : "25",
	"Lists_the_percentage_of_adult_patients_with_serum_phosphorus_between_5_6-7_0_mg_per_dL_facility" : "26",
	"Lists_the_percentage_of_adult_patients_with_serum_phosphorus_greater_than_7_0_mg_per_dL_facility" : "14",
	"SHR_date" : "01/01/2015-12/31/2015",
	"SRR_date" : "01/01/2015-12/31/2015",
	"SMR_date" : "01/01/2012-12/31/2015",
	"SHR_upper_confidence_limit_95pct" : "242.12",
	"SRR_upper_confidence_limit" : "30.61",
	"SMR_upper_confidence_limit_95pct" : "23.28",
	"SHR_lower_confidence_limit_5pct" : "91.18",
	"SRR_lower_confidence_limit" : "16.14",
	"SMR_lower_confidence_limit_5pct" : "13.98",
	"Patient_hospitalization_category_text" : "As Expected",
	"Patient_hospitalization_data_availability_code" : "001",
	"Rate_of_hospital_readmission_category_text" : "As Expected",
	"Rate_of_hospital_readmission_data_availability_code" : "001",
	"Patient_survival_category_text" : "As Expected",
	"Patient_survival_data_availability_code" : "001",
	"Number_of_patients_included_in_hospitalization_summary" : "84",
	"Number_of_hospitalizations_included_in_hospital_readmission_facility" : "91",
	"Number_of_patients_included_in_survival_summary" : "541",
	"Mortality_Rate_Facility" : "18.2",
	"Mortality_Rate_Upper_Confidence_Limit_97_5pct" : "23.28",
	"Mortality_Rate_Lower_Confidence_Limit_2_5pct" : "13.98",
	"Readmission_Rate_Facility" : "22.79",
	"Readmission_Rate_Upper_Confidence_Limit_97_5pct" : "30.61",
	"Readmission_Rate_Lower_Confidence_Limit_2_5pct" : "16.14",
	"Readmission_Rate_US" : "25.33",
	"Hospitalization_Rate_Facility" : "146.44",
	"Hospitalization_Rate_Upper_Confidence_Limit_97_5pct" : "242.12",
	"Hospitalization_Rate_Lower_Confidence_Limit_2_5pct" : "91.18",
	"Number_of_pediatric_PD_patients_with_Kt_per_V_data" : "0",
	"Number_of_pediatric_PD_patient-months_with_KT_per_V_data" : "0",
	"SIR_Date" : "01/01/2015-12/31/2015",
	"Patient_Infection_data_availability_Code" : "001",
	"Patient_Infection_category_text" : "Better than Expected",
	"Standard_Infection_Ratio" : "0.14",
	"SIR_Upper_Confidence_Limit_97_5pct" : "0.67",
	"SIR_Lower_Confidence_Limit_2_5pct" : "0.01",
	"Transfusion_Rate_Facility" : "28.2",
	"Transfusion_Rate_Upper_Confidence_Limit_97_5pct" : "73.52",
	"Transfusion_Rate_Lower_Confidence_Limit_2_5pct" : "12.34"
}
```

#### cms home health compare

- commands
```
tail -n +2 data/HHC_SOCRATA_PRVDR.csv | mongoimport --verbose --ignoreBlanks --type csv --collection cmsOriginalHHAgencies --drop --stopOnError --fieldFile data/home-health-agency-fields.dat --columnsHaveTypes --parseGrace=autoCast
```
- sample
```
> db.getCollection('cmsOriginalHHAgencies').find().limit(1).pretty()
{
	"_id" : ObjectId("584c663266c66811dcd669d9"),
	"State" : "AL",
	"CMS_Certification_Number_CCN" : "017000",
	"Provider_Name" : "BUREAU OF HOME & COMMUNITY SERVICES",
	"Address" : "201 MONROE STREET, THE RSA TOWER,  SUITE 1200",
	"City" : "MONTGOMERY",
	"Zip" : "36104",
	"Phone" : "3342065341",
	"Type_of_Ownership" : "Government - State/ County",
	"Offers_Nursing_Care_Services" : "Yes",
	"Offers_Physical_Therapy_Services" : "Yes",
	"Offers_Occupational_Therapy_Services" : "Yes",
	"Offers_Speech_Pathology_Services" : "Yes",
	"Offers_Medical_Social_Services" : "Yes",
	"Offers_Home_Health_Aide_Services" : "Yes",
	"Date_Certified" : "1966-07-01 00:00:00",
	"Quality_of_Patient_Care_Star_Rating" : "Not Available",
	"Footnote_-_Quality_of_Patient_Care_Star_Rating" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_the_home_health_team_began_their_patients_care_in_a_timely_manner" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_the_home_health_team_taught_patients_or_their_family_caregivers_about_their_drugs" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_the_home_health_team_checked_patients_risk_of_falling" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_the_home_health_team_checked_patients_for_depression" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_the_home_health_team_made_sure_that_their_patients_have_received_a_flu_shot_for_the_current_flu_season" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_as_how_often_the_home_health_team_made_sure_that_their_patients_have_received_a_pneumococcal_vaccine_pneumonia_shot" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_the_home_health_team_got_doctors_orders_gave_foot_care_and_taught_patients_about_foot_care" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_the_home_health_team_checked_patients_for_pain" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_often_the_home_health_team_treated_their_patients_pain" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_the_home_health_team_treated_heart_failure_weakening_of_the_heart_patients_symptoms" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_the_home_health_team_took_doctor-ordered_action_to_prevent_pressure_sores_bed_sores" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_the_home_health_team_included_treatments_to_prevent_pressure_sores_bed_sores_in_the_plan_of_care" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_the_home_health_team_checked_patients_for_the_risk_of_developing_pressure_sores_bed_sores" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_patients_got_better_at_walking_or_moving_around" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_patients_got_better_at_getting_in_and_out_of_bed" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_patients_got_better_at_bathing" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_patients_had_less_pain_when_moving_around" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_patients_breathing_improved" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_patients_wounds_improved_or_healed_after_an_operation" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_patients_got_better_at_taking_their_drugs_correctly_by_mouth" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_home_health_patients_had_to_be_admitted_to_the_hospital" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote_for_how_often_patients_receiving_home_health_care_needed_urgent_unplanned_care_in_the_ER_without_being_admitted" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"How_often_home_health_patients_who_have_had_a_recent_hospital_stay_had_to_be_re-admitted_to_the_hospital" : "Not Available",
	"Footnote_for_how_often_home_health_patients_who_have_had_a_recent_hospital_stay_had_to_be_re-admitted_to_the_hospital" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"How_often_home_health_patients_who_have_had_a_recent_hospital_stay_received_care_in_the_hospital_emergency_room_without_being_re-admitted_to_the_hospital" : "Not Available",
	"Footnote_for_how_often_home_health_patients_who_have_had_a_recent_hospital_stay_received_care_in_the_hospital_emergency_room_without_being_re-admitted_to_the_hospital" : "This measure currently does not have data or provider has been certified/recertified for less than 6 months.",
	"Footnote" : " "
}
```

#### cms hospice compare

- commands
```
tail -n +2 data/Hospice_Agencies.csv | mongoimport --verbose --db test --ignoreBlanks --type csv --collection cmsOriginalHospiceAgencies --drop --stopOnError --fieldFile data/hospice-fields.dat --columnsHaveTypes --parseGrace=autoCast
```
- sample
```
> db.getCollection('cmsOriginalHospiceAgencies').find().limit(1).pretty()
{
	"_id" : ObjectId("584ca8b066c66811dcd6e4cc"),
	"State_Abbreviation" : "AL",
	"CCN" : "011500",
	"Facility_Name" : "BAPTIST HOSPICE",
	"Address_Street" : "301 INTERSTATE PARK",
	"Address_City" : "MONTGOMERY",
	"Address_Zip_Code" : "36109",
	"Telephone_Number" : "3343955000",
	"Ownership_Type_Description" : "OTHER",
	"Profit_Status" : "OTHER",
	"Category-specific_Facility_Type_Description" : "Freestanding Hospice",
	"Original_Participation_Date" : "19840323"
}
```

#### taxonomy/specialties

##### import raw data
- commands
```
mongoimport --verbose --db test --ignoreBlanks --type csv --file nucc_taxonomy_161.csv --collection originalSpecialties --drop --stopOnError --headerline
```
- create unique index on `Code` field
```
mongo localhost:27017/test --eval 'db.originalSpecialties.createIndex({Code: 1}, {unique: true})'
```
- sample
```
> db.originalSpecialties.find().limit(1).pretty()
{
	"_id" : ObjectId("577424eb20782221efd5cee2"),
	"Code" : "101YA0400X",
	"Grouping" : "Behavioral Health & Social Service Providers",
	"Classification" : "Counselor",
	"Specialization" : "Addiction (Substance Use Disorder)",
	"Definition" : "Definition to come..."
}
```

##### transform into view

- example cli: `npm run specialties`
- [code](src/specialties.js)
- sample
```
> db.specialties.find().limit(1).pretty()
{
	"_id" : ObjectId("5818aeef04e848fdffeaa090"),
	"code" : "101Y00000X",
	"grouping" : "BEHAVIORAL HEALTH & SOCIAL SERVICE PROVIDERS",
	"classification" : "COUNSELOR",
	"specialization" : "HELPING PEOPLE",
	"system" : "2.16.840.1.113883.6.101"
}
```

#### geocoded zips

since the ui is currently only setup to filter based on distance from a zipcode (vs a more detailed address), we are capitalizing on that fact by maintaining a list of zip to lat/lon values.

we are currently sourcing that data from [here](https://boutell.com/zipcodes/).

- commands
```
tail -n +2 data/zipcode.csv | mongoimport --verbose --ignoreBlanks --type csv --collection geozip --drop --stopOnError --fieldFile data/geozip-fields.dat --columnsHaveTypes --parseGrace=autoCast
```
create unique index on `zip` field
```
mongo localhost:27017/test --eval 'db.geozip.createIndex({zip: 1}, {unique: true})'
```

- sample
```
> db.geozip.find().limit(1).pretty()
{
	"_id" : ObjectId("57b31b7f454ead5d7feefb3a"),
	"zip" : "00210",
	"city" : "Portsmouth",
	"state" : "NH",
	"latitude" : 43.005895,
	"longitude" : -71.013202,
	"timezone" : -5,
	"dst" : 1
}
```

### steps

the general strategy employed here is to transform data feeds in such a way as to:

1. minimize the number of collections
1. arrive at query specific collections (or transformations if performant enough)
1. make ingest operations [idempotent](https://en.wikipedia.org/wiki/Idempotence)

> these steps are generally listed in the order in which they should be run

#### npi-providers

this collection is arrived at from a public npi feed and is generally used for it's npi -> specializations data

- example cli: `npm run npi-providers`
- [code](src/npi-providers.js)
- sample
```
> db.npiProviders.find().limit(1).pretty()
{
	"_id" : ObjectId("57b7072abfd58db7f9795eea"),
	"prefix" : null,
	"firstName" : "GERARDO",
	"middleName" : null,
	"lastName" : "GOMEZ",
	"suffix" : null,
	"npi" : "1003000100",
	"specialties" : [
		"171M00000X"
	]
}
```

#### geocoder

> by default the geocoder will run against `cmsOriginalProviderLocations`

- example cli: `npm run geocoder`
- [code](src/geocoder.js)
- sample
```
> db.geocodedAddresses.find().limit(1).pretty()
{
	"_id" : ObjectId("5783db9adfd7e6b6bfef8356"),
	"geoPoint" : {
		"type" : "Point",
		"coordinates" : [
			-73.35333,
			42.855021
		]
	},
	"addressLine1" : "75 PINE VALLEY RD",
	"city" : "HOOSICK FALLS",
	"state" : "NY",
	"zip" : 120903808,
	"addressKey" : "75 PINE VALLEY RD:HOOSICK FALLS:NY:120903808"
}
```

> the `geocodedAddresses` collection is normalized with the intent to persist indefinitely to minimize the frequency of callouts to an external rate-limited geocoding service.

<!-- -->

> the geocoder must also be run against the other organization files before they are ingested such that their addresses will be geocoded and persisted in `geocodedAddresses`:
- `cmsOriginalHospitals`
- `cmsOriginalHHAgencies`
- `cmsOriginalHospiceAgencies`
- `cmsOriginalDialysisFacilities`
- `cmsOriginalNursingHomes`

- example cli: `npm run geocoder -- --sourceCollection=cmsOriginalHHAgencies line1Field=Address cityField=City stateField=State zipField=Zip`

#### cms-provider-locations

- example cli: `npm run cms-provider-locations`
- [code](src/cms-provider-locations.js)
- sample
```
> db.providerLocations.find().limit(1).pretty()
{
	"_id" : "-1:4.6:1003000126:e:pac:4587979323:1900 ELECTRIC RD:SALEM:VA:241537474",
	"practitioner" : {
		"_id" : "-1:4.6:1003000126",
		"id" : {
			"authority" : "npi",
			"oid" : "2.16.840.1.113883.4.6",
			"extension" : "1003000126"
		},
		"name" : {
			"first" : "ARDALAN",
			"last" : "ENKESHAFI"
		},
		"specialties" : [
			{
				"code" : "207R00000X",
				"classification" : "INTERNAL MEDICINE",
				"specialization" : "",
				"system" : "2.16.840.1.113883.6.101",
				"isPrimary" : true
			}
		],
		"identifiers" : [
			{
				"authority" : "npi",
				"oid" : "2.16.840.1.113883.4.6",
				"extension" : "1003000126"
			}
		]
	},
	"location" : {
		"_id" : "-1:e:pac:4587979323:1900 ELECTRIC RD:SALEM:VA:241537474",
		"organization" : {
			"_id" : "-1:e:pac:4587979323",
			"id" : {
				"authority" : "pac",
				"oid" : "pac",
				"extension" : "4587979323"
			},
			"name" : "COMMONWEALTH HOSPITALIST GROUP LLC",
			"identifiers" : [
				{
					"authority" : "pac",
					"oid" : "pac",
					"extension" : "4587979323"
				}
			]
		},
		"address" : {
			"line1" : "1900 ELECTRIC RD",
			"city" : "SALEM",
			"state" : "VA",
			"zip" : "241537474"
		},
		"geoPoint" : {
			"type" : "Point",
			"coordinates" : [
				-80.031391,
				37.263689
			]
		},
		"phone" : "5407764000"
	},
	"source" : {
		"_id" : "-1",
		"name" : "cms",
		"rank" : -100
	},
	"updated" : {
		"date" : ISODate("2016-12-10T06:40:37.330Z")
	}
}
```

#### cms-providers

- example cli: `npm run cms-providers`
- [code](src/cms-providers.js)
- sample
```
> db.providers.find().limit(1).pretty()
{
	"_id" : "-1:4.6:1003000126",
	"organizationRefs" : [
		{
			"_id" : "-1:4.6:1003000126:-1:e:pac:4587979323",
			"organization" : {
				"_id" : "-1:e:pac:4587979323",
				"name" : "COMMONWEALTH HOSPITALIST GROUP LLC",
				"locations" : [
					{
						"_id" : "-1:e:pac:4587979323:1900 ELECTRIC RD:SALEM:VA:241537474",
						"address" : {
							"line1" : "1900 ELECTRIC RD",
							"city" : "SALEM",
							"state" : "VA",
							"zip" : "241537474"
						},
						"geoPoint" : {
							"type" : "Point",
							"coordinates" : [
								-80.031391,
								37.263689
							]
						},
						"phone" : "5407764000"
					}
				]
			}
		},
		{
			"_id" : "-1:4.6:1003000126:-1:e:pac:8729138003",
			"organization" : {
				"_id" : "-1:e:pac:8729138003",
				"name" : "HOSPITALIST MEDICINE PHYSICIANS OF MARYLAND PC",
				"locations" : [
					{
						"_id" : "-1:e:pac:8729138003:827 LINDEN AVE:BALTIMORE:MD:212014606",
						"address" : {
							"line1" : "827 LINDEN AVE",
							"city" : "BALTIMORE",
							"state" : "MD",
							"zip" : "212014606"
						},
						"geoPoint" : {
							"type" : "Point",
							"coordinates" : [
								-76.620436,
								39.299376
							]
						},
						"phone" : "4435522447"
					}
				]
			}
		}
	],
	"name" : {
		"first" : "ARDALAN",
		"last" : "ENKESHAFI"
	},
	"id" : {
		"authority" : "npi",
		"oid" : "2.16.840.1.113883.4.6",
		"extension" : "1003000126"
	},
	"identifiers" : [
		{
			"authority" : "npi",
			"oid" : "2.16.840.1.113883.4.6",
			"extension" : "1003000126"
		}
	],
	"specialties" : [
		{
			"code" : "207R00000X",
			"classification" : "INTERNAL MEDICINE",
			"specialization" : "",
			"system" : "2.16.840.1.113883.6.101",
			"isPrimary" : true
		}
	],
	"source" : {
		"_id" : "-1",
		"name" : "cms",
		"rank" : -100
	},
	"updated" : {
		"date" : ISODate("2016-12-10T06:40:37.330Z")
	}
}
```

#### cms-organization-locations

- example cli: `npm run cms-organization-locations`
- [code](src/cms-organization-locations.js)
- sample
```
> db.organizationLocations.find().limit(1).pretty()
{
	"_id" : "-1:4.6:1003002312:571 MAIN ST:SOUTH WEYMOUTH:MA:021901843",
	"practitioners" : [
		{
			"_id" : "-1:4.6:1003002312",
			"id" : {
				"authority" : "npi",
				"oid" : "2.16.840.1.113883.4.6",
				"extension" : "1003002312"
			},
			"name" : {
				"first" : "PATRICIA",
				"middle" : "T",
				"last" : "HOPKINS"
			}
		}
	],
	"specialties" : [
		{
			"code" : "174400000X",
			"classification" : "SPECIALIST",
			"specialization" : "",
			"system" : "2.16.840.1.113883.6.101",
			"isPrimary" : true
		}
	],
	"organization" : {
		"_id" : "-1:4.6:1003002312",
		"id" : {
			"authority" : "npi",
			"oid" : "2.16.840.1.113883.4.6",
			"extension" : "1003002312"
		},
		"name" : "PATRICIA T HOPKINS",
		"identifiers" : [
			{
				"authority" : "npi",
				"oid" : "2.16.840.1.113883.4.6",
				"extension" : "1003002312"
			}
		]
	},
	"address" : {
		"line1" : "571 MAIN ST",
		"city" : "SOUTH WEYMOUTH",
		"state" : "MA",
		"zip" : "021901843"
	},
	"geoPoint" : {
		"type" : "Point",
		"coordinates" : [
			-70.955671,
			42.186935
		]
	},
	"phone" : "6177739198",
	"source" : {
		"_id" : "-1",
		"name" : "cms",
		"rank" : -100
	},
	"updated" : {
		"date" : ISODate("2016-12-10T06:40:37.330Z")
	}
}
```

#### cms-organizations

- example cli: `npm run cms-organizations`
- [code](src/cms-organizations.js)
- sample
```
> db.organizations.find({'id.authority': 'pac'}).limit(1).pretty()
{
	"_id" : "-1:e:pac:0042100067",
	"practitioners" : [
		{
			"_id" : "-1:4.6:1629006135",
			"id" : {
				"authority" : "npi",
				"oid" : "2.16.840.1.113883.4.6",
				"extension" : "1629006135"
			},
			"name" : {
				"first" : "ANNISA",
				"middle" : "L",
				"last" : "JAMIL"
			}
		}
	],
	"specialties" : [
		{
			"code" : "207W00000X",
			"classification" : "OPHTHALMOLOGY",
			"specialization" : "",
			"system" : "2.16.840.1.113883.6.101",
			"isPrimary" : true
		}
	],
	"locations" : [
		{
			"_id" : "-1:e:pac:0042100067:1221 MADISON ST:SEATTLE:WA:981043536",
			"address" : {
				"line1" : "1221 MADISON ST",
				"line2" : "SUITE 1124",
				"city" : "SEATTLE",
				"state" : "WA",
				"zip" : "981043536"
			},
			"geoPoint" : {
				"type" : "Point",
				"coordinates" : [
					-122.323798,
					47.609768
				]
			},
			"phone" : "2066823447"
		}
	],
	"name" : "GLAUCOMA CONSULTANTS NW P.S.",
	"id" : {
		"authority" : "pac",
		"oid" : "pac",
		"extension" : "0042100067"
	},
	"identifiers" : [
		{
			"authority" : "pac",
			"oid" : "pac",
			"extension" : "0042100067"
		}
	],
	"source" : {
		"_id" : "-1",
		"name" : "cms",
		"rank" : -100
	},
	"updated" : {
		"date" : ISODate("2016-12-10T06:40:37.330Z")
	}
}
```

#### auxiliary cms organization types

the auxiliary organization types can be loaded into `organizationLocations` using the following commands:
```
npm run cms-dialysis-facility-locations
npm run cms-hospice-agency-locations
npm run cms-nursing-home-locations
npm run cms-home-health-agency-locations
npm run cms-hospital-locations
```

after loading the additional organization types into `organizationLocations`, they can be loaded into the `organizations` collection using the following command:
```
npm run cms-organizations
```
or for efficiency, target a specific organization type via the `query` parameter like so:
```
npm run cms-organizations -- --query='{"specialties.code": "313M00000X"}'
```
> you can find specialty codes for auxiliary organizations in [the shared constants file](src/shared/constants.js)

or target all auxiliary organizations like so:
```
npm run cms-organizations -- --query='{"organization.id.authority": "ccn"}'
```

> - mongo `_id`s will be kept unique by qualifying `extension` with `oid` to avoid collisions

### other notes

#### export/import
```
rm -rf dump
mongodump  --db test --collection organizationLocations --gzip
tar czf organizationLocations.tar.gz dump
```
> apparently, if the `--archive` flag to `mongodump` is used on mac, the resultant archive doesn't `mongorestore` on windows, so we omit it here

```
mongorestore --db test --gzip dump/provider-directory/geocodedAddresses.bson.gz
```
#### export/import test data

```
mongoexport --collection organizationLocations --query '{"address.zip": {$regex: "^10021"}}' --limit 5 --out temp.json --jsonArray
```
```
mongoexport --collection organizationLocations --query '{"address.zip": {$regex: "^06108"}}' --limit 5 --out temp.json --jsonArray
```
```
mongoexport --collection providerLocations --query '{"location.address.zip": {$regex: "^10021"}}' --limit 5 --out temp.json --jsonArray
```
```
mongoexport --collection providerLocations --query '{"location.address.zip": {$regex: "^06108"}}' --limit 5 --out temp.json --jsonArray
```

> after export, alter data as desired, then import

```
mongoimport --verbose --db test --file fixture/organization-locations-client.json --collection organizationLocations --jsonArray
```
```
mongoimport --verbose --db test --file fixture/provider-locations-client.json --collection providerLocations --jsonArray
```
```
mongoimport --verbose --db test --file fixture/clients.js --jsonArray --collection clients
```
