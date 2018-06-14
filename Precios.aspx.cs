using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Services;
using System.Web.UI;
using Newtonsoft.Json;
using System.Web;

public partial class Precios : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["User"] == null)
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
        Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "SetSize();", true);
        ////ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "SetSize();", true);

        //var width = Convert.ToInt32(FrmWidth.Value);
        //var height = Convert.ToInt32(FrmHeight.Value);


        //if (width < 1200)
        //{
        //    IsMobile = true;
        //}
        //if (IsMobile)
        //{
        //    if (Page.IsCallback)
        //    {
        //        ASPxWebControl.RedirectOnCallback("/mobile/precios.aspx");
        //    }
        //    else
        //    {
        //        if (!string.IsNullOrEmpty(Request.QueryString["sp"]))
        //        {
        //            Response.Redirect("/mobile/precios.aspx?sp=" + Request.QueryString["sp"]);
        //        }
        //        else
        //        {
        //            Response.Redirect("/mobile/precios.aspx");
        //        }
        //    }

        //}

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
                    if (articulos.Dto == -1)
                        articulos.Dto = 0;

                    articulos.Neto = CommonFunction.Redondear(articulos.Precio - (articulos.Precio * articulos.Dto / 100), 2);
                    articulos.PrecioIgic = CommonFunction.Redondear(articulos.Precio + (articulos.Precio * articulos.PercenImpuesto / 100), 2);
                    articulos.NetoIgic = CommonFunction.Redondear(articulos.Neto + (articulos.Neto * articulos.PercenImpuesto / 100), 2);
                }

                Session["SelectedArticle"] = articulosList;
                GridViewPresupuestoActual.DataSource = articulosList;
                GridViewPresupuestoActual.DataBind();
            }
            pcHTMLEditor.ShowOnPageLoad = false;
        }

        GridViewGroup.DataSource = preciosGroupRepository.GetAllPreciosGroup();
        GridViewGroup.DataBind();

        if (GridViewGroup.FocusedRowIndex > 0 && GridViewGroup.GetSelectedFieldValues("Grupo").Count > 0)
        {
            grupo = (int)GridViewGroup.GetSelectedFieldValues("Grupo").Select(c => c).FirstOrDefault();
        }

        GridViewGroupFamily.DataSource = FamiliasRepository.GetFamiliaByGroup(grupo);
        GridViewGroupFamily.DataBind();

        //if (GridViewGroupFamily.FocusedRowIndex > -1 && GridViewGroupFamily.GetSelectedFieldValues("Autofamilia").Count > 0)
        if (GridViewGroupFamily.FocusedRowIndex > -1 && GridViewGroupFamily.GetRow(GridViewGroupFamily.FocusedRowIndex) != null)
        {
            var rowLvalue = (Familias)GridViewGroupFamily.GetRow(GridViewGroupFamily.FocusedRowIndex);
            familiaId = rowLvalue.Autofamilia;
        }
        GridViewArtículo.DataSource = ArticulosRepository.GetSelectedArticulos(FamiliaId: familiaId);
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
        var familiaId = 0;
        if (GridViewGroupFamily.GetSelectedFieldValues("Autofamilia").Count <= 0) return;
        familiaId = (int)GridViewGroupFamily.GetSelectedFieldValues("Autofamilia").Select(c => c).FirstOrDefault();
        GridViewArtículo.DataSource = ArticulosRepository.GetSelectedArticulos(familiaId);
        GridViewArtículo.DataBind();
    }

    protected void GridViewArtículo_CustomUnboundColumnData(object sender, DevExpress.Web.ASPxGridViewColumnDataEventArgs e)
    {

        var Cliente = (Clientes)Session["User"];
        if (Cliente == null)
        {
            ASPxWebControl.RedirectOnCallback("/Account/login.aspx");
        }

        //      if (Request.Browser.IsMobileDevice)
        //      {
        //          if (Page.IsCallback)
        //          {
        //              ASPxWebControl.RedirectOnCallback("/mobile/precios.aspx");
        //          }
        //          else
        //          {
        //              if (!string.IsNullOrEmpty(Request.QueryString["sp"]))
        //              {
        //                  Response.Redirect("/mobile/precios.aspx?sp=" + Request.QueryString["sp"]);
        //              }
        //              else
        //              {
        //                  Response.Redirect("/mobile/precios.aspx");
        //              }
        //          }

        //       }
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

        if (calcdto == -1)
        {
            calcdto = 0;
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

    protected void GridViewPresupuestoActual_CustomUnboundColumnData(object sender, DevExpress.Web.ASPxGridViewColumnDataEventArgs e)
    {

        var Cliente = (Clientes)Session["User"];
        if (Cliente == null)
        {
            ASPxWebControl.RedirectOnCallback("/Account/login.aspx");
        }

        //       if (Request.Browser.IsMobileDevice)
        //       {
        //           if (Page.IsCallback)
        //           {
        //               ASPxWebControl.RedirectOnCallback("/mobile/precios.aspx");
        //           }
        //           else
        //           {
        //              if (!string.IsNullOrEmpty(Request.QueryString["sp"]))
        //              {
        //                  Response.Redirect("/mobile/precios.aspx?sp=" + Request.QueryString["sp"]);
        //              }
        //              else
        //              {
        //                  Response.Redirect("/mobile/precios.aspx");
        //             }
        //          }

        //        }
        string CodigoCliente = Cliente.Código;
        int AutoCliente = Cliente.AutoCliente;
        int AutoArticulo = Convert.ToInt32(e.GetListSourceFieldValue("AutoArtículo"));


        double PrecioIgic = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "PrecioIgic") == null ? 0 : GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "PrecioIgic"));
        int Cantidad = Convert.ToInt32(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "Cantidad"));
        double NetoIgic = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "NetoIgic") == null ? 0 : GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "NetoIgic"));
        var PercenImpuesto = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "PercenImpuesto") == null ? 0 : GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "PercenImpuesto"));
        var Precio = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "Precio") == null ? 0 : GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "Precio"));
        var Dto = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "Dto") == null ? 0 : GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "Dto"));

        if (e.Column.FieldName == "Importe") // Total PVP
        {
            // e.Value = Math.Round(PrecioIgic * Cantidad, 2); // old code
            e.Value = Math.Round(Precio * Cantidad * (1 + PercenImpuesto / 100), 2);
        }
        else if (e.Column.FieldName == "ImporteNeto") // Total Neto
        {
            // e.Value = Math.Round(NetoIgic * Cantidad, 2); //old code
            //e.Value = Math.Round(Precio * Cantidad * (1 + PercenImpuesto / 100) * (1 - Dto / 100), 2);
            double dtoval = 1;
            if (Dto > 0)
                dtoval = (1 - Dto / 100);

            e.Value = Math.Round(Precio * Cantidad * (1 + PercenImpuesto / 100) * dtoval, 2);
        }
        else if (e.Column.FieldName == "ImpNetoDtopp") // Total Neto-DtoPP
        {
            //var neto = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "Neto") == null ? 0 : GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "Neto"));
            //double newimpor = neto * (1 - Cliente.Dtopp / 100);
            //e.Value = Math.Round(newimpor * (1 + PercenImpuesto / 100), 2);
            double dtoval = 1;
            if (Dto > 0)
                dtoval = (1 - Dto / 100);

            double dtoppval = 1;
            dtoppval = Cliente.Dtopp;

            var VarDtoPP = Math.Round(Cantidad * Precio * dtoval * dtoppval, 2);
            e.Value = Math.Round(Cantidad * Precio * dtoval * (1 + PercenImpuesto / 100), 2) - VarDtoPP;
        }
        else if (e.Column.FieldName == "beneficio")
        {
            var Importe = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "Importe") == null ? 0 : GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "Importe"));
            var ImpNetoDtopp = Convert.ToDouble(GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "ImpNetoDtopp") == null ? 0 : GridViewPresupuestoActual.GetRowValues(e.ListSourceRowIndex, "ImpNetoDtopp"));
            //e.Value = Math.Round(Math.Round(PrecioIgic * Cantidad, 2) - Math.Round(NetoIgic * Cantidad, 2), 2);
            e.Value = Math.Round(Importe - ImpNetoDtopp, 2);
        }
    }

    protected void linkselect_Init(object sender, EventArgs e)
    {

        GridViewDataItemTemplateContainer c = ((ASPxHyperLink)sender).NamingContainer as GridViewDataItemTemplateContainer;
        int rowIndex = c.VisibleIndex;
        ((ASPxHyperLink)sender).ClientSideEvents.Click = "function(s,e){ SelectArticle('" + rowIndex + "'); return false;}";
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
                var articulosHTML = ArticulosRepository.GetArticulosHTML(editorAuto);
                if (articulosHTML.Any())
                {
                    ((ASPxHyperLink)sender).ClientSideEvents.Click = "function(s,e){  e.processOnServer = false; showHTMLEditor('" + editorAuto + "'); return false;}";
                }
                else
                {
                    ((ASPxHyperLink)sender).Enabled = false;
                    ((ASPxHyperLink)sender).ClientEnabled = false;
                    ((ASPxHyperLink)sender).Text = "-";
                    ((ASPxHyperLink)sender).CssClass += " hidehovercursor";
                }
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
                selectedArticulos.EditorAuto = (int?)GridViewArtículo.GetRowValues(selectedRowIndex, "editorAuto");

                var searcheditem = articulosList.Where(x => x.Artículo == selectedArticulos.Artículo).FirstOrDefault();
                if (searcheditem != null)
                {
                    searcheditem.Cantidad += 1;
                }
                else
                {
                    articulosList.Add(selectedArticulos);
                }

                //articulosList = articulosList.OrderByDescending(x => x.AutoArtículo).ToList();
                Session["SelectedArticle"] = articulosList;
                GridViewPresupuestoActual.DataSource = articulosList;
                GridViewPresupuestoActual.DataBind();

                var selectedindex = articulosList.FindIndex(x => x.AutoArtículo == selectedArticulos.AutoArtículo);
                GridViewPresupuestoActual.FocusedRowIndex = selectedindex;
                //GridViewPresupuestoActual.Selection.SelectRow(selectedindex);
            }
        }
        GridViewArtículo.FocusedRowIndex = selectedRowIndex;
        GridViewArtículo.Selection.SelectRow(selectedRowIndex);
        //Page.ClientScript.RegisterStartupScript(this.GetType(), "PresupuestoActual", "FocusPresupuestoActual(" + GridViewPresupuestoActual.FocusedRowIndex + ");", true);
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

    protected void btnsearchArticulo_Click(object sender, EventArgs e)
    {
        var preciosGroupRepository = new PreciosGroupRepository();
        GridViewGroupFamily.SearchPanelFilter = "";
        GridViewArtículo.SearchPanelFilter = "";
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

    protected void btnexport_Click(object sender, EventArgs e)
    {
        if (Session["SelectedArticle"] != null)
        {
            var articulosList = (List<SelectedArticulos>)Session["SelectedArticle"];
            GridViewPresupuestoActual.DataSource = articulosList;
            GridViewPresupuestoActual.DataBind();
            exportGrid.ExportedRowType = GridViewExportedRowType.All;
            exportGrid.FileName = "Exportar";
            exportGrid.WriteXlsxToResponse();
        }
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
                var articulosHTML = ArticulosRepository.GetArticulosHTML(editorAuto);
                if (articulosHTML.Any())
                {
                    ((ASPxHyperLink)sender).ClientSideEvents.Click = "function(s,e){  e.processOnServer = false; showHTMLEditor('" + editorAuto + "'); return false;}";
                }
                else
                {
                    ((ASPxHyperLink)sender).Enabled = false;
                    ((ASPxHyperLink)sender).ClientEnabled = false;
                    ((ASPxHyperLink)sender).Text = "-";
                    ((ASPxHyperLink)sender).CssClass += " hidehovercursor";
                }
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
                var articulosHTML = ArticulosRepository.GetArticulosHTML(editorAuto);
                if (articulosHTML.Any())
                {
                    ((ASPxHyperLink)sender).ClientSideEvents.Click = "function(s,e){  e.processOnServer = false; showHTMLEditor('" + editorAuto + "'); return false;}";
                }
                else
                {
                    ((ASPxHyperLink)sender).Enabled = false;
                    ((ASPxHyperLink)sender).ClientEnabled = false;
                    ((ASPxHyperLink)sender).Text = "-";
                    ((ASPxHyperLink)sender).CssClass += " hidehovercursor";
                }
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

    protected void linkPresupuestoActualPhoto_Init(object sender, EventArgs e)
    {
        try
        {
            ((ASPxHyperLink)sender).Text = "Foto";
            GridViewDataItemTemplateContainer c = ((ASPxHyperLink)sender).NamingContainer as GridViewDataItemTemplateContainer;
            int rowIndex = c.VisibleIndex;
            var editorAuto = 0;
            int.TryParse(Convert.ToString(GridViewPresupuestoActual.GetRowValues(rowIndex, "EditorAuto")), out editorAuto);

            if (editorAuto > 0)
            {
                var articulosHTML = ArticulosRepository.GetArticulosHTML(editorAuto);
                if (articulosHTML.Any())
                {
                    ((ASPxHyperLink)sender).ClientSideEvents.Click = "function(s,e){  e.processOnServer = false; articleclicked = false; showHTMLEditor('" + editorAuto + "'); return false;}";
                }
                else
                {
                    ((ASPxHyperLink)sender).Enabled = false;
                    ((ASPxHyperLink)sender).ClientEnabled = false;
                    ((ASPxHyperLink)sender).Text = "-";
                    ((ASPxHyperLink)sender).CssClass += " hidehovercursor";
                }
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

    [System.Web.Services.WebMethod(EnableSession = true)]
    public static decimal? getstocks(string dearticulo, int dealmacen)
    {
        var isVendedor = false;
        bool.TryParse(Convert.ToString(HttpContext.Current.Session["Vendedor"]), out isVendedor);
        if (isVendedor)
        {
            // return CommonFunction.getStock(dearticulo, dealmacen);
        }
        return 0;
    }
}