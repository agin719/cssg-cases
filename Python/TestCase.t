# -*- coding=utf-8
import os

{{{initSnippet}}}

{{#isObjectTest}}
uploadId = ''
eTag = ''
{{/isObjectTest}}

{{#methods}}
def {{name}}():
    {{{snippet}}}

{{/methods}}

def setUp():
    {{#setup}}
    {{name}}()
    {{/setup}}
    {{^setup}}
    pass
    {{/setup}}

def tearDown():
    {{#teardown}}
    {{name}}()
    {{/teardown}}
    {{^teardown}}
    pass
    {{/teardown}}

{{#cases}}
def {{name}}():
    {{#steps}}
    {{name}}()
    {{/steps}}

{{/cases}}


if __name__ == "__main__":
    setUp()
    """
    {{#cases}}
    {{name}}()
    {{/cases}}
    """
    tearDown()