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
/// Summary description for FacturasRepository
/// </summary>
public class FacturasRepository
{
    public static IEnumerable<FacturasDAL> GetAllFacturas(string searchFactura, int autoCliente, DateTime? defecha = null, DateTime? afecha = null)
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
                string fr = string.Empty;

                fra = "SELECT [Fact Serie Factura] AS SerieFactura, [Fecha Factura] AS Fecha, Neto, [Descuento pp] As Descuento, impuestos, [total factura] AS TotalFactura FROM facturas  where ( FACTURAS.[Auto Cliente] ='" + autoCliente + "')";

                if (!string.IsNullOrEmpty(searchFactura))
                {
                    ast = " and ";
                    fr = fr + atw + ast + " FACTURAS.[Fact Serie Factura] ='" + searchFactura + "' ";

                    //atw = "": fin = " )"
                }
                if (defecha != null && defecha.Value.Date > new DateTime(0001, 01, 01))
                {
                    ast = " and ";
                    fr = fr + atw + ast + " FACTURAS.[Fecha Factura] >='" + defecha + "'";

                    //   atw = "": fin = " )"

                    // Me.MaxRecords = 10000
                }

                if (afecha != null && afecha.Value.Date > new DateTime(0001, 01, 01))
                {
                    ast = " and ";
                    fr = fr + atw + ast + " FACTURAS.[Fecha Factura] <='" + afecha + "'";

                    // ast = " and ";
                    //    atw = "": fin = " )"
                    // Me.MaxRecords = 10000
                }

                var fss = fra + fr + fin + " Order by FACTURAS.[Fecha Factura] Desc, FACTURAS.[Fact Factura] Desc";

                return dbConnection.Query<FacturasDAL>(fss);
            }
            catch (Exception ex)
            {
                return new List<FacturasDAL>();
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public static IEnumerable<FacturasAlbaran> GetFacturasDetail(string searchFactura)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var query = @"SELECT ALB.*, ALB.[Serie Albaran] AS SerieAlbaran, ELEMENTOS.Descripción AS Obra, FACTURAS.[Fact Factura], FACTURAS.[Fact Serie Factura], FACTURAS.[Fecha Factura] AS Fecha,
                          FACTURAS.[total factura], CLIENTES.[Razón Social],  CLIENTES.Dirección, CLIENTES.Código, CLIENTES.Nif, CLIENTES.Telefono, CLIENTES.Fax, CLIENTES.email, FACTURAS.[Número de Facturación], FACTURAS.[Abona Factura], 
                          FACTURAS.[Es Contado] AS Expr1, ARTICULOS.Desg AS Vendedor FROM ALB 
                          LEFT OUTER JOIN ARTICULOS ON ALB.Vendedor = ARTICULOS.[Auto Artículo] 
                          LEFT OUTER JOIN ELEMENTOS ON ALB.[Buque o Obra] = ELEMENTOS.Element 
                          LEFT OUTER JOIN CLIENTES ON ALB.[Auto Cliente] = CLIENTES.[Auto Cliente] 
                          LEFT OUTER JOIN FACTURAS ON ALB.[Serie Factura] = FACTURAS.[Fact Serie Factura] WHERE [Fact Serie Factura] ='" + searchFactura + "' ORDER BY  ALB.[Serie Albaran]";
                return dbConnection.Query<FacturasAlbaran>(query);
            }
            catch (Exception ex)
            {
                return new List<FacturasAlbaran>();
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public FacturasRepository()
    {
    }
}