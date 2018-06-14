using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using Dapper;
/// <summary>
/// Summary description for CommonFunction
/// </summary>
public static class CommonFunction
{
    public static double Nzn(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            return 0;
        }
        else
            return Convert.ToDouble(value, new NumberFormatInfo() { NumberDecimalSeparator = "." });
    }

    public static string tlookup(string pstrField, string pstrTable, string pstrCriteria)
    {
        string fr;
        fr = "SELECT [" + pstrField + "] from " + pstrTable + " Where " + pstrCriteria;
        return Gettlookup(fr).FirstOrDefault();
    }

    public static IEnumerable<string> Gettlookup(string query)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            dbConnection.Open();
            return dbConnection.Query<string>(query);
        }
    }

    public static IEnumerable<T> GetList<T>(string query)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            dbConnection.Open();
            return dbConnection.Query<T>(query);
        }
    }

    public static double Redondear(double dblnToR, int intCntDec)
    {
        return Math.Round(dblnToR, intCntDec);
    }

    public static int numeradorgeneral(string De, out int esaño, out string esserie, int esdelegacion)
    {
        var numeradorgeneral = tlookup("" + De + "", "DELEGACIONES", "Delegación = '" + delegaciongeneral() + "'");
        esaño = Convert.ToInt32(Gettlookup("SELECT Año from tipos where (Tipo = '" + numeradorgeneral + "') ").FirstOrDefault());
        esserie = Gettlookup("SELECT Serie from tipos where (Tipo = '" + numeradorgeneral + "') ").FirstOrDefault();

        return Convert.ToInt32(numeradorgeneral);
    }

    public static int delegaciongeneral()
    {
        double ven = 0.00;
        var Cliente = (Clientes)HttpContext.Current.Session["User"];

        var delegaciongeneral = tlookup("Delegación", "USUARIOS", "Usuario = '" + Cliente.AutoCliente + "'");
        ven = Math.Round(Convert.ToDouble(tlookup("vendedor", "DELEGACIONES", "Delegación = '" + delegaciongeneral + "'")), 0);
        if (ven > 0)
        {
            delegaciongeneral = tlookup("Delegación", "USUARIOS", "Usuario = '" + Cliente.AutoCliente + "'");
        }

        if (string.IsNullOrEmpty(delegaciongeneral)) { delegaciongeneral = "1"; };
        return Convert.ToInt32(delegaciongeneral);
    }

    public static double tMax(string pstrField, string pstrTable, string pstrCriteria)
    {
        string fr = string.Empty;
        double tMax = 0;
        //Dim salba As New ADODB.Recordset
        if (string.IsNullOrEmpty(pstrCriteria))
        {
            fr = "SELECT TOP 1 [" + pstrField + "] from " + pstrTable + " order by [" + pstrField + "] DESC";
        }
        else
        {
            fr = "SELECT TOP 1 [" + pstrField + "] from " + pstrTable + " Where " + pstrCriteria + " order by [" + pstrField + "] DESC";
        }

        var obtMax = Gettlookup(fr).FirstOrDefault();
        if (string.IsNullOrEmpty(obtMax))
        {
            tMax = 0;
        }
        else
        {
            tMax = Math.Round(Convert.ToDouble(obtMax), 0);
        };

        return tMax;
    }

    public static DateTime fechaserver()
    {
        string fr = string.Empty;
        fr = "select getdate()";
        DateTime date = DateTime.ParseExact(Gettlookup(fr).FirstOrDefault().Substring(0, 10), "MM/dd/yyyy", null);
        return date;
    }

    public static string Field(string casi, int pos, string CAR)
    {
        int i, vez, ll, llc, ipos;
        string letra = string.Empty;
        var sfield = "";
        vez = 1;
        ll = casi.Length;
        llc = CAR.Length;
        ipos = pos;
        for (i = 0; i < ll; i++)
        {
            letra = casi.Substring(i, llc);
            if (letra == CAR)
            {
                vez = vez + 1;
                if (vez > pos)
                    break;
            }
            else
            {
                if (vez == ipos)
                {
                    sfield = sfield + casi.Substring(i, 1);
                }
            }
        }
        return sfield;
    }

    public static object Calculoalbaran(string albaran, int tipo)
    {
        double importb, importn;
        string fr;
        double Neto = 0;
        double Bruto = 0;
        double clienes;

        int i = 0, j = 0;
        double[,] loigic = new double[5, 6];

        double descpp;
        int Redondeo;
        int Decimales;
        int IGIC;
        Decimales = 2;
        double dto;
        int Raee;
        double imprae;
        int posi = 0;
        double[,] matraee = new double[100, 100];
        double importerae, totalrae = 0;
        double descuentopp = 0;
        object calculoalbaran = 0;
        if (albaran == "" || string.IsNullOrEmpty(albaran))
            return 0;

        fr = "select [dto pp] AS dtopp, [Auto Cliente] AS AutoCliente , [Exento impuestos] AS Exentoimpuestos from ALB where ([Serie Albaran]= '" + albaran + "') ";
        var salba = GetList<ALB>(fr).FirstOrDefault();
        descpp = 0;
        if (salba != null)
        {
            descpp = Convert.ToDouble(salba.dtopp);
        }
        var AutoCliente = salba.AutoCliente;
        if (Convert.ToBoolean(tlookup("dto pp en cliente", "GENERAL", "Auto = '1'")) == true)
        {
            if (tlookup("Dto pp", "CLIENTES", "[Auto Cliente] = '" + AutoCliente + "'") == "" || string.IsNullOrEmpty(tlookup("Dto pp", "CLIENTES", "[Auto Cliente] = '" + AutoCliente + "'")))
            {
                descpp = 0;
            }
            else
            {
                var tdescpp = tlookup("Dto pp", "CLIENTES", "[Auto Cliente] = '" + AutoCliente + "'");
                descpp = tdescpp == "" ? 0 : Convert.ToDouble(tdescpp);
            }
        }

        if (tipo != 1)
        {
            fr = "select Cantidad, Precio, Dto, Raee, Impuesto from ALB_D where ([Serie Albaran]= '" + albaran + "') ";
        }
        else
        {
            fr = "SELECT [Serie Albaran] AS SerieAlbaran, SUM(Importe) AS newimporte FROM dbo.ALB_D GROUP BY [Serie Albaran] HAVING ([Serie Albaran] = '" + albaran + "')";
            return GetList<AlbaranD>(fr).FirstOrDefault().newimporte;//  salbaran("newimporte");
        }

        var lstsalbaran = GetList<AlbaranD>(fr).ToList();
        foreach (var salbaran in lstsalbaran)
        {
            importb = 0; importn = 0;
            dto = salbaran.Dto == null ? 0 : Convert.ToDouble(salbaran.Dto);
            Raee = salbaran.Raee == null ? 0 : Convert.ToInt32(salbaran.Raee);
            imprae = Convert.ToDouble(tlookup("Importe", "TIPOS_RAEE", "[Raee] ='" + Raee + "'"));

            importb = Redondear(Convert.ToDouble(salbaran.Cantidad * salbaran.Precio - salbaran.Cantidad * salbaran.Precio * dto / 100), Decimales);
            importerae = 0;
            if (Raee > 0)
            {
                for (i = 1; i <= 12; i++)
                {
                    if (matraee[i, 1] == 0)
                    {
                        break;
                    }
                    if (matraee[i, 1] == Raee)
                    {
                        matraee[i, 2] = Convert.ToDouble(matraee[i, 2] + salbaran.Cantidad);
                        matraee[i, 3] = Convert.ToDouble(matraee[i, 3] + (salbaran.Cantidad * imprae));
                        goto Salirrae;
                    }
                }
                matraee[i, 1] = Raee;
                matraee[i, 2] = Convert.ToDouble(salbaran.Cantidad);
                matraee[i, 3] = Convert.ToDouble(matraee[i, 3] + (salbaran.Cantidad * imprae));
                matraee[i, 4] = imprae;

                Salirrae:
                importerae = Convert.ToDouble(salbaran.Cantidad * imprae);
                totalrae = totalrae + importerae;
            }

            importn = Redondear(importb - (importb * descpp / 100), Decimales);

            Bruto = Bruto + importb;
            Neto = Neto + importn;


            IGIC = salbaran.Impuesto;

            if (salba.Exentoimpuestos == true) { IGIC = 0; }
            if (Convert.ToBoolean(tlookup("Minorista", "GENERAL", "Auto = '1'")) == true) { IGIC = 0; }
            fr = "Select * from impuestos where ([% Impuesto] ='" + IGIC + "')";
            var simpuestos = GetList<Impuestos>(fr).FirstOrDefault();
            if (simpuestos != null)
            {
                posi = simpuestos.Impuesto;
            }

            for (i = 1; i <= 3; i++)
            {
                if (loigic[i, 1] == 0)
                {
                    break;
                }
                if (loigic[i, 1] == IGIC)
                {
                    loigic[i, 1] = IGIC;
                    loigic[i, 2] = loigic[i, 2] + importn + importerae;
                    loigic[i, 3] = loigic[i, 3] + ((importn + importerae) * IGIC / 100);
                    goto Sigre;
                }
            }
            loigic[i, 1] = IGIC;
            loigic[i, 2] = loigic[i, 2] + importn + importerae;
            loigic[i, 3] = loigic[i, 3] + ((importn + importerae) * IGIC / 100);

            Sigre:
            descuentopp = Redondear((Bruto * descpp / 100), Decimales);
        }

        loigic[4, 1] = Bruto;
        loigic[4, 2] = descpp;
        loigic[4, 3] = descuentopp;
        loigic[4, 4] = loigic[1, 3] + loigic[2, 3] + loigic[3, 3];
        loigic[4, 5] = totalrae;

        if (tipo == 1) calculoalbaran = Bruto;
        if (tipo == 2) descpp = salba.dtopp;
        if (tipo == 3) calculoalbaran = descuentopp;
        if (tipo == 4) calculoalbaran = loigic[1, 3] + loigic[2, 3] + loigic[3, 3];
        if (tipo == 5) calculoalbaran = Convert.ToString(Bruto) + "&" + Convert.ToString(Redondear(Neto + (loigic[1, 3] + loigic[2, 3] + loigic[3, 3]), 2));
        if (tipo == 6) calculoalbaran = loigic;
        if (tipo == 7) calculoalbaran = matraee;
        if (tipo == 8) calculoalbaran = Bruto;
        return calculoalbaran;
    }

    public static decimal? getStock(string dearticulo, int dealmacen)
    {
        decimal? deinicio = 0;
        decimal? tostock = 0;
        decimal? Stock = 0;
        if (dearticulo == "" || string.IsNullOrEmpty(dearticulo)) return null;
        if (dealmacen == 0)
        {
            var frr = "select Element from elementos where ( elementos.[controlar stock] ='1' )";
            var list = GetList<int>(frr);
            foreach (var i in list)
            {
                dealmacen = i;
                deinicio = calcular(dearticulo, dealmacen);
                tostock = tostock + deinicio;
            }
            Stock = tostock;
        }
        else
        {
            deinicio = calcular(dearticulo, dealmacen);
            Stock = deinicio;
        }
        return Stock;
    }

    public class REGULARIZACIONES_DETs
    {
        public string SerieRegularizacion { get; set; }
        public int Auto { get; set; }
        public int AutoArtículo { get; set; }
        public decimal? Cantidad { get; set; }
        public decimal? Cantidadundpedido { get; set; }
        public decimal? factor { get; set; }
        public int? Unidad { get; set; }
        public decimal? Habían { get; set; }
        public string Partida { get; set; }
        public DateTime? Fecha { get; set; }
        public DateTime? Hora { get; set; }
        public string Artículo { get; set; }
        public Guid rowguid { get; set; }
        public int? DeAlmacen { get; set; }
    }

    public class ORDENES_DET
    {
        public string SerieOrden { get; set; }
        public int? AutoProveedor { get; set; }
        public DateTime? FechaDet { get; set; }
        public DateTime? Horagraba { get; set; }
        public int AutoArtículo { get; set; }
        public decimal? Cantidad { get; set; }
        public decimal? Factor { get; set; }
    }

    public static decimal? calcular(string dearticulo, int dealmacen)
    {
        decimal? decantidad;
        decimal? defactor;
        decimal? deinicio = 0;
        DateTime? adefecha;
        DateTime? adehora;

        var frr = @"SELECT rd.[Serie Regularizacion] SerieRegularizacion, rd.Auto, rd.[Auto Artículo] AutoArtículo, rd.Cantidad, rd.[Cantidad und pedido] Cantidadundpedido,
                    rd.factor, rd.Unidad, rd.Habían,  rd.Partida, rd.Fecha, rd.Hora, rd.Artículo, rd.rowguid, dbo.REGULARIZACIONES.[De Almacen] DeAlmacen
                    FROM dbo.REGULARIZACIONES_DET rd INNER JOIN dbo.REGULARIZACIONES ON rd.[Serie Regularizacion] = dbo.REGULARIZACIONES.[Serie Regularizacion]";
        frr = frr + " WHERE ([Auto artículo] = '" + dearticulo + "' and [De Almacen] = '" + dealmacen + "') order by fecha DESC, hora DESC";
        var list = GetList<REGULARIZACIONES_DETs>(frr);
        if (list.Count() > 0)
        {
            var sinventario = list.FirstOrDefault();
            deinicio = sinventario.Cantidad;
            adefecha = sinventario.Fecha;
            adehora = sinventario.Hora;
        }
        else
        {
            deinicio = 0;
            adefecha = Convert.ToDateTime("25/NOV/2000");
            adehora = Convert.ToDateTime("08:01:00");
        }

        frr = "SELECT ISNULL(SUM(REPOSICIONES_DET.Cantidad),0) as totrep FROM  dbo.REPOSICIONES_DET INNER JOIN dbo.REPOSICIONES ON dbo.REPOSICIONES_DET.[Serie Reposicion] = dbo.REPOSICIONES.[Serie Reposicion]";
        frr = frr + " WHERE REPOSICIONES_DET.[Auto artículo] ='" + dearticulo + "' AND REPOSICIONES.[De Almacen] = '" + dealmacen + "'";
        frr = frr + " AND ((REPOSICIONES_DET.[Fecha Salida] ='" + adefecha + "' AND REPOSICIONES_DET.[hora salida] >'" + adehora + "') OR (REPOSICIONES_DET.[Fecha Salida] >'" + adefecha + "'))";
        var total = GetList<decimal>(frr);
        deinicio = deinicio - total.Sum(x => x);


        frr = "SELECT  ISNULL(SUM(REPOSICIONES_DET.Cantidad),0) as totrep FROM  dbo.REPOSICIONES_DET INNER JOIN dbo.REPOSICIONES ON dbo.REPOSICIONES_DET.[Serie Reposicion] = dbo.REPOSICIONES.[Serie Reposicion]";
        frr = frr + " WHERE REPOSICIONES_DET.[Auto artículo] ='" + dearticulo + "' AND REPOSICIONES.[A Almacen] = '" + dealmacen + "'";
        frr = frr + " AND ((REPOSICIONES_DET.[fecha entrada] ='" + adefecha + "' AND REPOSICIONES_DET.[hora entrada] >'" + adehora + "') OR (REPOSICIONES_DET.[fecha entrada] >'" + adefecha + "'))";
        total = GetList<decimal>(frr);
        deinicio = deinicio + total.Sum(x => x);


        frr = "SELECT  ISNULL(SUM(cantidad),0) as totrep FROM HERRAMIENTAS";
        frr = frr + " WHERE [Auto artículo] ='" + dearticulo + "'";
        frr = frr + " AND (([Fecha] ='" + adefecha + "' AND [hora] >'" + adehora + "') OR ([Fecha] >'" + adefecha + "'))";
        total = GetList<decimal>(frr);
        deinicio = deinicio - total.Sum(x => x);

        if (tlookup("esnaval", "GENERAL", "Auto = '1'") == "True")
        { goto pasonaval; }

        var err = 0;
        frr = "SELECT  ISNULL(Sum(ALB_D.Cantidad),0) as totrep FROM  dbo.ALB_D INNER JOIN dbo.ALB ON dbo.ALB_D.[Serie Albaran] = dbo.ALB.[Serie Albaran]";
        frr = frr + " WHERE (ALB.[Albaran de entrega] = 0 or ALB.[Albaran de entrega] IS NULL) and ALB_D.[Auto artículo] ='" + dearticulo + "' and ALB_D.[Almacen] ='" + dealmacen + "'";
        frr = frr + " AND ((ALB.[Fecha] ='" + adefecha + "' AND ALB_D.[hora creación] >'" + adehora + "') OR (ALB.[Fecha] >'" + adefecha + "'))";
        total = GetList<decimal>(frr);
        deinicio = deinicio - total.Sum(x => x);


        pasonaval:
        int fact;
        err = 0;
        frr = @"SELECT ORDENES_DET.[Serie Orden] SerieOrden, ORDENES_DET.[Auto Proveedor] AutoProveedor, ORDENES_DET.[Fecha Det] FechaDet, ORDENES_DET.[Hora graba] Horagraba,
                ORDENES_DET.[Auto Artículo] AutoArtículo, ORDENES_DET.Cantidad, ORDENES_DET.Factor
                FROM ORDENES_DET INNER JOIN ORDENES ON ORDENES_DET.[Serie Orden] = ORDENES.[Serie Orden] 
                WHERE ([Auto artículo] = '" + dearticulo + "' and Ordenes_det.[Fecha det]>= '" + adefecha + "' and [Almacen] = '" + dealmacen + "')";

        var orderlist = GetList<ORDENES_DET>(frr);
        foreach (var sor in orderlist)
        {
            if (adefecha == sor.FechaDet)
            {
                if (sor.Horagraba < adehora) continue; ;
            }

            if (sor.SerieOrden.IndexOf(" - ") > 0)
            {
                fact = -1;
            }
            else
            {
                fact = 1;
            }
            if (fact == -1)
            {
                if (string.IsNullOrEmpty(Convert.ToString(sor.AutoProveedor))) continue;
            }
            decantidad = sor.Cantidad * fact;
            defactor = sor.Factor;
            deinicio = deinicio - (decantidad);

            frr = "SELECT Sum(PEDIDOS_DET.Cantidad) as totrep FROM PEDIDOS_DET";
            frr = frr + " Where [Auto artículo] ='" + dearticulo + "' and [Almacen] ='" + dealmacen + "'";
            frr = frr + " AND (([Fecha entrada] ='" + adefecha + "' AND ([hora] >'" + adehora + "' or [hora] is null)) OR ([Fecha entrada] >'" + adefecha + "'))";
            total = GetList<decimal>(frr);
            deinicio = deinicio + total.Sum(x => x);
        }
        return deinicio;
    }

}
