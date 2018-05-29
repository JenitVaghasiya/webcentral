using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DBConnection
/// </summary>
public static class DBConnection
{
    public static DbConnection Connection
    {
        get
        {
            var connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            return connection;
        }
    }
    public static int ConnectionTimeout
    {
        get
        {
             return 5000;
        }
    }
}