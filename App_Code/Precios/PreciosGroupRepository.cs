using System;
using System.Collections.Generic;
using System.Data;
using Dapper;

/// <summary>
/// Summary description for PreciosGroupRepository
/// </summary>
public class PreciosGroupRepository
{
    public IEnumerable<PreciosGroup> GetAllPreciosGroup()
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
            dbConnection.Open();
            return dbConnection.Query<PreciosGroup>("SELECT Grupo, Concepto as Categoría, [Articulo que tiene las fotos] AS AutoEditor FROM GRUPOS ORDER BY Concepto");
            }
            catch (Exception ex)
            {
                return new List<PreciosGroup>();
            }
            finally
            { dbConnection.Close(); }
        }
    }
}