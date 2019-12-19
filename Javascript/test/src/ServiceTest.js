function getAuthorization(assert) {
    //.cssg-snippet-body-start:[get-authorization]
    var Authorization = COS.getAuthorization({
        SecretId: 'COS_SECRETID',
        SecretKey: 'COS_SECRETKEY',
        Method: 'get',
        Key: 'object4js',
        Expires: 60,
        Query: {},
        Headers: {}
    });
    //.cssg-snippet-body-end
    assert.ok(Authorization)
}



test("testGetService", async function(assert) {
  await getAuthorization(assert)
})

