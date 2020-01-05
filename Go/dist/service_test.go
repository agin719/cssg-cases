package cos

import (
	"context"
	"github.com/stretchr/testify/assert"
)

func (s *CosTestSuite) getService() {
	client := s.Client
	//.cssg-snippet-body-start:[get-service]
	_, _, err := client.Service.Get(context.Background())
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) TestGetService() {
	s.getService()
}
