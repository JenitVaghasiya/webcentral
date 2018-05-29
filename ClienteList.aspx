<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ClienteList.aspx.cs" Inherits="ClienteList" %>

<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="Server">
    <style type="text/css">
        .hidebutton {
            display: none !important;
        }
    </style>


    <asp:ScriptManager ID="spmngr" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
    <asp:UpdatePanel runat="server" EnableViewState="true" ID="UpdatePanel" ClientIDMode="AutoID" ChildrenAsTriggers="true" RenderMode="Inline" UpdateMode="Always">
        <ContentTemplate>
            <%--            <meta name="viewport" content="width=device-width, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0" />--%>
            <style type="text/css">
                .col-lg-1, .col-lg-10, .col-lg-11, .col-lg-12, .col-lg-2, .col-lg-3, .col-lg-4, .col-lg-5, .col-lg-6, .col-lg-7, .col-lg-8, .col-lg-9, .col-md-1, .col-md-10, .col-md-11, .col-md-12, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6, .col-md-7, .col-md-8, .col-md-9, .col-sm-1, .col-sm-10, .col-sm-11, .col-sm-12, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6, .col-sm-7, .col-sm-8, .col-sm-9, .col-xs-1, .col-xs-10, .col-xs-11, .col-xs-12, .col-xs-2, .col-xs-3, .col-xs-4, .col-xs-5, .col-xs-6, .col-xs-7, .col-xs-8, .col-xs-9 {
                    padding-right: 5px !important;
                    padding-left: 5px !important;
                }

                .dxgvEditFormDisplayRow_MaterialCompact td.dxgv, .dxgvDetailCell_MaterialCompact td.dxgv, .dxgvDataRow_MaterialCompact td.dxgv, .dxgvDetailRow_MaterialCompact.dxgvADR td.dxgvAIC {
                    padding: 5px 5px 5px !important;
                }

                body {
                    overflow: auto;
                }

                .dxgvStatusBar, .dxgvStatusBar_MaterialCompact, .dxgvStatusBar_Office2003Blue {
                    display: none;
                }

                .width100, .dxgvADT {
                    width: 100%;
                }

                .textdecoration, .textdecoration:hover {
                    text-decoration: none;
                }

                .hidehovercursor {
                    cursor: default;
                }
            </style>
            <script type="text/javascript">
                function OnRowFocus(s, e) {
                    e.processOnServer = false;
                    s.SetFocusedRowIndex(e.visibleIndex);
                    s.MakeRowVisible(e.visibleIndex);
                    delete e.visibleIndex;
                }

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
                    gridViewClient.SetHeight(clientheight - 140);
                }

                function SelectClientes(index) {
                    gridViewClient.PerformCallback(index);
                }
            </script>
            <div style="margin-top:100px;">
                <div class="">
                    <div class="col-md-12">
                        <div class="col-md-12">
                         <dx:ASPxGridView  OnCustomCallback="gridViewClient_CustomCallback"  SettingsDetail-AllowOnlyOneMasterRowExpanded="true" ClientInstanceName="gridViewClient" Width="100%" ID="gridViewClient"
                                runat="server" KeyFieldName="AutoCliente" AutoGenerateColumns="False" EnableCallBacks="true">
                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                                <Styles Cell-CssClass="smallfont13size">
                                    <Cell Wrap="False" CssClass="smallfont13size"></Cell>
                                </Styles>
                                <SettingsDataSecurity AllowInsert="False" />
                                <SettingsSearchPanel Visible="true" ShowApplyButton="true" SearchInPreview="false" />
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="AutoCliente" Caption="Marcar" Width="14">
                                        <EditFormSettings Visible="False" />
                                        <DataItemTemplate>
                                            <dx:ASPxHyperLink ID="linkselect" runat="server" Text="Select" OnInit="linkselect_Init" CssClass="select">
                                            </dx:ASPxHyperLink>
                                        </DataItemTemplate>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Código" Width="14">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="RazónSocial" Caption="Razón Social" Width="70">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <Settings ShowGroupPanel="false" VerticalScrollBarMode="Visible" VerticalScrollableHeight="0" />
                                <SettingsPager Mode="EndlessPaging" PageSize="10" />
                                <ClientSideEvents Init="OnInit" RowClick="OnRowFocus" />
                            </dx:ASPxGridView>
                            <dx:ASPxGlobalEvents ID="ge" runat="server">
                                <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
                            </dx:ASPxGlobalEvents>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolderHead" runat="Server">
</asp:Content>

