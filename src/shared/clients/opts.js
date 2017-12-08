import {sequenceIdHook as idHook} from '../../framework/data/helper'
import constants from '../constants'
import createdDataHook from '../created-data-hook'
import changesPostUpdateHook from '../changes-post-update-hook'
import postDeleteHook from '../post-delete-hook'
import isValid from './is-valid'

export default {
  collectionName: constants.CLIENTS,
  idHook,
  dataHook: createdDataHook({omitSource: true}),
  isValid,
  postUpdateHook: changesPostUpdateHook({omitSource: true}),
  postDeleteHook
}
