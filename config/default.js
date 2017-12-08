module.exports = {
  mongo: {
    host: 'localhost:27017',
    db: 'test',
    connectTimeoutMs: 30000,
    socketTimeoutMs: 30000,
    cursorTimeoutMs: 30000,
    poolSize: 25
  },
  listener: {
    port: 3000,
    secret: 's3cret'
  },
  geocoder: {
    provider: 'geocodio',
    params: {
      // eslint-disable-next-line camelcase
      api_key: 'bfc5c9e6dc557e7ecb72757ce9b07596c757ff7'
    }
  },
  framework: {
    data: {
      defaultLimit: 10,
      maxLimit: 200
    }
  }
}
