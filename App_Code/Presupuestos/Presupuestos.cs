using Dapper;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Presupuestos
/// </summary>

[Table("Presupuestos", Schema = "dbo")]
public class Presupuestos
{
    [Column("Serie Presupuesto")]
    public string SeriePresupuesto { get; set; }

    [Key]
    public int Presupuesto { get; set; }

    public int PedidoCli { get; set; }

    public int status { get; set; }

    public int DelegacionOrden { get; set; }

    public int Tipo { get; set; }

    public int Año { get; set; }

    public int Delegación { get; set; }

    [Column("Auto Cliente")]
    public int AutoCliente { get; set; }

    [Column("Buque o Obra")]
    public string BuqueoObra { get; set; }

    public string Serie { get; set; }

    public DateTime? Fecha { get; set; }

    public string Usuario { get; set; }

    public int Vendedor { get; set; }

    public string Descripción { get; set; }

    public Presupuestos()
    {
    }
}


public class Presupuestosver
{
    [Column("Serie Presupuesto")]
    public string SeriePresupuesto { get; set; }

    [Key]
    public int Presupuesto { get; set; }

    public int PedidoCli { get; set; }

    public int status { get; set; }

    public int DelegacionOrden { get; set; }

    public int Tipo { get; set; }

    public int Año { get; set; }

    public int Delegación { get; set; }

    [Column("Auto Cliente")]
    public int AutoCliente { get; set; }

    [Column("Buque o Obra")]
    public string BuqueoObra { get; set; }

    public string Serie { get; set; }

    public DateTime? Fecha { get; set; }

    public string Usuario { get; set; }

    public int Vendedor { get; set; }

    public string Descripción { get; set; }

    public string Desobra { get; set; }

    public string Desstatus { get; set; }

    public string Albarán { get; set; }

    public Presupuestosver()
    {
    }
}