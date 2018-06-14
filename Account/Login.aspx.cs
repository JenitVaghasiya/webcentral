using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

public partial class Account_Login : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void LogIn(object sender, EventArgs e)
    {
        if (IsValid)
        {
                var clientesRepository = new ClientesRepository();
               var cliente = clientesRepository.Sigin(UserName.Text, Password.Text);
         //   var cliente= logear(UserName.Text, Password.Text);
           if (cliente != null)
         //   if(cliente >0)
            {
                Session["User"] = cliente;
                if (cliente.AutoCliente.ToString () == "908795") Session["Vendedor"] = true;
                if (cliente.AutoCliente.ToString() == "908798") Session["Vendedor"] = true;
                if (cliente.AutoCliente.ToString() == "908799") Session["Vendedor"] = true;
                Response.Redirect("/default.aspx");
            }
            else
            {
                FailureText.Text = "Invalid username or password.";
                ErrorMessage.Visible = true;
            }
        }
    }
    public static int logear(string UserName, string Password)
    {
        SqlConnection conn;
        SqlCommand cmd;
        int usuario = 0;
        try
        {
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conn.Open();

            cmd = new SqlCommand("SELECT [Auto Cliente]  FROM Clientes WHERE [Código] = @Código AND [Password Web] = @PasswordWeb ", conn);
            cmd.Parameters.Add("@Código", System.Data.SqlDbType.VarChar, 10);
            cmd.Parameters["@Código"].Value = UserName;
            cmd.Parameters.Add("@PasswordWeb", System.Data.SqlDbType.VarChar, 50);
            cmd.Parameters["@PasswordWeb"].Value = Password;

            usuario = (int)cmd.ExecuteScalar();

            cmd.Dispose();
            conn.Dispose();
        }
        catch (Exception ex)
        {
            System.Diagnostics.Trace.WriteLine("[ValidateUser] Exception " + ex.Message);
        }
        return usuario;
    }
}