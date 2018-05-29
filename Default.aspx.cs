using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

    public partial class _Default : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e) {
        ASPxButtonCLI.Visible = false;
        if (Session["User"] == null)
        {

                      Response.Redirect("/Account/login.aspx");
         
        }
        var client = (Clientes)Session["User"];
        string escliente =  client.Código ;
        if (escliente == "908795") ASPxButtonCLI.Visible = true;
        if (escliente == "908798") ASPxButtonCLI.Visible = true;
        if (escliente == "908799") ASPxButtonCLI.Visible = true;
    }
    }