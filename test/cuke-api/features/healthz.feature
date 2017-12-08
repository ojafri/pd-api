@api
Feature: check healthz endpoint

  Scenario: healthz good
    When the following documents exist in the 'geozip' collection:
    """
    [
      {zip: '90210', city: 'Whoville', state: 'NY', latitude: 1.0, longitude: 1.0}
    ]
    """
    And we HTTP GET '/healthz'
    Then our HTTP response should have status code 200

  Scenario: healthz bad
    When we HTTP GET '/healthz'
    Then our HTTP response should have status code 500
