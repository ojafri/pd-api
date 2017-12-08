@api
Feature: restful api to provide access to specialties
  can filter search
  can sort search

  Background:
    Given the following documents exist in the '${constants.SPECIALTIES}' collection:
    """
    [
      {code: 'code-1', grouping: 'group-1', classification: 'class-1', specialization: 'spec-1'},
      {code: 'code-2', grouping: 'group-2', classification: 'neuro', specialization: 'spec-2'},
      {code: 'code-3', grouping: 'group-3', classification: 'class-3', specialization: 'neuro'}
    ]
    """

  Scenario: all specialties can be searched
    When we HTTP GET '/specialties'
    Then our HTTP response should be like:
    """
    [
      {code: 'code-1', grouping: 'group-1', classification: 'class-1', specialization: 'spec-1'},
      {code: 'code-2', grouping: 'group-2', classification: 'neuro', specialization: 'spec-2'},
      {code: 'code-3', grouping: 'group-3', classification: 'class-3', specialization: 'neuro'}
    ]
    """

  Scenario: specialties can be or searched
    When we HTTP GET '/specialties' with query '_or(classification, specialization)=neuro'
    Then our HTTP response should be like:
    """
    [
      {code: 'code-2', grouping: 'group-2', classification: 'neuro', specialization: 'spec-2'},
      {code: 'code-3', grouping: 'group-3', classification: 'class-3', specialization: 'neuro'}
    ]
    """

  Scenario: specialties can be searched for code
    When we HTTP GET '/specialties' with query 'code=code-2'
    Then our HTTP response should be like:
    """
    [
      {code: 'code-2', grouping: 'group-2', classification: 'neuro', specialization: 'spec-2'}
    ]
    """

   Scenario: specialties can be searched for invalid code
    When we HTTP GET '/specialties' with query 'code=code-5'
    Then our HTTP response should be like:
    """
    [

    ]
    """

  Scenario: specialties can be searched for grouping
    When we HTTP GET '/specialties' with query 'grouping=group-1'
    Then our HTTP response should be like:
    """
    [
      {code: 'code-1', grouping: 'group-1', classification: 'class-1', specialization: 'spec-1'}
    ]
    """

  Scenario: specialties can be sorted by ascending on specialization
    When we HTTP GET '/specialties' with query 'sort=specialization'
    Then our HTTP response should be like:
    """
    [
      {code: 'code-3', grouping: 'group-3', classification: 'class-3', specialization: 'neuro'},
      {code: 'code-1', grouping: 'group-1', classification: 'class-1', specialization: 'spec-1'},
      {code: 'code-2', grouping: 'group-2', classification: 'neuro', specialization: 'spec-2'}
    ]
    """

   Scenario: specialties can be sorted by descending on grouping
    When we HTTP GET '/specialties' with query 'sort=-grouping'
    Then our HTTP response should be like:
    """
    [
      {code: 'code-3', grouping: 'group-3', classification: 'class-3', specialization: 'neuro'},
      {code: 'code-2', grouping: 'group-2', classification: 'neuro', specialization: 'spec-2'},
      {code: 'code-1', grouping: 'group-1', classification: 'class-1', specialization: 'spec-1'},
    ]
    """
