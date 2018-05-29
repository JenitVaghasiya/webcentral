using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;

public partial class SiteMaster : System.Web.UI.MasterPage
{
   
    protected void Page_Load(object sender, EventArgs e)
    {

        uluser.Visible = false;
        if (Session["User"] != null)
        {
            uluser.Visible = true;
            TopMenu.Visible = false; //Login
            LogingMenu.Visible = true; //Logout
            var client = (Clientes)Session["User"];
            userName.InnerText =  client.RazónSocial;
        }
        else
        {
            TopMenu.Visible = true; //Login
            LogingMenu.Visible = false; //Logout
            if (!HttpContext.Current.Request.Url.AbsoluteUri.Contains("login"))
            {
                Response.Redirect("/Account/login.aspx");
            }
        }
    }
}