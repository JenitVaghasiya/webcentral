using DapperExtensions.Mapper;

public class PresupuestosClassMapper : ClassMapper<Presupuestos>
{
    public PresupuestosClassMapper()
    {
        Map(x => x.SeriePresupuesto).Column("Serie Presupuesto").Key(KeyType.Assigned);

        Map(x => x.AutoCliente).Column("Auto Cliente");

        Map(x => x.BuqueoObra).Column("Buque o Obra");

        //optional, map all other columns
        AutoMap();
    }
}

public class PresupuestosCapitulosClassMapper : ClassMapper<PresupuestosCapitulos>
{
    public PresupuestosCapitulosClassMapper()
    {
        Table("Presupuestos_Capitulos");

        Map(x => x.SeriePresupuesto).Column("Serie Presupuesto").Key(KeyType.Assigned);

        Map(x => x.AutoPreCapitulo).Column("Auto Pre Capitulo");

        //optional, map all other columns
        AutoMap();
    }
}

public class PresupuestosSubcapitulosClassMapper : ClassMapper<PresupuestosSubcapitulos>
{
    public PresupuestosSubcapitulosClassMapper()
    {
        Table("Presupuestos_Subcapitulos");

        Map(x => x.SeriePresupuesto).Column("Serie Presupuesto").Key(KeyType.Assigned);

        Map(x => x.AutoPreCapitulo).Column("Auto Pre Capitulo");

        Map(x => x.Cantidadundpedido).Column("Cantidad und pedido");

        Map(x => x.AutoArtículo).Column("Auto Artículo");

        Map(x => x.pvpprecio).Column("pvp precio");

        Map(x => x.PrecioServicios).Column("Precio Servicios");

        Map(x => x.precioundpedido).Column("precio und pedido");

        Map(x => x.Tipoartículo).Column("Tipo artículo");

        Map(x => x.Auto).Key(KeyType.Assigned);

        Map(x => x.editorFoto).Ignore();

        //optional, map all other columns
        AutoMap();
    }
}


public class ArticulosHTMLMapper : ClassMapper<ArticulosHTML>
{
    public ArticulosHTMLMapper()
    {
        Map(x => x.Auto).Key(KeyType.Assigned);
        Map(x => x.Autofamilia).Column("Auto familia");
        Map(x => x.Descripción).Ignore();
        //optional, map all other columns
        AutoMap();
    }
}