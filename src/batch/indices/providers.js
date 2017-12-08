export default [
  [
    {
      'id.oid': 1,
      'id.extension': 1
    },
    {unique: true}
  ],
  {'name.last': 1},
  {'identifiers.extension': 1},
  {'organizationRefs._id': 1},
  {'organizationRefs.organization._id': 1},
  {'organizationRefs.organization.locations._id': 1},
  {'organizationRefs.organization.locations.geoPoint': '2dsphere'},
  {'organizationRefs.tierRefs._id': 1},
  {'organizationRefs.tierRefs.tier._id': 1},
  {'organizationRefs.tierRefs.tier.rank': 1},
  {'organizationRefs.tierRefs.tier.plan._id': 1},
  {'organizationRefs.tierRefs.tier.plan.network._id': 1},
  {'organizationRefs.tierRefs.tier.plan.network.client._id': 1}
]
