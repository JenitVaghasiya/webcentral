using System.Collections.Generic;
using System.Data;
using Dapper;
using Dapper.Contrib;
using System.Data.SqlClient;
using System.Data.Common;
using DapperExtensions;
using System.Linq;
using System.ComponentModel.DataAnnotations.Schema;
using System;

/// <summary>
/// Summary description for AlbaranRepository
/// </summary>
public class AlbaranRepository
{

    public static IEnumerable<Albaran> GetAllAlbaranosver(string searchText, string searchFactura, int autoCliente, DateTime? defecha = null, DateTime? afecha = null)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                string ast = string.Empty;
                string atw = string.Empty;
                string fin = string.Empty;
                string fra = string.Empty;
                string fr = string.Empty, rs = string.Empty;
                fr = @"SELECT ALB.[Serie Albaran] AS SerieAlbaran, ALB.[Serie Factura] AS SerieFactura, ALB.Fecha, ALB.[Auto Cliente] AS AutoCliente, ELEMENTOS.Descripción AS DesObra, ALB.Vendedor,
                    ARTICULOS.Desg AS NomVendedor FROM ALB
                        LEFT OUTER JOIN ARTICULOS ON ALB.Vendedor = ARTICULOS.[Auto Artículo] LEFT OUTER JOIN ELEMENTOS ON ALB.[Buque o Obra] = ELEMENTOS.Element
                        where ( ALB.[Auto Cliente] ='" + autoCliente + "')  ";

                if (!string.IsNullOrEmpty(searchText))
                {
                    ast = " and ";
                    fr = fr + atw + ast + " ALB.[Serie Albaran] ='" + searchText + "' ";

                    //atw = "": fin = " )";
                }

                if (defecha != null && defecha.Value.Date > new DateTime(0001, 01, 01))
                {
                    ast = " and ";
                    fr = fr + atw + ast + " ALB.Fecha >='" + defecha + "'";

                    //atw = "": fin = " )";
                }

                if (afecha != null && afecha.Value.Date > new DateTime(0001, 01, 01))
                {
                    ast = " and ";
                    fr = fr + atw + ast + " ALB.Fecha <='" + afecha + "'";

                    //atw = "": fin = " )";
                }

                if (!string.IsNullOrEmpty(searchFactura))
                {
                    ast = " and ";
                    fr = fr + atw + ast + " ALB.[Serie Factura] ='" + searchFactura + "' ";

                    //atw = "": fin = " )";

                    //Me.MaxRecords = 100000
                }
                var fss = rs + fra + fr + fin + " Order by ALB.[Fecha] Desc, ALB.[Albaran] Desc";
                return dbConnection.Query<Albaran>(fss);
            }
            catch (Exception ex)
            {
                return new List<Albaran>();
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public static IEnumerable<AlbaranD> GetAlbaranosverDetail(string SerieAlbaran)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var query = @"SELECT ALB_D.Auto, ALB_D.Artículo, ALB_D.Descripción, ALB_D.Cantidad, ALB_D.[Precio und Pedido] AS Precio, ALB_D.Dto, ALB_D.Importe, 
                                ALB_D.[Serie Albaran] AS SerieAlbaran , A.[Articulo que tiene las fotos]  AS editorFoto 
                              FROM ALB_D 
                              JOIN ARTICULOS A ON A.[Auto Artículo] = ALB_D.[Auto Artículo]
                              WHERE [Serie Albaran] ='" + SerieAlbaran + "' ORDER BY Auto";
                return dbConnection.Query<AlbaranD>(query);
            }
            catch (Exception ex)
            {
                return new List<AlbaranD>();
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public static int CheckAlbaranosverIdforImage(string SerieAlbaran,int cliente)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var query = @"SELECT COUNT(*) FROM ALB WHERE [Serie Albaran] ='" + SerieAlbaran + "' AND [Auto cliente] = "+ cliente;
                return dbConnection.QueryFirst<int>(query);
            }
            catch (Exception ex)
            {
                return 0;
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public AlbaranRepository()
    {
    }
}