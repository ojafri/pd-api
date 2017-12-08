export default [
  [
    {
      'id.oid': 1,
      'id.extension': 1
    },
    {
      unique: true
    }
  ],
  {'identifiers.extension': 1},
  {'specialties.code': 1},
  {'practitioners._id': 1},
  {'practitioners.name.last': 1},
  {'locations._id': 1},
  {'locations.geoPoint': '2dsphere'},
  {'tierRefs._id': 1},
  {'tierRefs.tier._id': 1},
  {'tierRefs.tier.rank': 1},
  {'tierRefs.tier.plan._id': 1},
  {'tierRefs.tier.plan.network._id': 1},
  {'tierRefs.tier.plan.network.client._id': 1}
]
