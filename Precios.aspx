<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Precios.aspx.cs" Inherits="Precios" UICulture="es-ES" Culture="es-ES" %>

<%@ Register Assembly="DevExpress.Web.ASPxHtmlEditor.v17.1, Version=17.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHtmlEditor" TagPrefix="dx" %>



<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHead" runat="server">
    <script>
        $(function () {
            var Height = $(window).height();
            var Width = $(window).width();


            if (Width < 1200) {
                window.location.href = "/mobile/Precios.aspx";
            }

        });
    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="Server">
    <style type="text/css">
        .hidebutton {
            display: none !important;
        }
    </style>



    <asp:ScriptManager ID="spmngr" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
    <asp:UpdatePanel runat="server" EnableViewState="true" ID="UpdatePanel" ClientIDMode="AutoID" ChildrenAsTriggers="true" RenderMode="Inline" UpdateMode="Always">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnexport" />
        </Triggers>
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

                .hide {
                    display: none;
                }
            </style>

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

                var articleclicked = false;
                function SelectArticle(index) {
                    articleclicked = true;
                    GridViewPresupuestoActual.PerformCallback(index);
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
                }

                function OnInitFocus(s, e) {
                    e.processOnServer = false;

                    if (articleclicked == true) {
                        //if (s.cellFocusHelper != undefined && s.cellFocusHelper.focusedCellInfo != undefined && s.cellFocusHelper.focusedCellInfo.columnIndex == 1) {
                        if (s.GetFocusedCell() != null && s.GetFocusedCell().column.fieldName == "EditorAuto") {
                            s.SetFocusedCell(2);
                            articleclicked = false;
                            GridViewPresupuestoActual.GetRowValues(GridViewPresupuestoActual.GetFocusedRowIndex(), 'EditorAuto', GetGridViewPresupuestoActualFocusedRowIndex);
                        }
                    }

                    //if (s.cellFocusHelper == undefined || (s.cellFocusHelper.focusedCellInfo != undefined && s.cellFocusHelper.focusedCellInfo.columnIndex != 1)) {
                    if (s.GetFocusedCell() == null || s.GetFocusedCell().column.fieldName != "EditorAuto") {
                        s.SetFocusedRowIndex(s.focusedRowIndex);
                        s.MakeRowVisible(s.focusedRowIndex);
                        delete s.focusedRowIndex;
                        delete e.visibleIndex;
                    }
                }

                function GetGridViewPresupuestoActualFocusedRowIndex(value) {
                    if (value != null) {
                        showHTMLEditor(value);
                    }
                    return false;
                }

                function OnRowFocus(s, e) {
                    $("#showlblfamilia").hide();
                    $("#linkfamiliaphoto").hide();
                    var visibleIndex = e.visibleIndex;
                    e.processOnServer = false;
                    s.SetFocusedRowIndex(visibleIndex);
                    s.MakeRowVisible(visibleIndex);
                    delete e.visibleIndex;
                    gridViewArtículo.GetRowValues(gridViewArtículo.GetFocusedRowIndex(), 'AutoFamilia;FamiliaDesc;FamiliaFoto', OnGetRowValues);
                    $("#divstock").hide();
                    var isVendedor = '<%=Session["Vendedor"] %>';
                    if(isVendedor == 'True'){
                        gridViewArtículo.GetRowValues(gridViewArtículo.GetFocusedRowIndex(), 'AutoArtículo', showstock);
                    }
                }

                function OnGetRowValues(values) {

                    lblfamilia.SetText("");
                    if (values != null && values != '' && values != "" && values != undefined && values.length > 0) {
                        if (values[0] != null && values[0] != '' && values[0] != "" && values[0] != undefined && values[0] > 0) {
                            if (values[1] != null && values[1] != '' && values[1] != "" && values[1] != undefined) {
                                $("#showlblfamilia").show();
                                lblfamilia.SetText(values[1]);
                            }

                            if (values[2] != null && values[2] != '' && values[2] != "" && values[2] != undefined && values[2] > 0) {
                                $("#linkfamiliaphoto").show();
                            }
                        }
                    }
                }

                function showstock(value) {

                    $.each([1, 3, 8], function (index, indexData) {
                        $.ajax(
                            {
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                url: '/precios.aspx/getstocks',
                                data: "{'dearticulo':'" + value + "','dealmacen':'" + indexData + "'}",
                                dataType: "json",
                                success: function (response) {
                                    if(indexData == 1) {
                                        $("#lblstock1").text(response.d);
                                    }
                                    else if(indexData == 3) {
                                        $("#lblstock2").text(response.d);
                                    }
                                    else if(indexData == 8){
                                        $("#lblstock3").text(response.d);
                                        $("#divstock").show();
                                    }
                                },
                                error: function (response) {

                                }
                            });
                    });
                }

                function linkfamiliaphotoClick() {
                    gridViewArtículo.GetRowValues(gridViewArtículo.GetFocusedRowIndex(), 'FamiliaFoto', openHTMLEditor);
                }

                function openHTMLEditor(value) {
                    showHTMLEditor(value);
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

                function showfullscreen() {
                    htmlEditor.SetHeight($(document).height());
                }

                $(document).ready(function () {
                    var pcHTMLEditorPreviewIFrame = document.getElementById("pcHTMLEditorPreviewIFrame");
                    pcHTMLEditorPreviewIFrame.innerHTML = "";
                });

                function OnSelectAll(s, e) {
                    gridViewGroupFamily.ApplySearchPanelFilter();
                    gridViewArtículo.ApplySearchPanelFilter();
                    return true;
                }
            </script>

            <div class="">
                <div>
                    <div class="col-md-4"></div>
                    <div class="col-md-1" style="padding: 4px;">
                        <dx:BootstrapButton ID="btnexport" runat="server" EnableTheming="False" Text="Excel"
                            AllowFocus="False" AutoPostBack="False" ClientInstanceName="btnexport" OnClick="btnexport_Click">
                            <SettingsBootstrap RenderOption="Primary" />
                        </dx:BootstrapButton>
                    </div>
                    <div class="col-md-2" style="padding: 4px;">
                        <dx:BootstrapButton ID="btnsave" runat="server" EnableTheming="False" Text="Guardar"
                            AllowFocus="False" AutoPostBack="False" ClientInstanceName="btnsave">
                            <ClientSideEvents Click="function(s, e) { if(GridViewPresupuestoActual.pageRowCount > 0) {ShowSaveWindow();} else {alert('Se requiere un mínimo de un artículo.'); }}" />
                            <SettingsBootstrap RenderOption="Primary" />
                        </dx:BootstrapButton>
                    </div>
                    <div class="col-md-1" style="padding: 4px;">
                        <dx:BootstrapButton ID="btnComprar" runat="server" EnableTheming="False" Text="Comprar"
                            AllowFocus="False" AutoPostBack="False" ClientInstanceName="btnComprar">
                            <ClientSideEvents Click="function(s, e) { if(GridViewPresupuestoActual.pageRowCount > 0) {ShowComprarWindow();} else {alert('Se requiere un mínimo de un artículo.'); }}" />
                            <SettingsBootstrap RenderOption="Primary" />
                        </dx:BootstrapButton>
                    </div>

                </div>
                <div class="">
                    <div class="col-md-9">
                        <dx:ASPxGridViewExporter ExportedRowType="All" GridViewID="GridViewPresupuestoActual" ID="exportGrid" runat="server">
                        </dx:ASPxGridViewExporter>
                        <dx:ASPxGridView OnCustomCallback="GridViewPresupuestoActual_CustomCallback" Width="100%" ID="GridViewPresupuestoActual"
                            runat="server" KeyFieldName="AutoArtículo" AutoGenerateColumns="False" OnCustomUnboundColumnData="GridViewPresupuestoActual_CustomUnboundColumnData"
                            EnableCallBacks="true" ClientInstanceName="GridViewPresupuestoActual" OnCustomButtonCallback="GridViewPresupuestoActual_CustomButtonCallback">
                            <SettingsLoadingPanel Mode="ShowAsPopup" />

                            <SettingsBehavior AllowSort="false" AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                            <SettingsEditing Mode="Batch" NewItemRowPosition="Bottom">
                                <BatchEditSettings EditMode="Cell" StartEditAction="Click" ShowConfirmOnLosingChanges="False" />
                            </SettingsEditing>

                            <Styles Cell-CssClass="smallfont11size">
                                <Cell CssClass="smallfont11size"></Cell>
                                <Header CssClass="smallfont11size"></Header>
                            </Styles>
                            <ClientSideEvents FocusedRowChanged="OnInitFocus" BatchEditEndEditing="function(s,e) { OnBatchEditingGrid(s.lastMultiSelectIndex,e.rowValues[5].value); }" />
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="EditorAuto" Visible="false" />
                                <dx:GridViewCommandColumn VisibleIndex="0">
                                    <CustomButtons>
                                        <dx:GridViewCommandColumnCustomButton ID="btnDelete" Text="Quitar" Visibility="AllDataRows">
                                        </dx:GridViewCommandColumnCustomButton>
                                    </CustomButtons>
                                </dx:GridViewCommandColumn>
                                <dx:GridViewDataTextColumn FieldName="EditorAuto" Caption="Foto" Width="5%" VisibleIndex="1">
                                    <EditFormSettings Visible="False" />
                                    <DataItemTemplate>
                                        <dx:ASPxHyperLink ID="linkphoto" runat="server" Text="Foto" OnInit="linkPresupuestoActualPhoto_Init" CssClass="textdecoration">
                                        </dx:ASPxHyperLink>
                                    </DataItemTemplate>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Artículo" VisibleIndex="2">
                                    <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    <Settings AllowAutoFilter="False"></Settings>
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Desg" Width="27%" VisibleIndex="3">
                                    <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    <Settings AllowAutoFilter="False"></Settings>
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Cantidad" VisibleIndex="4" Width="6%">
                                    <PropertiesSpinEdit DisplayFormatString="n" DisplayFormatInEditMode="true" MinValue="0" MaxValue="10000">
                                        <ValidationSettings Display="Dynamic" RequiredField-IsRequired="true" />
                                        <Style CssClass="smallfont10size"></Style>
                                    </PropertiesSpinEdit>
                                    <Settings AllowAutoFilter="False"></Settings>
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataTextColumn FieldName="Precio" Caption="Precio" VisibleIndex="5" Width="4%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                    <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    <Settings AllowAutoFilter="False"></Settings>
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Dto" Caption="Dto" VisibleIndex="6" Width="5%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                    <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    <Settings AllowAutoFilter="False"></Settings>
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Neto" Caption="Neto" VisibleIndex="7" UnboundType="Decimal" Width="5%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                    <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    <Settings AllowAutoFilter="False"></Settings>
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="PercenImpuesto" Caption="Igic" VisibleIndex="8" Width="4%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                    <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    <Settings AllowAutoFilter="False"></Settings>
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="PrecioIgic" Caption="Precio+Igic" VisibleIndex="9" Width="7%" PropertiesTextEdit-DisplayFormatString="{0:n}" Visible="false">
                                    <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    <Settings AllowAutoFilter="False"></Settings>
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="NetoIgic" Caption="Neto+Igic" VisibleIndex="10" Width="7%" PropertiesTextEdit-DisplayFormatString="{0:n}" Visible="false">
                                    <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    <Settings AllowAutoFilter="False"></Settings>
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Importe" Caption="Total PVP" UnboundType="Decimal" VisibleIndex="11" Width="6%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                    <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    <Settings AllowAutoFilter="False"></Settings>
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="ImporteNeto" Caption="Total Neto" UnboundType="Decimal" VisibleIndex="12" Width="7%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                    <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    <Settings AllowAutoFilter="False"></Settings>
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="ImpNetoDtopp" Caption="Total Neto-DtoPP" UnboundType="Decimal" VisibleIndex="12" Width="10%" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                    <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                    <Settings AllowAutoFilter="False"></Settings>
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="beneficio" Caption="Beneficio" UnboundType="Decimal" VisibleIndex="12" Width="7%" PropertiesTextEdit-DisplayFormatString="{0:n}">
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
                            <Settings ShowStatusBar="Visible" VerticalScrollBarMode="Auto" VerticalScrollableHeight="180" ShowGroupPanel="false" ShowFooter="true" ShowFilterRowMenu="true" />
                            <SettingsPager PageSize="300" Mode="EndlessPaging"></SettingsPager>
                            <TotalSummary>
                                <dx:ASPxSummaryItem FieldName="AutoArtículo" ShowInColumn="Desg" DisplayFormat="Total:" SummaryType="Sum" />
                                <dx:ASPxSummaryItem FieldName="Cantidad" SummaryType="Sum" DisplayFormat="{0}" />
                                <dx:ASPxSummaryItem FieldName="Importe" SummaryType="Sum" DisplayFormat="{0:n}" />
                                <dx:ASPxSummaryItem FieldName="ImporteNeto" SummaryType="Sum" DisplayFormat="{0:n}" />
                                <dx:ASPxSummaryItem FieldName="ImpNetoDtopp" SummaryType="Sum" DisplayFormat="{0:n}" />
                                <dx:ASPxSummaryItem FieldName="beneficio" SummaryType="Sum" DisplayFormat="{0:n}" />
                            </TotalSummary>
                            <SettingsDataSecurity AllowDelete="true" AllowEdit="true" AllowInsert="True" />
                        </dx:ASPxGridView>
                    </div>
                    <div class="col-md-3">
                        <dx:ASPxGridView Width="100%" ClientInstanceName="GridViewGroup" ID="GridViewGroup" runat="server" KeyFieldName="Grupo" AutoGenerateColumns="False" SettingsBehavior-ProcessSelectionChangedOnServer="true"
                            EnableTheming="true" OnSelectionChanged="GridViewGroup_SelectionChanged" EnableCallBacks="false">
                            <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />

                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                            <Styles Cell-CssClass="smallfont11size"></Styles>
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
                            <Settings VerticalScrollBarMode="Auto" VerticalScrollableHeight="210" ShowGroupPanel="false" ShowFooter="false" ShowFilterRowMenu="true" />
                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                            <ClientSideEvents Init="OnInitFocus"></ClientSideEvents>
                        </dx:ASPxGridView>
                    </div>
                    <div class="col-md-9">
                        <div class="col-md-12" style="margin-bottom: 5px; margin-top: 5px;">
                            <div class="row">
                                <div class="col-md-5" style="padding-left:20px !important;">
                                    <div id="divstock" style="display:none; font-size: 12px;">
                                    Stock almacen 1 = <label id="lblstock1"></label>;
                                        Stock almacen 3  = <label id="lblstock2"></label>;
                                        Stock almacen 8 = <label id="lblstock3"></label>;
                                </div>
                                </div>
                                <div class="col-md-7 col-sm-12">
                                    <div class="col-md-6  col-sm-12">
                                        <div id="showlblfamilia" style="display: none; font-size: 10px;">
                                            <b>Familia : </b>
                                            <a id="linkfamiliaphoto" href="#" onclick="linkfamiliaphotoClick(); return false;" class="select" style="display: none;">(Foto)</a>
                                            <dx:ASPxLabel ClientInstanceName="lblfamilia" ID="lblfamilia" runat="server"></dx:ASPxLabel>

                                        </div>
                                    </div>
                                    <div class="col-md-6  col-sm-12">
                                        <dx:ASPxButton ClientInstanceName="btnselectAllFamili" ID="btnselectAllFamili" runat="server" Text="Buscar en todos los artículos" AutoPostBack="false" OnClick="btnsearchArticulo_Click">
                                            <ClientSideEvents Click="OnSelectAll" />
                                        </dx:ASPxButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <dx:ASPxGridView SettingsDetail-AllowOnlyOneMasterRowExpanded="true" ClientInstanceName="gridViewArtículo" Width="100%" ID="GridViewArtículo"
                                runat="server" KeyFieldName="AutoArtículo" AutoGenerateColumns="False" OnCustomUnboundColumnData="GridViewArtículo_CustomUnboundColumnData"
                                EnableCallBacks="true">
                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                                <Styles Cell-CssClass="smallfont11size">
                                    <Cell Wrap="False" CssClass="smallfont11size"></Cell>
                                </Styles>
                                <SettingsDataSecurity AllowInsert="False" />
                                <SettingsSearchPanel Visible="true" ColumnNames="Desg" ShowApplyButton="true" SearchInPreview="false" />
                                <SettingsText SearchPanelEditorNullText="Buscar texto " Title="Buscar" />
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="AutoArtículo" Caption="Marcar" Width="14">
                                        <EditFormSettings Visible="False" />
                                        <DataItemTemplate>
                                            <dx:ASPxHyperLink ID="linkselect" runat="server" Text="Añadir" OnInit="linkselect_Init" CssClass="select">
                                            </dx:ASPxHyperLink>
                                        </DataItemTemplate>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AutoArtículo" Caption="Foto" Width="14">
                                        <EditFormSettings Visible="False" />
                                        <DataItemTemplate>
                                            <dx:ASPxHyperLink ID="linkphoto" runat="server" Text="Foto" OnInit="linkPhoto_Init" CssClass="select textdecoration">
                                            </dx:ASPxHyperLink>
                                        </DataItemTemplate>
                                    </dx:GridViewDataTextColumn>
                                    <%--<dx:GridViewCommandColumn Width="14" Caption="Foto">
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="lnkShowHtml" Text="Foto" Visibility="AllDataRows">
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                    </dx:GridViewCommandColumn>--%>
                                    <dx:GridViewDataTextColumn FieldName="Artículo" Width="14">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Fecha" Caption="Fecha" Width="15px" PropertiesTextEdit-DisplayFormatString="dd-MMM-yyyy" Visible="False">
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Desg" Width="70" Caption="Descripción">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AutoFilterCondition="Like" ShowFilterRowMenuLikeItem="True" AllowAutoFilter="True" FilterMode="DisplayText" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Artículonum" Width="14" Caption="Anter">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="Precio" Width="14" Caption="Precio" UnboundType="Decimal" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Dto" Width="14" Caption="Dto" UnboundType="Decimal" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Neto" Width="14" Caption="Neto" UnboundType="Decimal" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="PercenImpuesto" Width="14" Caption="Igic" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="PrecioIgic" Width="14" Caption="Precio+Igic" UnboundType="Decimal" PropertiesTextEdit-DisplayFormatString="{0:n}">
                                        <BatchEditModifiedCellStyle CssClass="smallfont10size"></BatchEditModifiedCellStyle>
                                        <Settings AllowAutoFilter="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="NetoIgic" Width="14" Caption="Neto+Igic" UnboundType="Decimal" PropertiesTextEdit-DisplayFormatString="{0:n}">
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
                                    <dx:GridViewDataTextColumn FieldName="FamiliaDesc" Visible="false" />
                                    <dx:GridViewDataTextColumn FieldName="FamiliaFoto" Visible="false" />
                                </Columns>
                                <Settings ShowGroupPanel="false" VerticalScrollBarMode="Visible" VerticalScrollableHeight="0" />
                                <SettingsPager Mode="EndlessPaging" PageSize="15" />
                                <ClientSideEvents Init="OnInit" EndCallback="OnEndCallback" RowClick="OnRowFocus" />
                            </dx:ASPxGridView>
                            <dx:ASPxGlobalEvents ID="ge" runat="server">
                                <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
                            </dx:ASPxGlobalEvents>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <dx:ASPxGridView ClientInstanceName="gridViewGroupFamily" Width="100%" ID="GridViewGroupFamily" runat="server" KeyFieldName="Autofamilia" AutoGenerateColumns="False" SettingsBehavior-ProcessSelectionChangedOnServer="true" EnableTheming="true" OnSelectionChanged="GridViewGroupFamily_SelectionChanged" EnableCallBacks="false">
                            <SettingsLoadingPanel Mode="ShowAsPopup" />

                            <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowSelectSingleRowOnly="true" />
                            <SettingsSearchPanel Visible="True" />
                            <Styles Cell-CssClass="smallfont11size"></Styles>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="AutoEditor" Caption="Foto" Width="14%">
                                    <EditFormSettings Visible="False" />
                                    <DataItemTemplate>
                                        <dx:ASPxHyperLink ID="linkfamiliphoto" runat="server" Text="Foto" OnInit="linkfamiliphoto_Init" CssClass="select textdecoration">
                                        </dx:ASPxHyperLink>
                                    </DataItemTemplate>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Descripción" Caption="Familia">
                                    <BatchEditModifiedCellStyle CssClass="smallfont11size"></BatchEditModifiedCellStyle>
                                </dx:GridViewDataTextColumn>
                            </Columns>
                            <Settings VerticalScrollBarMode="Auto" VerticalScrollableHeight="250" ShowGroupPanel="false" ShowFooter="false" ShowFilterRowMenu="true" />
                            <SettingsPager PageSize="300"></SettingsPager>
                            <ClientSideEvents Init="OnInitFocus"></ClientSideEvents>
                        </dx:ASPxGridView>

                    </div>
                </div>
            </div>

            <dx:ASPxPopupControl ID="pcSave" runat="server" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcSave"
                HeaderText="Indique el nombre del presupuesto:" AllowDragging="True" PopupAnimationType="None" EnableViewState="False">
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
                                                <dx:ASPxLabel ID="lblDescription" runat="server" Text="NOMBRE DEL PRESUPUESTO:" AssociatedControlID="tbDescription">
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
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
</asp:Content>
