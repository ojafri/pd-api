@api
Feature: restful api to provide access to plans

  Background:
    Given the following documents exist in the '${constants.CLIENTS}' collection:
    """
    [
      {
        _id: 'c1',
        name: 'c1',
        networks: [
          {
            _id: 'c1:n1',
            name: 'c1:n1',
            plans: [
              {_id: 'c1:n1:p1', name: 'c1:n1:p1'},
              {_id: 'c1:n1:p2', name: 'c1:n1:p2', isInactive: true}
            ]
          }
        ]
      },
      {
        _id: 'c2',
        name: 'c2',
        networks: [
          {
            _id: 'c2:n1',
            name: 'c2:n1'
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        _id: 'p1',
        id: {oid: 'oid1', extension: 'p1'},
        organizationRefs: [
          {
            _id: 'p1:o1',
            organization: {_id: 'o1'},
            tierRefs: [
              {
                _id: 'p1:o1:c1:n1:p1:t1',
                tier: {
                  _id: 'c1:n1:p1:t1',
                  plan: {
                    _id: 'c1:n1:p1',
                    name: 'plan one'
                  }
                }
              },
              {
                _id: 'p1:o1:c1:n1:p2:t1',
                tier: {
                  _id: 'c1:n1:p2:t1',
                  plan: {
                    _id: 'c1:n1:p2',
                    name: 'plan two'
                  }
                }
              }
            ]
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        _id: 'pl1',
        tierRefs: [
          {
            _id: 'pl1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan one'
              }
            }
          },
          {
            _id: 'pl1:c1:n1:p2:t1',
            tier: {
              _id: 'c1:n1:p2:t1',
              plan: {
                _id: 'c1:n1:p2',
                name: 'plan two'
              }
            }
          }
        ]
      },
      {
        _id: 'pl2',
        tierRefs: [
          {
            _id: 'pl2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan one'
              }
            }
          }
        ]
      }
    ]
    """
    And the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'o1',
        tierRefs: [
          {
            _id: 'o1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan one'
              }
            }
          },
          {
            _id: 'o1:c1:n1:p2:t1',
            tier: {
              _id: 'c1:n1:p2:t1',
              plan: {
                _id: 'c1:n1:p2',
                name: 'plan two'
              }
            }
          }
        ]
      },
      {
        _id: 'o2',
        tierRefs: [
          {
            _id: 'o2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan one'
              }
            }
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
        tierRefs: [
          {
            _id: 'ol1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan one'
              }
            }
          },
          {
            _id: 'ol1:c1:n1:p2:t1',
            tier: {
              _id: 'c1:n1:p2:t1',
              plan: {
                _id: 'c1:n1:p2',
                name: 'plan two'
              }
            }
          }
        ]
      },
      {
        _id: 'ol2',
        tierRefs: [
          {
            _id: 'ol2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan one'
              }
            }
          }
        ]
      }
    ]
    """

  Scenario: find plans
    When we HTTP GET '/clients/c1/networks/c1:n1/plans'
    Then our HTTP response should be like:
    """
    [
      {
        _id: 'c1:n1:p1',
        network: {
          _id: 'c1:n1',
          client: {
            _id: 'c1'
          }
        }
      },
      {
        _id: 'c1:n1:p2',
        network: {
          _id: 'c1:n1',
          client: {
            _id: 'c1'
          }
        }
      }
    ]
    """

  Scenario: get plan
    When we HTTP GET '/clients/c1/networks/c1:n2/plans/c1:n1:p2'
    Then our HTTP response should be like:
    """
    {
      _id: 'c1:n1:p2',
      network: {
        _id: 'c1:n1',
        client: {
          _id: 'c1'
        }
      }
    }
    """

  Scenario: find inactive plans
    When we HTTP GET '/clients/c1/networks/c1:n1/plans' with query 'isInactive=true'
    Then our HTTP response should be like:
    """
    [
      {
        _id: 'c1:n1:p2',
        network: {
          _id: 'c1:n1',
          client: {
            _id: 'c1'
          }
        },
        isInactive: true
      }
    ]
    """

  Scenario: create plan
    When we HTTP POST '/clients/c2/networks/c2:n1/plans' with body:
    """
    {name: 'plan one'}
    """
    Then our HTTP response should have status code 201
    And mongo query "{'networks.plans.name': 'plan one'}" on '${constants.CLIENTS}' should be like:
    """
    [
      {
        _id: 'c2',
        networks: [
          {
            _id: 'c2:n1',
            plans: [
              {
                _id: 'c2::1',
                name: 'plan one',
                updated: {
                  date: 'assert(actual.constructor.name == "Date")'
                }
              }
            ]
          }
        ]
      }
    ]
    """

  Scenario: create invalid plan
    When we HTTP POST '/clients/c2/networks/c2:n1/plans' with body:
    """
    {nayme: 'plan one'}
    """
    Then our HTTP response should have status code 422

  Scenario: create duplicate plan
    When we HTTP POST '/clients/c2/networks/c1:n1/plans' with body:
    """
    {name: 'c1:n1:p1'}
    """
    Then our HTTP response should have status code 409

  Scenario: update plan
    When we HTTP PUT '/clients/c1/networks/c1:n1/plans/c1:n1:p1' with body:
    """
    {
      name: 'plan won',
      isInactive: true
    }
    """
    Then our HTTP response should have status code 204
    And mongo query "{_id: 'c1'}" on '${constants.CLIENTS}' should be like:
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
                name: 'plan won',
                isInactive: true,
                updated: {date: 'assert(actual.constructor.name == "Date")'}
              },
              {_id: 'c1:n1:p2'}
            ]
          }
        ]
      }
    ]
    """
    And mongo query "{}" on '${constants.PROVIDERS}' should be like:
    """
    [
      {
        _id: 'p1',
        organizationRefs: [
          {
            _id: 'p1:o1',
            organization: {_id: 'o1'},
            tierRefs: [
              {
                _id: 'p1:o1:c1:n1:p1:t1',
                tier: {
                  _id: 'c1:n1:p1:t1',
                  plan: {
                    _id: 'c1:n1:p1',
                    name: 'plan won'
                  }
                }
              },
              {
                _id: 'p1:o1:c1:n1:p2:t1',
                tier: {
                  _id: 'c1:n1:p2:t1',
                  plan: {
                    _id: 'c1:n1:p2',
                    name: 'plan two'
                  }
                }
              }
            ]
          }
        ]
      }
    ]
    """
    And mongo query "{'tierRefs.tier.plan._id': 'c1:n1:p1'}" on '${constants.PROVIDER_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'pl1',
        tierRefs: [
          {
            _id: 'pl1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan won'
              }
            }
          },
          {
            _id: 'pl1:c1:n1:p2:t1',
            tier: {
              _id: 'c1:n1:p2:t1',
              plan: {
                _id: 'c1:n1:p2',
                name: 'plan two'
              }
            }
          }
        ]
      },
      {
        _id: 'pl2',
        tierRefs: [
          {
            _id: 'pl2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan won'
              }
            }
          }
        ]
      }
    ]
    """
    And mongo query "{'tierRefs.tier.plan._id': 'c1:n1:p1'}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'o1',
        tierRefs: [
          {
            _id: 'o1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan won'
              }
            }
          },
          {
            _id: 'o1:c1:n1:p2:t1',
            tier: {
              _id: 'c1:n1:p2:t1',
              plan: {
                _id: 'c1:n1:p2',
                name: 'plan two'
              }
            }
          }
        ]
      },
      {
        _id: 'o2',
        tierRefs: [
          {
            _id: 'o2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan won'
              }
            }
          }
        ]
      }
    ]
    """
    And mongo query "{'tierRefs.tier.plan._id': 'c1:n1:p1'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
    """
    [
      {
        _id: 'ol1',
        tierRefs: [
          {
            _id: 'ol1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan won'
              }
            }
          },
          {
            _id: 'ol1:c1:n1:p2:t1',
            tier: {
              _id: 'c1:n1:p2:t1',
              plan: {
                _id: 'c1:n1:p2',
                name: 'plan two'
              }
            }
          }
        ]
      },
      {
        _id: 'ol2',
        tierRefs: [
          {
            _id: 'ol2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                name: 'plan won'
              }
            }
          }
        ]
      }
    ]
    """

  Scenario: update invalid plan
    When we HTTP PUT '/clients/c1/networks/c1:n1/plans/c1:n1:p1' with body:
    """
    {nayme: 'c1:n1:p1'}
    """
    Then our HTTP response should have status code 422

  Scenario: update duplicate plan
    When we HTTP PUT '/clients/c1/networks/c1:n1/plans/c1:n1:p1' with body:
    """
    {name: 'c1:n1:p2'}
    """
    Then our HTTP response should have status code 409