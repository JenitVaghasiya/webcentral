using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class mobile_Precios : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["User"] != null)
        {
            TopMenu.Visible = false; //Login
            LogingMenu.Visible = true; //Logout
        }
        else
        {
            TopMenu.Visible = true; //Login
            LogingMenu.Visible = false; //Logout
            if (!HttpContext.Current.Request.Url.AbsoluteUri.Contains("login"))
            {
                if (Page.IsCallback)
                {
                    ASPxWebControl.RedirectOnCallback("/Account/login.aspx");
                }
                else
                {
                    Response.Redirect("/Account/login.aspx");
                }

            }
        }
   //     if (!Request.Browser.IsMobileDevice)
      
  //      {
  //          if (Page.IsCallback)
  //          {
  //              ASPxWebControl.RedirectOnCallback("/precios.aspx");
  //          }
  //          else
  //          {
  //              Response.Redirect("/precios.aspx");
  //          }

//        }

        var preciosGroupRepository = new PreciosGroupRepository();
        int grupo = 0;
        int familiaId = 0;
        if (!Page.IsPostBack)
        {
            Session["SelectedArticle"] = null;
            if (!string.IsNullOrEmpty(Request.QueryString["sp"]))
            {
                var articulosList = ArticulosRepository.GetAllArticuloDetail(Request.QueryString["sp"]);
                foreach (var articulos in articulosList)
                {
                    articulos.Neto = CommonFunction.Redondear(articulos.Precio - (articulos.Precio * articulos.Dto / 100), 2);
                    articulos.PrecioIgic = CommonFunction.Redondear(articulos.Precio + (articulos.Precio * articulos.PercenImpuesto / 100), 2);
                    articulos.NetoIgic = CommonFunction.Redondear(articulos.Neto + (articulos.Neto * articulos.PercenImpuesto / 100), 2);
                }

                Session["SelectedArticle"] = articulosList;
                GridViewPresupuestoActual.DataSource = articulosList;
                GridViewPresupuestoActual.DataBind();
            }
        }

        GridViewGroup.DataSource = preciosGroupRepository.GetAllPreciosGroup();
        GridViewGroup.DataBind();

        if (GridViewGroup.GetSelectedFieldValues("Grupo").Count > 0)
        {
            grupo = (int)GridViewGroup.GetSelectedFieldValues("Grupo").Select(c => c).FirstOrDefault();
        }

        GridViewGroupFamily.DataSource = FamiliasRepository.GetFamiliaByGroup(grupo);
        GridViewGroupFamily.DataBind();

        if (GridViewGroupFamily.GetSelectedFieldValues("Autofamilia").Count > 0)
        {
            familiaId = (int)GridViewGroupFamily.GetSelectedFieldValues("Autofamilia").Select(c => c).FirstOrDefault();
            GridViewArtículo.DataSource = ArticulosRepository.GetSelectedArticulos(familiaId);
        }
        else
        {
            GridViewArtículo.DataSource = ArticulosRepository.GetSelectedArticulos();
        }
        GridViewArtículo.DataBind();
    }

    protected void GridViewGroup_SelectionChanged(object sender, EventArgs e)
    {
        int grupo = 0;
        if (GridViewGroup.GetSelectedFieldValues("Grupo").Count > 0)
        {
            grupo = (int)GridViewGroup.GetSelectedFieldValues("Grupo").Select(c => c).FirstOrDefault();
        }

        GridViewGroupFamily.DataSource = FamiliasRepository.GetFamiliaByGroup(grupo);
        GridViewGroupFamily.DataBind();
    }

    protected void GridViewGroupFamily_SelectionChanged(object sender, EventArgs e)
    {
        int familiaId = 0;
        if (GridViewGroupFamily.GetSelectedFieldValues("Autofamilia").Count > 0)
        {
            familiaId = (int)GridViewGroupFamily.GetSelectedFieldValues("Autofamilia").Select(c => c).FirstOrDefault();
            GridViewArtículo.DataSource = ArticulosRepository.GetSelectedArticulos(familiaId);
            GridViewArtículo.DataBind();
        }
    }

    protected void GridViewArtículo_CustomUnboundColumnData(object sender, DevExpress.Web.ASPxGridViewColumnDataEventArgs e)
    {

        var Cliente = (Clientes)Session["User"];
        if (Cliente == null)
        {
            ASPxWebControl.RedirectOnCallback("/Account/login.aspx");
        }

        string CodigoCliente = Cliente.Código;
        int AutoCliente = Cliente.AutoCliente;
        int AutoArticulo = Convert.ToInt32(e.GetListSourceFieldValue("AutoArtículo"));


        // For Precio //

        string stTarifa = CommonFunction.tlookup("Tarifa", "CLIENTES", "Código ='" + CodigoCliente + "'");
        int Tarifa = 0;
        if (!string.IsNullOrEmpty(stTarifa))
        {
            Tarifa = Convert.ToInt32(stTarifa);
        }
        var PrecioFijo = CommonFunction.Nzn(CommonFunction.tlookup("Precio Fijo", "TARIFAS_DET", "[Auto Artículo] =" + AutoArticulo + " and [Auto Cliente] =" + AutoCliente + ""));
        if (PrecioFijo == 0)
        {
            PrecioFijo = CommonFunction.Nzn(CommonFunction.tlookup("Precio Fijo", "TARIFAS_DET", "[Auto Artículo] =" + AutoArticulo + " and Tarifa =" + Tarifa + ""));
        }

        // For DTO //
        int Clase = Convert.ToInt32(e.GetListSourceFieldValue("ClasedeArtículo"));
        double dtomax;
        var dtofijo = CommonFunction.Nzn(CommonFunction.tlookup("% Dto Fijo", "TARIFAS_DET", "[Auto Cliente] =" + AutoCliente + " and [Clase Artículo] =" + Clase + ""));
        var calcdto = dtofijo;
        dtomax = CommonFunction.Nzn(CommonFunction.tlookup("% Dto Máximo", "TARIFAS_DET", "[Auto Cliente] =" + AutoCliente + " and [Auto Artículo] =" + AutoArticulo + ""));
        if (dtomax == -1) { calcdto = -1; } else { dtofijo = 0; }
        if (Convert.ToBoolean(CommonFunction.tlookup("Precio Neto", "ARTICULOS", "[Auto Artículo] ='" + AutoArticulo + "'")))
        {
            calcdto = -1;
        }
        else
        {
            dtofijo = 0;
        }

        var PrecioNeto = CommonFunction.Redondear(PrecioFijo - (PrecioFijo * calcdto / 100), 2);
        double Impuesto = Convert.ToDouble(GridViewArtículo.GetRowValues(e.ListSourceRowIndex, "PercenImpuesto"));

        if (e.Column.FieldName == "Precio")
        {
            e.Value = PrecioFijo;
        }
        else if (e.Column.FieldName == "Dto")
        {
            e.Value = calcdto;
        }
        else if (e.Column.FieldName == "Neto")
        {
            e.Value = PrecioNeto;
        }
        else if (e.Column.FieldName == "PrecioIgic")
        {
            var calcprecioigic = CommonFunction.Redondear(PrecioFijo + (PrecioFijo * Impuesto / 100), 2);
            e.Value = calcprecioigic;
        }
        else if (e.Column.FieldName == "NetoIgic")
        {
            var calcnetoigic = CommonFunction.Redondear(PrecioNeto + (PrecioNeto * Impuesto / 100), 2);
            e.Value = calcnetoigic;
        }
    }

    protected void linkselect_Init(object sender, EventArgs e)
    {

        GridViewDataItemTemplateContainer c = ((ASPxHyperLink)sender).NamingContainer as GridViewDataItemTemplateContainer;
        int rowIndex = c.VisibleIndex;
        ((ASPxHyperLink)sender).ClientSideEvents.Click = "function(s,e){ e.processOnServer = false;  SelectArticle('" + rowIndex + "');return false;}";
        
    }

    protected void GridViewPresupuestoActual_CustomUnboundColumnData(object sender, DevExpress.Web.ASPxGridViewColumnDataEventArgs e)
    {

        var Cliente = (Clientes)Session["User"];
        if (Cliente == null)
        {
            ASPxWebControl.RedirectOnCallback("/Account/login.aspx");
        }

        string CodigoCliente = Cliente.Código;
        int AutoCliente = Cliente.AutoCliente;
        int AutoArticulo = Convert.ToInt32(e.GetListSourceFieldValue("AutoArtículo"));

        double PrecioIgic = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "PrecioIgic") == null ? 0 : GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "PrecioIgic"));
        int Cantidad = Convert.ToInt32(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "Cantidad"));
        double NetoIgic = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "NetoIgic") == null ? 0 : GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "NetoIgic"));

        if (e.Column.FieldName == "Importe")
        {
            e.Value = Math.Round(PrecioIgic * Cantidad, 2);
        }
        else if (e.Column.FieldName == "ImporteNeto")
        {
            e.Value = Math.Round(NetoIgic * Cantidad, 2);
        }
    }

    protected void GridViewPresupuestoActual_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
    {
        int selectedRowIndex = 0;
        if (e.Parameters.Contains("Save"))
        {
            var Cliente = (Clientes)Session["User"];
            if (Cliente == null)
            {
                ASPxWebControl.RedirectOnCallback("/Account/login.aspx");
            }


            string NumPresupuesto = string.Empty;

            string De = "Presupuestos";
            int esaño = 0;
            string esserie = string.Empty;
            var Tipo = CommonFunction.numeradorgeneral(De, out esaño, out esserie, 1);
            var fr = " Año = '" + esaño + "' and serie = '" + esserie + "' and pedidocli ='0'";
            var maximo = CommonFunction.tMax("Presupuesto", "PRESUPUESTOS", fr);

            if (!string.IsNullOrEmpty(Request.QueryString["sp"]))
            {
                NumPresupuesto = Request.QueryString["sp"];
            }
            else
            {
                maximo = maximo + 1;
                var lencount = 6 - Convert.ToString(maximo).Length;
                string len = string.Empty;
                for (int i = 0; i < lencount; i++)
                {
                    len += "0";
                }

                NumPresupuesto = esaño + esserie + len + maximo;
            }

            string SwCompra = "N";

            if (!string.IsNullOrEmpty(txtAlmacen.Text))
            {
                SwCompra = "S";
            }

            string Almacen = txtAlmacen.Text;

            // Store Value in Presupuestos

            var presupuestos = new Presupuestos();
            if (!string.IsNullOrEmpty(Request.QueryString["sp"]))
            {
                presupuestos = PresupuestosRepository.GetpresupuestosDetail(NumPresupuesto);
            }
            else
            {
                presupuestos = null;
            }

            if (presupuestos == null)
            {
                presupuestos = new Presupuestos();
                presupuestos.Presupuesto = Convert.ToInt32(maximo);
            }

            presupuestos.SeriePresupuesto = NumPresupuesto;
            presupuestos.PedidoCli = 0;
            if (SwCompra == "S")
            {
                presupuestos.status = 6;
            }
            else
            {
                presupuestos.status = 1;
            }
            presupuestos.DelegacionOrden = 1;
            presupuestos.Tipo = Tipo;
            presupuestos.Año = esaño;
            if (Almacen == "1") { presupuestos.Delegación = 1; } else { presupuestos.Delegación = 3; }
            presupuestos.AutoCliente = Cliente.AutoCliente;
            presupuestos.BuqueoObra = "";
            presupuestos.Delegación = 1;
            presupuestos.Serie = esserie;
            presupuestos.Usuario = "Web";
            presupuestos.Vendedor = 99;

            presupuestos.Fecha = CommonFunction.fechaserver();
            presupuestos.Descripción = tbDescription.Text;

            //Save PRESUPUESTOS_CAPITULOS // PresupuestosCapitulos

            var presupuestosCapitulos = new PresupuestosCapitulos();

            if (string.IsNullOrEmpty(Request.QueryString["sp"]))
            {
                presupuestosCapitulos.SeriePresupuesto = NumPresupuesto;
                presupuestosCapitulos.AutoPreCapitulo = 1;
                presupuestosCapitulos.PedidoCli = 0;
                presupuestosCapitulos.Capitulo = 1;
                presupuestosCapitulos.Descripción = " ";
                presupuestosCapitulos.Seleccionar = true;
            }

            //Save PRESUPUESTOS_SUBCAPITULOS // PresupuestosSubcapitulos
            int ccc = 0;
            var PresupuestosSubcapitulos = new PresupuestosSubcapitulos();
            var lstPresupuestosSubcapitulos = new List<PresupuestosSubcapitulos>();
            string[] command = e.Parameters.Split(',');
            var RowCount = Convert.ToInt32(command[0]);
            for (selectedRowIndex = 0; selectedRowIndex < RowCount; selectedRowIndex++)
            {
                PresupuestosSubcapitulos = new PresupuestosSubcapitulos();
                var AutoArtículo = Convert.ToInt32(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "AutoArtículo"));

                if (!string.IsNullOrEmpty(Request.QueryString["sp"]))
                {
                    PresupuestosSubcapitulos = PresupuestosRepository.GetPresupuestosSubcapitulosDetail(NumPresupuesto, AutoArtículo);
                }
                else
                {
                    PresupuestosSubcapitulos = null;
                }


                if (PresupuestosSubcapitulos == null)
                {
                    PresupuestosSubcapitulos = new PresupuestosSubcapitulos();
                }

                ccc = ccc + 1;
                PresupuestosSubcapitulos.Auto = ccc;
                PresupuestosSubcapitulos.SeriePresupuesto = NumPresupuesto;
                PresupuestosSubcapitulos.AutoPreCapitulo = 1;
                PresupuestosSubcapitulos.PedidoCli = 0;
                PresupuestosSubcapitulos.Artículo = Convert.ToString(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "Artículo"));
                PresupuestosSubcapitulos.Descripción = Convert.ToString(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "Desg"));
                PresupuestosSubcapitulos.Unidad = 1;
                PresupuestosSubcapitulos.Cantidad = Convert.ToDecimal(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "Cantidad"));
                PresupuestosSubcapitulos.Cantidadundpedido = Convert.ToDecimal(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "Cantidad"));
                PresupuestosSubcapitulos.factor = 1;
                PresupuestosSubcapitulos.AutoArtículo = AutoArtículo;
                PresupuestosSubcapitulos.pvpprecio = Convert.ToDecimal(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "Precio"));
                PresupuestosSubcapitulos.PrecioServicios = Convert.ToDecimal(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "Precio"));
                PresupuestosSubcapitulos.precioundpedido = Convert.ToDecimal(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "Precio"));
                PresupuestosSubcapitulos.Dto = Convert.ToDecimal(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "Dto"));
                PresupuestosSubcapitulos.Importe = Convert.ToDecimal(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "Importe"));
                PresupuestosSubcapitulos.Impuesto = Convert.ToDecimal(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "PercenImpuesto"));
                PresupuestosSubcapitulos.Tipoartículo = 1;
                PresupuestosSubcapitulos.Fecha = CommonFunction.fechaserver();

                lstPresupuestosSubcapitulos.Add(PresupuestosSubcapitulos);
            }

            if (string.IsNullOrEmpty(Request.QueryString["sp"]))
            {
                if (PresupuestosRepository.Insert_Presupuestos(presupuestos, presupuestosCapitulos, lstPresupuestosSubcapitulos))
                {
                    ASPxWebControl.RedirectOnCallback("/Precios.aspx");
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "errorAlert", "alert('Unable to store data, Please contact to administrator.');", true);
                }
            }
            else
            {
                if (PresupuestosRepository.Update_Presupuestos(presupuestos, lstPresupuestosSubcapitulos))
                {
                    ASPxWebControl.RedirectOnCallback("/Precios.aspx");
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "errorAlert", "alert('Unable to store data, Please contact to administrator.');", true);
                }
            }

        }
        else if (e.Parameters.Contains("Update"))
        {
            var articulosList = new List<SelectedArticulos>();
            if (Session["SelectedArticle"] != null)
            {
                articulosList = (List<SelectedArticulos>)Session["SelectedArticle"];
                string[] command = e.Parameters.Split(',');
                selectedRowIndex = Convert.ToInt32(command[0]);
                var AutoArtículo = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "AutoArtículo"));
                int Cantidad = 1;
                try
                {
                    Cantidad = Convert.ToInt32(command[2].Contains(".") == true ? command[2].Split('.')[0] : command[2]);
                }
                catch (Exception)
                {

                    Cantidad = 1;
                }
                articulosList.Find(x => x.AutoArtículo == AutoArtículo).Cantidad = Cantidad;

                Session["SelectedArticle"] = articulosList;
                GridViewPresupuestoActual.DataSource = articulosList;
                GridViewPresupuestoActual.DataBind();
            }
        }
        else if (e.Parameters.Contains("Delete"))
        {
            var articulosList = new List<SelectedArticulos>();
            if (Session["SelectedArticle"] != null)
            {
                articulosList = (List<SelectedArticulos>)Session["SelectedArticle"];
                string[] command = e.Parameters.Split(',');
                selectedRowIndex = Convert.ToInt32(command[0]);
                var AutoArtículo = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "AutoArtículo"));
                articulosList.Remove(articulosList.Find(x => x.AutoArtículo == AutoArtículo));

                Session["SelectedArticle"] = articulosList;
                GridViewPresupuestoActual.DataSource = articulosList;
                GridViewPresupuestoActual.DataBind();
            }
        }
        else
        {
            selectedRowIndex = Convert.ToInt32(e.Parameters);
            var articulos = (Articulos)GridViewArtículo.GetRow(selectedRowIndex);
            
            var articulosList = new List<SelectedArticulos>();
            if (Session["SelectedArticle"] != null)
            {
                articulosList = (List<SelectedArticulos>)Session["SelectedArticle"];
            }

            if (articulos != null)
            {
                var selectedArticulos = new SelectedArticulos();
                selectedArticulos.AutoArtículo = articulos.AutoArtículo;
                selectedArticulos.Artículo = articulos.Artículo;
                selectedArticulos.Desg = articulos.Desg;
                selectedArticulos.AutoFamilia = articulos.AutoFamilia;
                selectedArticulos.OrdenCatalogo = articulos.OrdenCatalogo;
                selectedArticulos.Impuesto = articulos.Impuesto;
                selectedArticulos.ClasedeArtículo = articulos.ClasedeArtículo;
                selectedArticulos.Artículonum = articulos.Artículonum;
                selectedArticulos.PercenImpuesto = articulos.PercenImpuesto;
                selectedArticulos.Precio = Convert.ToDouble(GridViewArtículo.GetRowValues(selectedRowIndex, "Precio"));
                selectedArticulos.Dto = Convert.ToDouble(GridViewArtículo.GetRowValues(selectedRowIndex, "Dto"));
                selectedArticulos.Neto = Convert.ToDouble(GridViewArtículo.GetRowValues(selectedRowIndex, "Neto"));
                selectedArticulos.PrecioIgic = Convert.ToDouble(GridViewArtículo.GetRowValues(selectedRowIndex, "PrecioIgic"));
                selectedArticulos.NetoIgic = Convert.ToDouble(GridViewArtículo.GetRowValues(selectedRowIndex, "NetoIgic"));

                var searcheditem = articulosList.Where(x => x.Artículo == selectedArticulos.Artículo).FirstOrDefault();
                if (searcheditem != null)
                {
                    searcheditem.Cantidad += 1;
                }
                else
                {
                    articulosList.Add(selectedArticulos);
                }

                //articulosList = articulosList.ToList();
                Session["SelectedArticle"] = articulosList;
                GridViewPresupuestoActual.DataSource = articulosList;
                GridViewPresupuestoActual.DataBind();
                GridViewPresupuestoActual.FocusedRowIndex = articulosList.FindIndex(x => x.AutoArtículo == selectedArticulos.AutoArtículo); 
            }
        }
        GridViewArtículo.Selection.SelectRow(selectedRowIndex);
        GridViewArtículo.FocusedRowIndex = selectedRowIndex;
    }

    protected void GridViewPresupuestoActual_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
    {
        if (e.ButtonID == "btnDelete")
        {
            var articulosList = new List<SelectedArticulos>();
            if (Session["SelectedArticle"] != null)
            {
                articulosList = (List<SelectedArticulos>)Session["SelectedArticle"];
                var selectedRowIndex = e.VisibleIndex;
                var AutoArtículo = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(selectedRowIndex, "AutoArtículo"));
                articulosList.Remove(articulosList.Find(x => x.AutoArtículo == AutoArtículo));

                Session["SelectedArticle"] = articulosList;
                GridViewPresupuestoActual.DataSource = articulosList;
                GridViewPresupuestoActual.DataBind();
            }
        }
    }

    protected void linkPhoto_Init(object sender, EventArgs e)
    {
        try
        {
            ((ASPxHyperLink)sender).Text = "Foto";
            GridViewDataItemTemplateContainer c = ((ASPxHyperLink)sender).NamingContainer as GridViewDataItemTemplateContainer;
            int rowIndex = c.VisibleIndex;
            GridViewArtículo.Selection.SelectRow(rowIndex);
            GridViewArtículo.FocusedRowIndex = rowIndex;
            var editorAuto = 0;
            int.TryParse(Convert.ToString(GridViewArtículo.GetRowValues(rowIndex, "editorAuto")), out editorAuto);
            if (editorAuto > 0)
            {
                ((ASPxHyperLink)sender).ClientSideEvents.Click = "function(s,e){  window.open('../editor.aspx?id=" + editorAuto + "');}";
            }
            else
            {
                ((ASPxHyperLink)sender).Enabled = false;
                ((ASPxHyperLink)sender).ClientEnabled = false;
                ((ASPxHyperLink)sender).Text = "-";
                ((ASPxHyperLink)sender).CssClass += " hidehovercursor";
            }
        }
        catch (Exception ex)
        {
        }
    }

    protected void btnsearchArticulo_Click(object sender, EventArgs e)
    {
        var preciosGroupRepository = new PreciosGroupRepository();
        GridViewGroup.FocusedRowIndex = 0;
        GridViewGroup.DataSource = preciosGroupRepository.GetAllPreciosGroup();
        GridViewGroup.DataBind();
        GridViewGroup.Selection.SelectRow(0);
        GridViewGroup.MakeRowVisible(0);
        GridViewGroupFamily.FocusedRowIndex = 0;
        GridViewGroupFamily.DataSource = FamiliasRepository.GetFamiliaByGroup();
        GridViewGroupFamily.DataBind();
        GridViewGroupFamily.MakeRowVisible(0);
        GridViewGroupFamily.Selection.SelectRow(0);
        GridViewArtículo.DataSource = ArticulosRepository.GetSelectedArticulos();
        GridViewArtículo.DataBind();

    }

    protected void GridViewGroup_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
    {
        int selectedRowIndex = 0;
    }

    protected void linkGroupphoto_Init(object sender, EventArgs e)
    {
        try
        {
            ((ASPxHyperLink)sender).Text = "Foto";
            GridViewDataItemTemplateContainer c = ((ASPxHyperLink)sender).NamingContainer as GridViewDataItemTemplateContainer;
            int rowIndex = c.VisibleIndex;
            var editorAuto = 0;
            int.TryParse(Convert.ToString(GridViewGroup.GetRowValues(rowIndex, "AutoEditor")), out editorAuto);
            if (editorAuto > 0)
            {
                ((ASPxHyperLink)sender).ClientSideEvents.Click = "function(s,e){  window.open('../editor.aspx?id=" + editorAuto + "');}";
            }
            else
            {
                ((ASPxHyperLink)sender).Enabled = false;
                ((ASPxHyperLink)sender).ClientEnabled = false;
                ((ASPxHyperLink)sender).Text = "-";
                ((ASPxHyperLink)sender).CssClass += " hidehovercursor";
            }
        }
        catch (Exception ex)
        {
            ((ASPxHyperLink)sender).Enabled = false;
            ((ASPxHyperLink)sender).ClientEnabled = false;
            ((ASPxHyperLink)sender).Text = "-";
            ((ASPxHyperLink)sender).CssClass += " hidehovercursor";
        }
    }

    protected void linkfamiliphoto_Init(object sender, EventArgs e)
    {
        try
        {
            ((ASPxHyperLink)sender).Text = "Foto";
            GridViewDataItemTemplateContainer c = ((ASPxHyperLink)sender).NamingContainer as GridViewDataItemTemplateContainer;
            int rowIndex = c.VisibleIndex;

            var editorAuto = 0;
            int.TryParse(Convert.ToString(GridViewGroupFamily.GetRowValues(rowIndex, "AutoEditor")), out editorAuto);
            if (editorAuto > 0)
            {
                ((ASPxHyperLink)sender).ClientSideEvents.Click = "function(s,e){  window.open('../editor.aspx?id=" + editorAuto + "');}";
            }
            else
            {
                ((ASPxHyperLink)sender).Enabled = false;
                ((ASPxHyperLink)sender).ClientEnabled = false;
                ((ASPxHyperLink)sender).Text = "-";
                ((ASPxHyperLink)sender).CssClass += " hidehovercursor";
            }
        }
        catch (Exception ex)
        {
            ((ASPxHyperLink)sender).Enabled = false;
            ((ASPxHyperLink)sender).ClientEnabled = false;
            ((ASPxHyperLink)sender).Text = "-";
            ((ASPxHyperLink)sender).CssClass += " hidehovercursor";
        }
    }
}
