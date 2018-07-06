using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ClienteList : System.Web.UI.Page
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

        var client = (Clientes)Session["User"];
        string escliente = client.Código;
        if (!(escliente == "908795" || escliente == "908798" || escliente == "908799")) return;
        gridViewClient.DataSource = ClientesRepository.GetClientList();
        gridViewClient.DataBind();
    }

    protected void linkselect_Init(object sender, EventArgs e)
    {

        GridViewDataItemTemplateContainer c = ((ASPxHyperLink)sender).NamingContainer as GridViewDataItemTemplateContainer;
        int rowIndex = c.VisibleIndex;
        ((ASPxHyperLink)sender).ClientSideEvents.Click = "function(s,e){ SelectClientes('" + rowIndex + "'); return false;}";
    }

    protected void gridViewClient_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
    {
        int selectedRowIndex = 0;
        int.TryParse(Convert.ToString(e.Parameters), out selectedRowIndex);
        var cliente = (Clientes)gridViewClient.GetRow(selectedRowIndex);
        Session.Remove("User");
        Session["User"] = cliente;
        ASPxWebControl.RedirectOnCallback("/default.aspx");
    }
}