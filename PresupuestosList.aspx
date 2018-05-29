<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PresupuestosList.aspx.cs" Inherits="PresupuestosList" UICulture="es-ES" Culture="es-ES"%>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHead" runat="server">
    <script>
        $(function () {
            var Height = $(window).height();
            var Width = $(window).width();


            if (Width < 1200) {
                window.location.href = "/mobile/PresupuestosList.aspx";
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
                function SearchByPresupuesto(e) {
                    if (e != undefined) {
                        if (e.keyCode == 13) {
                            GridViewPresupuestosver.PerformCallback("searchtext");
                        }
                    }
                    else {
                        GridViewPresupuestosver.PerformCallback("searchtext");
                    }
                }

                function SearchByDate() {
                    GridViewPresupuestosver.PerformCallback("date");
                }

                function ShowAll() {
                    GridViewPresupuestosver.PerformCallback();
                }

                function OnInit(s, e) {
                    AdjustSize();
                }

                function AdjustSize() {
                    var clientheight = document.documentElement.clientHeight;
                    var height = 0.00;
                    height = Math.max(0, document.documentElement.clientHeight * 0.40);

                    GridViewPresupuestosver.SetHeight(height);
                    GridViewPresupuestosverDetail.SetHeight(height);
                }

                function OnControlsInitialized(s, e) {
                    ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                        AdjustSize();
                    });
                }

                function showHTMLEditor(Auto) {
                    pcHTMLEditor.Hide();
                    var normalheight = document.documentElement.clientHeight - 100;
                    var pcHTMLEditorPreviewIFrame = document.getElementById("pcHTMLEditorPreviewIFrame");
                    pcHTMLEditorPreviewIFrame.style["height"] = "" + normalheight + "px";
                    $("[id$=_hdnfoto]").val(Auto);

                    pcHTMLEditorPreviewIFrame.innerHTML = "";
                    pcHTMLEditorPreviewIFrame.src = "editor.aspx?id=" + Auto;

                    pcHTMLEditor.Show();
                    return false;
                }

                 $(document).ready(function () {
                    var pcHTMLEditorPreviewIFrame = document.getElementById("pcHTMLEditorPreviewIFrame");
                    pcHTMLEditorPreviewIFrame.innerHTML = "";
                });
            </script>
            <br />
            <div>
                <%--<div class="row" style="padding-bottom: 15px;padding-top:40px;">--%>
                <div class="row searchtab" style="padding-bottom: 15px;">
                    <div class="col-md-12">
                        <div class="col-md-2 col-sm-6 col-xs-6">
                            PRESUPUESTO:
                            <dx:ASPxTextBox ClientInstanceName="searchText" ID="searchText" runat="server" Width="130">
                                <ClientSideEvents KeyDown="function(s, e) { SearchByPresupuesto(event);}" KeyPress="function(s, e) { SearchByPresupuesto(event);}" KeyUp="function(s, e) { SearchByPresupuesto(event);}" />
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
                            <dx:BootstrapButton ID="BootstrapButton2" runat="server" EnableTheming="False" Text="Todos los presupuestos de este año"
                                AllowFocus="False" AutoPostBack="False" ClientInstanceName="btnsave">
                                <ClientSideEvents Click="function(s, e) { ShowAll();}" />
                                <SettingsBootstrap RenderOption="Primary" />
                            </dx:BootstrapButton>
                        </div>
                    </div>
                </div>
                <br />
                <div class="col-md-12">
                    <dx:ASPxGridView ClientInstanceName="GridViewPresupuestosver" Width="100%" ID="GridViewPresupuestosver" runat="server" KeyFieldName="SeriePresupuesto"
                        AutoGenerateColumns="False" SettingsBehavior-ProcessSelectionChangedOnServer="true" EnableTheming="true"
                        OnSelectionChanged="GridViewPresupuestosver_SelectionChanged" OnCustomCallback="GridViewPresupuestosver_CustomCallback"
                        EnableCallBacks="false" OnCustomButtonCallback="GridViewPresupuestosver_CustomButtonCallback">
                        <SettingsLoadingPanel Mode="ShowAsPopup" />
                        <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                        <SettingsSearchPanel Visible="true" ShowApplyButton="true" SearchInPreview="false" />
                        <Styles Cell-CssClass="smallfont13size">
                            <Cell CssClass="smallfont13size"></Cell>
                        </Styles>
                        <SettingsLoadingPanel Mode="ShowAsPopup" />
                        <Columns>
                            <dx:GridViewCommandColumn VisibleIndex="0">
                                <CustomButtons>
                                    <dx:GridViewCommandColumnCustomButton ID="btnRecover" Text="Recuperar" Visibility="AllDataRows">
                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                            </dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn FieldName="SeriePresupuesto" Caption="Presupuesto" Width="10%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Desstatus" Caption="Status" Width="10%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Fecha" Caption="Fecha" Width="13%" PropertiesTextEdit-DisplayFormatString="dd-MMM-yyyy">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Descripción" Caption="Descripción" Width="30%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Desobra" Caption="Obra" Width="13%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Albarán" Caption="Albarán" Width="12%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                        </Columns>
                        <Settings ShowGroupPanel="false" VerticalScrollBarMode="Auto" VerticalScrollableHeight="180" />
                        <SettingsPager Mode="ShowPager" PageSize="10" />
                        <ClientSideEvents Init="OnInit" />
                    </dx:ASPxGridView>

                    <dx:ASPxGlobalEvents ID="ge" runat="server">
                        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
                    </dx:ASPxGlobalEvents>
                </div>
                <br />
                <div class="col-md-12" style="margin-top: 10px;">
                    <dx:ASPxGridView ClientInstanceName="GridViewPresupuestosverDetail" Width="100%" ID="GridViewPresupuestosverDetail" runat="server"
                        KeyFieldName="SeriePresupuesto" AutoGenerateColumns="False" EnableCallBacks="true" OnCustomCallback="GridViewPresupuestosverDetail_CustomCallback">
                        <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                        <Styles Cell-CssClass="smallfont13size">
                            <Cell CssClass="smallfont13size"></Cell>
                        </Styles>
                        <SettingsDataSecurity AllowInsert="False" />
                        <SettingsSearchPanel Visible="true" ShowApplyButton="true" SearchInPreview="false" />
                        <Settings ShowGroupPanel="false" VerticalScrollBarMode="Auto" VerticalScrollableHeight="200" ShowFooter="true" />
                        <SettingsPager Mode="EndlessPaging" PageSize="10" />
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
                            <dx:GridViewDataTextColumn FieldName="Artículo" Caption="Artículo" Width="16%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Descripción" Caption="Descripción" Width="40%">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Cantidad" Caption="Cantidad" Width="13%" PropertiesTextEdit-DisplayFormatString="{0:n1}">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="PrecioServicios" Caption="Precio" Width="13%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Dto" Caption="Dto" Width="13%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Importe" Caption="Importe" Width="13%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                <Settings AllowAutoFilter="False"></Settings>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="editorFoto" Caption="editorFoto" Visible="false">
                            </dx:GridViewDataTextColumn>
                        </Columns>
                        <TotalSummary>
                            <dx:ASPxSummaryItem FieldName="Artículo" ShowInColumn="Auto" DisplayFormat="Total:" SummaryType="sum" />
                            <dx:ASPxSummaryItem FieldName="Importe" SummaryType="Sum" DisplayFormat="{0:n}" />
                        </TotalSummary>
                    </dx:ASPxGridView>
                </div>
            </div>

            <dx:ASPxPopupControl ID="pcHTMLEditor" runat="server" Width="1000" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcHTMLEditor"
                HeaderText="HTML Editor" AllowDragging="True" PopupAnimationType="None" EnableViewState="False" AutoUpdatePosition="true">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <dx:ASPxPanel ID="ASPxPanel2" runat="server">
                            <PanelCollection>
                                <dx:PanelContent runat="server">
                                    <iframe id="pcHTMLEditorPreviewIFrame" class="dxhePreviewArea_Office2003Blue dxheViewArea_Office2003Blue"
                                        name="pcHTMLEditor_Panel1_ASPxFormLayout1_HtmlEditor_PreviewIFrame" src=""
                                        style="height: 700px; width: 100%; padding: 0px; border-style: none; border-width: 0px;" allowfullscreen="true"></iframe>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxPanel>
                    </dx:PopupControlContentControl>
                </ContentCollection>
                <ContentStyle>
                    <Paddings PaddingBottom="5px" />
                </ContentStyle>
            </dx:ASPxPopupControl>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
