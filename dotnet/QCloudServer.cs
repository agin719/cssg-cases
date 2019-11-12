using COSXML;
using COSXML.Auth;
using COSXML.Common;
using COSXML.Utils;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;


/* ============================================================================== 
* Copyright 2016-2019 Tencent Cloud. All Rights Reserved.
* Auth：bradyxiao 
* Date：2019/1/22 19:34:45 
* ==============================================================================*/

namespace ObjectTest
{
    public class QCloudServer
    {
        internal CosXml service;
        internal string bucketForBucketTest;
        internal string bucketForObjectTest;
        internal string region;

        private static QCloudServer instance;

        private QCloudServer()
        {
            string secretId = Environment.GetEnvironmentVariable("COS_KEY");
            string secretKey = Environment.GetEnvironmentVariable("COS_SECRET");
            string region = Environment.GetEnvironmentVariable("COS_REGION");
            string appid = Environment.GetEnvironmentVariable("COS_APPID");
           
            CosXmlConfig config = new CosXmlConfig.Builder()
                .SetRegion(region)
                .SetAppid(appid)
                .Build();

            long keyDurationSecond = 600;
            QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, secretKey, keyDurationSecond);

            CosXml service = new CosXmlServer(config, qCloudCredentialProvider);

            this.service = service;
        }

        public static QCloudServer Instance()
        {
            lock (typeof(QCloudServer))
            {
                if (instance == null)
                {
                    instance = new QCloudServer();
                }

            }
            return instance;
        }

        public static string CreateFile(string filename, long size)
        {
            try
            {
                string path = null;
                FileStream fs = new FileStream(filename, FileMode.Create);
                fs.SetLength(size);
                path = fs.Name;
                fs.Close();
                return path;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static void DeleteFile(string path)
        {
            FileInfo fileInfo = new FileInfo(path);
            if (fileInfo.Exists)
            {
                fileInfo.Delete();
            }
        }

        public static void DeleteAllFile(string dirPath, string regix)
        {
            DirectoryInfo directoryInfo = new DirectoryInfo(dirPath);
            if (directoryInfo.Exists)
            {
                FileInfo[] files = directoryInfo.GetFiles(regix);
                if (files != null && files.Length > 0)
                {
                    for (int i = 0, count = files.Length; i < count; i++)
                    {
                        Console.WriteLine(files[i].Name);
                        files[i].Delete();
                    }
                }
            }
        }
    }
}
