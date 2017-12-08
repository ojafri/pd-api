import test from 'ava'
import {decorateWithOid} from '../../../src/batch/shared/helper'
import {compressOid} from '../../../src/shared/helper'

test('decorateWithOid', t => {
  const oid = '1.2.3.4'
  const key = 'foo'
  t.deepEqual(decorateWithOid({oid, key}), [compressOid(oid), ':', key])
})
