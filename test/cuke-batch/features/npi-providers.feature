@batch
Feature: ingest (npi) providers

  Scenario: ingest npi-providers
    Given the following documents exist in the '${constants.NPPES_PROVIDER_SOURCE}' collection:
    """
    [
      {
        NPI: 'npi-1',
        Healthcare_Provider_Taxonomy_Code_1: 'code-1',
        Healthcare_Provider_Primary_Taxonomy_Switch_1: 'Y',
      },
      {
        NPI: 'npi-2',
        Healthcare_Provider_Taxonomy_Code_1: 'code-2',
        Healthcare_Provider_Primary_Taxonomy_Switch_1: 'N',
        NPI_Deactivation_Date: '05/23/2005',
        NPI_Reactivation_Date: null
      },
      {
        NPI: 'npi-3',
        Healthcare_Provider_Taxonomy_Code_1: 'code-3',
        Healthcare_Provider_Primary_Taxonomy_Switch_1: 'Y',
        NPI_Deactivation_Date: null,
        NPI_Reactivation_Date: '05/23/2005'
      },
      {
        NPI: 'npi-4',
        Healthcare_Provider_Taxonomy_Code_1: 'code-4',
        Healthcare_Provider_Primary_Taxonomy_Switch_1: 'Y',
        Healthcare_Provider_Taxonomy_Code_2: 'code-5',
        Healthcare_Provider_Primary_Taxonomy_Switch_2: 'N',
        Provider_License_Number_State_Code_2: 'CT',
        Healthcare_Provider_Taxonomy_Code_3: 'code-5',
        Healthcare_Provider_Primary_Taxonomy_Switch_3: 'N',
        Provider_License_Number_State_Code_3: 'NY'
      },
      {
        NPI: 'npi-1',
        Healthcare_Provider_Taxonomy_Code_1: 'code-1',
        Healthcare_Provider_Primary_Taxonomy_Switch_1: 'Y'
      }
    ]
    """
    When we run the '${BATCH}/npi-providers' ingester
    And the following aggregation steps execute on the '${constants.NPI_PROVIDERS}' collection:
    """
      [
        {$sort: {_id: 1}}
      ]
    """
    Then the result should be like:
    """
    [
      {
        _id: 'npi-1',
        npi: 'npi-1',
        specialties: [
          {
            code: 'code-1',
            isPrimary: true
          }
        ]
      },
      {
        _id: 'npi-3',
        npi: 'npi-3',
        specialties: [
          {
            code: 'code-3',
            isPrimary: true
          }
        ]
      },
      {
        _id: 'npi-4',
        npi: 'npi-4',
        specialties: [
          {
            code: 'code-4',
            isPrimary: true
          },
          {
            code: 'code-5'
          }
        ]
      }
    ]
    """
