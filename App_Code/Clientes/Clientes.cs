using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Clientes
/// </summary>
public class Clientes
{
    [Key]
    public int AutoCliente { get; set; }

    public string Código { get; set; }

    public double Dtopp { get; set; }

    public string RazónSocial { get; set; }

    public Clientes()
    {
    }
}