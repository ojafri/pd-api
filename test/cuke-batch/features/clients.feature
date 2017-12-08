@batch
Feature: clients

  Scenario: ingest clients: single
    Given the following documents exist in the '${constants.CLIENTS_SOURCE}' collection:
    """
    [
      {
        networkId: 'n1',
        networkName: 'n1',
        planId: 'n1:p1',
        planName: 'p1',
        tierId: 'n1:p1:t1',
        tierName: 't1',
        tierBenefits: 'good benefits',
        tierRank: 1,
        isTierInNetwork: true
      }
    ]
    """
    When we run the '${BATCH}/clients' ingester with environment:
    """
    {
      clientId: 'c1',
      isUpsertClient: true,
      clientName: 'ceeOne'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {inserted: 3, updated: 0, failed: 0, scanned: 0}
    }
    """
    Then mongo query "{_id: 'c1'}" on '${constants.CLIENTS}' should be like:
    """
    [
      {
        _id: 'c1',
        name: 'ceeOne',
        networks: [
          {
            _id: 'c1::n1',
            name: 'n1',
            plans: [
              {
                _id: 'c1::n1:p1',
                name: 'p1',
                tiers: [
                  {
                    _id: 'c1::n1:p1:t1',
                    name: 't1',
                    rank: 1,
                    benefits: 'good benefits',
                    isInNetwork: true,
                    created: {
                      date: 'assert(actual.constructor.name == "Date")'
                    },
                    updated: {
                      date: 'assert(actual.constructor.name == "Date")'
                    }
                  }
                ],
                created: {
                  date: 'assert(actual.constructor.name == "Date")'
                },
                updated: {
                  date: 'assert(actual.constructor.name == "Date")'
                }
              }
            ],
            created: {
              date: 'assert(actual.constructor.name == "Date")'
            },
            updated: {
              date: 'assert(actual.constructor.name == "Date")'
            }
          }
        ],
        created: {
          date: 'assert(actual.constructor.name == "Date")'
        },
        updated: {
          date: 'assert(actual.constructor.name == "Date")'
        }
      }
    ]
    """

  Scenario: ingest clients: scanned
    Given the following documents exist in the '${constants.CLIENTS_SOURCE}' collection:
    """
    [
      {
        networkId: 'n1',
        networkName: 'n1',
        planId: 'n1:p1',
        planName: 'p1',
        tierId: 'n1:p1:t1',
        tierName: 't1',
        tierBenefits: 'good benefits',
        tierRank: 1,
        isTierInNetwork: true
      },
      {
        networkId: 'n1',
        networkName: 'n1',
        planId: 'n1:p1',
        planName: 'p1',
        tierId: 'n1:p1:t1',
        tierName: 't1',
        tierBenefits: 'good benefits',
        tierRank: 1,
        isTierInNetwork: true
      }
    ]
    """
    When we run the '${BATCH}/clients' ingester with environment:
    """
    {
      clientId: 'c1',
      isUpsertClient: true,
      clientName: 'ceeOne'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {inserted: 3, updated: 0, failed: 0, scanned: 3}
    }
    """

  Scenario: ingest clients: updated
    Given the following documents exist in the '${constants.CLIENTS_SOURCE}' collection:
    """
    [
      {
        networkId: 'n1',
        networkName: 'n1',
        planId: 'n1:p1',
        planName: 'p1',
        tierId: 'n1:p1:t1',
        tierName: 't1',
        tierBenefits: 'good benefits',
        tierRank: 1,
        isTierInNetwork: true
      },
      {
        networkId: 'n1',
        networkName: 'n2',
        planId: 'n1:p1',
        planName: 'p2',
        tierId: 'n1:p1:t1',
        tierName: 't2',
        tierBenefits: 'good benefits',
        tierRank: 1,
        isTierInNetwork: true
      }
    ]
    """
    When we run the '${BATCH}/clients' ingester with environment:
    """
    {
      clientId: 'c1',
      isUpsertClient: true,
      clientName: 'ceeOne'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {inserted: 3, updated: 3, failed: 0, scanned: 0}
    }
    """

  Scenario: ingest clients: multiple
    Given the following documents exist in the '${constants.CLIENTS_SOURCE}' collection:
    """
    [
      {
        networkId: 'n1',
        networkName: 'n1',
        planId: 'n1:p1',
        planName: 'p1',
        tierId: 'n1:p1:t1',
        tierName: 't1',
        tierBenefits: 'good benefits',
        tierRank: 1,
        isTierInNetwork: true
      },
      {
        networkId: 'n1',
        networkName: 'n1',
        planId: 'n1:p1',
        planName: 'p1',
        tierId: 'n1:p1:t1',
        tierName: 't1',
        tierBenefits: 'good benefits',
        tierRank: 1,
        isTierInNetwork: true
      },
      {
        networkId: 'n1',
        networkName: 'n1',
        planId: 'n1:p1',
        planName: 'p1',
        tierId: 'n1:p1:t2',
        tierName: 't2',
        tierBenefits: 'ok benefits',
        tierRank: 2,
        isTierInNetwork: true
      },
      {
        networkId: 'c1::n2',
        networkName: 'n2',
        planId: 'c1::n2:p1',
        planName: 'p1',
        tierId: 'c1::n2:p1:t1',
        tierName: 't1',
        tierBenefits: 'good benefits',
        tierRank: 1,
        isTierInNetwork: true
      }
    ]
    """
    When we run the '${BATCH}/clients' ingester with environment:
    """
    {
      clientId: 'c1',
      isUpsertClient: true,
      clientName: 'ceeOne'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {inserted: 7, updated: 0, failed: 0, scanned: 5}
    }
    """
    Then mongo query "{_id: 'c1'}" on '${constants.CLIENTS}' should be like:
    """
    [
      {
        _id: 'c1',
        name: 'ceeOne',
        networks: [
          {
            _id: 'c1::n1',
            name: 'n1',
            plans: [
              {
                _id: 'c1::n1:p1',
                name: 'p1',
                tiers: [
                  {
                    _id: 'c1::n1:p1:t1',
                    name: 't1',
                    rank: 1,
                    benefits: 'good benefits',
                    isInNetwork: true
                  },
                  {
                    _id: 'c1::n1:p1:t2',
                    name: 't2',
                    rank: 2,
                    benefits: 'ok benefits',
                    isInNetwork: true
                  }
                ]
              }
            ]
          },
          {
            _id: 'c1::n2',
            name: 'n2',
            plans: [
              {
                _id: 'c1::n2:p1',
                name: 'p1',
                tiers: [
                  {
                    _id: 'c1::n2:p1:t1',
                    name: 't1',
                    rank: 1,
                    isInNetwork: true
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
    """

  Scenario: ingest clients with modification
    Given the following documents exist in the '${constants.CLIENTS_SOURCE}' collection:
    """
    [
      {
        networkId: 'n1',
        networkName: 'n1',
        planId: 'n1:p1',
        planName: 'p1',
        tierId: 'n1:p1:t1',
        tierName: 't1',
        tierBenefits: 'bad benefits',
        tierRank: 1,
        isTierInNetwork: true
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
            _id: 'c1::n1',
            name: 'n1',
            plans: [
              {
                _id: 'c1::n1:p1',
                name: 'p1',
                tiers: [
                  {
                    _id: 'c1::n1:p1:t1',
                    name: 't1',
                    benefits: 'good benefits',
                    rank: 1,
                    isTierInNetwork: true
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
    """
    When we run the '${BATCH}/clients' ingester with environment:
    """
    {
      clientId: 'c1'
    }
    """
    Then our resultant state should be like:
    """
    {
      result: {inserted: 0, updated: 1, failed: 0, scanned: 2}
    }
    """
    Then mongo query "{_id: 'c1'}" on '${constants.CLIENTS}' should be like:
    """
    [
      {
        _id: 'c1',
        name: 'ceeOne',
        networks: [
          {
            _id: 'c1::n1',
            name: 'n1',
            plans: [
              {
                _id: 'c1::n1:p1',
                name: 'p1',
                tiers: [
                  {
                    _id: 'c1::n1:p1:t1',
                    name: 't1',
                    rank: 1,
                    benefits: 'bad benefits',
                    isInNetwork: true
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
    """
    And mongo query "{}" on '${constants.CLIENTS}History' should be like:
    """
    [
      {
        source: {
          _id: 'c1',
        },
        data: {
          _id: 'c1',
          name: 'ceeOne',
          networks: [
            {
              _id: 'c1::n1',
              name: 'n1',
              plans: [
                {
                  _id: 'c1::n1:p1',
                  name: 'p1',
                  tiers: [
                    {
                      _id: 'c1::n1:p1:t1',
                      name: 't1',
                      rank: 1,
                      benefits: 'good benefits',
                      isTierInNetwork: true
                    }
                  ]
                }
              ]
            }
          ]
        }
      }
    ]
    """
