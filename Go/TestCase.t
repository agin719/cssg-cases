{{^isRunnable}}
package cos;

import (
	"context"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/suite"
	"github.com/tencentyun/cos-go-sdk-v5"
	"net/http"
	"net/url"
	"os"
	"testing"
)

type CosTestSuite struct {
	suite.Suite
	VariableThatShouldStartAtFive int

	// CI client
	Client *cos.Client

	// Copy source client
	CClient *cos.Client

	// test_object
	TestObject string

	// special_file_name
	SepFileName string
}

func (s *CosTestSuite) SetupSuite() {
  {{^isServcieInit}}
  {{{initSnippet}}}
  s.Client = client
  {{/isServcieInit}}

  {{#setup}}
  {{name}}()
  {{/setup}}
}

func (s *CosTestSuite) TearDownSuite() {
  {{#teardown}}
  {{name}}()
  {{/teardown}}
}

{{#methods}}
func (s *CosTestSuite) {{name}}() {
  {{^isServcieInit}}
  client := s.Client
  {{/isServcieInit}}
  {{{snippet}}}
}

{{/methods}}

{{#cases}}
func (s *CosTestSuite) {{name}}() {
  {{#steps}}
  s.{{name}}()
  {{/steps}}
}
{{/cases}}

func TestCosTestSuite(t *testing.T) {
	suite.Run(t, new(CosTestSuite))
}
{{/isRunnable}}
{{#isRunnable}}
{{#methods}}
{{{snippet}}}

{{/methods}}
{{/isRunnable}}