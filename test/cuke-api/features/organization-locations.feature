@api
Feature: organization-locations

  Background:
    Given the following documents exist in the '${constants.ORGANIZATION_LOCATIONS}' collection:
    """
    [
      {
        _id: 'id-1',
        organization: {
          id: {
            oid: 'pac',
            extension: 'pac-1'
          }
        },
        address: 'address-1',
        geoPoint: {
          type: 'Point',
          coordinates: [-76.620436, 39.299376]
        },
        tierRefs: [
          {
            _id: 'tr:p1:t1',
            tier: {
              _id: 'p1:t1',
              rank: 1,
              plan: {
                _id: 'p1'
              }
            }
          },
          {
            _id: 'tr:p2:t1',
            tier: {
              _id: 'p2:t1',
              rank: 3,
              plan: {
                _id: 'p2'
              }
            }
          }
        ],
        created: {
          source: {_id: constants.CMS_SOURCE_ID}
        }
      },
      {
        _id: 'id-2',
        organization: {
          id: {
            oid: 'pac',
            extension: 'pac-2'
          }
        },
        address: 'address-2',
        geoPoint: {
          type: 'Point',
          coordinates: [-80.031391, 37.263689]
        },
        tierRefs: [
          {
            _id: 'tr:p1:t2',
            tier: {
              _id: 'p1:t2',
              rank: 2,
              plan: {
                _id: 'p1'
              }
            }
          },
          {
            _id: 'tr:p2:t2',
            tier: {
              _id: 'p2:t2',
              rank: 2,
              plan: {
                _id: 'p2'
              }
            }
          }
        ],
        created: {
          source: {_id: constants.CMS_SOURCE_ID}
        }
      },
      {
        _id: 'id-3',
        organization: {
          id: {
            oid: 'pac',
            extension: 'pac-1'
          }
        },
        address: 'address-1',
        geoPoint: {
          type: 'Point',
          coordinates: [-87.68343, 42.065355]
        },
        tierRefs: [
          {
            _id: 'tr:p1:t3',
            tier: {
              _id: 'p1:t3',
              rank: 3,
              plan: {
                _id: 'p1'
              }
            }
          },
          {
            _id: 'tr:p2:t1',
            tier: {
              _id: 'p2:t1',
              rank: 1,
              plan: {
                _id: 'p2'
              }
            }
          }
        ],
        created: {
          source: {_id: '1'}
        }
      },
      {
        _id: 'id-4',
        organization: {
          id: {
            oid: 'pac',
            extension: 'pac-1'
          }
        },
        address: 'address-1',
        geoPoint: {
          type: 'Point',
          coordinates: [-87.68343, 42.065355]
        },
        created: {
          source: {_id: '2'}
        },
        isPrivate: true
      }
    ]
    """
    And the following indices exist on the '${constants.ORGANIZATION_LOCATIONS}' collection:
    """
    [
      {'geoPoint': '2dsphere'}
    ]
    """

  Scenario: get organization-location
    When we HTTP GET '/organization-locations/id-3'
    Then our HTTP response should be like:
    """
    {_id: 'id-3'}
    """

  Scenario: find organization-locations
    When we HTTP GET '/organization-locations' with query 'source._id=1&sort=_id'
    Then our HTTP response should be like:
    """
    [
      {_id: 'id-1'},
      {_id: 'id-2'},
      {_id: 'id-3'}
    ]
    """

  Scenario: find organization-locations for geoPoint
    When we HTTP GET '/organization-locations' with query 'nearLon=-76.620436&nearLat=39.299376&nearMiles=1&limit=1'
    Then our HTTP response should be like:
    """
    [
      {_id: 'id-1'}
    ]
    """

  Scenario: find organization-locations for far geoPoint
    When we HTTP GET '/organization-locations' with query 'nearLon=1.0000&nearLat=1.0000&nearMiles=1&limit=1'
    Then our HTTP response should be like:
    """
    []
    """

  Scenario: find organization-locations sorted by tier
    When we HTTP GET '/organization-locations' with query 'tierRefs.tier.plan._id=p2&sort=tierRefs.tier.rank'
    Then our HTTP response should be like:
    """
    [
      {_id: 'id-3'},
      {_id: 'id-2'},
      {_id: 'id-1'}
    ]
    """
