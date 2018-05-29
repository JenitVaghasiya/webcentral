using System.ComponentModel.DataAnnotations;

/// <summary>
/// Summary description for PreciosGroup
/// </summary>
public class PreciosGroup
{
    [Key]
    public int Grupo { get; set; }

    public string Categoría { get; set; }

    public int? AutoEditor { get; set; }

    public PreciosGroup()
    {
    }
}