using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Articulos
/// </summary>
public class Articulos
{
    public int AutoArtículo { get; set; }

    public string Artículo { get; set; }

    public string Desg { get; set; }

    public string Fecha { get; set; }

    public int AutoFamilia { get; set; }

    public int OrdenCatalogo { get; set; }

    public int Impuesto { get; set; }

    public int ClasedeArtículo { get; set; }

    public int Artículonum { get; set; }

    public double PercenImpuesto { get; set; }

    public int? editorAuto { get; set; }

    public string FamiliaDesc { get; set; }

    public int? FamiliaFoto { get; set; }

    public Articulos()
    {
        //
        // TODO: Add constructor logic here
        //
    }
}

public class SelectedArticulos
{
    public int AutoArtículo { get; set; }

    public string Artículo { get; set; }

    public string Desg { get; set; }

    public string Fecha { get; set; }

    public int AutoFamilia { get; set; }

    public int OrdenCatalogo { get; set; }

    public int Impuesto { get; set; }

    public int ClasedeArtículo { get; set; }

    public int Artículonum { get; set; }

    public double PercenImpuesto { get; set; }

    public int Cantidad { get; set; }

    public double Precio { get; set; }

    public double Dto { get; set; }

    public double Neto { get; set; }

    public double PrecioIgic { get; set; }

    public double NetoIgic { get; set; }

    public double DoublicateImporte { get; set; }

    public double DoublicateImporteIgic { get; set; }

    public int? EditorAuto { get; set; }

    public SelectedArticulos()
    {
        Cantidad = 1;
        //
        // TODO: Add constructor logic here
        //
    }
}

[Table("ArticulosHTML", Schema = "dbo")]
public class ArticulosHTML
{
    [Key]
    public int Auto { get; set; }

    public string Concepto { get; set; }

    public string Html { get; set; }

    [Column("Auto familia")]
    public int? Autofamilia { get; set; }

    public string Descripción { get; set; }

    public ArticulosHTML()
    {

    }
}