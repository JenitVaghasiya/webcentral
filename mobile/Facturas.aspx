<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="Facturas.aspx.cs" Inherits="mobile_Facturas" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no, minimal-ui">
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    <link href="~/Content/bootstrap.min.css" rel="stylesheet" />
    <link href="~/Content/Site.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro" rel="stylesheet" />
    <script type="text/javascript" src="/Scripts/jquery-1.12.2.min.js"></script>
    <script type="text/javascript" src="/Scripts/bootstrap.min.js"></script>
    <style type="text/css">
        body {
            font-family: 'Source Sans Pro' !important;
        }

        .btn {
            padding: 6px !important;
        }

        .width100, .dxgvADT {
            width: 100%;
        }

        .opacity01 {
            opacity: 0.2;
        }

        .opacity1 {
            opacity: 1 !important;
        }

        .dxgvStatusBar, .dxgvStatusBar_MaterialCompact, #GridViewPresupuestoActual_DXStatus {
            display: none;
        }

        .smallfont10size {
            font-size: 13px !important;
        }
    </style>
    
</head>
<body>
    <form id="form1" runat="server">

        <asp:ScriptManager ID="spmngr" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
        <asp:UpdatePanel runat="server" EnableViewState="true" ID="UpdatePanel" ClientIDMode="AutoID" ChildrenAsTriggers="true" RenderMode="Inline" UpdateMode="Always">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="GridViewFacturas" />
            </Triggers>
            <ContentTemplate>

                <script type="text/javascript">
                    function ShowPopup() {
                        $("#btnShowPopup").click();
                    }
                    function divShow(divName) {

                        showLoader();
                        $("#gridgrupo").hide();
                        $("#gridfamilia").hide();
                        
                        

                        $(".gridgrupo").removeClass("opacity1");
                        $(".gridfamilia").removeClass("opacity1");
                        
                        

                        $(".gridgrupo").addClass("opacity01");
                        $(".gridfamilia").addClass("opacity01");
                        
                        

                        //AdjustSize();
                        $(divName).show();
                        var getclass = divName.replace('#', '.');
                        $(getclass).addClass("opacity1");
                        $(getclass).removeClass("opacity01");
                        var url = window.location.href;
                        var hash = location.hash;
                        url = url.replace(hash, '');
                        window.location.href = url + divName;
                        return false;
                    }

                    function OnControlsInitialized(s, e) {
                        ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                            //window.location.reload();
                        });
                    }

                    

                    function OnInitGroup(s, e) {
                        //AdjustSize();

                        var url = window.location.href;
                        var hash = location.hash;
                        url = url.replace(hash, '');
                        if (hash == "") {
                            hash = "#gridgrupo";
                        }

                        divShow(hash);
                    }

                    function OnSelectionChangedGroup(s, e) {
                        showLoader();
                        var url = window.location.href;
                        var hash = location.hash;
                        url = url.replace(hash, '');
                        var divName = "#gridfamilia";
                        divShow(divName);
                        window.location.href = url + divName;
                    }

                    function OnSelectionChangedFamilia(s, e) {
                        showLoader();
                        var url = window.location.href;
                        var hash = location.hash;
                        url = url.replace(hash, '');                       

                    }

                    function OnSelectionChangedArtículo(s, e) {

                    }

                    function showLoader() {
                        if (LoadingPanel != undefined) {
                            LoadingPanel.Show();

                            setTimeout(function () { hideLoader(); }, 2000);
                        }
                    }

                    function hideLoader() {
                        LoadingPanel.Hide();
                    }

                   
                    function OnBatchEditingGrid(index, updatedValue) {
                        GridViewPresupuestoActual.PerformCallback(index + ",Update," + updatedValue);
                    }
                    function onBtnSave() {
                        if (GridViewPresupuestoActual.pageRowCount > 0) {
                            GridViewPresupuestoActual.PerformCallback(GridViewPresupuestoActual.pageRowCount + ",Save");
                            pcSave.Hide();
                        }
                        else {
                            pcSave.Hide();
                        }
                    }

                    function ShowSaveWindow() {
                        pcSave.Show();
                        return false;
                    }

                    function onBtnAlmacen() {
                        if (txtAlmacen.lastChangedValue == "1" || txtAlmacen.lastChangedValue == "2") {
                            pcComprar.Hide();
                            ShowSaveWindow();
                        }
                        else {
                            alert('No se ha creado el pedido');
                        }
                    }

                    function ShowComprarWindow() {
                        pcComprar.Show();
                        return false;
                    }

                    function RefreshPage() {
                        showLoader();
                        var url = window.location.href;
                        var hash = location.hash;
                        url = url.replace(hash, '');
                        hash = "#gridgrupo";
                        window.location.href = url + hash;
                    }
                    function SearchByAlbaran(e) {

                        if (e != undefined) {
                            if (e.keyCode == 13) {
                                //var text = searchalbaran.GetText();

                                GridViewFacturas.PerformCallback("searchalbaran");
                            }
                        }
                        else {
                            GridViewFacturas.PerformCallback("searchalbaran");
                        }
                    }

                    function SearchByFectura(e) {
                        if (e != undefined) {
                            if (e.keyCode == 13) {
                                GridViewFacturas.PerformCallback("searchfectura");
                            }
                        }
                        else {
                            GridViewFacturas.PerformCallback("searchfectura");
                        }
                    }

                    function SearchByDate() {
                        GridViewFacturas.PerformCallback("date");
                    }

                    function ShowAll() {
                        GridViewFacturas.PerformCallback();
                        $("#gridgrupo").css("display", "block");
                    }

                    function OnInit(s, e) {
                        AdjustSize();
                    }

                    function AdjustSize() {
                        var clientheight = document.documentElement.clientHeight;
                        var height = 0.00;
                        height = Math.max(0, document.documentElement.clientHeight * 0.40);

                        GridViewFacturas.SetHeight(height);
                        GridViewFacturasDetail.SetHeight(height);
                    }

                    function OnControlsInitialized(s, e) {
                        ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                            AdjustSize();
                        });
                    }
                </script>
                <br />
                <nav class="navbar navbar-inverse navbar-fixed-top">
                    <div class="container">
                        <div class="navbar-header">
                            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#topMenu">
                                <span class="sr-only">Toggle navigation</span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                            </button>
                            <a class="navbar-brand" href="#">Web Central - Mobile</a>
                        </div>
                        <div class="collapse navbar-collapse" id="topMenu">
                            <dx:BootstrapMenu ID="TopMenu" runat="server" ShowPopOutImages="True" ItemAutoWidth="false" ClientInstanceName="topMenu">
                                <CssClasses Control="top-menu" Menu="navbar-nav" />
                                <Items>
                                    <dx:BootstrapMenuItem Text="Home" Name="Home" NavigateUrl="/">
                                    </dx:BootstrapMenuItem>
                                    <dx:BootstrapMenuItem Text="Login" Name="Login" NavigateUrl="Account/Login.aspx">
                                    </dx:BootstrapMenuItem>
                                </Items>
                            </dx:BootstrapMenu>
                            <dx:BootstrapMenu ID="LogingMenu" runat="server" ShowPopOutImages="True" ItemAutoWidth="false" ClientInstanceName="topMenu">
                                <CssClasses Control="top-menu" Menu="navbar-nav" />
                                <Items>
                                    <dx:BootstrapMenuItem Text="PRECIOS" Name="PRECIOS" NavigateUrl="precios.aspx">
                                    </dx:BootstrapMenuItem>
                                    <dx:BootstrapMenuItem Text="PRESUPUESTOS" Name="PRESUPUESTOS" NavigateUrl="PresupuestosList.aspx">
                                    </dx:BootstrapMenuItem>
                                    <dx:BootstrapMenuItem Text="FACTURAS" Name="FACTURAS" NavigateUrl="Facturas.aspx">
                                    </dx:BootstrapMenuItem>
                                    <dx:BootstrapMenuItem Text="ALBARANES" Name="ALBARANES" NavigateUrl="Albaranes.aspx">
                                    </dx:BootstrapMenuItem>
                                    <dx:BootstrapMenuItem runat="server" Text="LOGOUT" Name="Login" NavigateUrl="~/Account/Logout.aspx">
                                    </dx:BootstrapMenuItem>
                                </Items>
                            </dx:BootstrapMenu>

                        </div>
                    </div>
                </nav>

                <div style="padding-top: 55px !important; padding: 5px;">
                    <div class="btn-toolbar">
                        <button class="btn btn-info dxbs-button gridgrupo" id="btngrupo" type="submit" name="btngrupo" value="Grupo" onclick="divShow('#gridgrupo');return false;">Grupo</button>
                        <button class="btn btn-primary dxbs-button gridfamilia" id="btnfamilia" type="submit" name="btnfamilia" value="Familia" onclick="divShow('#gridfamilia');return false;">Familia</button>
                    </div>
                </div>
                <br />
                <div class="container">
                    <div id="gridgrupo" class="row" runat="server">
                        <div class="row searchtab" style="padding-bottom: 15px;">
                            <div class="col-md-12">
                                <div class="col-md-2 col-sm-6 col-xs-6">
                                    FECTURA:
                            <dx:ASPxTextBox ClientInstanceName="searchfectura" ID="searchfectura" runat="server" Width="130">
                                <ClientSideEvents KeyDown="function(s, e) { SearchByFectura(event);}" KeyPress="function(s, e) { SearchByFectura(event);}" KeyUp="function(s, e) { SearchByFectura(event);}" />
                            </dx:ASPxTextBox>
                                </div>
                                <div class="col-md-3 col-sm-6 col-xs-6">
                                    DESDE FECHA:
                            <dx:ASPxDateEdit ID="dtfromDate" runat="server" OnInit="dtfromDate_Init" ClearButton-DisplayMode="Always">
                                <ClientSideEvents CloseUp="function(s, e) { SearchByDate();}" DateChanged="function(s, e) { SearchByDate();}" />
                            </dx:ASPxDateEdit>
                                </div>
                                <div class="col-md-3 col-sm-6 col-xs-6">
                                    HASTA FECHA:
                            <dx:ASPxDateEdit ID="dttoDate" runat="server" OnInit="dttoDate_Init" ClearButton-DisplayMode="Always">
                                <ClientSideEvents CloseUp="function(s, e) { SearchByDate();}" DateChanged="function(s, e) { SearchByDate();}" />
                            </dx:ASPxDateEdit>
                                </div>
                                <div class="col-md-4 col-sm-6 col-xs-12" style="padding-top: 20px;">
                                    <dx:BootstrapButton ID="BootstrapButton2" runat="server" EnableTheming="False" Text="Todas las facturas del año"
                                        AllowFocus="False" AutoPostBack="False" ClientInstanceName="btnsave">
                                        <ClientSideEvents Click="function(s, e) { ShowAll();}" />
                                        <SettingsBootstrap RenderOption="Primary" />
                                    </dx:BootstrapButton>
                                </div>
                            </div>
                        </div>
                        <br />
                        <div class="col-md-12 searchtab">
                            <dx:ASPxGridView ClientInstanceName="GridViewFacturas" Width="100%" ID="GridViewFacturas" runat="server" KeyFieldName="SerieFactura"
                                AutoGenerateColumns="False" SettingsBehavior-ProcessSelectionChangedOnServer="true" EnableTheming="true"
                                OnSelectionChanged="GridViewFacturas_SelectionChanged" OnCustomCallback="GridViewFacturas_CustomCallback"
                                EnableCallBacks="false">
                                <SettingsLoadingPanel Mode="ShowAsPopup" />
                                <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                                <SettingsSearchPanel Visible="false" />
                                <Styles Cell-CssClass="smallfont13size">
                                    <Cell CssClass="smallfont13size"></Cell>
                                </Styles>
                                <SettingsLoadingPanel Mode="ShowAsPopup" />
                                <Columns>
                                    
                                    <dx:GridViewDataTextColumn FieldName="SerieFactura" Caption="Factura">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Fecha" Caption="Fecha" PropertiesTextEdit-DisplayFormatString="dd-MMM-yyyy">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Neto" Caption="Base" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Descuento" Caption="Descuento" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="impuestos" Caption="Igic" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="TotalFactura" Caption="Total Factura" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <Settings ShowGroupPanel="false" VerticalScrollBarMode="Auto" VerticalScrollableHeight="200" />
                                <SettingsPager Mode="ShowPager" PageSize="10" />
                                <ClientSideEvents Init="OnInit" />
                            </dx:ASPxGridView>

                            <dx:ASPxGlobalEvents ID="ge" runat="server">
                                <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
                            </dx:ASPxGlobalEvents>
                            <%--  <dx:ASPxCallback ID="ASPxCallback1" runat="server" ClientInstanceName="clb"
                                OnCallback="ASPxCallback1_Callback">
                            </dx:ASPxCallback>--%>
                        </div>
                        <br />

                    </div>
                </div>

                <div id="gridfamilia" class="col-md-12" style="display: none;">
                    <div class="col-md-12 GridTab" style="margin-top: 10px;">
                        <dx:ASPxGridView ClientInstanceName="GridViewFacturasDetail" Width="100%" ID="GridViewFacturasDetail" runat="server"
                            KeyFieldName="SerieAlbaran" AutoGenerateColumns="False" EnableCallBacks="false" OnCustomCallback="GridViewFacturasDetail_CustomCallback"
                            OnCustomUnboundColumnData="GridViewFacturasDetail_CustomUnboundColumnData">
                            <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                            <Styles Cell-CssClass="smallfont13size">
                                <Cell CssClass="smallfont13size"></Cell>
                            </Styles>
                            <SettingsDataSecurity AllowInsert="False" />
                            <SettingsSearchPanel Visible="false" />
                            <Settings ShowGroupPanel="false" VerticalScrollBarMode="Auto" VerticalScrollableHeight="200" ShowFooter="true" />
                            <SettingsPager Mode="EndlessPaging" PageSize="10" />

                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="SerieAlbaran" Caption="#" Width="15" BatchEditModifiedCellStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Center">
                                        <EditFormSettings Visible="False" />
                                        <DataItemTemplate>
                                            <dx:ASPxHyperLink ID="linkselect" runat="server" Text="S" OnInit="linkselect_Init" CssClass="select">
                                            </dx:ASPxHyperLink>
                                        </DataItemTemplate>
                                    </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="SerieAlbaran" Caption="Albaran" Width="12%">
                                    <Settings AllowAutoFilter="False"></Settings>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Fecha" Caption="Fecha" Width="15%" PropertiesTextEdit-DisplayFormatString="dd-MMM-yyyy">
                                    <Settings AllowAutoFilter="False"></Settings>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Obra" Caption="Obra" Width="34%">
                                    <Settings AllowAutoFilter="False"></Settings>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="TotalNeto" Caption="Total Neto" Width="10%" UnboundType="Decimal" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                    <Settings AllowAutoFilter="False"></Settings>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="NetoIgic" Caption="Neto+Igic" Width="10%" UnboundType="Decimal" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                    <Settings AllowAutoFilter="False"></Settings>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Vendedor" Caption="Vendedor" Width="20%">
                                    <Settings AllowAutoFilter="False"></Settings>
                                </dx:GridViewDataTextColumn>
                            </Columns>
                            <TotalSummary>
                                <dx:ASPxSummaryItem FieldName="Artículo" ShowInColumn="Auto" DisplayFormat="Total:" SummaryType="Sum" />
                                <dx:ASPxSummaryItem FieldName="TotalNeto" SummaryType="Sum" DisplayFormat="{0:n}" />
                                <dx:ASPxSummaryItem FieldName="NetoIgic" SummaryType="Sum" DisplayFormat="{0:n}" />
                            </TotalSummary>
                        </dx:ASPxGridView>
                    </div>
                </div>
                <div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
</body>
</html>


