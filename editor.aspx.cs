using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using DevExpress.Web;

public partial class editor : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var Auto = 0;
        int.TryParse(Request.QueryString["id"], out Auto);
        if (Auto > 0)
        {
            var articulosHTML = ArticulosRepository.GetArticulosHTML(Auto);
            if (articulosHTML.Any())
            {
                htmlEditor.Html = articulosHTML.FirstOrDefault().Html;
                htmlEditor.ClientSideEvents.EndCallback = "function(s,e) {imageiframe();}";
                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "imageiframe()", true);
            }
        }
        Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "imageiframe()", true);
    }
}
