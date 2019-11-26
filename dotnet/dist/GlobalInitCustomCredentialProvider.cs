using COSXML.Common;
using COSXML.CosException;
using COSXML.Model;
using COSXML.Model.Object;
using COSXML.Model.Tag;
using COSXML.Model.Bucket;
using COSXML.Model.Service;
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

namespace COSSample
{
    // 方式3: 自定义方式提供密钥， 继承 QCloudCredentialProvider 并重写 GetQCloudCredentials() 方法
    public class MyQCloudCredentialProvider : QCloudCredentialProvider
    {
      public override QCloudCredentials GetQCloudCredentials()
      {
        string secretId = "COS_SECRETID"; //密钥 SecretId
        string secretKey = "COS_SECRETKEY"; //密钥 SecretKey
        //密钥有效时间, 精确到秒，例如 1546862502;1546863102
        string keyTime = "SECRET_STARTTIME;SECRET_ENDTIME"; 
        return new QCloudCredentials(secretId, secretKey, keyTime);
      }
    
      public override void Refresh()
      {
        //更新密钥信息，密钥过期会自动回调该方法
      }
    }
}