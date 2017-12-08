@api
Feature: restful api to provide access to clients

  Background:
    Given the following documents exist in the '${constants.CLIENTS}' collection:
    """
    [
      {
        _id: 'c1',
        name: 'client one',
        created: {
          user: {
            _id: '321',
            name: 'jane doe'
          }
        },
        updated: {
          user: {
            _id: '321',
            name: 'jane doe'
          }
        }
      },
      {
        _id: 'c2',
        name: 'client two'
      }
    ]
    """
    And the following indices exist on the '${constants.CLIENTS}' collection:
    """
    [
      [{'name': 1}, {unique: true}]
    ]
    """
    And we set the following HTTP headers:
    """
    {
      authorization: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJjaHIiLCJ1c2VySWQiOiIxMjMiLCJ1c2VyTmFtZSI6ImpvaG4gZG9lIiwiY2xpZW50SWQiOiJjMSJ9._CjFrsNP_jCLg1M24-W6POjp4Z8LNd7pQD2irXYlJok'
    }
    """

  Scenario: find clients
    When we HTTP GET '/clients'
    Then our HTTP response should be like:
    """
    [
      {_id: 'c1', name: 'client one'},
      {_id: 'c2', name: 'client two'}
    ]
    """

  Scenario: get client
    When we HTTP GET '/clients/c1'
    Then our HTTP response should be like:
    """
      {_id: 'c1', name: 'client one'}
    """

  Scenario: get non-existent client
    When we HTTP GET '/clients/nope'
    Then our HTTP response should have status code 404

  Scenario: create client
    When we HTTP POST '/clients' with body:
    """
    {name: 'client three'}
    """
    Then our HTTP response should have status code 201
    And our HTTP headers should include 'location'
    And mongo query "{name: 'client three'}" on '${constants.CLIENTS}' should be like:
    """
    [
      {
        _id: '1',
        name: 'client three',
        created: {
          user: {
            _id: '123',
            name: 'john doe'
          },
          date: 'assert(actual.constructor.name == "Date")'
        },
        updated: {
          user: {
            _id: '123',
            name: 'john doe'
          },
          date: 'assert(actual.constructor.name == "Date")'
        }
      }
    ]
    """

  Scenario: create invalid client
    When we HTTP POST '/clients' with body:
    """
    {nayme: 'client four'}
    """
    Then our HTTP response should have status code 422

  Scenario: create duplicate client
    When we HTTP POST '/clients' with body:
    """
    {name: 'client one'}
    """
    Then our HTTP response should have status code 409

  Scenario: update client
    When we HTTP PUT '/clients/c1' with body:
    """
    {name: 'client won', isInactive: true}
    """
    Then our HTTP response should have status code 204
    And mongo query "{_id: 'c1'}" on '${constants.CLIENTS}' should be like:
    """
    [
      {
        _id: 'c1',
        name: 'client won',
        isInactive: true,
        created: {
          user: {
            _id: '321',
            name: 'jane doe'
          }
        },
        updated: {
          user: {
            _id: '123',
            name: 'john doe'
          },
          date: 'assert(actual.constructor.name == "Date")'
        }
      }
    ]
    """
    And mongo query "{}" on '${constants.CLIENTS}History' should be like:
    """
    [
      {
        source: {
          _id: 'c1',
          name: 'client won'
        },
        user: {
          _id: '123',
          name: 'john doe'
        },
        mode: constants.MODES.update,
        date: 'assert(actual.constructor.name == "Date")',
        data: {
          _id: 'c1',
          name: 'client one'
        }
      }
    ]
    """

  Scenario: update invalid client
    When we HTTP PUT '/clients/c2' with body:
    """
    {nayme: 'client too'}
    """
    Then our HTTP response should have status code 422

  Scenario: update duplicate client
    When we HTTP PUT '/clients/c2' with body:
    """
    {name: 'client one'}
    """
    Then our HTTP response should have status code 409

  Scenario: update non-existent client
    When we HTTP PUT '/clients/nope' with body:
    """
    {name: 'nope'}
    """
    Then our HTTP response should have status code 404

  Scenario: delete client
    When we HTTP DELETE '/clients/c2'
    Then our HTTP response should have status code 204
    And mongo query "{_id: 'c2'}" on '${constants.CLIENTS}' should be like:
    """
    []
    """
    And mongo query "{}" on '${constants.CLIENTS}History' should be like:
    """
    [
      {
        source: {
          _id: 'c1',
          name: 'client one'
        },
        mode: constants.MODES.delete,
        date: 'assert(actual.constructor.name == "Date")',
        data: {
          _id: 'c2',
          name: 'client two'
        }
      }
    ]
    """

  Scenario: delete non-existent client
    When we HTTP DELETE '/clients/nope'
    Then our HTTP response should have status code 404
