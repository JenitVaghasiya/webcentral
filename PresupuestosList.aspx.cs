using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PresupuestosList : BasePage
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
  //      if (Request.Browser.IsMobileDevice)
  //      {
  //          if (Page.IsCallback)
  //          {
  //              ASPxWebControl.RedirectOnCallback("/mobile/PresupuestosList.aspx");
  //          }
  //          else
  //          {
  //              Response.Redirect("/mobile/PresupuestosList.aspx");
  //          }

//        }
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
        GridViewPresupuestosver.DataSource = PresupuestosRepository.GetAllPresupuestosver("", Cliente.AutoCliente, defecha, afecha);
        GridViewPresupuestosver.DataBind();

        string seriePresupuesto = string.Empty;
        if (GridViewPresupuestosver.GetSelectedFieldValues("SeriePresupuesto").Count > 0)
        {
            seriePresupuesto = Convert.ToString(GridViewPresupuestosver.GetSelectedFieldValues("SeriePresupuesto").Select(c => c).FirstOrDefault());
        }
        else
        {
            seriePresupuesto = Convert.ToString(GridViewPresupuestosver.GetRowValues(0, "SeriePresupuesto"));
        }
        GridViewPresupuestosverDetail.DataSource = PresupuestosRepository.GetAllPresupuestosverDetail(seriePresupuesto);
        GridViewPresupuestosverDetail.DataBind();
    }

    protected void dtfromDate_Init(object sender, EventArgs e)
    {
        dtfromDate.Date = Convert.ToDateTime(fechahoy.ToString("01/MMM/yyy"));
    }

    protected void dttoDate_Init(object sender, EventArgs e)
    {
        dttoDate.Date = Convert.ToDateTime(DateTime.DaysInMonth(fechahoy.Year, fechahoy.Month) + "/" + fechahoy.Month + "/" + fechahoy.Year);
    }

    protected void GridViewPresupuestosver_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
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
        if (e.Parameters.Contains("searchtext"))
        {
            Session["buttonclick"] = "searchtext";
            GridViewPresupuestosver.DataSource = PresupuestosRepository.GetAllPresupuestosver(searchText.Text, Cliente.AutoCliente, null, null);
        }
        else if (e.Parameters.Contains("date"))
        {
            Session["buttonclick"] = "date";
            GridViewPresupuestosver.DataSource = PresupuestosRepository.GetAllPresupuestosver("", Cliente.AutoCliente, dtfromDate.Date, dttoDate.Date);
        }
        else
        {
            Session["buttonclick"] = "showall";
            GridViewPresupuestosver.DataSource = PresupuestosRepository.GetAllPresupuestosver("", Cliente.AutoCliente, null, null);
        }
        GridViewPresupuestosver.DataBind();

    }

    protected void GridViewPresupuestosverDetail_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
    {
        string seriePresupuesto = Convert.ToString(GridViewPresupuestosver.GetSelectedFieldValues("SeriePresupuesto").Select(c => c).FirstOrDefault());

        GridViewPresupuestosverDetail.DataSource = PresupuestosRepository.GetAllPresupuestosverDetail(seriePresupuesto);
        GridViewPresupuestosverDetail.DataBind();
    }

    protected void GridViewPresupuestosver_SelectionChanged(object sender, EventArgs e)
    {
        string seriePresupuesto = Convert.ToString(GridViewPresupuestosver.GetSelectedFieldValues("SeriePresupuesto").Select(c => c).FirstOrDefault());

        GridViewPresupuestosverDetail.DataSource = PresupuestosRepository.GetAllPresupuestosverDetail(seriePresupuesto);
        GridViewPresupuestosverDetail.DataBind();
    }

    protected void GridViewPresupuestosver_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
    {
        if (e.ButtonID == "btnRecover")
        {
            var selectedRowIndex = e.VisibleIndex;
            var SeriePresupuesto = Convert.ToString(GridViewPresupuestosver.GetRowValues(selectedRowIndex, "SeriePresupuesto"));

            Response.Redirect("/precios.aspx?sp="+ SeriePresupuesto);

        }
    }

    protected void linkPhoto_Init(object sender, EventArgs e)
    {
        try
        {
            ((ASPxHyperLink)sender).Text = "Foto";
            GridViewDataItemTemplateContainer c = ((ASPxHyperLink)sender).NamingContainer as GridViewDataItemTemplateContainer;
            int rowIndex = c.VisibleIndex;
            GridViewPresupuestosverDetail.Selection.SelectRow(rowIndex);
            GridViewPresupuestosverDetail.FocusedRowIndex = rowIndex;
            var editorAuto = 0;
            int.TryParse(Convert.ToString(GridViewPresupuestosverDetail.GetRowValues(rowIndex, "editorFoto")), out editorAuto);

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
}