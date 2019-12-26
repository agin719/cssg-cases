//.cssg-snippet-body-start:[get-bucket-comp]
  package main
  
  import (
      "context"
      "fmt"
      "os"
      "net/url"
      "net/http"
  
      "github.com/tencentyun/cos-go-sdk-v5"
  )
  
  func main() {
      // 将 bucket-cssg-test-go-1253653367 和 ap-guangzhou 修改为真实的信息
      u, _ := url.Parse("http://bucket-cssg-test-go-1253653367.cos.ap-guangzhou.myqcloud.com")
      b := &cos.BaseURL{BucketURL: u}
      c := cos.NewClient(b, &http.Client{
          Transport: &cos.AuthorizationTransport{
              SecretID: os.Getenv("COS_KEY"),
              SecretKey: os.Getenv("COS_SECRET"),  
          },
      })
  
      opt := &cos.BucketGetOptions{
          Prefix:  "test",
          MaxKeys: 3,
      }
      v, _, err := c.Bucket.Get(context.Background(), opt)
      if err != nil {
          panic(err)
      }
  
      for _, c := range v.Contents {
          fmt.Printf("%s, %d\n", c.Key, c.Size)
      }
  }
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end

