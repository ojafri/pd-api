@api
Feature: organization-tiers

  Background:
    Given the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 's1:o1',
        id: {oid: 'oid1', extension: 'o1'},
        identifiers: [{oid: 'oid1', extension: 'o1'}],
        name: 'org one',
        created: {
          source: {_id: '-1'},
        },
        tierRefs: [
          {
            _id: 's1:o1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1:n1:p1',
                // product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 's1:o1:c2:n1:p1:t1',
            tier: {
              _id: 'c2:n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c2:n1:p1',
                // product: 'c2:n1:pr1',
                network: {
                  _id: 'c2:n1',
                  client: {
                    _id: 'c2'
                  }
                }
              }
            }
          }
        ]
      },
      {
        _id: 'c1:o1',
        id: {oid: 'oid1', extension: 'o1'},
        created: {
          source: {_id: 'c1'}
        },
        tierRefs: [
          {
            _id: 'c1:o1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1:n1:p1',
                // product: 'c1:n1:pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      },
      {
        _id: 's1:o2',
        id: {oid: 'oid1', extension: 'o2'},
        created: {
          source: {_id: '-1'},
        }
      }
    ]
    """
    And the following documents exist in the '${constants.CLIENTS}' collection:
    """
    [
      {
        _id: 'c1',
        name: 'ceeOne',
        networks: [
          {
            _id: 'c1:n1',
            plans: [
              {
                _id: 'c1:n1:p1',
                // product: {
                //   _id: 'c1:n1:pr1',
                //   name: 'pr1'
                // },
                tiers: [
                  {_id: 'c1:n1:p1:t1', isInactive: true, rank: 1},
                  {_id: 'c1:n1:p1:t2', isInactive: false, rank: 2}
                ]
              }
            ]
          }
        ]
      },
      {
        _id: 'c2',
        networks: [
          {
            _id: 'c2:n1',
            plans: [
              {
                _id: 'c2:n1:p1',
                tiers: [
                  {_id: 'c2:n1:p1:t1', isInactive: true, rank: 1},
                  {_id: 'c2:n1:p1:t2', isInactive: false, rank: 2}
                ]
              }
            ]
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATION_LOCATIONS}' collection:
    """
    [
      {
        _id: 'ol1',
        organization: {_id: 's1:o1'},
        tierRefs: [
          {_id: 's1:o1:c1:n1:p1:t1'},
          {_id: 's1:o1:c2:n1:p1:t1'}
        ]
      },
      {
        _id: 'ol2',
        organization: {_id: 's1:o2'}
      }
    ]
    """

  Scenario: find organization-tiers without client
    When we HTTP GET '/organization-tiers'
    Then our HTTP response should have status code 500

  Scenario: find organization-tiers for client
    When we HTTP GET '/organization-tiers' with query 'source._id=c1'
    Then our HTTP response should be like:
    """
    [
      {_id: 's1:o1:c1:n1:p1:t1', created: {source: {_id: '-1'}}},
      {_id: 'c1:o1:c1:n1:p1:t1', created: {source: {_id: 'c1'}}}
    ]
    """

  Scenario: get organization-tier
    When we HTTP GET '/organization-tiers/s1:o1:c1:n1:p1:t1'
    Then our HTTP response should be like:
    """
    {
      _id: 's1:o1:c1:n1:p1:t1',
      organization: {
        _id: 's1:o1',
        id: {
          oid: 'oid1',
          extension: 'o1'
        },
        identifiers: [
          {
            oid: 'oid1',
            extension: 'o1'
          }
        ],
        name: 'org one'
      }
    }
    """

  Scenario: get non-existent organization-tier
    When we HTTP GET '/organization-tiers/nope'
    Then our HTTP response should have status code 404

  Scenario: create organization-tier
    When we HTTP POST '/organization-tiers?organization._id=s1:o2&tier._id=c1:n1:p1:t1' with body:
    """
    {
      isInactive: true
    }
    """
    Then our HTTP response should have status code 201
    And mongo query "{_id: 's1:o2'}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 's1:o2',
        tierRefs: [
          {
            _id: 's1:o2:c1:n1:p1:t1',
            isInactive: true,
            tier: {
              _id: 'c1:n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1:n1:p1',
                // product: 'pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """
    And mongo query "{'organization._id': 's1:o2'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'ol2',
        organization: {_id: 's1:o2'},
        tierRefs: [
          {
            _id: 's1:o2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1:n1:p1',
                // product: 'pr1',
                network: {
                  _id: 'c1:n1',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          }
        ]
      }
    ]
    """

  Scenario: create duplicate organization-tier
    When we HTTP POST '/organization-tiers?organization._id=s1:o1&tier._id=c1:n1:p1:t1' with body:
    """
    {
    }
    """
    Then our HTTP response should have status code 409

  Scenario: update organization-tier
    When we HTTP PUT '/organization-tiers/s1:o1:c2:n1:p1:t1' with body:
    """
    {isInactive: true}
    """
    Then our HTTP response should have status code 500
    # Then our HTTP response should have status code 204
    # And mongo query "{_id: 's1:o1'}" on '${constants.ORGANIZATIONS}' should be like:
    # """
    # [
    #   {
    #     _id: 's1:o1',
    #     tierRefs: [
    #       {
    #         _id: 's1:o1:c1:n1:p1:t1'
    #       },
    #       {
    #         _id: 's1:o1:c2:n1:p1:t1',
    #         isInactive: true
    #       }
    #     ]
    #   }
    # ]
    # """
    # And mongo query "{'organization._id': 's1:o1'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    # """
    # [
    #   {
    #     _id: 'ol1',
    #     organization: {_id: 's1:o1'},
    #     tierRefs: [
    #       {
    #         _id: 's1:o1:c1:n1:p1:t1'
    #       },
    #       {
    #         _id: 's1:o1:c2:n1:p1:t1',
    #         isInactive: true
    #       }
    #     ]
    #   }
    # ]
    # """

  Scenario: update non-existent organization-tier
    When we HTTP PUT '/organization-tiers/nope' with body:
    """
    {foo: 'bar'}
    """
    Then our HTTP response should have status code 500
    # Then our HTTP response should have status code 404

  Scenario: delete organization-tier
    When we set the following HTTP headers:
    """
    {
      authorization: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJjaHIiLCJ1c2VySWQiOiIxMjMiLCJ1c2VyTmFtZSI6ImpvaG4gZG9lIiwiY2xpZW50SWQiOiJjMSJ9._CjFrsNP_jCLg1M24-W6POjp4Z8LNd7pQD2irXYlJok'
    }
    """
    And we HTTP DELETE '/organization-tiers/s1:o1:c1:n1:p1:t1'
    Then our HTTP response should have status code 204
    And mongo query "{'_id': 's1:o1'}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 's1:o1',
        tierRefs: [{_id: 's1:o1:c2:n1:p1:t1'}]
      }
    ]
    """
    And mongo query "{'organization._id': 's1:o1'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'ol1',
        organization: {_id: 's1:o1'},
        tierRefs: [{_id: 's1:o1:c2:n1:p1:t1'}]
      }
    ]
    """
    And mongo query "{}" on '${constants.ORGANIZATIONS}History' should be like:
    """
    [
      {
        source: {
          _id: 'c1',
          name: 'ceeOne'
        },
        mode: constants.MODES.delete,
        date: 'assert(actual.constructor.name == "Date")',
        data: {
          _id: 's1:o1',
          tierRefs: [
            {_id: 's1:o1:c1:n1:p1:t1'},
            {_id: 's1:o1:c2:n1:p1:t1'}
          ]
        }
      }
    ]
    """

  Scenario: delete non-existent organization-tier
    When we HTTP DELETE '/organization-tiers/nope'
    Then our HTTP response should have status code 404
