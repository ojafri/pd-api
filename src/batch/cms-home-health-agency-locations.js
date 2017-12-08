import {unwind} from 'mongo-helpr'
import getIngester from '../framework/batch/ingester'
import {getAddressKeyArray} from '../framework/data/helper'
import constants from './shared/constants'
import {
  getLocationKeyArray,
  decorateWithOid,
  getRatingNullCheck,
  transformField,
  ratingsCleaner
} from './shared/helper'
import upsertPostProcessor from './shared/upsert-post-processor'
import inactivePostIngestHook from './shared/inactive-post-ingest-hook'
import sourceHook from './shared/source-hook'

const addressKeyArray = getAddressKeyArray(
  {
    line1: '$Address',
    city: '$City',
    state: '$State',
    zip: '$Zip'
  }
)

const orgKeyArray = decorateWithOid({oid: constants.CCN.oid, key: '$CMS_Certification_Number_CCN'})

const locationKeyArray = getLocationKeyArray({orgKey: orgKeyArray, addressKey: addressKeyArray})

const id = {
  ...constants.CCN,
  extension: '$CMS_Certification_Number_CCN'
}

const measures = {
  starRatings: {
    _id: 'cms:hhc:starRatings',
    name: 'Quality of Patient Care Star Rating',
    scale: 5
  },
  timelyCare: {
    _id: 'cms:hhc:timelyCare',
    name: 'How often the home health team began their patients care in a timely manner',
    scale: 100
  },
  drugTeaching: {
    _id: 'cms:hhc:drugTeaching',
    name: 'How often the home health team taught patients or their family caregivers about their drugs',
    scale: 100
  },
  fallingRiskCheck: {
    _id: 'cms:hhc:fallingRiskCheck',
    name: 'How often the home health team checked patients risk of falling',
    scale: 100
  },
  depressionCheck: {
    _id: 'cms:hhc:depressionCheck',
    name: 'How often the home health team checked patients for depression',
    scale: 100
  },
  currentFluShot: {
    _id: 'cms:hhc:currentFluShot',
    name: 'How often the home health team made sure that their patients have received a flu shot for the current flu season',
    scale: 100
  },
  currentPneumoniaShot: {
    _id: 'cms:hhc:currentPneumoniaShot',
    name: 'How often the home health team made sure that their patients have received a pneumococcal vaccine pneumonia shot',
    scale: 100
  },
  diabetesFootCare: {
    _id: 'cms:hhc:diabetesFootCare',
    name: 'With diabetes how often the home health team got doctors orders gave foot care and taught patients about foot care',
    scale: 100
  },
  painCheck: {
    _id: 'cms:hhc:painCheck',
    name: 'How often the home health team checked patients for pain',
    scale: 100
  },
  painTreatment: {
    _id: 'cms:hhc:painTreatment',
    name: 'How often the home health team treated their patients pain',
    scale: 100
  },
  heartTreatment: {
    _id: 'cms:hhc:heartTreatment',
    name: 'How often the home health team treated heart failure weakening of the heart patients symptoms',
    scale: 100
  },
  sorePreventiveAction: {
    _id: 'cms:hhc:sorePreventiveAction',
    name: 'How often the home health team took doctor ordered action to prevent pressure sores bed sores',
    scale: 100
  },
  sorePreventiveTreatment: {
    _id: 'cms:hhc:sorePreventiveTreatment',
    name: 'How often the home health team included treatments to prevent pressure sores bed sores in the plan of care',
    scale: 100
  },
  soreRiskCheck: {
    _id: 'cms:hhc:soreRiskCheck',
    name: 'How often the home health team checked patients for the risk of developing pressure sores bed sores',
    scale: 100
  },
  betterWalking: {
    _id: 'cms:hhc:betterWalking',
    name: 'How often patients got better at walking or moving around',
    scale: 100
  },
  betterBedMovement: {
    _id: 'cms:hhc:betterBedMovement',
    name: 'How often patients got better at getting in and out of bed',
    scale: 100
  },
  betterBath: {
    _id: 'cms:hhc:betterBath',
    name: 'How often patients got better at bathing',
    scale: 100
  },
  lessMovingPain: {
    _id: 'cms:hhc:lessMovingPain',
    name: 'How often patients had less pain when moving around',
    scale: 100
  },
  improvedBreathing: {
    _id: 'cms:hhc:improvedBreathing',
    name: 'How often patients breathing improved',
    scale: 100
  },
  woundHealing: {
    _id: 'cms:hhc:woundHealing',
    name: 'How often patients wounds improved or healed after an operation',
    scale: 100
  },
  drugIntakeImprovement: {
    _id: 'cms:hhc:drugIntakeImprovement',
    name: 'How often patients got better at taking their drugs correctly by mouth',
    scale: 100
  },
  admission: {
    _id: 'cms:hhc:admission',
    name: 'How often home health patients had to be admitted to the hospital',
    scale: 100
  },
  erVisit: {
    _id: 'cms:hhc:erVisit',
    name: 'How often patients receiving home health care needed urgent unplanned care in the ER without being admitted',
    scale: 100
  }
}

export default getIngester(
  {
    inputName: constants.CMS_HHA_SOURCE,
    outputName: constants.ORGANIZATION_LOCATIONS,
    sourceHook,
    steps: [
      {
        $addFields: {
          addressKey: {$concat: addressKeyArray},
          specialty: constants.HOME_HEALTH_SPECIALTY,
          ratings: [
            getRatingNullCheck({measure: measures.starRatings, score: '$Quality_of_Patient_Care_Star_Rating', nullEqVals: [null, 'Not Available']}),
            getRatingNullCheck({measure: measures.timelyCare, score: '$How_often_the_home_health_team_began_their_patients_care_in_a_timely_manner', nullEqVals: [null, 'Not Available']}),
            getRatingNullCheck({measure: measures.fallingRiskCheck, score: '$How_often_the_home_health_team_checked_patients_risk_of_falling', nullEqVals: [null, 'Not Available']}),
            getRatingNullCheck({measure: measures.drugTeaching, score: '$How_often_the_home_health_team_taught_patients_or_their_family_caregivers_about_their_drugs', nullEqVals: [null, 'Not Available']}),
            getRatingNullCheck({measure: measures.depressionCheck, score: '$How_often_the_home_health_team_checked_patients_for_depression', nullEqVals: [null, 'Not Available']}),
            getRatingNullCheck({measure: measures.currentFluShot, score: '$How_often_the_home_health_team_made_sure_that_their_patients_have_received_a_flu_shot_for_the_current_flu_season', nullEqVals: [null, 'Not Available']}),
            getRatingNullCheck({measure: measures.currentPneumoniaShot, score: '$How_often_the_home_health_team_made_sure_that_their_patients_have_received_a_pneumococcal_vaccine_pneumonia_shot', nullEqVals: [null, 'Not Available']}),
            getRatingNullCheck({measure: measures.diabetesFootCare, score: '$With_diabetes_how_often_the_home_health_team_got_doctors_orders_gave_foot_care_and_taught_patients_about_foot_care'}),
            getRatingNullCheck({measure: measures.painCheck, score: '$How_often_the_home_health_team_checked_patients_for_pain'}),
            getRatingNullCheck({measure: measures.painTreatment, score: '$How_often_the_home_health_team_treated_their_patients_pain'}),
            getRatingNullCheck({measure: measures.heartTreatment, score: '$How_often_the_home_health_team_treated_heart_failure_weakening_of_the_heart_patients_symptoms'}),
            getRatingNullCheck({measure: measures.sorePreventiveAction, score: '$How_often_the_home_health_team_took_doctor_ordered_action_to_prevent_pressure_sores_bed_sores'}),
            getRatingNullCheck({measure: measures.sorePreventiveTreatment, score: '$How_often_the_home_health_team_included_treatments_to_prevent_pressure_sores_bed_sores_in_the_plan_of_care'}),
            getRatingNullCheck({measure: measures.soreRiskCheck, score: '$How_often_the_home_health_team_checked_patients_for_the_risk_of_developing_pressure_sores_bed_sores'}),
            getRatingNullCheck({measure: measures.betterWalking, score: '$How_often_patients_got_better_at_walking_or_moving_around'}),
            getRatingNullCheck({measure: measures.betterBedMovement, score: '$How_often_patients_got_better_at_getting_in_and_out_of_bed'}),
            getRatingNullCheck({measure: measures.betterBath, score: '$How_often_patients_got_better_at_bathing'}),
            getRatingNullCheck({measure: measures.lessMovingPain, score: '$How_often_patients_had_less_pain_when_moving_around'}),
            getRatingNullCheck({measure: measures.improvedBreathing, score: '$How_often_patients_breathing_improved'}),
            getRatingNullCheck({measure: measures.woundHealing, score: '$How_often_patients_wounds_improved_or_healed_after_an_operation'}),
            getRatingNullCheck({measure: measures.drugIntakeImprovement, score: '$How_often_patients_got_better_at_taking_their_drugs_correctly_by_mouth'}),
            getRatingNullCheck({measure: measures.admission, score: '$How_often_home_health_patients_had_to_be_admitted_to_the_hospital'}),
            getRatingNullCheck({measure: measures.erVisit, score: '$How_often_patients_receiving_home_health_care_needed_urgent_unplanned_care_in_the_ER_without_being_admitted'})
          ]
        }
      },
      {
        $lookup: {
          from: constants.GEO_ADDRESSES,
          localField: 'addressKey',
          foreignField: 'addressKey',
          as: 'geocoded'
        }
      },
      {
        $lookup: {
          from: 'specialties',
          localField: 'specialty',
          foreignField: 'code',
          as: 'taxonomy'
        }
      },
      unwind('$geocoded'),
      unwind('$taxonomy'),
      {
        $project: {
          _id: {$concat: locationKeyArray},
          address: {
            line1: '$Address',
            city: '$City',
            state: '$State',
            zip: '$Zip'
          },
          geoPoint: '$geocoded.geoPoint',
          organization: {
            _id: {$concat: orgKeyArray},
            id,
            name: '$Provider_Name',
            identifiers: [id]
          },
          specialties: [
            {
              code: '$taxonomy.code',
              grouping: '$taxonomy.grouping',
              classification: '$taxonomy.classification',
              specialization: '$taxonomy.specialization',
              system: '$taxonomy.system',
              isPrimary: true
            }
          ],
          phone: '$Phone',
          ratings: 1
        }
      }
    ],
    postProcessor: upsertPostProcessor({
      recordHook: record => {
        return transformField(
          {
            target: record,
            field: 'ratings',
            transformer: ratingsCleaner
          }
        )
      }
    }),
    postIngestHook: inactivePostIngestHook(
      {
        query: {
          'organization.id.oid': constants.CCN.oid,
          'specialties.code': constants.HOME_HEALTH_SPECIALTY
        }
      }
    )
  }
)()
