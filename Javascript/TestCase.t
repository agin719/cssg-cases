{{#methods}}
{{#syncMethod}}
function {{name}}(assert) {
    {{{snippet}}}
    {{#isPresignUrl}}
    assert.ok(url)
    {{/isPresignUrl}}
    {{#isGetAuthorization}}
    assert.ok(Authorization)
    {{/isGetAuthorization}}
}
{{/syncMethod}}
{{^syncMethod}}
function {{name}}(assert) {
  return new Promise((resolve, reject) => {
    {{{snippet}}}
  })
}
{{/syncMethod}}

{{/methods}}

{{^isStsCase}}

{{#cases}}
test("{{name}}", async function(assert) {
  {{#steps}}
  await {{name}}(assert)
  {{#isBucketTest}}
  sleepfor(100)
  {{/isBucketTest}} 
  {{/steps}}
})
{{/cases}}

{{#isBucketTest}}
test("CleanBucket", async function(assert) {
  await suspendBucketVersioning(assert)
})
{{/isBucketTest}}
{{#isObjectTest}}
test("CleanObjects", async function(assert) {
  await cleanupObjects(assert)
})
{{/isObjectTest}}
{{/isStsCase}}