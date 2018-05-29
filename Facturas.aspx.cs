using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Facturas : BasePage
{
    DateTime fechahoy = CommonFunction.fechaserver();

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


 //       if (Request.Browser.IsMobileDevice)
 //       {
 //           if (Page.IsCallback)
 //           {
  //              ASPxWebControl.RedirectOnCallback("/mobile/Facturas.aspx");
  //          }
  //          else
  //          {
  //              Response.Redirect("/mobile/Facturas.aspx");
  //          }

  //      }
        DateTime? defecha = null;
        DateTime? afecha = null;

        if (!Page.IsPostBack)
        {
            Session["buttonclick"] = "date";
            defecha = Convert.ToDateTime(fechahoy.ToString("01/MMM/yyy"));
            afecha = Convert.ToDateTime(DateTime.DaysInMonth(fechahoy.Year, fechahoy.Month) + "/" + fechahoy.Month + "/" + fechahoy.Year);
        }

        if ((dtfromDate.Date != null || dttoDate.Date != null) && Convert.ToString(Session["buttonclick"]) == "date")
        {
            defecha = dtfromDate.Date;
            afecha = dttoDate.Date;
        }

        var Cliente = (Clientes)Session["User"];
        GridViewFacturas.DataSource = FacturasRepository.GetAllFacturas("", Cliente.AutoCliente, defecha, afecha);
        GridViewFacturas.DataBind();

        string SerieFactura = string.Empty;
        if (GridViewFacturas.GetSelectedFieldValues("SerieFactura").Count > 0)
        {
            SerieFactura = Convert.ToString(GridViewFacturas.GetSelectedFieldValues("SerieFactura").Select(c => c).FirstOrDefault());
        }
        else
        {
            SerieFactura = Convert.ToString(GridViewFacturas.GetRowValues(0, "SerieFactura"));
        }
        GridViewFacturasDetail.DataSource = FacturasRepository.GetFacturasDetail(SerieFactura);
        GridViewFacturasDetail.DataBind();
    }

    protected void GridViewFacturas_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
    {
        var Cliente = (Clientes)Session["User"];
        if (Cliente == null)
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
        if (e.Parameters.Contains("searchalbaran"))
        {
            Session["buttonclick"] = "searchalbaran";
            GridViewFacturas.DataSource = FacturasRepository.GetAllFacturas("", Cliente.AutoCliente, null, null);
        }
        else if (e.Parameters.Contains("searchfectura"))
        {
            Session["buttonclick"] = "searchfectura";
            GridViewFacturas.DataSource = FacturasRepository.GetAllFacturas(searchfectura.Text, Cliente.AutoCliente, null, null);
        }
        else if (e.Parameters.Contains("date"))
        {
            Session["buttonclick"] = "date";
            GridViewFacturas.DataSource = FacturasRepository.GetAllFacturas("", Cliente.AutoCliente, dtfromDate.Date, dttoDate.Date);
        }
        else
        {
            Session["buttonclick"] = "showall";
            GridViewFacturas.DataSource = FacturasRepository.GetAllFacturas("", Cliente.AutoCliente, null, null);
        }
        GridViewFacturas.DataBind();
    }

    protected void GridViewFacturasDetail_CustomUnboundColumnData(object sender, DevExpress.Web.ASPxGridViewColumnDataEventArgs e)
    {
        var Cliente = (Clientes)Session["User"];
        if (Cliente == null)
        {
            ASPxWebControl.RedirectOnCallback("/Account/login.aspx");
        }

        string CodigoCliente = Cliente.Código;
        int AutoCliente = Cliente.AutoCliente;
        int AutoArticulo = Convert.ToInt32(e.GetListSourceFieldValue("AutoArtículo"));
        string resp = (string)CommonFunction.Calculoalbaran(Convert.ToString(GridViewFacturasDetail.GetRowValues(e.ListSourceRowIndex, "SerieAlbaran")), 5);
        if (e.Column.FieldName == "TotalNeto")
        {
            var val = CommonFunction.Field(resp, 1, "&");
            if (!string.IsNullOrEmpty(val))
                e.Value = Convert.ToDouble(CommonFunction.Field(resp, 1, "&"));
        }
        else if (e.Column.FieldName == "NetoIgic")
        {
            var val = CommonFunction.Field(resp, 2, "&");
            if (!string.IsNullOrEmpty(val))
                e.Value = Convert.ToDouble(CommonFunction.Field(resp, 2, "&"));
        }
    }

    protected void GridViewFacturas_SelectionChanged(object sender, EventArgs e)
    {
        string SerieFactura = Convert.ToString(GridViewFacturas.GetSelectedFieldValues("SerieFactura").Select(c => c).FirstOrDefault());

        GridViewFacturasDetail.DataSource = FacturasRepository.GetFacturasDetail(SerieFactura);
        GridViewFacturasDetail.DataBind();
    }

    protected void dttoDate_Init(object sender, EventArgs e)
    {
        dttoDate.Date = Convert.ToDateTime(DateTime.DaysInMonth(fechahoy.Year, fechahoy.Month) + "/" + fechahoy.Month + "/" + fechahoy.Year);
    }

    protected void dtfromDate_Init(object sender, EventArgs e)
    {
        dtfromDate.Date = Convert.ToDateTime(fechahoy.ToString("01/MMM/yyy"));
    }

    protected void GridViewFacturasDetail_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
    {
        string SerieFactura = Convert.ToString(GridViewFacturas.GetSelectedFieldValues("SerieFactura").Select(c => c).FirstOrDefault());

        GridViewFacturasDetail.DataSource = FacturasRepository.GetFacturasDetail(SerieFactura);
        GridViewFacturasDetail.DataBind();
    }
}