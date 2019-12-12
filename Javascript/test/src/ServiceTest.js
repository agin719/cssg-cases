function getAuthorization(assert) {
    var Authorization = COS.getAuthorization({
        SecretId: 'COS_SECRETID',
        SecretKey: 'COS_SECRETKEY',
        Method: 'get',
        Key: 'object4js',
        Expires: 60,
        Query: {},
        Headers: {}
    });
    
    assert.ok(Authorization)
}



test("testGetService", async function(assert) {
  await getAuthorization(assert)
})

