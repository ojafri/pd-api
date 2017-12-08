[
  {
    _id: 'QAC1',
    name: 'QA clientOne',
    isActive: true,
    networks: [
      {
        _id: 'QAC1:n1',
        name: 'QANet',
        description: 'a plan-network',
        isActive: true,
        products: [
          {
            _id: 'QAC1:n1:pr1',
            name: 'QA Gold',
            description: 'QA Gold Product Covers All',
            isActive: true
          },
          {
            _id: 'QAC1:n1:pr2',
            name: 'QA Silver',
            description: 'QA Silver Product Covers Major',
            isActive: true
          }
        ],
        plans: [
          {
            _id: 'QAC1:n1:p1',
            name: 'QAG Plan1',
            isActive: true,
            product: {
              _id: 'QAC1:n1:pr1',
              name: 'QA Gold'
            },
            tiers: [
              {
                _id: 'QAC1:n1:p1:t1',
                name: 'QA Tier1',
                rank: 1,
                benefits: '100% coverage w/$0 co-pay',
                isInNetwork: true,
                isActive: true
              },
              {
                _id: 'QAC1:n1:p1:t2',
                name: 'QA Tier2',
                rank: 2,
                benefits: '90% coverage w/$25 co-pay',
                isInNetwork: true,
                isActive: true
              },
              {
                _id: 'QAC1:n1:p1:t3',
                name: 'OK',
                rank: 3,
                benefits: '80% coverage w/$50 co-pay',
                isInNetwork: false,
                isActive: true
              },
              {
                _id: 'QAC1:n1:p1:t4',
                name: 'Allowed',
                rank: 4,
                benefits: '70% coverage w/$50 co-pay',
                isInNetwork: false,
                isActive: true
              },
              {
                _id: 'QAC1:n1:p1:t5',
                name: 'Out of Network',
                rank: 5,
                benefits: '60% coverage w/$50 co-pay',
                isInNetwork: false,
                isActive: true
              }
            ],
            updated: {
              user: {
                _id: 'u1',
                name: 'Anil K'
              },
              date: '1928-04-26T06:48:47.504Z'
            }
          },
          {
            _id: 'QAC1:n1:p2',
            name: 'QAG Plan2',
            isActive: true,
            product: {
              _id: 'QAC1:n1:pr1',
              name: 'QA Gold'
            },
            tiers: [
              {
                _id: 'QAC1:n1:p2:t1',
                name: 'In Network',
                rank: 1,
                isInNetwork: true,
                isActive: true
              },
              {
                _id: 'QAC1:n1:p2:t2',
                name: 'Out of Network',
                rank: 2,
                isInNetwork: false,
                isActive: true
              }
            ],
            updated: {
              user: {
                _id: 'u1',
                name: 'Anil K'
              },
              date: '1928-04-26T06:48:47.504Z'
            }
          }
        ],
        updated: {
          user: {
            _id: 'u1',
            name: 'Anil K'
          },
          date: '1928-04-26T06:48:47.504Z'
        }
      },
      {
        _id: 'QAC1:n2',
        name: 'QA Simple Network',
        description: 'a simple-network',
        isActive: true,
        plans: [
          {
            _id: 'QAC1:n2:p1',
            isActive: true,
            tiers: [
              {
                _id: 'QAC1:n2:p1:t1',
                name: 'In Network',
                rank: 1,
                isInNetwork: true,
                isActive: true
              },
              {
                _id: 'QAC1:n2:p1:t2',
                name: 'Out of Network',
                rank: 2,
                isInNetwork: false,
                isActive: true
              }
            ],
            updated: {
              user: {
                _id: 'u1',
                name: 'Anil K'
              },
              date: '1928-04-26T06:48:47.504Z'
            }
          }
        ],
        updated: {
          user: {
            _id: 'u1',
            name: 'Anil K'
          },
          date: '1928-04-26T06:48:47.504Z'
        }
      }
    ]
  }
]