@batch
Feature: client organizations
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
    And the following documents exist in the '${constants.ORGANIZATION_LOCATIONS}' collection:
    """
    [
      {
        organization: {
          _id: 'e:oid-1:ext-1',
          name: 'name-1'
        }
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        organizationRefs: [
          {
            _id: 'or-1',
            organization: {
              _id: 'e:oid-1:ext-1',
              name: 'name-1'
            }
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        location: {
          _id: 'ol-1',
          organization: {
            _id: 'e:oid-1:ext-1',
            name: 'name-1'
          }
        }
      }
    ]
    """

  Scenario: ingest client-organizations: insert
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATIONS_SOURCE}' collection:
    """
    [
      {
        authority: 'auth-1',
        oid: 'oid-1',
        extension: 'ext-1',
        name: 'name-1',
        specialtyCodes: 'code-1|code-2',
        hospitals: 'hosp-1|hosp-2',
        insurances: 'ins-1|ins-2',
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
    When we run the '${BATCH}/client-organizations' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {inserted: 1}
    }
    """
    And mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-1',
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
        hospitals: ['hosp-1', 'hosp-2'],
        insurances: ['ins-1', 'ins-2'],
        website: 'website-1',
        direct: 'direct-1@medicity.com',
        email: 'email-1@medicity.com',
        description: 'description-1',
        isInactive: true,
        isPrivate: true,
        created: {
          source: {
            _id: 'c1'
          }
        },
        updated: {
          source: {
            _id: 'c1'
          }
        }
      }
    ]
    """

  Scenario: ingest client-organizations: insert: record-id
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATIONS_SOURCE}' collection:
    """
    [
      {
        authority: 'auth-1',
        oid: 'oid-1',
        extension: 'ext-1',
        name: 'name-1',
        specialtyCodes: 'code-1',
        recordId: 'rid-1',
        action: constants.MODES.create
      }
    ]
    """
    When we run the '${BATCH}/client-organizations' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {inserted: 1}
    }
    """
    And mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-1',
        name: 'name-1',
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
          }
        ]
      }
    ]
    """

  Scenario: ingest client-organizations: insert: mixed fail
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATIONS_SOURCE}' collection:
    """
    [
      {
        authority: 'auth-1',
        oid: 'oid-1',
        extension: 'ext-1',
        name: 'name-1',
        action: constants.MODES.create
      },
      {
        authority: 'auth-2',
        oid: 'oid-2',
        extension: 'ext-2',
        name: 'name-2',
        specialtyCodes: 'code-2',
        action: constants.MODES.create
      }
    ]
    """
    When we run the '${BATCH}/client-organizations' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {inserted: 1, failed: 1}
    }
    """
    And mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-2:ext-2',
        name: 'name-2',
        id: {
          oid: 'oid-2',
          authority: 'auth-2',
          extension: 'ext-2'
        },
        specialties: [
          {
            code: 'code-2',
            classification: 'class-2',
            specialization: 'spec-2',
            system: 'sys-2',
            isPrimary: true
          }
        ]
      }
    ]
    """

  Scenario: ingest client-organizations: update
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATIONS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        name: 'name-2',
        action: constants.MODES.update
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-1',
        id: {
          oid: 'oid-1',
          authority: 'auth-1',
          extension: 'ext-1'
        },
        created: {
          source: {
            _id: 'c1'
          }
        },
        updated: {
          source: {
            _id: 'c1'
          }
        }
      }
    ]
    """
    When we run the '${BATCH}/client-organizations' ingester with environment:
    """
    {
      sourceId: 'c2'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {updated: 1}
    }
    """
    And mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-2',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        },
        updated: {
          source: {
            _id: 'c2'
          }
        }
      }
    ]
    """
    And mongo query "{}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        organization: {
          _id: 'e:oid-1:ext-1',
          name: 'name-2'
        }
      }
    ]
    """
    And mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        organizationRefs: [
          {
            _id: 'or-1',
            organization: {
              _id: 'e:oid-1:ext-1',
              name: 'name-2'
            }
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        location: {
          _id: 'ol-1',
          organization: {
            _id: 'e:oid-1:ext-1',
            name: 'name-2'
          }
        }
      }
    ]
    """
    And mongo query "{}" on '${constants.ORGANIZATIONS}History' should be like:
    """
    [
      {
        source: {
          _id: 'c2'
        },
        data: {
          _id: 'e:oid-1:ext-1',
          name: 'name-1',
          id: {
            authority: 'auth-1',
            oid: 'oid-1',
            extension: 'ext-1'
          },
          created: {
            source: {
              _id: 'c1'
            }
          },
          updated: {
            source: {
              _id: 'c1'
            }
          }
        }
      }
    ]
    """

  Scenario: ingest client-organizations: update: fail
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATIONS_SOURCE}' collection:
    """
    [
      {
        oid: 'oid-1',
        extension: 'ext-1',
        isInactive: 'not a boolean',
        action: constants.MODES.update
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-1',
        id: {
          oid: 'oid-1',
          authority: 'auth-1',
          extension: 'ext-1'
        },
        specialties: [
          {
            code: 'code-1'
          }
        ],
        created: {
          source: {_id: 'c1'}
        },
        updated: {
          source: {_id: 'c1'}
        }
      }
    ]
    """
    When we run the '${BATCH}/client-organizations' ingester with environment:
    """
    {
      sourceId: 'c2'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {failed: 1}
    }
    """
    And mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'e:oid-1:ext-1',
        name: 'name-1',
        id: {
          authority: 'auth-1',
          oid: 'oid-1',
          extension: 'ext-1'
        },
        isInactive: undefined,
        updated: {
          source: {_id: 'c1'}
        }
      }
    ]
    """

  Scenario: ingest client-organizations: update: record-id
    Given the following documents exist in the '${constants.CLIENT_ORGANIZATIONS_SOURCE}' collection:
    """
    [
      {
        recordId: 'rid-1',
        oid: 'oid-2',
        extension: 'ext-2',
        name: 'name-2',
        action: constants.MODES.update
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'c1:rid-1',
        name: 'name-1',
        id: {
          oid: 'oid-1',
          authority: 'auth-1',
          extension: 'ext-1'
        },
        specialties: [
          {
            code: 'code-1'
          }
        ],
        created: {
          source: {_id: 'c1'}
        },
        updated: {
          source: {_id: 'c1'}
        }
      }
    ]
    """
    When we run the '${BATCH}/client-organizations' ingester with environment:
    """
    {
      sourceId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {updated: 1}
    }
    """
    And mongo query "{}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'c1:rid-1',
        name: 'name-2',
        id: {
          authority: 'auth-1',
          oid: 'oid-2',
          extension: 'ext-2'
        },
        updated: {
          source: {
            _id: 'c1'
          }
        }
      }
    ]
    """
