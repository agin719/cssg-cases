package cos

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

	Uin                   string
	ReplicationDestBucket string
}

func (s *CosTestSuite) SetupSuite() {
	//.cssg-snippet-body-start:[global-init]
	// 将uin和跨区域复制存储桶替换成真是信息，跨区域复制存储桶与原存储桶的地域不能相同
	s.Uin = "100000760461"
	s.ReplicationDestBucket = "qcs::cos:ap-beijing::bucket-cssg-assist-1253653367"
	// 将 bucket-cssg-test-go-1253653367 和 ap-guangzhou修改为真实的信息
	u, _ := url.Parse("http://bucket-cssg-test-go-1253653367.cos.ap-guangzhou.myqcloud.com")
	b := &cos.BaseURL{BucketURL: u}
	// 1.永久密钥
	client := cos.NewClient(b, &http.Client{
		Transport: &cos.AuthorizationTransport{
			SecretID:  os.Getenv("COS_KEY"),
			SecretKey: os.Getenv("COS_SECRET"),
		},
	})
	//.cssg-snippet-body-end
	s.Client = client

	s.putBucket()
}

func (s *CosTestSuite) TearDownSuite() {
	s.testBucketReplicationAndVersioning()
	s.deleteBucket()
}

func (s *CosTestSuite) putBucket() {
	client := s.Client
	//.cssg-snippet-body-start:[put-bucket]
	opt := &cos.BucketPutOptions{
		XCosACL: "public-read",
	}
	_, err := client.Bucket.Put(context.Background(), opt)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) deleteBucket() {
	client := s.Client
	//.cssg-snippet-body-start:[delete-bucket]
	_, err := client.Bucket.Delete(context.Background())
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucket() {
	client := s.Client
	//.cssg-snippet-body-start:[get-bucket]
	opt := &cos.BucketGetOptions{
		Prefix:  "test",
		MaxKeys: 100,
	}
	_, _, err := client.Bucket.Get(context.Background(), opt)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) headBucket() {
	client := s.Client
	//.cssg-snippet-body-start:[head-bucket]
	_, err := client.Bucket.Head(context.Background())
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
	_, err := client.Bucket.PutACL(context.Background(), opt)

	// 2. Set Bucket ACL by body.
	opt = &cos.BucketPutACLOptions{
		Body: &cos.ACLXml{
			Owner: &cos.Owner{
				ID: "qcs::cam::uin/" + s.Uin + ":uin/" + s.Uin,
			},
			AccessControlList: []cos.ACLGrant{
				{
					Grantee: &cos.ACLGrantee{
						// Type can also chose the "Group", "CanonicalUser"
						Type: "RootAccount",
						ID:   "qcs::cam::uin/" + s.Uin + ":uin/" + s.Uin,
					},
					// Permission can also chose the "WRITE"，"FULL_CONTROL"
					Permission: "FULL_CONTROL",
				},
			},
		},
	}
	_, err = client.Bucket.PutACL(context.Background(), opt)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucketAcl() {
	client := s.Client
	//.cssg-snippet-body-start:[get-bucket-acl]
	_, _, err := client.Bucket.GetACL(context.Background())
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
	_, err := client.Bucket.PutCORS(context.Background(), opt)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucketCors() {
	client := s.Client
	//.cssg-snippet-body-start:[get-bucket-cors]
	_, _, err := client.Bucket.GetCORS(context.Background())
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) deleteBucketCors() {
	client := s.Client
	//.cssg-snippet-body-start:[delete-bucket-cors]
	_, err := client.Bucket.DeleteCORS(context.Background())
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
	_, err := client.Bucket.PutLifecycle(context.Background(), lc)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucketLifecycle() {
	client := s.Client
	//.cssg-snippet-body-start:[get-bucket-lifecycle]
	_, _, err := client.Bucket.GetLifecycle(context.Background())
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) deleteBucketLifecycle() {
	client := s.Client
	//.cssg-snippet-body-start:[delete-bucket-lifecycle]
	_, err := client.Bucket.DeleteLifecycle(context.Background())
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
	_, err := client.Bucket.PutVersioning(context.Background(), opt)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucketVersioning() {
	client := s.Client
	//.cssg-snippet-body-start:[get-bucket-versioning]
	_, _, err := client.Bucket.GetVersioning(context.Background())
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) putBucketReplication() {
	client := s.Client
	//.cssg-snippet-body-start:[put-bucket-replication]
	opt := &cos.PutBucketReplicationOptions{
		// qcs::cam::uin/[UIN]:uin/[Subaccount]
		Role: "qcs::cam::uin/" + s.Uin + ":uin/" + s.Uin,
		Rule: []cos.BucketReplicationRule{
			{
				ID: "1",
				// Enabled or Disabled
				Status: "Enabled",
				Destination: &cos.ReplicationDestination{
					// qcs::cos:[Region]::[Bucketname-Appid]
					Bucket: s.ReplicationDestBucket,
				},
			},
		},
	}
	_, err := client.Bucket.PutBucketReplication(context.Background(), opt)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) getBucketReplication() {
	client := s.Client
	//.cssg-snippet-body-start:[get-bucket-replication]
	_, _, err := client.Bucket.GetBucketReplication(context.Background())
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) deleteBucketReplication() {
	client := s.Client
	//.cssg-snippet-body-start:[delete-bucket-replication]
	_, err := client.Bucket.DeleteBucketReplication(context.Background())
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

func (s *CosTestSuite) testBucketReplicationAndVersioning() {
	s.putBucketVersioning()
	s.getBucketVersioning()
	s.putBucketReplication()
	s.getBucketReplication()
	s.deleteBucketReplication()
}

func TestCosTestSuite(t *testing.T) {
	suite.Run(t, new(CosTestSuite))
}
