export default [
  [
    {
      'practitioner.id.oid': 1,
      'practitioner.id.extension': 1,
      'location.organization.id.oid': 1,
      'location.organization.id.extension': 1,
      'location.address.line1': 1,
      'location.address.city': 1,
      'location.address.state': 1,
      'location.address.zip': 1
    },
    {unique: true, name: 'provider-org-location-idx'}
  ],
  {'practitioner._id': 1},
  {'practitioner.name.last': 1},
  {'practitioner.identifiers.extension': 1},
  {'practitioner.specialties.code': 1},
  {'location._id': 1},
  {'location.organization._id': 1},
  {'location.organization.identifiers.extension': 1},
  {'location.geoPoint': '2dsphere'},
  {'tierRefs._id': 1},
  {'tierRefs.tier._id': 1},
  {'tierRefs.tier.rank': 1},
  {'tierRefs.tier.plan._id': 1},
  {'tierRefs.tier.plan.network._id': 1},
  {'tierRefs.tier.plan.network.client._id': 1}
]
