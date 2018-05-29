using Dapper;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for PresupuestosCapitulos
/// </summary>
[Table("Presupuestos_Capitulos", Schema = "dbo")]
public class PresupuestosCapitulos
{
    [Column("Serie Presupuesto")]
    public string SeriePresupuesto { get; set; }

    [Key]
    [Column("Auto Pre Capitulo")]
    public int AutoPreCapitulo { get; set; }

    public int PedidoCli { get; set; }

    public string Descripción { get; set; }

    public int Capitulo { get; set; }

    public bool Seleccionar { get; set; }

    public PresupuestosCapitulos()
    {
    }
}