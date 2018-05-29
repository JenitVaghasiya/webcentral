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
using DevExpress.Web.ASPxHtmlEditor;
public partial class editornew : System.Web.UI.Page
{
    protected void Page_Load(Object sender, EventArgs e)
    {
        if (!this.IsPostBack)
        {
            txtConcepto.Text = string.Empty;
            HtmlEditor.Html = string.Empty;
            selectedAuto.Value = Convert.ToString(0);
            pcHTMLEditor.ShowOnPageLoad = false;
            btSave.Text = "Save";


        }

        drpfamilias.DataSource = FamiliasRepository.GetFamiliaByGroup();
        drpfamilias.DataBind();

        gridarticulosHTML.DataSource = ArticulosRepository.GetArticulosHTML();
        gridarticulosHTML.DataBind();
    }

    protected void gridarticulosHTML_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
    {

        txtConcepto.Enabled = true;
        HtmlEditor.Enabled = true;
        btSave.Visible = true;
        if (e.ButtonID == "btnEdit")
        {
            var selectedRowIndex = e.VisibleIndex;
            var Auto = Convert.ToInt32(gridarticulosHTML.GetRowValues(selectedRowIndex, "Auto"));
            txtConcepto.Text = Convert.ToString(gridarticulosHTML.GetRowValues(selectedRowIndex, "Concepto"));
            HtmlEditor.Html = Convert.ToString(gridarticulosHTML.GetRowValues(selectedRowIndex, "Html"));
            var Autofamilia = Convert.ToString(gridarticulosHTML.GetRowValues(selectedRowIndex, "Autofamilia"));
            drpfamilias.SelectedIndex = -1;
            drpfamilias.Text = "";
            if (!string.IsNullOrEmpty(Autofamilia))
            {
                drpfamilias.Value = Autofamilia;
            }

            selectedAuto.Value = Convert.ToString(Auto);
            btSave.Text = "Update";
            pcHTMLEditor.ShowOnPageLoad = true;
        }
        else if (e.ButtonID == "btnDelete")
        {
            var selectedRowIndex = e.VisibleIndex;
            var Auto = Convert.ToInt32(gridarticulosHTML.GetRowValues(selectedRowIndex, "Auto"));
            ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "ConfirmAlert", " document.getElementById('selectedAuto').value = " + Auto + " ;ConfirmDelete(" + Auto + "); ", true);
        }
        else if (e.ButtonID == "btnShowHtml")
        {
            var selectedRowIndex = e.VisibleIndex;
            var Auto = Convert.ToInt32(gridarticulosHTML.GetRowValues(selectedRowIndex, "Auto"));

            txtConcepto.Text = Convert.ToString(gridarticulosHTML.GetRowValues(selectedRowIndex, "Concepto"));
            HtmlEditor.Html = Convert.ToString(gridarticulosHTML.GetRowValues(selectedRowIndex, "Html"));
            selectedAuto.Value = Convert.ToString(Auto);
            pcHTMLEditor.ShowOnPageLoad = true;
            txtConcepto.Enabled = false;
            HtmlEditor.Enabled = false;
            btSave.Visible = false;
        }
    }

    protected void btSave_Click(object sender, EventArgs e)
    {
        var Auto = 0;
        int.TryParse(Convert.ToString(selectedAuto.Value), out Auto);
        var html = HtmlEditor.Html;
        html = html.Replace("<img", "<img class='imgcls' ");
        html = html.Replace("<head>", "<head><style>.imgcls {width: 80% !important;}</style>");
        // drpfamilias.SelectedItem
        int? familios = null;
        if (Convert.ToString(drpfamilias.Text) != Convert.ToString(drpfamilias.Value))
        {
            familios = Convert.ToInt32(drpfamilias.Value);
        }

        if (Auto > 0)
        {
            ArticulosRepository.UpdateArticulosHTML(Auto, txtConcepto.Text, familios, html);
        }
        else
        {
            ArticulosRepository.InsertArticulosHTML(txtConcepto.Text, familios, html);
        }
        gridarticulosHTML.DataSource = ArticulosRepository.GetArticulosHTML();
        gridarticulosHTML.DataBind();
    }

    protected void btAddNew_Click(object sender, EventArgs e)
    {
        txtConcepto.Enabled = true;
        HtmlEditor.Enabled = true;
        btSave.Visible = true;
        txtConcepto.Text = string.Empty;
        HtmlEditor.Html = string.Empty;
        selectedAuto.Value = "0";
        btSave.Text = "Save";
        drpfamilias.SelectedIndex = -1;
        drpfamilias.Text = "";
        pcHTMLEditor.ShowOnPageLoad = true;
    }

    protected void ASPxDelete_Click(object sender, EventArgs e)
    {
        int Auto = 0;
        int.TryParse(Convert.ToString(selectedAuto.Value), out Auto);
        if (Auto > 0)
        {
            ArticulosRepository.DeleteArticulosHTML(Auto);
        }
        gridarticulosHTML.DataSource = ArticulosRepository.GetArticulosHTML();
        gridarticulosHTML.DataBind();
    }
}