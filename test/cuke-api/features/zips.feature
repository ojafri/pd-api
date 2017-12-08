@api
Feature: restful api to provide access to geocoded zips
  can filter search
  can sort search

  Background:
    Given the following documents exist in the 'geozip' collection:
    """
    [
      {zip: '12345', city: 'Whoville', state: 'NY', latitude: 1.0, longitude: 1.0},
      {zip: '12346', city: 'Smallville', state: 'NY', latitude: 2.0, longitude: 2.0},
      {zip: '12347', city: 'Gotham', state: 'NJ', latitude: 3.0, longitude: 3.0},
      {zip: '06457', city: 'Middletown', state: 'CT', latitude: 4.0, longitude: 4.0}
    ]
    """

  Scenario: geocoded zips can be searched
    When we HTTP GET '/zips' with query 'state=NY'
    Then our HTTP response should be like:
    """
    [
      {zip: '12345', city: 'Whoville', state: 'NY', latitude: 1.0, longitude: 1.0},
      {zip: '12346', city: 'Smallville', state: 'NY', latitude: 2.0, longitude: 2.0}
    ]
    """
    And our HTTP headers should include 'content-security-policy'

  Scenario: geocoded zips can be sorted
    When we HTTP GET '/zips' with query 'state=NY&sort=city'
    Then our HTTP response should be like:
    """
    [
      {zip: '12346', city: 'Smallville', state: 'NY', latitude: 2.0, longitude: 2.0},
      {zip: '12345', city: 'Whoville', state: 'NY', latitude: 1.0, longitude: 1.0}
    ]
    """

  Scenario: geocoded zips can be searched with operators
    When we HTTP GET '/zips' with query 'latitude=_gte:1&latitude=_lte:2&sort=zip'
    Then our HTTP response should be like:
    """
    [
      {zip: '12345', city: 'Whoville', state: 'NY', latitude: 1.0, longitude: 1.0},
      {zip: '12346', city: 'Smallville', state: 'NY', latitude: 2.0, longitude: 2.0}
    ]
    """

  Scenario: geocoded zips can be searched with nulls
    When we HTTP GET '/zips' with query 'nope=null&city=Gotham'
    Then our HTTP response should be like:
    """
    [
      {zip: '12347', city: 'Gotham', state: 'NJ', latitude: 3.0, longitude: 3.0}
    ]
    """

  Scenario: geocoded zips can be searched not equal to null
    When we HTTP GET '/zips' with query 'state=_ne:null&state=_gt:NJ&sort=zip'
    Then our HTTP response should be like:
    """
    [
      {zip: '12345', city: 'Whoville', state: 'NY', latitude: 1.0, longitude: 1.0},
      {zip: '12346', city: 'Smallville', state: 'NY', latitude: 2.0, longitude: 2.0}
    ]
    """

  Scenario: geocoded zips can be searched by zip
    When we HTTP GET '/zips' with query 'zip=06457'
    Then our HTTP response should be like:
    """
    [
      {zip: '06457', city: 'Middletown', state: 'CT', latitude: 4.0, longitude: 4.0}
    ]
    """
