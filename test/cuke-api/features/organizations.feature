@api
Feature: organizations

  Background:
    Given the following documents exist in the '${constants.ORGANIZATIONS}' collection:
    """
    [
      {
        _id: 'o1',
        id: {oid: 'pac', extension: 'e1'},
        name: 'n1',
        locations: [{_id: 'l1'}],
        identifiers: [{oid: 'pac', extension: 'e1'}],
        specialties: [{code: 'c1'}],
        tierRefs: [
          {
            _id: 'tr1',
            tier: {
              _id: 'c1:n1:p1:t1',
              rank: 1,
              plan: {
                _id: 'c1:n1:p1',
                network: {
                  _id: 'c1:n1',
                  client: {_id: 'c1'}
                }
              }
            }
          }
        ],
        created: {
          source: {_id: constants.CMS_SOURCE_ID}
        }
      },
      {
        _id: 'o2',
        id: {oid: 'pac', extension: 'e2'},
        name: 'n2',
        locations: [{_id: 'l2'}],
        identifiers: [{oid: 'pac', extension: 'e2'}],
        specialties: [{code: 'c2'}],
        tierRefs: [
          {
            _id: 'tr1',
            tier: {_id: 'c1:n1:p1:t2', rank: 2}
          }
        ],
        created: {
          source: {_id: constants.CMS_SOURCE_ID}
        }
      },
      {
        _id: 'o3',
        id: {oid: 'pac', extension: 'e3'},
        name: 'n3',
        practitioners: [
          {
            _id: 'p1',
            name: {last: 'ln3'}
          }
        ],
        created: {
          source: {_id: constants.CMS_SOURCE_ID}
        }
      }
    ]
    """

  Scenario: find organizations
    When we HTTP GET '/organizations' with query 'sort=_id'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o1'},
      {_id: 'o2'},
      {_id: 'o3'}
    ]
    """

  Scenario: find organizations for client
    When we HTTP GET '/organizations' with query 'tierRefs.tier.plan.network.client._id=c1'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o1', tierRefs: [{tier: {plan: {network: {client: {_id: 'c1'}}}}}]}
    ]
    """

  Scenario: find organizations for network
    When we HTTP GET '/organizations' with query 'tierRefs.tier.plan.network._id=c1:n1'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o1', tierRefs: [{tier: {plan: {network: {_id: 'c1:n1'}}}}]}
    ]
    """

  Scenario: find organizations for non-existent network
    When we HTTP GET '/organizations' with query 'tierRefs.tier.plan.network._id=nope'
    Then our HTTP response should be like:
    """
    []
    """

  Scenario: find organizations for tier
    When we HTTP GET '/organizations' with query 'tierRefs.tier._id=c1:n1:p1:t1'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o1', tierRefs: [{tier: {_id: 'c1:n1:p1:t1'}}]}
    ]
    """

  Scenario: find organizations for name
    When we HTTP GET '/organizations' with query 'name=n3'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o3', name: 'n3'}
    ]
    """

  Scenario: find organizations for practitioner last name
    When we HTTP GET '/organizations' with query 'practitioners.name.last=ln3'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o3', practitioners: [{name: {last: 'ln3'}}]}
    ]
    """

  Scenario: find organizations for location
    When we HTTP GET '/organizations' with query 'locations._id=l2'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o2', locations: [{_id: 'l2'}]}
    ]
    """

  Scenario: find organizations for identifier
    When we HTTP GET '/organizations' with query 'identifiers.extension=e2'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o2', identifiers: [{extension: 'e2'}]}
    ]
    """

  Scenario: find organizations for specialty code
    When we HTTP GET '/organizations' with query 'specialties.code=c1'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o1', specialties: [{code: 'c1'}]}
    ]
    """

  Scenario: find organizations for tier rank
    When we HTTP GET '/organizations' with query 'tierRefs.tier.rank=1'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o1', tierRefs: [{tier: {rank: 1}}]}
    ]
    """

  Scenario: find organizations sorted by name
    When we HTTP GET '/organizations' with query 'sort=-name'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o3', name: 'n3'},
      {_id: 'o2', name: 'n2'},
      {_id: 'o1', name: 'n1'}
    ]
    """

  Scenario: find organizations sorted by tier rank descending
    When we HTTP GET '/organizations' with query 'sort=-tierRefs.tier.rank'
    Then our HTTP response should be like:
    """
    [
      {_id: 'o2', tierRefs: [{tier: {rank: 2}}]},
      {_id: 'o1', tierRefs: [{tier: {rank: 1}}]},
      {_id: 'o3'}
    ]
    """

  Scenario: get organization
    When we HTTP GET '/organizations/o2'
    Then our HTTP response should be like:
    """
    {_id: 'o2'}
    """

  Scenario: get non-existent organization
    When we HTTP GET '/organizations/nope'
    Then our HTTP response should have status code 404
