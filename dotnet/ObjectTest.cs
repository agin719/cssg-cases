using COSXML.Common;
using COSXML.CosException;
using COSXML.Model;
using COSXML.Model.Object;
using COSXML.Model.Tag;
using COSXML.Utils;
using COSXML.Auth;
using COSXML.Transfer;
using NUnit.Framework;
using System;
using COSXML;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

// cssg-snippet-lang: [dotnet]
namespace ObjectTest
{
    public class ObjectTest {

        CosXml service = QCloudServer.Instance().service;

        public void GetObject()
        {

            // .cssg-body-start: [get-object]
            string bucket = "{{bucket}}";
            string key = "your-cos-key";
            string localDir = System.IO.Path.GetTempPath();
            string localFileName = "my-local-temp-file";

            GetObjectRequest request = new GetObjectRequest(bucket, key, localDir, localFileName);
            //设置签名有效时长
            request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);

            request.SetCosProgressCallback(delegate (long completed, long total)
            {
                Console.WriteLine(String.Format("progress = {0} / {1} : {2:##.##}%", 
                    completed, total, completed * 100.0 / total));
            });

            //执行请求
            GetObjectResult result = service.GetObject(request);

            Console.WriteLine(result.GetResultInfo());
            // .cssg-body-end
        }

        public void PutObject()
        {

            // .cssg-body-start: [put-object]
            string bucket = "{{bucket}}";
            string key = "your-cos-key";
            string srcPath = "temp-source-file";
            File.WriteAllBytes(srcPath, new byte[1024 * 1024 * 1]);

            PutObjectRequest request = new PutObjectRequest(bucket, key, srcPath);
            //设置签名有效时长
            request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);

            //设置进度回调
            request.SetCosProgressCallback(delegate (long completed, long total)
            {
                Console.WriteLine(String.Format("{0} progress = {1} / {2} : {3:##.##}%", 
                    DateTime.Now.ToString(), completed, total, completed * 100.0 / total));
            });

            //执行请求
            PutObjectResult result = service.PutObject(request);

            Console.WriteLine(result.GetResultInfo());
            // .cssg-body-end
        }
    }
}