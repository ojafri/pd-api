@api
Feature: restful api to provide access to networks

  Background:
    Given the following documents exist in the '${constants.CLIENTS}' collection:
    """
    [
      {
        _id: 'c1',
        networks: [
          {_id: 'c1:n1', name: 'c1:n1'},
          {_id: 'c1:n2', name: 'c1:n2'},
          {_id: 'c1:n3', name: 'c1:n3', isInactive: true}
        ]
      },
      {
        _id: 'c2',
        networks: [
          {_id: 'c2:n1'},
          {_id: 'c2:n2'}
        ]
      },
      {
        _id: 'c3'
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
            _id: 's1:p1:s1:o1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                network: {
                  _id: 'c1:n1',
                  name: 'network one',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 's1:p1:s1:o1:c1:n2:p1:t1',
            tier: {
              _id: 'c1:n2:p1:t1',
              plan: {
                _id: 'c1:n2:p1',
                network: {
                  _id: 'c1:n2',
                  name: 'network two',
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
        _id: 'o2',
        tierRefs: [
          {
            _id: 's1:p1:s1:o2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                network: {
                  _id: 'c1:n1',
                  name: 'network one',
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
                network: {
                  _id: 'c1:n1',
                  name: 'network one',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 'ol1:c1:n2:p1:t1',
            tier: {
              _id: 'c1:n2:p1:t1',
              plan: {
                _id: 'c1:n2:p1',
                network: {
                  _id: 'c1:n2',
                  name: 'network two',
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
        _id: 'ol2',
        tierRefs: [
          {
            _id: 'ol2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                network: {
                  _id: 'c1:n1',
                  name: 'network one',
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
                network: {
                  _id: 'c1:n1',
                  name: 'network one',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 'pl1:c1:n2:p1:t1',
            tier: {
              _id: 'c1:n2:p1:t1',
              plan: {
                _id: 'c1:n2:p1',
                network: {
                  _id: 'c1:n2',
                  name: 'network two',
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
        _id: 'pl2',
        tierRefs: [
          {
            _id: 'pl2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                network: {
                  _id: 'c1:n1',
                  name: 'network one',
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
    And the following documents exist in the '${constants.PROVIDERS}' collection:
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
                    network: {
                      _id: 'c1:n1',
                      name: 'network one',
                      client: {
                        _id: 'c1'
                      }
                    }
                  }
                }
              },
              {
                _id: 'p1:o1:c1:n2:p1:t1',
                tier: {
                  _id: 'c1:n2:p1:t1',
                  plan: {
                    _id: 'c1:n2:p1',
                    network: {
                      _id: 'c1:n2',
                      name: 'network two',
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

  Scenario: find networks
    When we HTTP GET '/clients/c1/networks'
    Then our HTTP response should be like:
    """
    [
      {_id: 'c1:n1', client: {_id: 'c1'}},
      {_id: 'c1:n2', client: {_id: 'c1'}},
      {_id: 'c1:n3', client: {_id: 'c1'}}
    ]
    """

  Scenario: get network
    When we HTTP GET '/clients/c1/networks/c1:n2'
    Then our HTTP response should be like:
    """
      {_id: 'c1:n2', client: {_id: 'c1'}}
    """

  Scenario: find inactive networks
    When we HTTP GET '/clients/c1/networks' with query 'isInactive=true'
    Then our HTTP response should be like:
    """
    [
      {_id: 'c1:n3', client: {_id: 'c1'}, isInactive: true}
    ]
    """

  Scenario: create network
    When we HTTP POST '/clients/c3/networks' with body:
    """
    {name: 'net one'}
    """
    Then our HTTP response should have status code 201
    And mongo query "{'networks.name': 'net one'}" on '${constants.CLIENTS}' should be like:
    """
    [{_id: 'c3', networks: [{_id: 'c3::1', name: 'net one', updated: {date: 'assert(actual.constructor.name == "Date")'}}]}]
    """

  Scenario: create invalid network
    When we HTTP POST '/clients/c3/networks' with body:
    """
    {nayme: 'c3:n1'}
    """
    Then our HTTP response should have status code 422

  Scenario: create duplicate network
    When we HTTP POST '/clients/c1/networks' with body:
    """
    {name: 'c1:n1'}
    """
    Then our HTTP response should have status code 409

  Scenario: update network
    When we HTTP PUT '/clients/c1/networks/c1:n1' with body:
    """
    {name: 'network won', isInactive: true}
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
            name: 'network won',
            isInactive: true,
            updated: {date: 'assert(actual.constructor.name == "Date")'}
          },
          {_id: 'c1:n2'},
          {_id: 'c1:n3', isInactive: true}
        ]
      }
    ]
    """
    And mongo query "{'tierRefs.tier.plan.network._id': 'c1:n1'}" on '${constants.ORGANIZATIONS}' should be like:
    """
    [
      {
        _id: 'o1',
        tierRefs: [
          {
            _id: 's1:p1:s1:o1:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                network: {
                  _id: 'c1:n1',
                  name: 'network won',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 's1:p1:s1:o1:c1:n2:p1:t1',
            tier: {
              _id: 'c1:n2:p1:t1',
              plan: {
                _id: 'c1:n2:p1',
                network: {
                  _id: 'c1:n2',
                  name: 'network two',
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
        _id: 'o2',
        tierRefs: [
          {
            _id: 's1:p1:s1:o2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                network: {
                  _id: 'c1:n1',
                  name: 'network won',
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
    And mongo query "{'tierRefs.tier.plan.network._id': 'c1:n1'}" on '${constants.ORGANIZATION_LOCATIONS}' should be like:
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
                network: {
                  _id: 'c1:n1',
                  name: 'network won',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 'ol1:c1:n2:p1:t1',
            tier: {
              _id: 'c1:n2:p1:t1',
              plan: {
                _id: 'c1:n2:p1',
                network: {
                  _id: 'c1:n2',
                  name: 'network two',
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
        _id: 'ol2',
        tierRefs: [
          {
            _id: 'ol2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                network: {
                  _id: 'c1:n1',
                  name: 'network won',
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
    And mongo query "{'tierRefs.tier.plan.network._id': 'c1:n1'}" on '${constants.PROVIDER_LOCATIONS}' should be like:
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
                network: {
                  _id: 'c1:n1',
                  name: 'network won',
                  client: {
                    _id: 'c1'
                  }
                }
              }
            }
          },
          {
            _id: 'pl1:c1:n2:p1:t1',
            tier: {
              _id: 'c1:n2:p1:t1',
              plan: {
                _id: 'c1:n2:p1',
                network: {
                  _id: 'c1:n2',
                  name: 'network two',
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
        _id: 'pl2',
        tierRefs: [
          {
            _id: 'pl2:c1:n1:p1:t1',
            tier: {
              _id: 'c1:n1:p1:t1',
              plan: {
                _id: 'c1:n1:p1',
                network: {
                  _id: 'c1:n1',
                  name: 'network won',
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
                    network: {
                      _id: 'c1:n1',
                      name: 'network won',
                      client: {
                        _id: 'c1'
                      }
                    }
                  }
                }
              },
              {
                _id: 'p1:o1:c1:n2:p1:t1',
                tier: {
                  _id: 'c1:n2:p1:t1',
                  plan: {
                    _id: 'c1:n2:p1',
                    network: {
                      _id: 'c1:n2',
                      name: 'network two',
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

  Scenario: update invalid network
    When we HTTP PUT '/clients/c1/networks/c1:n1' with body:
    """
    {nayme: 'c1:n1'}
    """
    Then our HTTP response should have status code 422

  Scenario: update duplicate network
    When we HTTP PUT '/clients/c1/networks/c1:n2' with body:
    """
    {name: 'c1:n1'}
    """
    Then our HTTP response should have status code 409

  # Scenario: delete network
  #   When we HTTP DELETE '/clients/c2/networks/c2:n2'
  #   Then our HTTP response should have status code 204
  #   And mongo query "{_id: 'c2'}" on '${constants.CLIENTS}' should be like:
  #   """
  #   {
  #     _id: 'c2',
  #     networks: [
  #       {_id: 'c2:n1'}
  #     ]
  #   }
  #   """
