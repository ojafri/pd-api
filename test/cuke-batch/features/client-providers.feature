@batch
Feature: client providers
  Background:
    Given the following documents exist in the '${constants.CLIENTS}' collection:
    """
    [
      {
        _id: 'c1',
        name: 'ceeOne'
      },
      {
        _id: 'c2',
        name: 'ceeTwo'
      }
    ]
    """
    And the following documents exist in the '${constants.SPECIALTIES}' collection:
    """
    [
      {
        code: 'code-1',
        classification: 'class-1',
        specialization: 'spec-1',
        system: 'sys-1'
      },
      {
        code: 'code-2',
        classification: 'class-2',
        specialization: 'spec-2',
        system: 'sys-2'
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        practitioners: [
          {
            _id: 'c1:rid-2',
            id: {
              oid: 'oid-2',
              extension: 'ext-2'
            },
            name: {
              first: 'fname-2',
              last: 'lname-2'
            }
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        _id: 'c1:rid-2',
        name: {
          first: 'fname-2',
          last: 'lname-2'
        },
        id: {
          oid: 'oid-2',
          authority: 'auth-2',
          extension: 'ext-2'
        },
        website: 'website-2',
        updated: {
          source: {
            _id: 'c1'
          }
        }
      }
    ]
    """

  Scenario: ingest client-providers: insert
    Given the following documents exist in the '${constants.CLIENT_PROVIDERS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        authority: 'auth-1',
        firstName: 'fname-1',
        lastName: 'lname-1',
        specialtyCodes: 'code-1|code-2',
        hospitals: 'hosp-1|hosp-2',
        education: 'education-1|education-2',
        gender: 'M',
        insurances: 'ins-1|ins-2',
        languages: 'en|es',
        website: 'website-1',
        direct: 'direct-1@medicity.com',
        email: 'email-1@medicity.com',
        description: 'description-1',
        isPrivate: true,
        isInactive: true,
        recordId: false,
        action: constants.MODES.create
      }
    ]
    """
    When we run the '${BATCH}/client-providers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then mongo query "{_id: 'e:oid-1:ext-1'}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: {
          first: 'fname-1',
          last: 'lname-1'
        },
        id: {
          oid: 'oid-1',
          authority: 'auth-1',
          extension: 'ext-1'
        },
        specialties: [
          {
            code: 'code-1',
            classification: 'class-1',
            specialization: 'spec-1',
            system: 'sys-1',
            isPrimary: true
          },
          {
            code: 'code-2',
            classification: 'class-2',
            specialization: 'spec-2',
            system: 'sys-2'
          }
        ],
        education: ['education-1', 'education-2'],
        gender: 'M',
        languages: ['en', 'es'],
        hospitals: ['hosp-1', 'hosp-2'],
        insurances: ['ins-1', 'ins-2'],
        website: 'website-1',
        direct: 'direct-1@medicity.com',
        email: 'email-1@medicity.com',
        description: 'description-1',
        isInactive: true,
        isPrivate: true
      }
    ]
    """

  Scenario: ingest client-providers: insert: record-id
    Given the following documents exist in the '${constants.CLIENT_PROVIDERS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        authority: 'auth-1',
        firstName: 'fname-1',
        lastName: 'lname-1',
        specialtyCodes: 'code-1|code-2',
        hospitals: 'hosp-1|hosp-2',
        education: 'education-1|education-2',
        gender: 'M',
        insurances: 'ins-1|ins-2',
        languages: 'en|es',
        website: 'website-1',
        direct: 'direct-1@medicity.com',
        email: 'email-1@medicity.com',
        description: 'description-1',
        isPrivate: true,
        isInactive: true,
        recordId: 'rid-1',
        action: constants.MODES.create
      }
    ]
    """
    When we run the '${BATCH}/client-providers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then mongo query "{_id: 'c1:rid-1'}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 'c1:rid-1',
        name: {
          first: 'fname-1',
          last: 'lname-1'
        },
        id: {
          oid: 'oid-1',
          authority: 'auth-1',
          extension: 'ext-1'
        },
        specialties: [
          {
            code: 'code-1',
            classification: 'class-1',
            specialization: 'spec-1',
            system: 'sys-1',
            isPrimary: true
          },
          {
            code: 'code-2',
            classification: 'class-2',
            specialization: 'spec-2',
            system: 'sys-2'
          }
        ],
        education: ['education-1', 'education-2'],
        gender: 'M',
        languages: ['en', 'es'],
        hospitals: ['hosp-1', 'hosp-2'],
        insurances: ['ins-1', 'ins-2'],
        website: 'website-1',
        direct: 'direct-1@medicity.com',
        email: 'email-1@medicity.com',
        description: 'description-1',
        isInactive: true,
        isPrivate: true
      }
    ]
    """

  Scenario: ingest client-providers: update
    Given the following documents exist in the '${constants.CLIENT_PROVIDERS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-2',
        extension: 'ext-2',
        firstName: 'fname-3',
        action: constants.MODES.update
      }
    ]
    """
    When we run the '${BATCH}/client-providers' ingester with environment:
    """
    {
      sourceId: 'c2'
    }
    """
    Then mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 'c1:rid-2',
        name: {
          first: 'fname-3'
        },
        updated: {
          source: {
            _id: 'c2'
          }
        }
      }
    ]
    """
    And mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        practitioners: [
          {
            _id: 'c1:rid-2',
            name: {
              first: 'fname-3'
            }
          }
        ]
      }
    ]
    """

  Scenario: ingest client-providers: update: non-existent
    Given the following documents exist in the '${constants.CLIENT_PROVIDERS_SOURCE}' collection:
    """
    [
      {
        oid: 'nope',
        extension: 'nope',
        firstName: 'fname-3',
        action: constants.MODES.update
      }
    ]
    """
    When we run the '${BATCH}/client-providers' ingester with environment:
    """
    {
      sourceId: 'c2'
    }
    """
    Then mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 'c1:rid-2',
        name: {
          first: 'fname-2'
        },
        updated: {
          source: {
            _id: 'c1'
          }
        }
      }
    ]
    """
    And our resultant state should be like:
    """
    {
      result: {failed: 1}
    }
    """

  Scenario: ingest client-providers: update: record-id
    Given the following documents exist in the '${constants.CLIENT_PROVIDERS_SOURCE}' collection:
    """
    [
      {
        recordId: 'rid-2',
        authority: 'auth-3',
        oid: 'oid-3',
        extension: 'ext-3',
        firstName: 'fname-3',
        action: constants.MODES.update
      }
    ]
    """
    When we run the '${BATCH}/client-providers' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 'c1:rid-2',
        id: {
          oid: 'oid-3',
          extension: 'ext-3',
          authority: 'auth-3'
        },
        name: {
          first: 'fname-3'
        },
        updated: {
          source: {
            _id: 'c1'
          }
        }
      }
    ]
    """
    And mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        practitioners: [
          {
            _id: 'c1:rid-2',
            id: {
              oid: 'oid-3',
              extension: 'ext-3',
              authority: 'auth-3'
            },
            name: {
              first: 'fname-3'
            }
          }
        ]
      }
    ]
    """
