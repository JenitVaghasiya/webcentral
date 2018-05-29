<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeFile="Default.aspx.cs" Inherits="_Default" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHead" runat="server">
    <script>

        //$(document).ready(function () {
        //    var Height = $(window).height();
        //    var Width = $(window).width();

        //    debugger
        //    if (Width < 1200) {
        //        $("#HDFIsMobile").val("1");
        //    }

        //});
        $(function () {
            var Height = $(window).height();
            var Width = $(window).width();


            if (Width < 1200) {
                $("#HDFIsMobile").val("1");
            }

        });
    </script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="server">
    <asp:HiddenField runat="server" ID="HDFIsMobile" Value="0" ClientIDMode="Static"></asp:HiddenField>
    <div class="container">
        <br />
        <br />
        <br />
        <div class="row">

            <div class="col-xs-6 col-md-3">


                <dx:ASPxButton ID="ASPxButton4" Paddings-PaddingLeft="30" runat="server" Width="80" PostBackUrl="precios.aspx" Image-Height="80" Image-Width="80" RenderMode="Link" Image-ToolTip="Precios y crear presupuesto" Image-Url="~/image/precios.png" Image-UrlPressed="~/image/precios.png" Image-UrlHottracked="~/image/precios.png" Font-Bold="false" Text="PRECIOS" VerticalAlign="Middle" ImagePosition="Top" Theme="Moderno" Paddings-PaddingBottom="20" Font-Size="Larger" Font-Names="Trajan pro"></dx:ASPxButton>
 


            </div>
           

            <div class="col-xs-6  col-md-3">
                <dx:ASPxButton ID="ASPxButton12" Paddings-PaddingLeft="30" runat="server" RenderMode="Link" Width="80" PostBackUrl="presupuestoslist.aspx" Image-Height="80" Image-Width="80" Image-Url="image/presupuestos.png" Image-UrlPressed="image/presupuestos.png" Image-UrlHottracked="image/presupuestos.png" Font-Bold="false" Text="PRESUPUESTOS" VerticalAlign="Middle" ImagePosition="Top" Theme="Moderno" Paddings-PaddingBottom="20" Font-Size="Larger" Font-Names="Trajan pro"></dx:ASPxButton>
            </div>
            <div class="col-xs-6 col-md-3">
                <dx:ASPxButton ID="ASPxButton2" Paddings-PaddingLeft="30" Width="80" Image-Height="80" Image-Width="80" RenderMode="Link" runat="server" PostBackUrl="facturas.aspx" Image-Url="~/image/facturas.png" Image-UrlPressed="~/image/facturas.png" Image-UrlHottracked="~/image/facturas.png" Font-Bold="false" Text="FACTURAS" VerticalAlign="Middle" ImagePosition="Top" Theme="Moderno" Paddings-PaddingBottom="20" Font-Size="Larger" Font-Names="Trajan pro"></dx:ASPxButton>
            </div>
            <div class="col-xs-6 col-md-3">
                <dx:ASPxButton ID="ASPxButton5" Paddings-PaddingLeft="30" Width="80" Image-Height="80" Image-Width="80" RenderMode="Link" runat="server" PostBackUrl="albaranes.aspx" Image-Url="~/image/albaranes.png" Image-UrlPressed="~/image/albaranes.png" Image-UrlHottracked="~/image/albaranes.png" Font-Bold="false" Text="ALBARANES" VerticalAlign="Middle" ImagePosition="Top" Theme="Moderno" Paddings-PaddingBottom="20" Font-Size="Larger" Font-Names="Trajan pro"></dx:ASPxButton>
            </div>

            <div class="col-xs-6 col-md-3">
                <dx:ASPxButton ID="ASPxButton3" Paddings-PaddingLeft="30" Width="80" Image-Height="80" Image-Width="80" RenderMode="Link" PostBackUrl="editornew.aspx" runat="server" Image-Url="~/image/crear.png" Image-UrlPressed="~/image/crear.png" Image-UrlHottracked="~/image/crear.png" Font-Bold="false" Text="CREAR HTML" VerticalAlign="Middle" ImagePosition="Top" Theme="Moderno" Paddings-PaddingBottom="20" Font-Size="Larger" Font-Names="Trajan pro"></dx:ASPxButton>
            </div>
            <div class="col-xs-6 col-md-3">
                <dx:ASPxButton ID="ASPxButtonCLI" Paddings-PaddingLeft="30" Width="80" Image-Height="80" Image-Width="80" RenderMode="Link" PostBackUrl="ClienteList.aspx" runat="server" Image-Url="~/image/crear.png" Image-UrlPressed="~/image/crear.png" Image-UrlHottracked="~/image/crear.png" Font-Bold="false" Text="CLIENTES" VerticalAlign="Middle" ImagePosition="Top" Theme="Moderno" Paddings-PaddingBottom="20" Font-Size="Larger" Font-Names="Trajan pro"></dx:ASPxButton>
            </div>
        </div>
    </div>


</asp:Content>
