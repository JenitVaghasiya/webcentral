using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Dapper;

/// <summary>
/// Summary description for ClientesRepository
/// </summary>
public class ClientesRepository
{

    public Clientes Sigin(string UserName, string Password)
    {
  
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                string sQuery = "SELECT [Auto Cliente] as AutoCliente,[Dto pp] AS Dtopp,[Razón Social] AS RazónSocial, * FROM Clientes "
                               + " WHERE [Código] = @Código AND [Password Web] = @PasswordWeb";
                dbConnection.Open();
                return dbConnection.Query<Clientes>(sQuery, new { Código = UserName, PasswordWeb = Password }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                return new Clientes();
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public static IEnumerable<Clientes> GetClientList()
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                string sQuery = "SELECT [Auto Cliente] as AutoCliente,[Dto pp] AS Dtopp,[Razón Social] AS RazónSocial, * FROM Clientes";
                dbConnection.Open();
                return dbConnection.Query<Clientes>(sQuery);
            }
            catch (Exception ex)
            {
                return new List<Clientes>();
            }
            finally
            { dbConnection.Close(); }
        }
    }



    //public void Add(Clientes prod)
    //{
    //    using (IDbConnection dbConnection = Connection)
    //    {
    //        string sQuery = "INSERT INTO Products (Name, Quantity, Price)"
    //                        + " VALUES(@Name, @Quantity, @Price)";
    //        dbConnection.Open();
    //        dbConnection.Execute(sQuery, prod);
    //    }
    //}

    //public IEnumerable<Product> GetAll()
    //{
    //    using (IDbConnection dbConnection = Connection)
    //    {
    //        dbConnection.Open();
    //        return dbConnection.Query<Product>("SELECT * FROM Products");
    //    }
    //}

    //public Product GetByID(int id)
    //{
    //    using (IDbConnection dbConnection = Connection)
    //    {
    //        string sQuery = "SELECT * FROM Products"
    //                       + " WHERE ProductId = @Id";
    //        dbConnection.Open();
    //        return dbConnection.Query<Product>(sQuery, new { Id = id }).FirstOrDefault();
    //    }
    //}

    //public void Delete(int id)
    //{
    //    using (IDbConnection dbConnection = Connection)
    //    {
    //        string sQuery = "DELETE FROM Products"
    //                     + " WHERE ProductId = @Id";
    //        dbConnection.Open();
    //        dbConnection.Execute(sQuery, new { Id = id });
    //    }
    //}

    //public void Update(Product prod)
    //{
    //    using (IDbConnection dbConnection = Connection)
    //    {
    //        string sQuery = "UPDATE Products SET Name = @Name,"
    //                       + " Quantity = @Quantity, Price= @Price"
    //                       + " WHERE ProductId = @ProductId";
    //        dbConnection.Open();
    //        dbConnection.Query(sQuery, prod);
    //    }
    //}
}