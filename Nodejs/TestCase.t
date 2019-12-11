const assert = require('assert')
const fs = require('fs')
const path = require('path')

var createFileSync = function (filePath, size) {
  if (!fs.existsSync(filePath) || fs.statSync(filePath).size !== size) {
      fs.writeFileSync(filePath, Buffer.from(Array(size).fill(0)));
  }
  return filePath;
};

{{^isStsCase}}
function initCOS () {
    {{{initSnippet}}}
    return cos
}
var cos = initCOS()
{{#isObjectTest}}
var uploadId
var eTag
var tempFilePath = createFileSync(path.join(process.cwd(), "temp-file-to-upload"), 2048)
{{/isObjectTest}}
{{/isStsCase}}

{{#methods}}
{{#syncMethod}}
function {{name}}() {
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
function {{name}}() {
  return new Promise((resolve, reject) => {
    {{{snippet}}}
  })
}
{{/syncMethod}}

{{/methods}}

{{^isStsCase}}

{{#cases}}
describe("{{name}}", function() {
  {{#steps}}
  it("{{name}}", function() {
    return {{name}}()
  })
  {{/steps}}
})
{{/cases}}

{{#isBucketTest}}
describe("CleanBucket", function() {
  {{#teardown}}
  it("{{name}}", function() {
    return {{name}}()
  })
  {{/teardown}}
  {{#setup}}
  it("{{name}}", function() {
    return {{name}}()
  })
  {{/setup}}
})
{{/isBucketTest}}
{{/isStsCase}}