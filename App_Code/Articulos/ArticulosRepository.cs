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
/// Summary description for ArticulosRepository
/// </summary>
public class ArticulosRepository
{
    public static IEnumerable<Articulos> GetSelectedArticulos(int FamiliaId = 0, int AutoArtículo = 0)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var query = @"SELECT ISNULL(ARTICULOS.Fecha,'') as Fecha,ARTICULOS.[Auto Artículo] AS AutoArtículo, isnull(ARTICULOS.Desg,'') as Desg,
                            ARTICULOS.[Orden Catalogo] AS OrdenCatalogo, ARTICULOS.Artículo, isnull(ARTICULOS.[Auto Familia],'0') AS AutoFamilia,
                            isnull(ARTICULOS.[Clase de Artículo],'0') AS ClasedeArtículo, ARTICULOS.Impuesto, isnull(ARTICULOS.[Artículo num],'0') AS Artículonum,
                            IMPUESTOS.[% Impuesto] AS PercenImpuesto, ARTICULOS.[Articulo que tiene las fotos] AS editorAuto, 
                            FM.Descripción AS FamiliaDesc, 
                            (SELECT TFM.[Articulo que tiene las fotos] FROM FAMILIAS TFM
                             JOIN ARTICULOSHTML AH ON AH.Auto = FM.[Articulo que tiene las fotos]
                             WHERE TFM.[Auto familia] = FM.[Auto familia]) AS FamiliaFoto FROM ARTICULOS 
                            LEFT OUTER JOIN IMPUESTOS ON ARTICULOS.Impuesto = IMPUESTOS.Impuesto
                            LEFT OUTER JOIN FAMILIAS FM ON FM.[Auto familia] = ARTICULOS.[Auto Familia]
                            WHERE ARTICULOS.[Tipo Artículo] = '2' AND Estado <> 'Pasivo' and  (NOT (Desg IS NULL)) AND (Desg NOT LIKE '--%')";

                if (FamiliaId > 0)
                {
                    query += " AND ARTICULOS.[Auto Familia] = " + FamiliaId + "";
                }
                if (AutoArtículo > 0)
                {
                    query += " AND [Auto Artículo] = " + AutoArtículo + "";
                }
                query += " ORDER BY ARTICULOS.[Orden Catalogo]";
                return dbConnection.Query<Articulos>(query);
            }
            catch (Exception ex)
            {
                return new List<Articulos>();
            }
            finally
            {
                dbConnection.Close();
            }
        }
    }

    public static IEnumerable<SelectedArticulos> GetAllArticuloDetail(string SeriePresupuesto)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();

                var query = @"SELECT art.[Auto Artículo] AS AutoArtículo, art.Desg, prs.Cantidad, imp.[% Impuesto] AS PercenImpuesto,prs.[pvp precio] AS Precio, prs.Dto, art.Artículo, 
                            art.Impuesto, art.[Articulo que tiene las fotos] AS EditorAuto FROM PRESUPUESTOS_SUBCAPITULOS prs
                            JOIN ARTICULOS AS art ON prs.[Auto Artículo] = art.[Auto Artículo]
                            LEFT OUTER JOIN IMPUESTOS AS imp ON art.Impuesto = imp.Impuesto
                            WHERE prs.[Serie Presupuesto] = '" + SeriePresupuesto + "' AND art.[Tipo Artículo] = '2' AND Estado <> 'Pasivo' ORDER BY art.Desg";

                return dbConnection.Query<SelectedArticulos>(query);

            }
            catch (Exception ex)
            {
                return new List<SelectedArticulos>();
            }
            finally
            { dbConnection.Close(); }
        }
    }

    public static IEnumerable<Articulos> GetfilteredArticulos(string desg)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var query =
                    @"SELECT isnull(ARTICULOS.Fecha,'') as Fecha,ARTICULOS.[Auto Artículo] AS AutoArtículo, isnull(ARTICULOS.Desg,'') as Desg,ARTICULOS.[Orden Catalogo] AS OrdenCatalogo, ARTICULOS.Artículo, isnull(ARTICULOS.[Auto Familia],'0') AS AutoFamilia,isnull(ARTICULOS.[Clase de Artículo],'0') AS ClasedeArtículo, 
                          ARTICULOS.Impuesto, isnull(ARTICULOS.[Artículo num],'0') AS Artículonum, IMPUESTOS.[% Impuesto] AS PercenImpuesto FROM ARTICULOS
                          LEFT OUTER JOIN IMPUESTOS ON ARTICULOS.Impuesto = IMPUESTOS.Impuesto
                           WHERE [Tipo Artículo] = '2' AND Estado <> 'Pasivo'";

                if (!string.IsNullOrEmpty(desg))
                {
                    for (var ii = 1; ii <= 5; ii++)
                    {
                        var palabra = Field(desg, ii, " ");
                        if (!string.IsNullOrEmpty(palabra))
                        {
                            query += " and Desg like '%" + palabra + "%' ";
                        }
                    }
                }

                query += " ORDER BY ARTICULOS.[Orden Catalogo]";
                return dbConnection.Query<Articulos>(query);

            }
            catch (Exception ex)
            {
                return new List<Articulos>();
            }
            finally
            {
                dbConnection.Close();
            }
        }
    }

    public static string Field(string casi, int pos, string car)
    {
        int i;
        var field = "";
        var vez = 1;
        var ll = casi.Length;
        var llc = car.Length;
        var ipos = pos;
        for (i = 0; i < ll; i++)
        {
            var letra = Mid(casi, i, llc);
            if (letra == car)
            {
                vez = vez + 1;
                if (vez > pos)
                    break;
            }
            else
            {
                if (vez == ipos)
                {
                    field = field + Mid(casi, i, 1);
                }
            }
        }
        return field;
    }

    public static string Mid(string input, int index, int next)
    {
        if (input == null)
        {
            throw new ArgumentNullException("input");
        }

        return input.Substring(index, next);
    }

    public static IEnumerable<ArticulosHTML> GetArticulosHTML(int Auto = 0)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var query = "SELECT AH.*,AH.[Auto familia] AS Autofamilia,FM.Descripción FROM [DBO].[ARTICULOSHTML] AH " +
                    "        LEFT JOIN [dbo].[FAMILIAS] FM on FM.[Auto familia] = AH.[Auto familia]";
                if (Auto > 0)
                {
                    query += " WHERE Auto =" + Auto;
                }
                return dbConnection.Query<ArticulosHTML>(query);
            }
            catch (Exception ex)
            {
                return new List<ArticulosHTML>();
            }
            finally
            {
                dbConnection.Close();
            }
        }
    }

    public static bool InsertArticulosHTML(string concepto, int? familios, string strarticuloHtml)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                using (var tran = dbConnection.BeginTransaction())
                {
                    try
                    {
                        var parameters = new
                        {
                            Concepto = concepto,
                            Html = strarticuloHtml,
                            familio = familios
                        };
                        dbConnection.Execute("INSERT INTO [DBO].[ARTICULOSHTML] (Concepto,Html,[Auto familia]) VALUES(@Concepto,@Html,@familio)", parameters, tran);
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
            }
            finally
            {
                dbConnection.Close();
            }
            return false;
        }
    }

    public static bool UpdateArticulosHTML(int Auto, string concepto, int? familios, string strarticuloHtml)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                var articulosHTMLs = dbConnection.Query<ArticulosHTML>("SELECT * FROM [DBO].[ARTICULOSHTML] WHERE Auto = " + Auto);
                if (articulosHTMLs.Any())
                {
                    var articulosHTML = articulosHTMLs.FirstOrDefault();
                    articulosHTML.Html = strarticuloHtml;
                    articulosHTML.Concepto = concepto;
                    articulosHTML.Autofamilia = familios;
                    DapperExtensions.DapperExtensions.SetMappingAssemblies(new[] { typeof(ArticulosHTMLMapper).Assembly });
                    dbConnection.Update(articulosHTML);
                }
                return true;
            }
            catch (Exception ex)
            {
            }
            finally
            {
                dbConnection.Close();
            }
            return false;
        }
    }

    public static bool DeleteArticulosHTML(int Auto)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            try
            {
                dbConnection.Open();
                dbConnection.Execute("DELETE FROM [DBO].[ARTICULOSHTML] WHERE Auto = " + Auto);
                return true;
            }
            catch (Exception ex)
            {
            }
            finally
            {
                dbConnection.Close();
            }
            return false;
        }
    }
}