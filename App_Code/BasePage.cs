using System;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

public class BasePage : System.Web.UI.Page
{
    protected override void InitializeCulture()
    {
        CultureInfo c = new CultureInfo("es-ES");
        c.NumberFormat.NumberDecimalSeparator = ",";
        c.NumberFormat.NumberGroupSeparator = ".";
        System.Threading.Thread.CurrentThread.CurrentCulture = c;
        base.InitializeCulture();
    }
    public bool IsMobile = false;

    protected void Page_Init(object sender, EventArgs e)
    {
        





    }
}