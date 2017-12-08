[
  {
    _id: 'c1',
    name: 'client one',
    networks: [
      {
        _id: 'c1:n1',
        name: 'Aetna',
        description: 'a plan-network',
        products: [
          {
            _id: 'c1:n1:pr1',
            name: 'PPO',
            description: 'PPO desc'
          },
          {
            _id: 'c1:n1:pr2',
            name: 'HMO',
            description: 'HMO desc'
          }
        ],
        plans: [
          {
            _id: 'c1:n1:p1',
            name: 'Aetna Choice POS II',
            product: {
              _id: 'c1:n1:pr1',
              name: 'PPO'
            },
            tiers: [
              {
                _id: 'c1:n1:p1:t1',
                name: 'Super Preferred',
                rank: 1,
                benefits: '100% coverage w/$0 co-pay',
                isInNetwork: true
              },
              {
                _id: 'c1:n1:p1:t2',
                name: 'Preferred',
                rank: 2,
                benefits: '90% coverage w/$25 co-pay',
                isInNetwork: true
              },
              {
                _id: 'c1:n1:p1:t3',
                name: 'OK',
                rank: 3,
                benefits: '80% coverage w/$50 co-pay',
                isInNetwork: false
              },
              {
                _id: 'c1:n1:p1:t4',
                name: 'Allowed',
                rank: 4,
                benefits: '70% coverage w/$50 co-pay',
                isInNetwork: false
              },
              {
                _id: 'c1:n1:p1:t5',
                name: 'Out of Network',
                rank: 5,
                benefits: '60% coverage w/$50 co-pay',
                isInNetwork: false
              }
            ],
            updated: {
              user: {
                _id: 'u1',
                name: 'jon smith'
              },
              date: '1928-04-26T06:48:47.504Z'
            }
          },
          {
            _id: 'c1:n1:p2',
            name: 'Aetna Freedom 10',
            product: {
              _id: 'c1:n1:pr1',
              name: 'PPO'
            },
            tiers: [
              {
                _id: 'c1:n1:p2:t1',
                name: 'In Network',
                rank: 1,
                isInNetwork: true
              },
              {
                _id: 'c1:n1:p2:t2',
                name: 'Out of Network',
                rank: 2,
                isInNetwork: false
              }
            ],
            updated: {
              user: {
                _id: 'u1',
                name: 'jon smith'
              },
              date: '1928-04-26T06:48:47.504Z'
            }
          }
        ],
        updated: {
          user: {
            _id: 'u1',
            name: 'jon smith'
          },
          date: '1928-04-26T06:48:47.504Z'
        }
      },
      {
        _id: 'c1:n2',
        name: 'Basic Network',
        description: 'a basic network',
        plans: [
          {
            _id: 'c1:n2:p1',
            name: 'Default Plan',
            tiers: [
              {
                _id: 'c1:n2:p1:t1',
                name: 'In Network',
                rank: 1,
                isInNetwork: true
              }
            ],
            updated: {
              user: {
                _id: 'u1',
                name: 'jon smith'
              },
              date: '1928-04-26T06:48:47.504Z'
            }
          }
        ],
        updated: {
          user: {
            _id: 'u1',
            name: 'jon smith'
          },
          date: '1928-04-26T06:48:47.504Z'
        }
      },
      {
        _id: 'c1:n3',
        name: 'Another Basic Network',
        description: 'another basic network',
        isInactive: true,
        plans: [
          {
            _id: 'c1:n3:p1',
            name: 'Default Plan',
            tiers: [
              {
                _id: 'c1:n3:p1:t1',
                name: 'In Network',
                rank: 1,
                isInNetwork: true
              }
            ],
            updated: {
              user: {
                _id: 'u1',
                name: 'jon smith'
              },
              date: '1928-04-26T06:48:47.504Z'
            }
          }
        ],
        updated: {
          user: {
            _id: 'u1',
            name: 'jon smith'
          },
          date: '1928-04-26T06:48:47.504Z'
        }
      }
    ]
  },
  {
    _id: 'c2',
    name: 'client two',
    networks: [
      {
        _id: 'c2:n1',
        name: 'net one',
        products: [
          {
            _id: 'c2:n1:pr1',
            name: 'product one'
          }
        ],
        plans: [
          {
            _id: 'c2:n1:p1',
            name: 'plan one',
            tiers: [
              {
                _id: 'c2:n1:p1:t1',
                name: 'Super Preferred',
                rank: 1,
                isInNetwork: true
              },
              {
                _id: 'c2:n1:p1:t2',
                name: 'Preferred',
                rank: 2,
                isInNetwork: true
              },
              {
                _id: 'c2:n1:p1:t3',
                name: 'Out of Network',
                rank: 3,
                isInNetwork: false
              }
            ]
          }
        ]
      },
      {
        _id: 'c2:n2',
        name: 'net two',
        products: [
          {
            _id: 'c2:n2:pr1',
            name: 'product one'
          }
        ],
        plans: [
          {
            _id: 'c2:n2:p1',
            name: 'plan one',
            tiers: [
              {
                _id: 'c2:n2:p1:t1',
                name: 'Super Preferred',
                rank: 1,
                isInNetwork: true
              },
              {
                _id: 'c2:n2:p1:t2',
                name: 'Preferred',
                rank: 2,
                isInNetwork: true
              },
              {
                _id: 'c2:n2:p1:t3',
                name: 'Out of Network',
                rank: 3,
                isInNetwork: false
              }
            ]
          }
        ]
      }
    ]
  }
]
