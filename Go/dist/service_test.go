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
  //.cssg-snippet-body-start:[global-init]
  // 将 bucket-cssg-test-go-1253653367 和 ap-guangzhou 修改为真实的信息
  u, _ := url.Parse("http://bucket-cssg-test-go-1253653367.cos.ap-guangzhou.myqcloud.com")
  b := &cos.BaseURL{BucketURL: u}
  // 1.永久密钥
  client := cos.NewClient(b, &http.Client{
      Transport: &cos.AuthorizationTransport{
          SecretID: os.Getenv("COS_KEY"),
          SecretKey: os.Getenv("COS_SECRET"),                      
      },                                 
  })
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
  s.Client = client

}

func (s *CosTestSuite) TearDownSuite() {
}

func (s *CosTestSuite) getService() {
  client := s.Client
  //.cssg-snippet-body-start:[get-service]
  s, resp, err := c.Service.Get(context.Background()) 
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}


func (s *CosTestSuite) TestGetService() {
  s.getService()
}

func TestCosTestSuite(t *testing.T) {
	suite.Run(t, new(CosTestSuite))
}
