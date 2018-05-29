using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class mobile_Albaranes : BasePage
{
    DateTime fechahoy = CommonFunction.fechaserver();

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
        searchalbaran.Text = string.IsNullOrWhiteSpace(Request.QueryString["albarane"]) ? searchalbaran.Text : Request.QueryString["albarane"];
        if (!string.IsNullOrEmpty(searchalbaran.Text))
        {
            GridViewAlbaransver.DataSource = AlbaranRepository.GetAllAlbaranosver(searchalbaran.Text, "", Cliente.AutoCliente, null, null);
        }
        else
        {
            GridViewAlbaransver.DataSource = AlbaranRepository.GetAllAlbaranosver(searchalbaran.Text, "", Cliente.AutoCliente, defecha, afecha);
        }
        GridViewAlbaransver.DataBind();

        string serieAlbaran = string.Empty;
        if (GridViewAlbaransver.GetSelectedFieldValues("SerieAlbaran").Count > 0)
        {
            serieAlbaran = Convert.ToString(GridViewAlbaransver.GetSelectedFieldValues("SerieAlbaran").Select(c => c).FirstOrDefault());
        }
        else
        {
            serieAlbaran = Convert.ToString(GridViewAlbaransver.GetRowValues(0, "SerieAlbaran"));
        }
        GridViewAlbaransverDetail.DataSource = AlbaranRepository.GetAlbaranosverDetail(serieAlbaran);
        GridViewAlbaransverDetail.DataBind();
        
        gridgrupo.Visible = true;

    }

    protected void dtfromDate_Init(object sender, EventArgs e)
    {
        dtfromDate.Date = Convert.ToDateTime(fechahoy.ToString("01/MMM/yyy"));
    }

    protected void dttoDate_Init(object sender, EventArgs e)
    {
        dttoDate.Date = Convert.ToDateTime(DateTime.DaysInMonth(fechahoy.Year, fechahoy.Month) + "/" + fechahoy.Month + "/" + fechahoy.Year);
    }

    protected void GridViewAlbaransver_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
    {
        var Cliente = (Clientes)Session["User"];
        GridViewAlbaransver.Columns["foto"].Visible = false;
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
            GridViewAlbaransver.Columns["foto"].Visible = true;
            Session["buttonclick"] = "searchalbaran";
            GridViewAlbaransver.DataSource = AlbaranRepository.GetAllAlbaranosver(searchalbaran.Text, "", Cliente.AutoCliente, null, null);
        }
        else if (e.Parameters.Contains("searchfectura"))
        {
            Session["buttonclick"] = "searchfectura";
            GridViewAlbaransver.DataSource = AlbaranRepository.GetAllAlbaranosver(searchalbaran.Text, searchfectura.Text, Cliente.AutoCliente, null, null);
        }
        else if (e.Parameters.Contains("date"))
        {
            Session["buttonclick"] = "date";
            GridViewAlbaransver.DataSource = AlbaranRepository.GetAllAlbaranosver("", "", Cliente.AutoCliente, dtfromDate.Date, dttoDate.Date);
        }
        else
        {
            Session["buttonclick"] = "showall";
            GridViewAlbaransver.DataSource = AlbaranRepository.GetAllAlbaranosver("", "", Cliente.AutoCliente, null, null);
        }
        GridViewAlbaransver.DataBind();
    }

    protected void GridViewAlbaransverDetail_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
    {
        string SerieAlbaran = Convert.ToString(GridViewAlbaransver.GetSelectedFieldValues("SerieAlbaran").Select(c => c).FirstOrDefault());

        GridViewAlbaransverDetail.DataSource = AlbaranRepository.GetAlbaranosverDetail(SerieAlbaran);
        GridViewAlbaransverDetail.DataBind();
    }

    protected void GridViewAlbaransver_SelectionChanged(object sender, EventArgs e)
    {
        string SerieAlbaran = Convert.ToString(GridViewAlbaransver.GetSelectedFieldValues("SerieAlbaran").Select(c => c).FirstOrDefault());

        GridViewAlbaransverDetail.DataSource = AlbaranRepository.GetAlbaranosverDetail(SerieAlbaran);
        GridViewAlbaransverDetail.DataBind();
        ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "divShow('#gridfamilia')", true);
    }

    protected void GridViewAlbaransver_CustomUnboundColumnData(object sender, ASPxGridViewColumnDataEventArgs e)
    {
        var Cliente = (Clientes)Session["User"];
        if (Cliente == null)
        {
            ASPxWebControl.RedirectOnCallback("/Account/login.aspx");
        }

        string CodigoCliente = Cliente.Código;
        int AutoCliente = Cliente.AutoCliente;
        int AutoArticulo = Convert.ToInt32(e.GetListSourceFieldValue("AutoArtículo"));
        string resp = (string)CommonFunction.Calculoalbaran(Convert.ToString(GridViewAlbaransver.GetRowValues(e.ListSourceRowIndex, "SerieAlbaran")), 5);
        if (e.Column.FieldName == "Importe")
        {
            var val = CommonFunction.Field(resp, 1, "&");
            if (!string.IsNullOrEmpty(val))
                e.Value = Convert.ToDouble(CommonFunction.Field(resp, 1, "&"));
        }
        else if (e.Column.FieldName == "ImporteIgic")
        {
            var val = CommonFunction.Field(resp, 2, "&");
            if (!string.IsNullOrEmpty(val))
                e.Value = Convert.ToDouble(CommonFunction.Field(resp, 2, "&"));
        }
    }
    protected void linkselect_Init(object sender, EventArgs e)
    {
        ((ASPxHyperLink)sender).Text = "Ver Albarán";
        GridViewDataItemTemplateContainer c = ((ASPxHyperLink)sender).NamingContainer as GridViewDataItemTemplateContainer;
        int rowIndex = c.VisibleIndex;
        GridViewAlbaransver.FocusedRowIndex = rowIndex;
        var s = Convert.ToString(GridViewAlbaransver.GetRowValues(GridViewAlbaransver.FocusedRowIndex, "Fecha"));
        //s = "31/12/1900 0:00:00";
        if (string.IsNullOrEmpty(s)) return;
        var date1 = Convert.ToDateTime(s);

        string year = date1.Year.ToString();
        string month = date1.Month.ToString();
        string date = date1.Day.ToString();

        var cliente = (Clientes)Session["User"];
        var val = GridViewAlbaransver.GetRowValues(GridViewAlbaransver.FocusedRowIndex, "SerieAlbaran").ToString();
        if (AlbaranRepository.CheckAlbaranosverIdforImage(val, cliente.AutoCliente) > 0)
        {
            ((ASPxHyperLink)sender).ClientSideEvents.Click = "function(s,e){  window.open('../Imageviewer.aspx?id=" + val + "&year=" + year + "&month=" + month + "&date=" + date + "','_blank');}";
        }
        else
        {
            ((ASPxHyperLink)sender).Text = "-";
        }
    }
    protected void ASPxCallback1_Callback(object source,
         DevExpress.Web.CallbackEventArgs e)
    {
        if (IsPostBack)
        {
            Thread.Sleep(3000);
        }

        if (e.Parameter == "SaveData")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "ShowPopup();", true);
        }
    }
}