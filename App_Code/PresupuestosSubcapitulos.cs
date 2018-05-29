using Dapper;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for PresupuestosSubcapitulos
/// </summary>
[Table("Presupuestos_Subcapitulos", Schema = "dbo")]
public class PresupuestosSubcapitulos
{
    public int Auto { get; set; }

    [Column("Serie Presupuesto")]
    public string SeriePresupuesto { get; set; }

    [Column("Auto Pre Capitulo")]
    public int AutoPreCapitulo { get; set; }

    public int PedidoCli { get; set; }

    public string Artículo { get; set; }

    public string Descripción { get; set; }

    public int Unidad { get; set; }

    public decimal Cantidad { get; set; }

    [Column("Cantidad und pedido")]
    public decimal Cantidadundpedido { get; set; }

    public int factor { get; set; }

    [Column("Auto Artículo")]
    public int AutoArtículo { get; set; }

    [Column("pvp precio")]
    public decimal pvpprecio { get; set; }

    [Column("Precio Servicios")]
    public decimal PrecioServicios { get; set; }

    [Column("precio und pedido")]
    public decimal precioundpedido { get; set; }

    public decimal Dto { get; set; }

    public decimal Importe { get; set; }

    public decimal Impuesto { get; set; }

    [Column("Tipo artículo")]
    public int Tipoartículo { get; set; }

    public DateTime Fecha { get; set; }

    public int? editorFoto { get; set; }

    public PresupuestosSubcapitulos()
    {
    }
}