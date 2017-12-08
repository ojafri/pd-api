@api
Feature: practitioner-organizations

Background:
  Given the following documents exist in the '${constants.PROVIDERS}' collection:
  """
  [
    {
      _id: '-1:npi:npi-1',
      id: {
        oid: 'npi',
        extension: 'npi-1'
      },
      organizationRefs: [
        {
          _id: '-1:npi:npi-1:-1:pac:pac-1',
          organization: {
            _id: '-1:pac:pac-1',
            id: {
              oid: 'pac',
              extension: 'pac-1'
            },
            locations: [
              {
                _id: 'l1'
              }
            ]
          },
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
                    client: {
                      _id: 'c1'
                    }
                  }
                }
              }
            }
          ]
        }
      ],
      specialties: [{code: 'code-1'}],
      name: {last: 'last-1'},
      created: {
        source: {_id: constants.CMS_SOURCE_ID}
      }
    },
    {
      _id: '-1:npi:npi-2',
      id: {
        oid: 'npi',
        extension: 'npi-2'
      },
      organizationRefs: [
        {
          _id: "-1:npi:npi-2:-1:pac:pac-1",
          organization: {
            _id: '-1:pac:pac-1',
            id: {
              oid: 'pac',
              extension: 'pac-1'
            },
            locations: [
              {
                _id: 'l1'
              }
            ]
          },
          tierRefs: [
            {
              _id: 'tr1',
              tier: {
                _id: 'c1:n1:p1:t2',
                rank: 2
              }
            }
          ]
        }
      ],
      specialties: [{code: 'code-2'}],
      name: {last: 'last-2'},
      created: {
        source: {_id: constants.CMS_SOURCE_ID}
      }
    },
    {
      _id: 'c1:npi:npi-3',
      id: {
        oid: 'npi',
        extension: 'npi-3'
      },
      organizationRefs: [
        {
          _id: "c1:npi:npi-3:c1:pac:pac-2",
          organization: {
            _id: 'c1:pac:pac-2',
            id: {
              oid: 'pac',
              extension: 'pac-2'
            },
            locations: [
              {
                _id: 'l1'
              }
            ]
          },
          tierRefs: [
            {
              _id: 'tr1',
              tier: {
                _id: 'c1:n1:p1:t2',
                rank: 2
              }
            }
          ]
        }
      ],
      specialties: [{code: 'code-3'}],
      name: {last: 'last-3'},
      created: {
        source: {_id: 'c1'}
      },
      isPrivate: true
    }
  ]
  """

  Scenario: find practitioner-organizations: public
    When we HTTP GET '/practitioner-organizations' with query 'sort=practitioner.id.extension'
    Then our HTTP response should be like:
    """
    [
      {_id: '-1:npi:npi-1:-1:pac:pac-1'},
      {_id: '-1:npi:npi-2:-1:pac:pac-1'}
    ]
    """

  Scenario: find practitioner-organizations: private
    When we HTTP GET '/practitioner-organizations' with query 'source._id=c1&sort=practitioner.id.extension'
    Then our HTTP response should be like:
    """
    [
      {_id: '-1:npi:npi-1:-1:pac:pac-1'},
      {_id: '-1:npi:npi-2:-1:pac:pac-1'},
      {_id: 'c1:npi:npi-3:c1:pac:pac-2'}
    ]
    """

  Scenario: get practitioner-organization
    When we HTTP GET '/practitioner-organizations/-1:npi:npi-1:-1:pac:pac-1'
    Then our HTTP response should be like:
    """
    {_id: '-1:npi:npi-1:-1:pac:pac-1'}
    """
