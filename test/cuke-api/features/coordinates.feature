@api
Feature: restful api to geocode addresses
  valid addresses result in correct coordinates
  invalid addresses result in error response

  Scenario Outline: valid address geocoded
    When we HTTP GET '/coordinates' with query 'address=<address>'
    Then our HTTP response should be '<coordinates>'

    Examples:
      | address                                  | coordinates |
      | 151 Farmington Ave, Hartford CT 06108    | [-72.691454, 41.767744] |
      | 333 E 69th Street, New York, NY 10021    | [-73.958125, 40.766299] |

  Scenario: invalid address rejected
    When we HTTP GET '/coordinates' with query 'address=neverland'
    Then our HTTP response should have status code 500
