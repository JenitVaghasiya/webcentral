using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using Dapper;
/// <summary>
/// Summary description for FamiliasRepository
/// </summary>
public class FamiliasRepository
{
    public static IEnumerable<Familias> GetFamiliaByGroup(int Id = 0)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                string query = "SELECT [Auto familia] As Autofamilia, Familia, Descripción, [Oden Catalogo] AS OdenCatalogo, Grupo, [Articulo que tiene las fotos] AS AutoEditor FROM FAMILIAS WHERE Descripción <>''";
                if (Id > 0)
                {
                    query += " and [Grupo] = " + Id + "";
                }

                query += "ORDER BY Descripción";
                return dbConnection.Query<Familias>(query);
            }
            catch (Exception ex)
            {
                return new List<Familias>();
            }
            finally
            { dbConnection.Close(); }
        }
    }
}