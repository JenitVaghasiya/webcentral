<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Precios.aspx.cs" Inherits="mobile_Precios" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Web Central - Mobile</title>
    <meta name="google" content="notranslate" />
<meta http-equiv="content-language" content="es" />
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

        .opacity0 {
            opacity: 0;
        }

        .opacity1 {
            opacity: 1 !important;
        }

        .dxgvStatusBar, .dxgvStatusBar_MaterialCompact, #GridViewPresupuestoActual_DXStatus {
            display: none;
        }

        .smallfont10size {
            font-size: 11px !important;
        }

        .navbar-brand {
            width: 140px !important;
        }
    </style>
    <script type="text/javascript">
       function toggleFullScreen() {
  var doc = window.document;
  var docEl = doc.documentElement;

  var requestFullScreen = docEl.requestFullscreen || docEl.mozRequestFullScreen || docEl.webkitRequestFullScreen || docEl.msRequestFullscreen;
  var cancelFullScreen = doc.exitFullscreen || doc.mozCancelFullScreen || doc.webkitExitFullscreen || doc.msExitFullscreen;

  if(!doc.fullscreenElement && !doc.mozFullScreenElement && !doc.webkitFullscreenElement && !doc.msFullscreenElement) {
    requestFullScreen.call(docEl);
  }
  else {
    cancelFullScreen.call(doc);
  }
}

        // Launch fullscreen for browsers that support it!
         // the whole page

        setTimeout(toggleFullScreen(), 2000);
    </script>
</head>
<body>
    <form runat="server">
        <asp:ScriptManager ID="spmngr" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
        <asp:UpdatePanel runat="server" EnableViewState="true" ID="UpdatePanel" ClientIDMode="AutoID" ChildrenAsTriggers="true" RenderMode="Inline" UpdateMode="Always">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="gridViewArtículo" />
            </Triggers>
            <ContentTemplate>
                <script type="text/javascript">
                    function OnInit(s, e) {
                        AdjustSize();
                    }
                    function OnEndCallback(s, e) {
                        //  AdjustSize();
                    }
                    function OnControlsInitialized(s, e) {
                        ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                            AdjustSize();
                        });
                    }
                    function AdjustSize() {
                        var clientheight = document.documentElement.clientHeight;
                        var height = 0.00;

                        if (clientheight >= 600 && clientheight <= 768) {
                            height = Math.max(0, document.documentElement.clientHeight * 0.47);
                        }
                        else {
                            height = Math.max(0, document.documentElement.clientHeight * 0.58);
                        }

                        gridViewArtículo.SetHeight(height - 40);
                        gridViewGroupFamily.SetHeight(height);
                    }
                    function SelectArticle(index) {
                        GridViewPresupuestoActual.PerformCallback(index);
                        return false;
                    }

                    function OnBatchEditingGrid(index, updatedValue) {
                        GridViewPresupuestoActual.PerformCallback(index + ",Update," + updatedValue);
                        gridViewArtículo.SetFocusedRowIndex(index);
                    }

                    function onBtnSave() {
                        if (GridViewPresupuestoActual.pageRowCount > 0) {
                            GridViewPresupuestoActual.PerformCallback(GridViewPresupuestoActual.pageRowCount + ",Save");
                            pcSave.Hide();
                            window.location.reload();
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

                    $(document).ready(function () {
                        $("#divgrupoandfamili").hide();
                        $("#divarticulo").show();
                    });

                    function divbtnarticulo() {
                        $("#divgrupoandfamili").hide();
                        $("#divarticulo").show();
                    }

                    function divbtngrupoandfamili() {
                        $("#divgrupoandfamili").show();
                        $("#divarticulo").hide();
                    }

                    function OnSelectionChangedGrupo(s, e) {
                        e.processOnServer = false;
                        divbtngrupoandfamili();
                        callbackPanel.PerformCallback();
                    }

                    function OnInitFocus(s, e) {
                        e.processOnServer = false;
                        s.SetFocusedRowIndex(s.focusedRowIndex);
                        s.MakeRowVisible(s.focusedRowIndex);
                        delete s.focusedRowIndex;
                    }
                </script>
                <nav class="navbar navbar-inverse navbar-fixed-top">
                    <div class="container">
                        <div class="navbar-header">
                            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#topMenu">
                                <span class="sr-only">Toggle navigation</span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                            </button>
                            <a class="navbar-brand" href="#">Web Central</a>
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
                <br />
                <div class="container">
                    <div class="row" id="divarticulo" style="display: block;">
                        <div style="padding-top: 40px !important; padding-bottom: 25px;">
                            <div class="col-md-5 col-sm-5 col-xs-5">
                                <button style="" class="btn btn-success dxbs-button" id="btngrupoandfamili" type="button" name="btngrupoandfamili" value="Grupo & Familia" onclick="divbtngrupoandfamili(); return false;">Grupo & Familia</button>
                            </div>
                            <div class="col-md-7 col-sm-7 col-xs-7">
                                <%--<button class="btn btn-info dxbs-button" id="btnselectallitem" type="button" name="btnselectallitem" value="seleccionar todos los artículos" runat="server" oncli>seleccionar todos los artículos</button>--%>
                                <dx:ASPxButton CssClass="btn btn-info dxbs-button" ClientInstanceName="btnselectAllFamili" ID="btnselectAllFamili" runat="server" Text="Todos los artículos" AutoPostBack="false" OnClick="btnsearchArticulo_Click"></dx:ASPxButton>
                            </div>
                        </div>
                        <br />
                        <div class="col-md-12">
                            <dx:ASPxGridView SettingsDetail-AllowOnlyOneMasterRowExpanded="true" ClientInstanceName="gridViewArtículo" Width="100%" ID="GridViewArtículo" runat="server" KeyFieldName="AutoArtículo" AutoGenerateColumns="False" OnCustomUnboundColumnData="GridViewArtículo_CustomUnboundColumnData" EnableCallBacks="true">
                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />


                                <SettingsDataSecurity AllowInsert="False" />
                                <SettingsSearchPanel Visible="true"  ColumnNames="Desg" ShowApplyButton="true"  SearchInPreview="false" />
                                                                <Styles Cell-CssClass="smallfont10size" >
                                    <Cell CssClass="smallfont10size"></Cell>
                                    <Header CssClass="smallfont13size"></Header>
                                </Styles>
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="AutoArtículo" Caption="#" Width="3" BatchEditModifiedCellStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Center">
                                        <EditFormSettings Visible="False" />
                                        <DataItemTemplate>
                                            <dx:ASPxHyperLink ID="linkselect" runat="server" Text="S" OnInit="linkselect_Init" CssClass="select">
                                            </dx:ASPxHyperLink>
                                        </DataItemTemplate>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AutoArtículo" Caption="#" Width="2" BatchEditModifiedCellStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Center">
                                        <EditFormSettings Visible="False" />
                                        <DataItemTemplate>
                                            <dx:ASPxHyperLink ID="linkphoto" runat="server" Text="F" OnInit="linkPhoto_Init" CssClass="select">
                                            </dx:ASPxHyperLink>
                                        </DataItemTemplate>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Fecha" Caption="Fecha" Width="15px" PropertiesTextEdit-DisplayFormatString="dd-MMM-yyy" Visible="false">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Desg" Width="9" Caption="Descripción">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AutoFilterCondition="Like" ShowFilterRowMenuLikeItem="True" AllowAutoFilter="True" FilterMode="DisplayText" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Artículo" Width="2" Visible="false">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Neto" Width="4" Caption="Neto" UnboundType="Decimal" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Artículonum" Width="6" Caption="Anter" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="Precio" Width="6" Caption="Precio" UnboundType="Decimal" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Dto" Width="6" Caption="Dto" UnboundType="Decimal" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="PercenImpuesto" Width="6" Caption="Igic" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="PrecioIgic" Width="6" Caption="Precio+Igic" UnboundType="Decimal" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="NetoIgic" Width="6" Caption="Neto+Igic" UnboundType="Decimal" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AutoFamilia" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="OrdenCatalogo" Visible="false" VisibleIndex="0">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Impuesto" Visible="false" VisibleIndex="1">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ClasedeArtículo" Visible="false" VisibleIndex="2">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AutoArtículo" Visible="false" VisibleIndex="3" />
                                    <dx:GridViewDataTextColumn FieldName="editorAuto" Visible="false" />
                                </Columns>
                                <Settings ShowGroupPanel="false" VerticalScrollBarMode="Visible" VerticalScrollableHeight="130" />
                                <SettingsPager Mode="EndlessPaging" PageSize="10" />
                            </dx:ASPxGridView>
                        </div>
                        <br />
                        <div class="col-md-12">
                            <dx:ASPxGridView OnCustomCallback="GridViewPresupuestoActual_CustomCallback" Width="100%" ID="GridViewPresupuestoActual" runat="server" KeyFieldName="AutoArtículo" AutoGenerateColumns="False" OnCustomUnboundColumnData="GridViewPresupuestoActual_CustomUnboundColumnData" EnableCallBacks="true" ClientInstanceName="GridViewPresupuestoActual"
                                OnCustomButtonCallback="GridViewPresupuestoActual_CustomButtonCallback">
                                <SettingsLoadingPanel Mode="ShowAsPopup" />

                                <SettingsBehavior AllowSort="false" AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                                <SettingsEditing Mode="Batch" NewItemRowPosition="Bottom">
                                    <BatchEditSettings EditMode="Cell" StartEditAction="Click" ShowConfirmOnLosingChanges="False" />
                                </SettingsEditing>

                                <Styles Cell-CssClass="smallfont10size">
                                    <Cell CssClass="smallfont10size"></Cell>
                                    <Header CssClass="smallfont13size"></Header>
                                </Styles>
                                <ClientSideEvents FocusedRowChanged="OnInitFocus" BatchEditEndEditing="function(s,e) { OnBatchEditingGrid(s.lastMultiSelectIndex,e.rowValues[3].value); }" />
                                <Columns>
                                    <dx:GridViewCommandColumn VisibleIndex="0" Width="35">
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="btnDelete" Text=" "  Visibility="AllDataRows">
                                                <Image Url="../Image/delete.png" Width="20"></Image>
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                    </dx:GridViewCommandColumn>
                                    <dx:GridViewDataTextColumn FieldName="Artículo" VisibleIndex="2" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Desg" Width="100" VisibleIndex="3" Caption="Descripción">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Cantidad" VisibleIndex="4" Width="50">
                                        <PropertiesTextEdit DisplayFormatString="n" DisplayFormatInEditMode="true" Width="50">
                                            <ValidationSettings Display="Dynamic" RequiredField-IsRequired="true" />
                                            <Style CssClass="smallfont10size"></Style>
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Precio" Caption="Precio" VisibleIndex="5" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Dto" Caption="Dto" VisibleIndex="6" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Neto" Caption="Neto" VisibleIndex="7" Width="30" PropertiesTextEdit-DisplayFormatString="{0:n}" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="PercenImpuesto" Caption="Igic" VisibleIndex="8" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="PrecioIgic" Caption="Precio+Igic" VisibleIndex="9" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="NetoIgic" Caption="Neto+Igic" VisibleIndex="10" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Importe" Caption="Importe" UnboundType="Decimal" VisibleIndex="11" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ImporteNeto" Caption="Importe Neto" UnboundType="Decimal" Width="70" VisibleIndex="12" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AutoFamilia" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="OrdenCatalogo" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Impuesto" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ClasedeArtículo" Visible="false">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AutoArtículo" Visible="false">
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <Settings ShowStatusBar="Visible" VerticalScrollBarMode="Auto" VerticalScrollableHeight="160" ShowGroupPanel="false" ShowFooter="true" ShowFilterRowMenu="true" />
                                <SettingsPager PageSize="300" Mode="EndlessPaging"></SettingsPager>
                                <TotalSummary>
                                    <dx:ASPxSummaryItem FieldName="AutoArtículo" ShowInColumn="Desg" DisplayFormat="Total:" SummaryType="Sum" />
                                    <dx:ASPxSummaryItem FieldName="Cantidad" SummaryType="Sum" DisplayFormat="{0}" />
                                    <%--<dx:ASPxSummaryItem FieldName="Neto" SummaryType="Sum" DisplayFormat="{0:n2}" />--%>
                                    <%--<dx:ASPxSummaryItem FieldName="Importe" SummaryType="Sum" DisplayFormat="Total:{0:c2}" />--%>
                                    <dx:ASPxSummaryItem FieldName="ImporteNeto" SummaryType="Sum" DisplayFormat="{0:n}" />
                                </TotalSummary>
                                <SettingsDataSecurity AllowDelete="true" AllowEdit="true" AllowInsert="True" />
                            </dx:ASPxGridView>
                            <div style="margin-top: 5px">
                                <div class="col-xs-9" style="padding: 4px;">
                                    <dx:BootstrapButton ID="btnsave" runat="server" EnableTheming="False" Text="Guardar este presupuesto"
                                        AllowFocus="False" AutoPostBack="False" ClientInstanceName="btnsave">
                                        <ClientSideEvents Click="function(s, e) { if(GridViewPresupuestoActual.pageRowCount > 0) {ShowSaveWindow();return false;} else {alert('Se requiere un mínimo de un artículo.'); }}" />
                                        <SettingsBootstrap RenderOption="Primary" />
                                    </dx:BootstrapButton>
                                </div>
                                <div class="col-xs-3" style="padding: 4px;">
                                    <dx:BootstrapButton ID="btnComprar" runat="server" EnableTheming="False" Text="Comprar"
                                        AllowFocus="False" AutoPostBack="False" ClientInstanceName="btnComprar">
                                        <ClientSideEvents Click="function(s, e) { if(GridViewPresupuestoActual.pageRowCount > 0) {ShowComprarWindow(); return false;} else {alert('Se requiere un mínimo de un artículo.'); }}" />
                                        <SettingsBootstrap RenderOption="Primary" />
                                    </dx:BootstrapButton>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="divgrupoandfamili" style="display: none;">
                        <div class="col-md-12" style="padding-top: 40px !important; padding-bottom: 5px;">
                            <div class="btn-toolbar">
                                <button class="btn btn-success dxbs-button" id="btnarticulo" type="button" name="btnarticulo" value="Volver a la lista de artículos" onclick="divbtnarticulo(); return false;">Volver a la lista de artículos</button>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <dx:ASPxGridView Width="100%" ClientInstanceName="GridViewGroup" ID="GridViewGroup" runat="server" KeyFieldName="Grupo"
                                AutoGenerateColumns="False" EnableTheming="true" EnableCallBacks="false">
                                <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                                <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                <Styles Cell-CssClass="smallfont10size"></Styles>
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="AutoEditor" Caption="Foto" Width="14%">
                                        <EditFormSettings Visible="False" />
                                        <DataItemTemplate>
                                            <dx:ASPxHyperLink ID="linkGroupphoto" runat="server" Text="Foto" OnInit="linkGroupphoto_Init" CssClass="select textdecoration">
                                            </dx:ASPxHyperLink>
                                        </DataItemTemplate>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Categoría">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <Settings VerticalScrollBarMode="Auto" VerticalScrollableHeight="180" ShowGroupPanel="false" ShowFooter="false" ShowFilterRowMenu="true" />
                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                <ClientSideEvents SelectionChanged="OnSelectionChangedGrupo" />
                            </dx:ASPxGridView>
                        </div>
                        <br />
                        <div class="col-md-12">
                            <dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="callbackPanel" runat="server">
                                <PanelCollection>
                                    <dx:PanelContent ID="PanelContent1" runat="server" SupportsDisabledAttribute="True">
                                        <div id="div" runat="server">
                                            <dx:ASPxGridView ClientInstanceName="gridViewGroupFamily" Width="100%" ID="GridViewGroupFamily" runat="server" KeyFieldName="Autofamilia" AutoGenerateColumns="False" SettingsBehavior-ProcessSelectionChangedOnServer="true" EnableTheming="true" OnSelectionChanged="GridViewGroupFamily_SelectionChanged" EnableCallBacks="false">
                                                <SettingsLoadingPanel Mode="ShowAsPopup" />
                                                <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                                                <SettingsSearchPanel Visible="True" />
                                                <Styles Cell-CssClass="smallfont10size"></Styles>
                                                <Columns>
                                                    <dx:GridViewDataTextColumn FieldName="AutoEditor" Caption="Foto" Width="14%">
                                                        <EditFormSettings Visible="False" />
                                                        <DataItemTemplate>
                                                            <dx:ASPxHyperLink ID="linkfamiliphoto" runat="server" Text="Foto" OnInit="linkfamiliphoto_Init" CssClass="select textdecoration">
                                                            </dx:ASPxHyperLink>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="Descripción" Caption="Familia">
                                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                                    </dx:GridViewDataTextColumn>
                                                </Columns>
                                                <Settings VerticalScrollBarMode="Auto" VerticalScrollableHeight="150" ShowGroupPanel="false" ShowFooter="false" ShowFilterRowMenu="true" />
                                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                            </dx:ASPxGridView>
                                        </div>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxCallbackPanel>
                        </div>
                    </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <dx:ASPxPopupControl ID="pcSave" runat="server" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcSave"
            HeaderText="Indique el nombre del presupuesto:" AllowDragging="True" PopupAnimationType="None" EnableViewState="False" HeaderStyle-Font-Size="12">
            <ClientSideEvents PopUp="function(s, e) { ASPxClientEdit.ClearGroup('entryGroup'); tbDescription.Focus(); }" />
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxPanel ID="Panel1" runat="server" DefaultButton="btOK">
                        <PanelCollection>
                            <dx:PanelContent runat="server">
                                <table>
                                    <tr>
                                        <td rowspan="4">
                                            <div class="pcmSideSpacer">
                                            </div>
                                        </td>
                                        <td class="pcmCellCaption">
                                            <dx:ASPxLabel ID="lblDescription" runat="server" Text="NOMBRE DEL PRESUPUESTO:" AssociatedControlID="tbDescription" Font-Size="9">
                                            </dx:ASPxLabel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="pcmCellText">
                                            <dx:ASPxTextBox ID="tbDescription" runat="server" Width="150px" ClientInstanceName="tbDescription">
                                                <ValidationSettings EnableCustomValidation="True" SetFocusOnError="True"
                                                    ErrorDisplayMode="Text" ErrorTextPosition="Bottom" CausesValidation="True" ValidationGroup="entryGroup">
                                                    <RequiredField ErrorText="Description required" IsRequired="True" />
                                                    <RegularExpression ErrorText="Description required" />
                                                    <ErrorFrameStyle Font-Size="10px">
                                                        <ErrorTextPaddings PaddingLeft="0px" />
                                                    </ErrorFrameStyle>
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td rowspan="4">
                                            <div class="pcmSideSpacer">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <div class="pcmButton">
                                                <dx:ASPxButton ID="btOK" runat="server" Text="OK" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                    <ClientSideEvents Click="function(s, e) { if (ASPxClientEdit.ValidateGroup('entryGroup')){onBtnSave();} }" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="btCancel" runat="server" Text="Cancel" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                    <ClientSideEvents Click="function(s, e) { pcSave.Hide(); }" />
                                                </dx:ASPxButton>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ContentStyle>
                <Paddings PaddingBottom="5px" />
            </ContentStyle>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="pcComprar" runat="server" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcComprar"
            HeaderText="CONFIRMACION DE PEDIDO" AllowDragging="True" PopupAnimationType="None" EnableViewState="False" Width="300">
            <ClientSideEvents PopUp="function(s, e) { ASPxClientEdit.ClearGroup('entryAlmacenGroup'); txtAlmacen.Focus(); }" />
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxPanel ID="ASPxPanel1" runat="server" DefaultButton="btOK">
                        <PanelCollection>
                            <dx:PanelContent runat="server">
                                <table>
                                    <tr>
                                        <td rowspan="4">
                                            <div class="pcmSideSpacer">
                                            </div>
                                        </td>
                                        <td class="pcmCellCaption">Está a punto de realizar una compra definitiva.
												<br />
                                            Su pedido será preparado y podrá pasar a recogerlo.
												<br />
                                            Puede consultar si su pedido está preparado desde la opción CONSULTA DE PRESUPUESTOS
												<br />
                                            Indique donde desea recoger el pedido:
												<br />
                                            &nbsp;&nbsp;&nbsp;1 - Las Palmas
												<br />
                                            &nbsp;&nbsp;&nbsp;2 - Salinetas
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="pcmCellText">
                                            <dx:ASPxTextBox ID="txtAlmacen" runat="server" Width="150px" ClientInstanceName="txtAlmacen">
                                                <ValidationSettings EnableCustomValidation="True" SetFocusOnError="True"
                                                    ErrorDisplayMode="Text" ErrorTextPosition="Bottom" CausesValidation="True" ValidationGroup="entryAlmacenGroup">
                                                    <RequiredField ErrorText="Almacen required" IsRequired="True" />
                                                    <RegularExpression ErrorText="Almacen required" />
                                                    <ErrorFrameStyle Font-Size="10px">
                                                        <ErrorTextPaddings PaddingLeft="0px" />
                                                    </ErrorFrameStyle>
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td rowspan="4">
                                            <div class="pcmSideSpacer">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <div class="pcmButton">
                                                <dx:ASPxButton ID="btnOkAlmacen" runat="server" Text="OK" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                    <ClientSideEvents Click="function(s, e) { if (ASPxClientEdit.ValidateGroup('entryAlmacenGroup')){onBtnAlmacen();} }" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="btnCancelAlmacen" runat="server" Text="Cancel" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                    <ClientSideEvents Click="function(s, e) { pcComprar.Hide(); }" />
                                                </dx:ASPxButton>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ContentStyle>
                <Paddings PaddingBottom="5px" />
            </ContentStyle>
        </dx:ASPxPopupControl>
    </form>
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
</body>
</html>
