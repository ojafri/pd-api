import {unwind} from 'mongo-helpr'
import getIngester from '../framework/batch/ingester'
import constants from './shared/constants'
import sourceHook from './shared/source-hook'

/* eslint-disable camelcase */

export default getIngester(
  {
    inputName: constants.NPPES_PROVIDER_SOURCE,
    outputName: constants.NPI_PROVIDERS,
    sourceHook,
    steps: [
      {
        $match: {
          $or: [
            {NPI_Deactivation_Date: null},
            {NPI_Reactivation_Date: {$ne: null}}
          ]
        }
      },
      {
        $group: {
          _id: '$NPI',
          doc: {$last: '$$ROOT'},
          ...allSpecialties()
        }
      },
      {
        $project: {
          doc: 1,
          specialties: {$setUnion: allTaxonomyFields()}
        }
      },
      unwind('$specialties'),
      {$match: {'specialties.code': {$ne: null}}},
      {$sort: {'doc.NPI': 1, 'specialties.code': 1, 'specialties.isPrimary': 1}},
      {
        $group: {
          _id: {npi: '$doc.NPI', code: '$specialties.code'},
          doc: {$last: '$doc'},
          specialties: {$last: '$specialties'}
        }
      },
      {
        $group: {
          _id: '$doc.NPI',
          doc: {$last: '$doc'},
          specialties: {$push: '$specialties'}
        }
      },
      {
        $project: {
          _id: 1,
          npi: '$_id',
          name: {
            prefix: '$doc.Provider_Name_Prefix_Text',
            first: {$ifNull: ['$doc.Provider_First_Name', '$doc.Authorized_Official_First_Name']},
            middle: {$ifNull: ['$doc.Provider_Middle_Name', '$doc.Authorized_Official_Middle_Name']},
            last: {$ifNull: ['$doc.Provider_Last_Name', '$doc.Authorized_Official_Last_Name']},
            suffix: '$Provider_Name_Suffix_Text'
          },
          specialties: 1
        }
      }
    ],
    isReplace: true
  }
)()

function allSpecialties() {
  const result = {}
  for (let i = 1; i <= 15; i++) {
    result[`taxonomy${i}`] = {
      $push: {
        $cond: [
          {$eq: [`$Healthcare_Provider_Primary_Taxonomy_Switch_${i}`, 'Y']},
          {code: `$Healthcare_Provider_Taxonomy_Code_${i}`, isPrimary: {$literal: true}},
          {code: `$Healthcare_Provider_Taxonomy_Code_${i}`}
        ]
      }
    }
  }
  return result
}

function allTaxonomyFields() {
  const result = []
  for (let i = 1; i <= 15; i++) {
    result.push(`$taxonomy${i}`)
  }
  return result
}
