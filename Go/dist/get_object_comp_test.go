//.cssg-snippet-body-start:[get-object-comp]
  package main
  
  import (
      "context"
      "fmt"
      "net/url"
      "os"
      "io/ioutil"
      "net/http"
  
      "github.com/tencentyun/cos-go-sdk-v5"
  )
  
  func main() {
      // 将<BucketName-APPID>和<region>修改为真实的信息
      // 例如：http://bucket-cssg-test-go-1253653367.cos.ap-guangzhou.myqcloud.com
      u, _ := url.Parse("http://<BucketName-APPID>.cos.<region>.myqcloud.com")
      b := &cos.BaseURL{BucketURL: u}
      c := cos.NewClient(b, &http.Client{
          Transport: &cos.AuthorizationTransport{
              SecretID: os.Getenv("COS_KEY"),
              SecretKey: os.Getenv("COS_SECRET"),  
          },
      })
      // 1.Get object content by resp body.
      name := "test/hello.txt"
      resp, err := c.Object.Get(context.Background(), name, nil)
      if err != nil {
          panic(err)
      }
      bs, _ := ioutil.ReadAll(resp.Body)
      resp.Body.Close()
      fmt.Printf("%s\n", string(bs))
      // 2.Get object to local file path.
      _, err = c.Object.GetToFile(context.Background(), name, "example", nil)
      if err != nil {
          panic(err)
      }
  }
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end

