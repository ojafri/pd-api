export default [
  [
    {
      'organization.id.oid': 1,
      'organization.id.extension': 1,
      'address.line1': 1,
      'address.city': 1,
      'address.state': 1,
      'address.zip': 1
    },
    {unique: true, name: 'org-location-idx'}
  ],
  {geoPoint: '2dsphere'},
  {'organization._id': 1},
  {'organization.identifiers.extension': 1},
  {'specialties.code': 1},
  {'practitioners._id': 1},
  {'practitioners.name.last': 1},
  {'tierRefs._id': 1},
  {'tierRefs.tier._id': 1},
  {'tierRefs.tier.rank': 1},
  {'tierRefs.tier.plan._id': 1},
  {'tierRefs.tier.plan.network._id': 1},
  {'tierRefs.tier.plan.network.client._id': 1}
]
