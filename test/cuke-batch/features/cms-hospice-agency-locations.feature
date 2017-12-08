@batch
Feature: ingest (cms) hospice agency locations

 Background:
   Given the following documents exist in the '${constants.CMS_HOSPICE_AGENCY_SOURCE}' collection:
   """
   [
     {
       CCN: 'ccn-1',
       Facility_Name: 'facility-1',
       Address_Street: 'addressLine1-1',
       Address_City: 'city-1',
       State_Abbreviation: 'state-1',
       Address_Zip_Code: 'zip-1',
       Telephone_Number: 'phone-1'
     }
   ]
   """
   And the following documents exist in the '${constants.GEO_ADDRESSES}' collection:
   """
   [
     {
       geoPoint: {
         type: 'Point',
         coordinates: [
           1.0,
           1.0
         ]
       },
       addressKey: 'addressLine1-1:city-1:state-1:zip-1'
     }
   ]
   """
   And the following documents exist in the '${constants.SPECIALTIES}' collection:
   """
   [
     {
       code: constants.HOSPICE_SPECIALTY,
       grouping: 'grouping-1',
       classification: 'classification-1',
       specialization: 'specialization-1',
       system: 'system-1'
     }
   ]
   """

 Scenario: ingest cms-hospice-agency-locations
   When we run the '${BATCH}/cms-hospice-agency-locations' ingester
   Then mongo query "{}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
   """
   [
     {
       _id: '4.336:ccn-1:addressLine1-1:city-1:state-1:zip-1',
       organization: {
         _id: '4.336:ccn-1',
         id: {
             authority: 'ccn',
             oid: '2.16.840.1.113883.4.336',
             extension: 'ccn-1',
         },
         name: 'facility-1',
         identifiers: [
           {
             authority: 'ccn',
             oid: '2.16.840.1.113883.4.336',
             extension: 'ccn-1',
           }
         ]
       },
       address: {
         line1: 'addressLine1-1',
         city: 'city-1',
         state: 'state-1',
         zip: 'zip-1'
       },
       geoPoint: {
         type: 'Point',
         coordinates: [
           1.0,
           1.0
         ]
       },
       phone: 'phone-1',
       specialties: [
         {
           code: constants.HOSPICE_SPECIALTY,
           classification: 'classification-1',
           specialization: 'specialization-1',
           system: 'system-1',
           grouping: 'grouping-1',
           isPrimary: true
         }
       ],
       created: {
         source: {_id: '-1', name: 'cms'},
         date: 'assert(actual.constructor.name == "Date")'
       },
       updated: {
         source: {_id: '-1', name: 'cms'},
         date: 'assert(actual.constructor.name == "Date")'
       }
     }
   ]
   """
