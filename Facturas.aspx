<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Facturas.aspx.cs" Inherits="Facturas"  UICulture="es-ES" Culture="es-ES"%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHead" runat="server">
    <script>
        $(function () {
            var Height = $(window).height();
            var Width = $(window).width();


            if (Width < 1200) {
                window.location.href = "/mobile/Facturas.aspx";
            }

        });
    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="Server">
    <asp:ScriptManager ID="spmngr" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
    <asp:UpdatePanel runat="server" EnableViewState="true" ID="UpdatePanel" ClientIDMode="AutoID" ChildrenAsTriggers="true" RenderMode="Inline" UpdateMode="Always">
        <ContentTemplate>
            <script type="text/javascript">
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
                }

                function OnInit(s, e) {
                    AdjustSize();
                }

                function AdjustSize() {
                    var clientheight = document.documentElement.clientHeight;
                    var height = 0.00;
                    height = Math.max(0, document.documentElement.clientHeight * 0.38);

                    GridViewFacturas.SetHeight(height);
                    GridViewFacturasDetail.SetHeight(height);
                }

                function OnControlsInitialized(s, e) {
                    ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                        AdjustSize();
                    });
                }

                function OnRowDoubleClick(s, e) {
                    
                    s.GetRowValues(e.visibleIndex, 'SerieAlbaran', function (value) {
                        window.location.href = "/Albaranes.aspx?albarane=" + value;
                    });
                }
            </script>
            <br />
            <div>
                <div class="row searchtab" style="padding-bottom: 15px;">
                    <div class="col-md-12">
                        <div class="col-md-2 col-sm-6 col-xs-6">
                            FACTURA:
                            <dx:ASPxTextBox ClientInstanceName="searchfectura" ID="searchfectura" runat="server" Width="130" >
                                <ClientSideEvents KeyDown="function(s, e) { SearchByFectura(event);}" KeyPress="function(s, e) { SearchByFectura(event);}" KeyUp="function(s, e) { SearchByFectura(event);}" />
                            </dx:ASPxTextBox>
                        </div>
                        <div class="col-md-3 col-sm-6 col-xs-6">
                            DESDE FECHA:
                            <dx:ASPxDateEdit ID="dtfromDate" runat="server"  OnInit="dtfromDate_Init" ClearButton-DisplayMode="Always">
                                <ClientSideEvents CloseUp="function(s, e) { SearchByDate();}" DateChanged="function(s, e) { SearchByDate();}" />
                            </dx:ASPxDateEdit>
                        </div>
                        <div class="col-md-3 col-sm-6 col-xs-6">
                            HASTA FECHA:
                            <dx:ASPxDateEdit ID="dttoDate" runat="server"  OnInit="dttoDate_Init" ClearButton-DisplayMode="Always">
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
                <div class="col-md-12">
                    <dx:ASPxGridView ClientInstanceName="GridViewFacturas" Width="100%" ID="GridViewFacturas" runat="server" KeyFieldName="SerieFactura"
                        AutoGenerateColumns="False" SettingsBehavior-ProcessSelectionChangedOnServer="true" EnableTheming="true"
                        OnSelectionChanged="GridViewFacturas_SelectionChanged" OnCustomCallback="GridViewFacturas_CustomCallback"
                        EnableCallBacks="false" >
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
                            <dx:GridViewDataTextColumn FieldName="TotalFactura" Caption="Total Factura" PropertiesTextEdit-DisplayFormatString="{0:n}" >
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
                </div>
                <br />
                <div class="col-md-12" style="margin-top: 10px;">
                    <dx:ASPxGridView ClientInstanceName="GridViewFacturasDetail"  Width="100%" ID="GridViewFacturasDetail" runat="server"
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
                        <ClientSideEvents Init="OnInit" RowDblClick="OnRowDoubleClick" />
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="SerieAlbaran" Caption="Albaran" Width="12%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Fecha" Caption="Fecha" Width="15%" PropertiesTextEdit-DisplayFormatString="dd-MMM-yyyy" Visible="false">
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
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

