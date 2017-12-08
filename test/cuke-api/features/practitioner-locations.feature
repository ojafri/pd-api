@api
Feature: practitioner-locations

  Background:
    Given the following documents exist in the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {
        _id: 'id-1',
        practitioner: {
          id: {
            oid: 'npi',
            extension: 'npi-1'
          }
        },
        location: {
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
          }
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
        practitioner: {
          id: {
            oid: 'npi',
            extension: 'npi-2'
          }
        },
        location: {
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
          }
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
        practitioner: {
          id: {
            oid: 'npi',
            extension: 'npi-1'
          }
        },
        location: {
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
          }
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
              benefits: 'simply the best',
              plan: {
                _id: 'p2',
                other: 'stuff'
              }
            }
          }
        ],
        created: {
          source: {_id: '1'}
        },
        isPrivate: true
      },
      {
        _id: 'id-4',
        practitioner: {
          id: {
            oid: 'npi',
            extension: 'npi-1'
          }
        },
        location: {
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
          }
        },
        created: {
          source: {_id: '2'}
        },
        isPrivate: true
      }
    ]
    """
    And the following indices exist on the '${constants.PROVIDER_LOCATIONS}' collection:
    """
    [
      {'location.geoPoint': '2dsphere'}
    ]
    """

  Scenario: get practitioner-location
    When we HTTP GET '/practitioner-locations/id-3'
    Then our HTTP response should be like:
    """
    {_id: 'id-3'}
    """

  Scenario: find practitioner-locations
    When we HTTP GET '/practitioner-locations' with query 'source._id=1&sort=_id'
    Then our HTTP response should be like:
    """
    [
      {_id: 'id-1'},
      {_id: 'id-2'},
      {_id: 'id-3'}
    ]
    """

  Scenario: search practitioner-locations
    When we HTTP POST '/practitioner-locations/search' with body:
    """
    {
      _id: ['id-1', 'id-2'],
      sort: '_id'
    }
    """
    Then our HTTP response should be like:
    """
    [
      {_id: 'id-1'},
      {_id: 'id-2'}
    ]
    """

  Scenario: find practitioner-locations for geoPoint
    When we HTTP GET '/practitioner-locations' with query 'nearLon=-76.620436&nearLat=39.299376&nearMiles=1&limit=1'
    Then our HTTP response should be like:
    """
    [
      {_id: 'id-1'}
    ]
    """

  Scenario: find practitioner-locations for far geoPoint
    When we HTTP GET '/practitioner-locations' with query 'nearLon=1.0000&nearLat=1.0000&nearMiles=1&limit=1'
    Then our HTTP response should be like:
    """
    []
    """

  Scenario: find practitioner-locations sorted by tier
    When we HTTP GET '/practitioner-locations' with query 'tierRefs.tier.plan._id=p2&sort=tierRefs.tier.rank'
    Then our HTTP response should be like:
    """
    [
      {_id: 'id-2'},
      {_id: 'id-1'}
    ]
    """

  Scenario: find practitioner-locations sorted by tier: no filter
    When we HTTP GET '/practitioner-locations' with query 'sort=tierRefs.tier.rank'
    Then our HTTP response should have status code 500

  Scenario: find practitioner-locations sorted by tier: bad combo
    When we HTTP GET '/practitioner-locations' with query 'tierRefs.tier.plan._id=p2&contextPlanId=p2'
    Then our HTTP response should have status code 500

  Scenario: find practitioner-locations sorted by tier: reject multi value
    When we HTTP GET '/practitioner-locations' with query 'contextPlanId=p1&contextPlanId=p2'
    Then our HTTP response should have status code 500

  Scenario: find practitioner-locations sorted by tier: context-plan-id
    When we HTTP GET '/practitioner-locations' with query 'contextPlanId=p2&sort=tierRefs.tier.rank&source._id=2'
    Then our HTTP response should be like:
    """
    [
      {_id: 'id-2'},
      {_id: 'id-1'},
      {_id: 'id-4'}
    ]
    """
