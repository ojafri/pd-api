@batch
Feature: ingest specialties

 Background:
   Given the following documents exist in the '${constants.SPECIALTIES_SOURCE}' collection:
   """
   [
     {
       Code: 'code-1',
       Grouping: 'grouping-1',
       Classification: 'classification-1',
       Specialization: 'specialization-1'
     }
   ]
   """

 Scenario: ingest specialties
   When we run the '${BATCH}/specialties' ingester
   Then mongo query "{}" on '${constants.SPECIALTIES}' should be like:
   """
   [
     {
       code: 'code-1',
       grouping: 'GROUPING-1',
       classification: 'CLASSIFICATION-1',
       specialization: 'SPECIALIZATION-1',
       system: '2.16.840.1.113883.6.101'
     }
   ]
   """
