using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Imageviewer : System.Web.UI.Page
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
        
        if (!IsPostBack)
        {
            string val = string.IsNullOrWhiteSpace(Request.QueryString["id"]) ? "0" : Request.QueryString["id"];
            string year = string.IsNullOrWhiteSpace(Request.QueryString["year"]) ? "0" : Request.QueryString["year"];
            string month = string.IsNullOrWhiteSpace(Request.QueryString["month"]) ? "0" : Request.QueryString["month"];
              string date = string.IsNullOrWhiteSpace(Request.QueryString["date"]) ? "0" : Request.QueryString["date"];
             month = Request.QueryString["month"].PadLeft(2, '0');
             date = Request.QueryString["date"].PadLeft(2, '0');
            string path = "\\Image\\factor2010\\albaranes\\Dropbox\\" + year.Substring(year.Length - 2) + "\\" + month + "\\" + date + "\\";

            var cliente = (Clientes)Session["User"];

            if (AlbaranRepository.CheckAlbaranosverIdforImage(val, cliente.AutoCliente) > 0)
            {

                DirSearch(@"" + Server.MapPath(path), val, path);

            }
            else
            { Response.Redirect("~/Albaranes.aspx"); }
            
        }


        //string[] dirs = Directory.GetDirectories("C:\factor2010\albaranes");

        //foreach (string item2 in dirs)
        //{
        //    FileInfo f = new FileInfo(item2);
        //}
    }
    void DirSearch(string sDir, string filename, string path)
    {

        try
        {
            DataTable dt = new DataTable("Items");

            dt.Columns.Add("Id");
            dt.Columns.Add("ImageUrl");
            dt.Columns.Add("MediumImageUrl");
            dt.Columns.Add("ThumbnailUrl");
            dt.Columns.Add("Rating");
            dt.Columns.Add("Text");
            int i = 0;
       
   
            foreach (string f in Directory.GetFiles(sDir))
            {

                if (f.Contains(filename))
                {
                    DataRow dr = dt.NewRow();
                    dr["ID"] = i;
                    dr["ImageUrl"] = path + Path.GetFileName(f);
                    dr["MediumImageUrl"] = path + Path.GetFileName(f);
                    dr["ThumbnailUrl"] = path + Path.GetFileName(f);
                    dr["Text"] = Path.GetFileName(f);
                    dr["Rating"] = i;
                    dt.Rows.Add(dr);
                    i++;
                }
            }

            //dvGalery.DataSource = dt;
            //dvGalery.DataBind();
            imageGallery.DataSource = dt;
            imageGallery.DataBind();

            //Console.WriteLine(f);
            //foreach (string d in Directory.GetDirectories(sDir))
            //{
            //    foreach (string f in Directory.GetFiles(d))
            //    {
            //        Console.WriteLine(f);
            //    }
            //    DirSearch(d, filename);
            //}
        }
        catch (System.Exception excpt)
        {
            Label1.Text = excpt.ToString ();
            Console.WriteLine(excpt.Message);
        }
    }
}