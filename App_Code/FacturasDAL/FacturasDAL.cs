using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for FacturasDAL
/// </summary>
public class FacturasDAL
{
    public string SerieFactura { get; set; }

    public DateTime Fecha { get; set; }

    public decimal Neto { get; set; }

    public decimal Descuento { get; set; }

    public decimal impuestos { get; set; }

    public decimal TotalFactura { get; set; }

    public FacturasDAL()
    {
    }
}

public class FacturasAlbaran
{
    public string SerieAlbaran { get; set; }

    public DateTime Fecha { get; set; }

    public string Obra { get; set; }

    public string Vendedor { get; set; }

    public FacturasAlbaran()
    {
    }
}