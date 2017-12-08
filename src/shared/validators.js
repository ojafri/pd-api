import joi from 'joi'
import iso6391 from 'iso-639-1'

export const id = joi.object(
  {
    authority: joi.string().min(3).max(16),
    oid: joi.string().min(3).max(32),
    extension: joi.string().min(3).max(32)
  }
)

export const address = joi.object(
  {
    line1: joi.string().min(3).max(64),
    line2: joi.string().min(3).max(32),
    city: joi.string().min(3).max(32),
    state: joi.string().min(2).max(2),
    zip: joi.string().min(5).max(10)
  }
).and('line1', 'city', 'state', 'zip')

export const humanName = joi.object(
  {
    first: joi.string().min(2).max(16),
    last: joi.string().min(2).max(32)
  }
)

export const _id = joi.string()
export const identifiers = joi.array().min(1)
export const specialties = joi.array().min(1)
export const phone = joi.string().min(10)
export const fax = joi.string().min(10)
export const name = joi.string().min(2).max(64)
export const county = joi.string().min(2).max(32)
export const hours = joi.string().min(2).max(64)
export const hospitals = joi.array().min(1)
export const insurances = joi.array().min(1)
export const website = joi.string().min(2).max(64)
export const direct = joi.string().email()
export const email = joi.string().email()
export const description = joi.string().min(2).max(64)
export const isInactive = joi.boolean()
export const isPrivate = joi.boolean()
export const gender = joi.any().valid('M', 'F', 'U')
export const education = joi.array().min(1).items(joi.string())
export const languages = joi.array().min(1).items(joi.valid(iso6391.getAllCodes()))
export const specialtyCodes = joi.array().min(1).items(joi.string())
export const benefits = joi.string().min(2).max(255)
export const rank = joi.number().integer().min(0)
export const isInNetwork = joi.boolean()
