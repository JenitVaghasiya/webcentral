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
/// Summary description for PresupuestosRepository
/// </summary>
public class PresupuestosRepository
{
    public static bool Insert_Presupuestos(Presupuestos presupuestos, PresupuestosCapitulos presupuestosCapitulos, List<PresupuestosSubcapitulos> lstPresupuestosSubcapitulos)
    {
        using (var dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                using (var tran = dbConnection.BeginTransaction())
                {
                    try
                    {
                        DapperExtensions.DapperExtensions.SetMappingAssemblies(new[] { typeof(PresupuestosClassMapper).Assembly });
                        DapperExtensions.DapperExtensions.SetMappingAssemblies(new[] { typeof(PresupuestosCapitulosClassMapper).Assembly });
                        DapperExtensions.DapperExtensions.SetMappingAssemblies(new[] { typeof(PresupuestosSubcapitulosClassMapper).Assembly });

                        dbConnection.Insert(presupuestos, tran);
                        dbConnection.Insert(presupuestosCapitulos, tran);
                        foreach (var ps in lstPresupuestosSubcapitulos)
                        {
                            dbConnection.Insert(ps, tran);
                        }
                        tran.Commit();
                        return true;
                    }
                    catch (System.Exception ex)
                    {
                        tran.Rollback();
                        return false;
                    }
                }
            }
            catch (Exception ex)
            {
                return false;
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public static bool Update_Presupuestos(Presupuestos presupuestos, List<PresupuestosSubcapitulos> lstPresupuestosSubcapitulos)
    {
        using (var dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();


                // return affectedrows > 0;
                using (var tran = dbConnection.BeginTransaction())
                {
                    try
                    {
                        dbConnection.Execute("DELETE FROM PRESUPUESTOS_SUBCAPITULOS where [Serie Presupuesto] = @SeriePresupuesto", new { SeriePresupuesto = presupuestos.SeriePresupuesto }, tran);

                        DapperExtensions.DapperExtensions.SetMappingAssemblies(new[] { typeof(PresupuestosClassMapper).Assembly });
                        DapperExtensions.DapperExtensions.SetMappingAssemblies(new[] { typeof(PresupuestosSubcapitulosClassMapper).Assembly });

                        dbConnection.Update(presupuestos, tran);
                        foreach (var ps in lstPresupuestosSubcapitulos)
                        {
                            dbConnection.Insert(ps, tran);
                        }
                        tran.Commit();
                        return true;
                    }
                    catch (System.Exception ex)
                    {
                        tran.Rollback();
                        return false;
                    }
                }
            }
            catch (Exception ex)
            {
                return false;
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public static IEnumerable<Presupuestosver> GetAllPresupuestosver(string searchText, int autoCliente, DateTime? defecha = null, DateTime? afecha = null)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var query = @"SELECT PRESUPUESTOS.[Serie Presupuesto] AS SeriePresupuesto, PRESUPUESTOS.status, PRESUPUESTOS.Descripción, PRESUPUESTOS.Fecha, PRESUPUESTOS.[Albarán asignado] AS Albarán, 
                            ELEMENTOS.Descripción AS Desobra, STATUS.Descripción AS Desstatus FROM PRESUPUESTOS 
                            LEFT OUTER JOIN ELEMENTOS ON PRESUPUESTOS.[Buque o Obra] = ELEMENTOS.Element 
                            LEFT OUTER JOIN STATUS ON PRESUPUESTOS.status = STATUS.Status where Vendedor = '99' AND PRESUPUESTOS.[Auto Cliente] =" + autoCliente + "";

                if (!string.IsNullOrEmpty(searchText))
                {
                    query += " AND PRESUPUESTOS.[Serie Presupuesto] = '" + searchText + "'";
                }

                if (defecha != null && defecha.Value.Date > new DateTime(0001, 01, 01))
                {
                    query += " AND PRESUPUESTOS.Fecha >= '" + defecha + "'";
                }

                if (afecha != null && afecha.Value.Date > new DateTime(0001, 01, 01))
                {
                    query += " and PRESUPUESTOS.Fecha <='" + afecha + "'";
                }
                query += " Order by PRESUPUESTOS.[Fecha] Desc, PRESUPUESTOS.[Presupuesto] Desc";

                return dbConnection.Query<Presupuestosver>(query);
            }
            catch (Exception ex)
            {
                return new List<Presupuestosver>();
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public static IEnumerable<PresupuestosSubcapitulos> GetAllPresupuestosverDetail(string SeriePresupuesto)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var query = @"SELECT PS.Artículo, PS.Descripción, PS.[Cantidad und pedido] AS Cantidad, PS.[Precio Servicios] AS PrecioServicios, PS.Dto, PS.Importe, PS.Auto, 
                              PS.PedidoCli, PS.[Serie Presupuesto], A.[Articulo que tiene las fotos]  AS editorFoto 
                                FROM PRESUPUESTOS_SUBCAPITULOS  PS
                                JOIN ARTICULOS A ON A.[Auto Artículo] = PS.[Auto Artículo]
                          WHERE ([Serie Presupuesto] = '" + SeriePresupuesto + "') and PedidoCli='0' ORDER BY Auto";

                return dbConnection.Query<PresupuestosSubcapitulos>(query);
            }
            catch (Exception ex)
            {
                return new List<PresupuestosSubcapitulos>();
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public static Presupuestos GetpresupuestosDetail(string SeriePresupuesto)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var query = @"select * from Presupuestos WHERE [Serie Presupuesto] = '" + SeriePresupuesto + "'";

                return dbConnection.Query<Presupuestos>(query).FirstOrDefault();
            }
            catch (Exception ex)
            {
                return new Presupuestos();
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public static PresupuestosSubcapitulos GetPresupuestosSubcapitulosDetail(string SeriePresupuesto, int AutoArtículo)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var query = @"select *,[Serie Presupuesto] AS SeriePresupuesto,[Auto Pre Capitulo] AS AutoPreCapitulo,[Cantidad und pedido] As Cantidadundpedido, [Auto Artículo] As AutoArtículo, [pvp precio] As pvpprecio, [Precio Servicios] AS PrecioServicios, [precio und pedido] AS precioundpedido, [Tipo artículo] AS Tipoartículo from Presupuestos_Subcapitulos WHERE [Serie Presupuesto] = '" + SeriePresupuesto + "' AND [Auto Artículo] = " + AutoArtículo;
                return dbConnection.Query<PresupuestosSubcapitulos>(query).FirstOrDefault();
            }
            catch (Exception ex)
            {
                return new PresupuestosSubcapitulos();
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public static IEnumerable<PresupuestosSubcapitulos> GetPresupuestosSubcapitulosDetail(string SeriePresupuesto)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var query = @"select *,[Serie Presupuesto] AS SeriePresupuesto,[Auto Pre Capitulo] AS AutoPreCapitulo,[Cantidad und pedido] As Cantidadundpedido, [Auto Artículo] As AutoArtículo, [pvp precio] As pvpprecio, [Precio Servicios] AS PrecioServicios, [precio und pedido] AS precioundpedido, [Tipo artículo] AS Tipoartículo from Presupuestos_Subcapitulos WHERE [Serie Presupuesto] = '" + SeriePresupuesto + "'";

                return dbConnection.Query<PresupuestosSubcapitulos>(query).ToList();
            }
            catch (Exception ex)
            {
                return new List<PresupuestosSubcapitulos>();
            }
            finally
            { dbConnection.Close(); }
        }
    }
}