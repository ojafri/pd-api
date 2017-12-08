@api
Feature: practitioner-organization-tiers

  Background:
    Given the following documents exist in the '${constants.CLIENTS}' collection:
    """
    [
      {
        _id: 'c1',
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
    And the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        _id: 's1:p1',
        id: {oid: 'oid1', extension: 'p1'},
        organizationRefs: [
          {
            _id: 's1:p1:s1:o1',
            organization: {_id: 's1:o1'},
            tierRefs: [
              {
                _id: 's1:p1:s1:o1:c1:n1:p1:t1',
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
                _id: 's1:p1:s1:o1:c2:n1:p1:t1',
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
            _id: 's1:p1:s1:o2',
            organization: {_id: 's1:o2'}
          }
        ]
      },
      {
        _id: 's1:p2',
        id: {oid: 'oid1', extension: 'p2'},
        organizationRefs: [
          {
            _id: 's1:p2:s1:o2',
            organization: {_id: 's1:o2'}
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        _id: 's1:p1:s1:o1:l1',
        practitioner: {_id: 's1:p1'},
        location: {organization: {_id: 's1:o1'}},
        tierRefs: [
          {
            _id: 's1:p1:s1:o1:c1:n1:p1:t1',
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
            _id: 's1:p1:s1:o1:c2:n1:p1:t1',
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
        _id: 'c1:p1:c1:o1:l1',
        practitioner: {_id: 'c1:p1'},
        location: {organization: {_id: 'c1:o1'}},
        tierRefs: [
          {
            _id: 'c1:p1:c1:o1:c1:n1:p1:t1',
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
        _id: 's1:p2:s1:o2:l1',
        practitioner: {_id: 's1:p2'},
        location: {organization: {_id: 's1:o2'}}
      }
    ]
    """

  Scenario: find practitioner-organization-tiers without client
    When we HTTP GET '/practitioner-organization-tiers'
    Then our HTTP response should have status code 500

  Scenario: find practitioner-organization-tiers for client
    When we HTTP GET '/practitioner-organization-tiers' with query 'source._id=c1'
    Then our HTTP response should be like:
    """
    [
      {_id: 's1:p1:s1:o1:c1:n1:p1:t1'}
    ]
    """

  Scenario: get practitioner-organization-tier
    When we HTTP GET '/practitioner-organization-tiers/s1:p1:s1:o1:c1:n1:p1:t1'
    Then our HTTP response should be like:
    """
      {
        _id: 's1:p1:s1:o1:c1:n1:p1:t1',
        practitionerOrganization: {
          _id: 's1:p1:s1:o1',
          practitioner: {_id: 's1:p1'},
          organization: {_id: 's1:o1'}
        },
        tier: {_id: 'c1:n1:p1:t1'}
      }
    """

  Scenario: get non-existent practitioner-organization-tier
    When we HTTP GET '/practitioner-organization-tiers/nope'
    Then our HTTP response should have status code 404

  Scenario: create practitioner-organization-tier
    When we HTTP POST '/practitioner-organization-tiers?practitionerOrganization._id=s1:p2:s1:o2&tier._id=c1:n1:p1:t2' with body:
    """
    {}
    """
    Then our HTTP response should have status code 201
    And mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 's1:p1',
        organizationRefs: [
          {
            _id: 's1:p1:s1:o1',
            tierRefs: [
              {
                _id: 's1:p1:s1:o1:c1:n1:p1:t1'
              },
              {
                _id: 's1:p1:s1:o1:c2:n1:p1:t1'
              }
            ]
          },
          {
            _id: 's1:p1:s1:o2'
          }
        ]
      },
      {
        _id: 's1:p2',
        organizationRefs: [
          {
            _id: 's1:p2:s1:o2',
            tierRefs: [
              {
                _id: 's1:p2:s1:o2:c1:n1:p1:t2',
                tier: {
                  _id: 'c1:n1:p1:t2',
                  plan: {
                    _id: 'c1:n1:p1',
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
      }
    ]
    """
    And mongo query "{'practitioner._id': 's1:p2'}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 's1:p2:s1:o2:l1',
        tierRefs: [
          {
            _id: 's1:p2:s1:o2:c1:n1:p1:t2'
          }
        ]
      }
    ]
    """

  Scenario: update practitioner-organization-tier
    When we HTTP PUT '/practitioner-organization-tiers/s1:p1:s1:o1:c2:n1:p1:t1' with body:
    """
    {
      isInactive: true
    }
    """
    Then our HTTP response should have status code 204
    And mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 's1:p1',
        organizationRefs: [
          {
            _id: 's1:p1:s1:o1',
            tierRefs: [
              {
                _id: 's1:p1:s1:o1:c1:n1:p1:t1'
              },
              {
                _id: 's1:p1:s1:o1:c2:n1:p1:t1',
                isInactive: true
              }
            ]
          },
          {
            _id: 's1:p1:s1:o2',
            tierRefs: undefined
          }
        ]
      },
      {
        _id: 's1:p2',
        organizationRefs: [
          {
            _id: 's1:p2:s1:o2',
            tierRefs: undefined
          }
        ]
      }
    ]
    """
    And mongo query "{'practitioner._id': 's1:p1'}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 's1:p1:s1:o1:l1',
        tierRefs: [
          {
            _id: 's1:p1:s1:o1:c1:n1:p1:t1'
          },
          {
            _id: 's1:p1:s1:o1:c2:n1:p1:t1',
            isInactive: true
          }
        ]
      }
    ]
    """

  Scenario: update non-existent practitioner-organization-tier
    When we HTTP PUT '/practitioner-organization-tiers/nope' with body:
    """
    {foo: 'bar'}
    """
    Then our HTTP response should have status code 404

  Scenario: delete practitioner-organization-tier
    When we HTTP DELETE '/practitioner-organization-tiers/s1:p1:s1:o1:c1:n1:p1:t1'
    Then our HTTP response should have status code 204
    And mongo query "{_id: 's1:p1'}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 's1:p1',
        organizationRefs: [
          {
            _id: 's1:p1:s1:o1',
            tierRefs: [
              {
                _id: 's1:p1:s1:o1:c2:n1:p1:t1'
              }
            ]
          },
          {
            _id: 's1:p1:s1:o2'
          }
        ]
      }
    ]
    """
    And mongo query "{'practitioner._id': 's1:p1', 'location.organization._id': 's1:o1'}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 's1:p1:s1:o1:l1',
        tierRefs: [
          {
            _id: 's1:p1:s1:o1:c2:n1:p1:t1'
          }
        ]
      }
    ]
    """

  Scenario: delete non-existent practitioner-organization-tier
    When we HTTP DELETE '/practitioner-organization-tiers/nope'
    Then our HTTP response should have status code 404
