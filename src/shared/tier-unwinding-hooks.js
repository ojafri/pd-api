import assert from 'assert'
import _ from 'lodash'
import debug from 'debug'
import {stringify, join} from 'helpr'
import {unwind} from 'mongo-helpr'

const dbg = debug('app:shared:tier-unwinding-hooks')

const planKey = 'tierRefs.tier.plan._id'
const contextPlanKey = 'contextPlanId'
const tierRankKey = 'tierRefs.tier.rank'

export default {
  queryHook: ({query}) => {
    return _.omit(query, contextPlanKey)
  },

  postStepsHook: ({postSteps, query, prefix, sort}) => {
    dbg('post-steps=%o, query=%o, prefix=%o, sort=%o', stringify(postSteps), stringify(query), prefix, sort)
    const planValue = query[planKey]
    const contextPlanValue = query[contextPlanKey]
    assert(!Array.isArray(contextPlanValue), `${contextPlanKey} does not accept multiple values`)
    assert(!(planValue && contextPlanValue), `${planKey} and ${contextPlanKey} are mutually exclusive`)
    const isTierSort = Array.isArray(sort) ? sort.includes(tierRankKey) : sort === tierRankKey
    isTierSort && assert(
      planValue || contextPlanValue,
      `sorting by ${tierRankKey} requires either ${planKey} or ${contextPlanKey}`
    )

    if ((planValue && !Array.isArray(planValue)) || contextPlanValue) {
      let steps
      if (planValue) {
        dbg('unwinding tierRefs based on query=%o, value=%o', planKey, planValue)
        steps = [
          {$match: {[join([prefix, planKey])]: planValue}}
        ]
      } else {
        dbg('unwinding tierRefs based on query=%o, value=%o', contextPlanKey, contextPlanValue)
        steps = [
          {
            $addFields: {
              tierRefs: {
                _id: '$tierRefs._id',
                tier: {
                  _id: '$tierRefs.tier._id',
                  name: '$tierRefs.tier.name',
                  benefits: '$tierRefs.tier.benefits',
                  isInNetwork: '$tierRefs.tier.isInNetwork',
                  updated: '$tierRefs.tier.updated',
                  plan: '$tierRefs.tier.plan',
                  rank: {
                    $cond: {
                      if: {$eq: ['$tierRefs.tier.plan._id', contextPlanValue]},
                      then: '$tierRefs.tier.rank',
                      else: Number.MAX_SAFE_INTEGER
                    }
                  }
                }
              }
            }
          },
          {$sort: {'tierRefs.tier.rank': 1}},
          {$group: {_id: '$_id', doc: {$first: '$$ROOT'}}},
          {$replaceRoot: {newRoot: '$doc'}}
        ]
      }
      return [
        ...postSteps,
        unwind(`$${join([prefix, 'tierRefs'])}`),
        ...steps
      ]
    }
    //
    // if plan not specified, perhaps attempt to strip tierRefs altogether to mitigate risk of
    // inadvertently sharing one clients tier associations with another...?
    //
    return postSteps
  }
}
