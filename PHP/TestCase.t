<?php

use Qcloud\Cos\Client;
use Qcloud\Cos\Exception\ServiceResponseException;

class {{name}}Test extends \PHPUnit\Framework\TestCase
{
    private $cosClient;
    private $bucket;
    private $region;

    {{#isObjectTest}}
    private $uploadId;
    private $eTag;
    {{/isObjectTest}}

    {{#methods}}
    protected function {{name}}() {
        {{{snippet}}}
    }

    {{/methods}}

    protected function setUp(): void
    {
        {{{initSnippet}}}
        {{#setup}}
        $this->{{name}}();
        {{/setup}}
    }

    protected function tearDown(): void
    {
        {{#teardown}}
        $this->{{name}}();
        {{/teardown}}
    }

    {{#cases}}
    public function {{name}}() {
        {{#steps}}
        $this->{{name}}();
        {{/steps}}
    }

    {{/cases}}
}
?>