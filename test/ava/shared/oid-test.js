import test from 'ava'
import {
  HL7_OID,
  compressOid
} from '../../../src/shared/helper'

test('compressOid: internal', t => {
  const suffix = '1.2'
  t.is(compressOid(`${HL7_OID}.${suffix}`), suffix)
})

test('compressOid: external', t => {
  const externalOid = '1.2.3.4'
  t.not(compressOid(`${HL7_OID}.${externalOid}`), compressOid(externalOid))
})
