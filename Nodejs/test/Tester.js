const helper = require('../utils/helper')

describe("setup", function() {
  it("createBucket", function() {
    return helper.setup()
  })
})

require('./../src/InitServiceTest')
require('./../src/ServiceTest')
require('./../src/BucketTest')
require('./../src/ObjectTest')

describe("cleanUp", function() {
  it("cleanObjectAndBucket", function() {
    return helper.cleanUp()
  })
})