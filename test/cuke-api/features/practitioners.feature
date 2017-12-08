@api
Feature: practitioners

  Background:
    Given the following documents exist in the '${constants.PROVIDERS}' collection:
    """
    [
      {
        _id: 'p1',
        id: {
          oid: 'npi',
          extension: 'n1'
        },
        organizationRefs: {
          organization: {
            _id: 'o1',
            locations: [
              {
                _id: 'l1'
              }
            ]
          },
          tierRefs: {
            _id: 'tr1',
            tier: {
              _id: 'c1:n1:p1:t1',
              rank: 1,
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
        },
        specialties: [{code: 'code-1'}],
        name: {last: 'last-1'},
        created: {
          source: {_id: constants.CMS_SOURCE_ID}
        }
      },
      {
        _id: 'p2',
        id: {
          oid: 'npi',
          extension: 'n2'
        },
        organizationRefs: {
          tierRefs: {
            _id: 'tr1',
            tier: {
              _id: 'c1:n1:p1:t2',
              rank: 2
            }
          }
        },
        specialties: [{code: 'code-2'}],
        name: {last: 'last-2'},
        created: {
          source: {_id: constants.CMS_SOURCE_ID}
        }
      },
      {
        _id: 's1:p2',
        id: {
          oid: 'npi',
          extension: 'n2'
        },
        specialties: [{code: 'code-3'}],
        name: {last: 'last-3'},
        created: {
          source: {_id: 's1'}
        },
        isPrivate: true
      },
      {
        _id: 's2:p1',
        id: {
          oid: 'npi',
          extension: 'n2'
        },
        specialties: [{code: 'code-3'}],
        name: {last: 'last-4'},
        created: {
          source: {_id: 's2'}
        },
        isPrivate: true
      }
    ]
    """

  Scenario: find practitioners
    When we HTTP GET '/practitioners' with query 'sort=_id'
    Then our HTTP response should be like:
    """
    [
      {_id: 'p1'},
      {_id: 'p2'}
    ]
    """

  Scenario: find practitioners for source
    When we HTTP GET '/practitioners' with query 'source._id=s1&sort=_id'
    Then our HTTP response should be like:
    """
    [
      {_id: 'p1'},
      {_id: 'p2'},
      {_id: 's1:p2'}
    ]
    """

  Scenario: find practitioners for only source
    When we HTTP GET '/practitioners' with query 'source._id=s1&onlyClientCreated=true&sort=_id'
    Then our HTTP response should be like:
    """
    [
      {_id: 's1:p2'}
    ]
    """

  Scenario: get practitioners meta for source
    When we HTTP GET '/practitioners/meta' with query 'source._id=s1'
    Then our HTTP response should be like:
    """
    {count: 3}
    """

  Scenario: post practitioners meta for source
    When we HTTP POST '/practitioners/meta' with body:
    """
    {'source._id': 's1'}
    """
    Then our HTTP response should be like:
    """
    {count: 3}
    """

  Scenario: find practitioners for non-existent client
    When we HTTP GET '/practitioners' with query 'privateOnly=true&source._id=nope'
    Then our HTTP response should be like:
    """
    []
    """

  Scenario: find practitioners for network
    When we HTTP GET '/practitioners' with query 'organizationRefs.tierRefs.tier.plan.network._id=c1:n1'
    Then our HTTP response should be like:
    """
    [
      {_id: 'p1'}
    ]
    """

  Scenario: find practitioners for last name
    When we HTTP GET '/practitioners' with query 'name.last=last-2'
    Then our HTTP response should be like:
    """
    [
      {
        _id: 'p2',
        name: {last: 'last-2'}
      }
    ]
    """

  Scenario: find practitioners for specialty code
    When we HTTP GET '/practitioners' with query 'specialties.code=code-2'
    Then our HTTP response should be like:
    """
    [
      {
        _id: 'p2',
        specialties: [{code: 'code-2'}]
      }
    ]
    """

  Scenario: find practitioners for tier
    When we HTTP GET '/practitioners' with query 'organizationRefs.tierRefs.tier._id=c1:n1:p1:t1'
    Then our HTTP response should be like:
    """
    [
      {_id: 'p1'}
    ]
    """

  Scenario: find practitioners for tier rank
    When we HTTP GET '/practitioners' with query 'organizationRefs.tierRefs.tier.rank=1'
    Then our HTTP response should be like:
    """
    [
      {_id: 'p1'}
    ]
    """

  Scenario: find practitioners for location
    When we HTTP GET '/practitioners' with query 'organizationRefs.organization.locations._id=l1'
    Then our HTTP response should be like:
    """
    [
      {_id: 'p1'}
    ]
    """

  Scenario: find practitioners sorted by last name descending
    When we HTTP GET '/practitioners' with query 'sort=-name.last'
    Then our HTTP response should be like:
    """
    [
      {_id: 'p2'},
      {_id: 'p1'}
    ]
    """

  Scenario: find practitioners sorted by tier rank
    When we HTTP GET '/practitioners' with query 'sort=organizationRefs.tierRefs.tier.rank'
    Then our HTTP response should be like:
    """
    [
      {_id: 'p1'},
      {_id: 'p2'}
    ]
    """

  #  Scenario: find practitioners near address
  #   When we HTTP GET '/practitioners' with query 'nearAddress=10021'
  #   Then our HTTP response should be like:
  #   """
  #   [
  #     {
  #       npi: '1003',
  #       locations: [{address: {zip: '10021'}}]
  #     },
  #     {
  #       npi: '1005',
  #       locations: [{address: {zip: '10021'}}]
  #     }
  #   ]
  #   """

  Scenario: get practitioner
    When we HTTP GET '/practitioners/p1'
    Then our HTTP response should be like:
    """
    {_id: 'p1'}
    """

  Scenario: get non-existent practitioner
    When we HTTP GET '/practitioners/nope'
    Then our HTTP response should have status code 404
