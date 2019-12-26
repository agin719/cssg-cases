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

  putBucket()
}

func (s *CosTestSuite) TearDownSuite() {
  deleteBucket()
}

func (s *CosTestSuite) putBucket() {
  client := s.Client
  //.cssg-snippet-body-start:[put-bucket]
  opt := &cos.BucketPutOptions{
      XCosACL: "public-read",
  }
  resp, err := client.Bucket.Put(context.Background(), opt)
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) deleteBucket() {
  client := s.Client
  //.cssg-snippet-body-start:[delete-bucket]
  resp, err := client.Bucket.Delete(context.Background())
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucket() {
  client := s.Client
  //.cssg-snippet-body-start:[get-bucket]
  opt := &cos.BucketGetOptions{
      Prefix: "test",
      MaxKeys: 100,                                
  }
  v, resp, err := client.Bucket.Get(context.Background(), opt)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) headBucket() {
  client := s.Client
  //.cssg-snippet-body-start:[head-bucket]
  resp, err := client.Bucket.Head(context.Background())
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) putBucketAcl() {
  client := s.Client
  //.cssg-snippet-body-start:[put-bucket-acl]
  // 1. Set Bucket ACL by header.
  opt := &cos.BucketPutACLOptions{
      Header: &cos.ACLHeaderOptions{
          //private，public-read，public-read-write
          XCosACL: "private",
      },
  }
  resp, err := client.Bucket.PutACL(context.Background(), opt)
  
  // 2. Set Bucket ACL by body.
  opt := &cos.BucketPutACLOptions{
      Body: &cos.ACLXml{
          Owner: &cos.Owner{
              ID: "qcs::cam::uin/100000760461:uin/100000760461",
          },
          AccessControlList: []cos.ACLGrant{
              {
                  Grantee: &cos.ACLGrantee{
              // Type can also chose the "Group", "CanonicalUser"
                      Type: "RootAccount",
                      ID:"qcs::cam::uin/100000760461:uin/100000760461",
                  },
          // Permission can also chose the "WRITE"，"FULL_CONTROL" 
                  Permission: "FULL_CONTROL",
              },
          },
      },
  }
  resp, err := client.Bucket.PutACL(context.Background(), opt)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucketAcl() {
  client := s.Client
  //.cssg-snippet-body-start:[get-bucket-acl]
  v, resp, err := client.Bucket.GetACL(context.Background())
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) putBucketCors() {
  client := s.Client
  //.cssg-snippet-body-start:[put-bucket-cors]
  opt := &cos.BucketPutCORSOptions{
      Rules: []cos.BucketCORSRule{
          {
              AllowedOrigins: []string{"http://www.qq.com"},
              AllowedMethods: []string{"PUT", "GET"},
              AllowedHeaders: []string{"x-cos-meta-test", "x-cos-xx"},
              MaxAgeSeconds:  500,
              ExposeHeaders:  []string{"x-cos-meta-test1"},
          },
          {
              ID:             "1234",
              AllowedOrigins: []string{"http://www.baidu.com", "twitter.com"},
              AllowedMethods: []string{"PUT", "GET"},
              MaxAgeSeconds:  500,
          },
      },
  }
  resp, err := client.Bucket.PutCORS(context.Background(), opt)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucketCors() {
  client := s.Client
  //.cssg-snippet-body-start:[get-bucket-cors]
  v, resp, err := client.Bucket.GetCORS(context.Background())
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) deleteBucketCors() {
  client := s.Client
  //.cssg-snippet-body-start:[delete-bucket-cors]
  resp, err := client.Bucket.DeleteCORS(context.Background())
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) putBucketLifecycle() {
  client := s.Client
  //.cssg-snippet-body-start:[put-bucket-lifecycle]
  lc := &cos.BucketPutLifecycleOptions{
      Rules: []cos.BucketLifecycleRule{
          {
              ID:     "1234",
              Filter: &cos.BucketLifecycleFilter{Prefix: "test"},
              Status: "Enabled",
              Transition: &cos.BucketLifecycleTransition{
                  Days:         10,
                  StorageClass: "Standard",
              },
          },
          {
              ID:     "123422",
              Filter: &cos.BucketLifecycleFilter{Prefix: "gg"},
              Status: "Disabled",
              Expiration: &cos.BucketLifecycleExpiration{
                  Days: 10,
              },
          },
      },
  }
  resp, err := client.Bucket.PutLifecycle(context.Background(), lc)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucketLifecycle() {
  client := s.Client
  //.cssg-snippet-body-start:[get-bucket-lifecycle]
  v, resp, err := client.Bucket.GetLifecycle(context.Background()) 
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) deleteBucketLifecycle() {
  client := s.Client
  //.cssg-snippet-body-start:[delete-bucket-lifecycle]
  resp, err := client.Bucket.DeleteLifecycle(context.Background())
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) putBucketVersioning() {
  client := s.Client
  //.cssg-snippet-body-start:[put-bucket-versioning]
  opt := &cos.BucketPutVersionOptions{
      // Enabled or Suspended, the versioning once opened can not close.
      Status: "Enabled",
  }
  resp, err := c.Bucket.PutVersioning(context.Background(), opt)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucketVersioning() {
  client := s.Client
  //.cssg-snippet-body-start:[get-bucket-versioning]
  v, resp, err := c.Bucket.GetVersioning(context.Background())
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) putBucketReplication() {
  client := s.Client
  //.cssg-snippet-body-start:[put-bucket-replication]
  opt := &cos.PutBucketReplicationOptions{
      // qcs::cam::uin/[UIN]:uin/[Subaccount]
      Role: "qcs::cam::uin/1278687956:uin/1278687956",
      Rule: []cos.BucketReplicationRule{
          {
              ID: "1",
              // Enabled or Disabled
              Status: "Enabled",
              Destination: &cos.ReplicationDestination{
                  // qcs::cos:[Region]::[Bucketname-Appid]
                  Bucket: "qcs::cos:ap-beijing::bucket-cssg-assist-1253653367",
              },
          },
      },
  }
  resp, err := c.Bucket.PutBucketReplication(context.Background(), opt)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucketReplication() {
  client := s.Client
  //.cssg-snippet-body-start:[get-bucket-replication]
  v, resp, err := c.Bucket.GetBucketReplication(context.Background())
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) deleteBucketReplication() {
  client := s.Client
  //.cssg-snippet-body-start:[delete-bucket-replication]
  resp, err := c.Bucket.DeleteBucketReplication(context.Background())
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}


func (s *CosTestSuite) TestBucketACL() {
  s.getBucket()
  s.headBucket()
  s.putBucketAcl()
  s.getBucketAcl()
}
func (s *CosTestSuite) TestBucketCORS() {
  s.putBucketCors()
  s.getBucketCors()
  s.deleteBucketCors()
}
func (s *CosTestSuite) TestBucketLifecycle() {
  s.putBucketLifecycle()
  s.getBucketLifecycle()
  s.deleteBucketLifecycle()
}
func (s *CosTestSuite) TestBucketReplicationAndVersioning() {
  s.putBucketVersioning()
  s.getBucketVersioning()
  s.putBucketReplication()
  s.getBucketReplication()
  s.deleteBucketReplication()
}

func TestCosTestSuite(t *testing.T) {
	suite.Run(t, new(CosTestSuite))
}
