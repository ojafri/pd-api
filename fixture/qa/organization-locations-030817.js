[
  {
    "_id": "QAC1:4.6:1003922642:124 S 400 E:SALT LAKE CITY:UT:841115308",
    "practitioners": [
      {
        "_id": "QAC1:4.6:1003922642",
        "id": {
          "authority": "npi",
          "oid": "2.16.840.1.113883.4.6",
          "extension": "1003922642"
        },
        "name": {
          "first": "ANIL",
          "middle": "AT",
          "last": "MEDICITY"
        }
      }
    ],
    "specialties": [
      {
        "code": "207SM0001X",
        "classification": "MEDICAL GENETICS",
        "specialization": "MOLECULAR GENETIC PATHOLOGY",
        "system": "2.16.840.1.113883.6.101",
        "isPrimary": true
      }
    ],
    "organization": {
      "_id": "QAC1:4.6:1003922642",
      "id": {
        "authority": "npi",
        "oid": "2.16.840.1.113883.4.6",
        "extension": "1003922642"
      },
      "name": "ANIL AT MEDICITY",
      "identifiers": [
        {
          "authority": "npi",
          "oid": "2.16.840.1.113883.4.6",
          "extension": "1003922642"
        }
      ]
    },
    "address": {
      "line1": "124 s 400 E",
      "city": "SALT LAKE CITY",
      "state": "UT",
      "zip": "841115308"
    },
    "geoPoint": {
      "type": "Point",
      "coordinates": [
        -111.87979,
        40.766643
      ]
    },
    "phone": "8013643723",
    "source": {
      "_id": "QAC1",
      "name": "QA client-1",
      "rank": 1
    },
    "updated": {
      "date": {
        "$date": "2016-12-10T06:40:37.330Z"
      }
    },
    "tierRefs": [
      {
        "_id": "qatr1",
        "tier": {
          "_id": "QAC1:n1:p1:t1",
          "name": "QA Tier1",
          "rank": 1,
          "isInNetwork": true,
          "plan": {
            "_id": "QAC1:n1:p1",
            "name": "QAG Plan1",
            "product": "QA Gold",
            "network": {
              "_id": "QAC1:n1",
              "name": "QANet",
              "client": {
                "_id": "QAC1",
                "name": "QA clientOne"
              }
            }
          }
        }
      }
    ]
  }
]