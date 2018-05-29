using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Albaran
/// </summary>
public class Albaran
{
    public string SerieAlbaran { get; set; }

    public string SerieFactura { get; set; }

    public DateTime Fecha { get; set; }

    public int AutoCliente { get; set; }

    public string DesObra { get; set; }

    public int Vendedor { get; set; }

    public string NomVendedor { get; set; }

    public double dtopp { get; set; }

    public Albaran()
    {
    }
}

public class AlbaranD
{
    public int Auto { get; set; }
    public string Artículo { get; set; }
    public string SerieAlbaran { get; set; }
    public string Descripción { get; set; }
    public int? Cantidad { get; set; }
    public double? Precio { get; set; }
    public double? Dto { get; set; }
    public int? Raee { get; set; }
    public int Impuesto { get; set; }
    public double newimporte { get; set; }
    public double Importe { get; set; }
    public int? editorFoto { get; set; }
}

public class ALB
{
    public double dtopp { get; set; }
    public int AutoCliente { get; set; }
    public bool Exentoimpuestos { get; set; }
}

public class Impuestos
{
    public int Impuesto { get; set; }
}