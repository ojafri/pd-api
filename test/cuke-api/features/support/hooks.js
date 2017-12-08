import debug from 'debug'
import {initState} from 'test-helpr'
import {getDb} from 'mongo-helpr'
import {initDb} from 'mongo-test-helpr'

/* eslint-disable new-cap */

const dbg = debug('test:api:support:hooks')
dbg('loaded hooks')

export default function () {
  this.BeforeFeatures(() => {
    dbg('before-features...')
    // eslint-disable-next-line no-unused-expressions
    require('../../../../src/api').default
  })

  // this === World
  this.Before(async scenario => {
    try {
      dbg('before: scenario=%o', scenario.getName())
      const db = await getDb()
      initState()
      const result = await initDb(db)
      dbg('before: init-db result=%o', result)
    } catch (err) {
      dbg('before: caught=%o', err)
      throw err
    }
  })
}
