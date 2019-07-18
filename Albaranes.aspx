<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Albaranes.aspx.cs" Inherits="Albaranes"  UICulture="es-ES" Culture="es-ES"%>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHead" runat="server">
    <script>
        $(function () {
            var Height = $(window).height();
            var Width = $(window).width();


            if (Width < 1200) {
                window.location.href = "/mobile/Albaranes.aspx";
            }

        });
    </script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="Server">
    <asp:ScriptManager ID="spmngr" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
    <asp:UpdatePanel runat="server" EnableViewState="true" ID="UpdatePanel" ClientIDMode="AutoID" ChildrenAsTriggers="true" RenderMode="Inline" UpdateMode="Always">
        <ContentTemplate>
            <style type="text/css">
                .textdecoration, .textdecoration:hover {
                    text-decoration: none;
                }

                .hidehovercursor {
                    cursor: default;
                }

                .hide {
                    display: none;
                }
            </style>
            <script type="text/javascript">
                function SearchByAlbaran(e) {

                    if (e != undefined) {
                        if (e.keyCode == 13) {
                            //var text = searchalbaran.GetText();

                            GridViewAlbaransver.PerformCallback("searchalbaran");
                        }
                    }
                    else {
                        GridViewAlbaransver.PerformCallback("searchalbaran");
                    }
                }

                function SearchByFectura(e) {
                    if (e != undefined) {
                        if (e.keyCode == 13) {
                            GridViewAlbaransver.PerformCallback("searchfectura");
                        }
                    }
                    else {
                        GridViewAlbaransver.PerformCallback("searchfectura");
                    }
                }

                function SearchByDate() {
                    GridViewAlbaransver.PerformCallback("date");
                }

                function ShowAll() {
                    GridViewAlbaransver.PerformCallback();
                }

                function OnInit(s, e) {
                    AdjustSize();
                }

                function AdjustSize() {
                    var clientheight = document.documentElement.clientHeight;
                    var height = 0.00;
                    height = Math.max(0, document.documentElement.clientHeight * 0.40);

                    GridViewAlbaransver.SetHeight(height);
                    GridViewAlbaransverDetail.SetHeight(height);
                }

                function OnControlsInitialized(s, e) {
                    ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                        AdjustSize();
                    });
                }
            </script>
            <br />
            <div>
                <div class="row searchtab" style="padding-bottom: 15px;">
                    <div class="col-md-12">
                        <div class="col-md-2 col-sm-6 col-xs-6">
                            Albaran:
                        <dx:ASPxTextBox ClientInstanceName="searchalbaran" ID="searchalbaran" runat="server" Width="100px">
                            <ClientSideEvents KeyDown="function(s, e) { SearchByAlbaran(event);}" KeyPress="function(s, e) { SearchByAlbaran(event);}" KeyUp="function(s, e) { SearchByAlbaran(event);}" />
                        </dx:ASPxTextBox>
                        </div>
                        <div class="col-md-2 col-sm-6 col-xs-6">
                            FECTURA:
                        <dx:ASPxTextBox ClientInstanceName="searchfectura" ID="searchfectura" runat="server" Width="100px">
                            <ClientSideEvents KeyDown="function(s, e) { SearchByFectura(event);}" KeyPress="function(s, e) { SearchByFectura(event);}" KeyUp="function(s, e) { SearchByFectura(event);}" />
                        </dx:ASPxTextBox>
                        </div>
                        <div class="col-md-2 col-sm-6 col-xs-6">
                            DESDE FECHA:
                        <dx:ASPxDateEdit ID="dtfromDate" runat="server" OnInit="dtfromDate_Init" Width="140px" ClearButton-DisplayMode="OnHover">
                            <ClientSideEvents CloseUp="function(s, e) { SearchByDate();}" DateChanged="function(s, e) { SearchByDate();}" />
                        </dx:ASPxDateEdit>
                        </div>
                        <div class="col-md-2 col-sm-6 col-xs-6">
                            HASTA FECHA:
                        <dx:ASPxDateEdit ID="dttoDate" runat="server" OnInit="dttoDate_Init" Width="140px" ClearButton-DisplayMode="OnHover">
                            <ClientSideEvents CloseUp="function(s, e) { SearchByDate();}" DateChanged="function(s, e) { SearchByDate();}" />
                        </dx:ASPxDateEdit>
                        </div>
                        <div class="col-md-4 col-sm-12 col-xs-12" style="padding-top: 20px;">
                            <dx:BootstrapButton ID="BootstrapButton2" runat="server" EnableTheming="False" Text="Todos los albaranes del año"
                                AllowFocus="False" AutoPostBack="False" ClientInstanceName="btnsave">
                                <ClientSideEvents Click="function(s, e) { ShowAll();}" />
                                <SettingsBootstrap RenderOption="Primary" />
                            </dx:BootstrapButton>
                        </div>
                    </div>
                </div>
                <br />
                <div class="col-md-12">
                    <dx:ASPxGridView ClientInstanceName="GridViewAlbaransver" Width="100%" ID="GridViewAlbaransver" runat="server" KeyFieldName="SerieAlbaran"
                        AutoGenerateColumns="False" SettingsBehavior-ProcessSelectionChangedOnServer="true" EnableTheming="true"
                        OnSelectionChanged="GridViewAlbaransver_SelectionChanged" OnCustomCallback="GridViewAlbaransver_CustomCallback"
                        EnableCallBacks="false" OnCustomUnboundColumnData="GridViewAlbaransver_CustomUnboundColumnData">
                        <SettingsLoadingPanel Mode="ShowAsPopup" />
                        <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                        <SettingsSearchPanel Visible="false" />
                        <Styles Cell-CssClass="smallfont13size">
                            <Cell CssClass="smallfont13size"></Cell>
                        </Styles>
                        <SettingsLoadingPanel Mode="ShowAsPopup" />
                        <Columns>
                            <dx:GridViewDataTextColumn Name="foto" FieldName="foto" Caption="foto" Width="8%">
                                <EditFormSettings />
                                <DataItemTemplate>
                                    <dx:ASPxHyperLink ID="linkfoto" runat="server" Text="Ver Albarán" OnInit="linkselect_Init" NavigateUrl="#" CssClass="select">
                                    </dx:ASPxHyperLink>
                                </DataItemTemplate>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="SerieAlbaran" Caption="Albaran" Width="8%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Fecha" Caption="Fecha" Width="12%" PropertiesTextEdit-DisplayFormatString="dd-MMM-yyy">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="SerieFactura" Caption="Factura" Width="10%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="DesObra" Caption="Obra" Width="34%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Importe" Caption="Importe" Width="10%" UnboundType="Decimal" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="ImporteIgic" Caption="Importe+Igic" Width="10%" UnboundType="Decimal" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Vendedor" Caption="Vendedor" Width="12%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                        </Columns>

                            <Settings ShowStatusBar="Visible" VerticalScrollBarMode="Auto" VerticalScrollableHeight="180" ShowGroupPanel="false" ShowFooter="true" ShowFilterRowMenu="true" />
                            <SettingsPager PageSize="300" Mode="EndlessPaging"></SettingsPager>

                        <ClientSideEvents Init="OnInit" />
                    </dx:ASPxGridView>

                    <dx:ASPxGlobalEvents ID="ge" runat="server">
                        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
                    </dx:ASPxGlobalEvents>
                </div>
                <br />
                <div class="col-md-12" style="margin-top: 10px;">
                    <dx:ASPxGridView ClientInstanceName="GridViewAlbaransverDetail" Width="100%" ID="GridViewAlbaransverDetail" runat="server"
                        KeyFieldName="SerieAlbaran" AutoGenerateColumns="False" EnableCallBacks="false" OnCustomCallback="GridViewAlbaransverDetail_CustomCallback">
                        <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                        <Styles Cell-CssClass="smallfont13size">
                            <Cell CssClass="smallfont13size"></Cell>
                        </Styles>
                        <SettingsDataSecurity AllowInsert="False" />
                        <SettingsSearchPanel Visible="false" />
                        <Settings ShowGroupPanel="false" VerticalScrollBarMode="Auto" VerticalScrollableHeight="200" ShowFooter="true" />
                        <SettingsPager Mode="EndlessPaging" PageSize="1000" />
                        <ClientSideEvents Init="OnInit" />
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="editorFoto" Caption="Foto" Width="7%">
                                <EditFormSettings Visible="False" />
                                <DataItemTemplate>
                                    <dx:ASPxHyperLink ID="linkphoto" runat="server" Text="Foto" OnInit="linkPhoto_Init" CssClass="select textdecoration">
                                    </dx:ASPxHyperLink>
                                </DataItemTemplate>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Auto" Caption="L" Width="6%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Artículo" Caption="Artículo" Width="12%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Descripción" Caption="Descripción" Width="34%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Cantidad" Caption="Cantidad" Width="12%" PropertiesTextEdit-DisplayFormatString="{0:n1}">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Precio" Caption="Precio" Width="12%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Dto" Caption="Dto" Width="12%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Importe" Caption="Importe" Width="12%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="editorFoto" Caption="editorFoto" Visible="false">
                            </dx:GridViewDataTextColumn>
                        </Columns>
                        <TotalSummary>
                            <dx:ASPxSummaryItem FieldName="Artículo" ShowInColumn="Auto" DisplayFormat="Total:" SummaryType="Sum" />
                            <dx:ASPxSummaryItem FieldName="Importe" SummaryType="Sum" DisplayFormat="{0:n}" />
                        </TotalSummary>
                    </dx:ASPxGridView>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

