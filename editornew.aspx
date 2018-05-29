<%@ Page Language="C#" AutoEventWireup="true" CodeFile="editornew.aspx.cs" Inherits="editornew" %>

<%@ Register Assembly="DevExpress.Web.ASPxHtmlEditor.v17.1, Version=17.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHtmlEditor" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.ASPxSpellChecker.v17.1, Version=17.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxSpellChecker" TagPrefix="dx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0" />
    <title>Web Central</title>
    <script type="text/javascript">
        function onInit(s, e) {
            s.SetHeight(document.getElementById("form1").offsetHeight);
        }

        function ShowLoginWindow() {
            pcHTMLEditor.Show();
        }
        function ConfirmDelete(auto) {
            document.getElementById('selectedAuto').value = 0;
            if (confirm('Are you want to delete this record?')) {
                document.getElementById("selectedAuto").value = auto;
                ASPxDelete.DoClick();
            }
            else {
                document.getElementById('selectedAuto').value = 0;
            }
        }
    </script>
    <style type="text/css">
        img, .imgcls {
            width: 50% !important;
        }

        .textdecoration, .textdecoration:hover {
            text-decoration: none;
        }

        .hidebutton {
            display: none !important;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div style="margin-top: 16px; width: 160px; margin-bottom: 16px;">

            <dx:ASPxButton ID="btAddNew" ClientInstanceName="btAddNew" OnClick="btAddNew_Click" runat="server" Text="Add New" AutoPostBack="False" UseSubmitBehavior="false" Width="100%">
            </dx:ASPxButton>
            <dx:ASPxButton CssClass="hidebutton" ClientInstanceName="ASPxDelete" ID="ASPxDelete" runat="server" Text="Delete" Width="80px" AutoPostBack="False" OnClick="ASPxDelete_Click">
            </dx:ASPxButton>
        </div>
        <asp:ScriptManager ID="spmngr" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
        <asp:UpdatePanel runat="server" EnableViewState="true" ID="UpdatePanel" ClientIDMode="AutoID" ChildrenAsTriggers="true" RenderMode="Inline" UpdateMode="Always">
            <ContentTemplate>
                <asp:HiddenField ID="selectedAuto" runat="server" Value="0" />
                <dx:ASPxGridView OnCustomButtonCallback="gridarticulosHTML_CustomButtonCallback" EnableCallBacks="false" 
                    ID="gridarticulosHTML" runat="server" AutoGenerateColumns="False" Width="70%" KeyFieldName="Auto">
                    <ClientSideEvents Init="onInit" />
                    <SettingsSearchPanel Visible="true" SearchInPreview="false" />
                    <Columns>
                        <dx:GridViewCommandColumn VisibleIndex="0" Width="20%">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="btnEdit" Text="Edit" Visibility="AllDataRows">
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="btnDelete" Text="Delete" Visibility="AllDataRows">
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Auto" ReadOnly="True" VisibleIndex="1" Width="5%">
                            <EditFormSettings Visible="False" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Concepto" VisibleIndex="2" Width="30%">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Descripción" Caption="Familia" VisibleIndex="2" Width="30%">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Autofamilia" Caption="Autofamilia" VisibleIndex="2" Width="30%" Visible="false">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Html" VisibleIndex="-1" PropertiesTextEdit-Height="100px" Settings-AllowEllipsisInText="True" Visible="false">
                            <PropertiesTextEdit EncodeHtml="False">
                            </PropertiesTextEdit>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewCommandColumn VisibleIndex="3" Width="20%" Caption="HTML" Visible="false">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="btnShowHtml" Text="Show Content" Visibility="AllDataRows">
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                    </Columns>

                </dx:ASPxGridView>
                <dx:ASPxPopupControl ID="pcHTMLEditor" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                    PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcHTMLEditor"
                    HeaderText="HTML Editor" AllowDragging="True" PopupAnimationType="None" EnableViewState="False" AutoUpdatePosition="true">
                    <ClientSideEvents PopUp="function(s, e) { ASPxClientEdit.ClearGroup('entryGroup'); txtConcepto.Focus(); }" />
                    <ContentCollection>
                        <dx:PopupControlContentControl runat="server">
                            <dx:ASPxPanel ID="Panel1" runat="server" DefaultButton="btOK">
                                <PanelCollection>
                                    <dx:PanelContent runat="server">
                                        <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout1" Width="100%" Height="100%">
                                            <Items>
                                                <dx:LayoutItem Caption="Concepto">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxTextBox ID="txtConcepto" runat="server" Width="100%" ClientInstanceName="txtConcepto">
                                                                <ValidationSettings ValidationGroup="html" SetFocusOnError="True">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem Caption="FAMILIAS">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxComboBox AllowNull="false" runat="server" ID="drpfamilias" ClientInstanceName="drpfamilias"
                                                                DropDownStyle="DropDown" TextField="Descripción" Width="100%"
                                                                ValueField="Autofamilia" IncrementalFilteringMode="Contains" EnableSynchronization="False" >
                                                                <ValidationSettings ValidationGroup="html" SetFocusOnError="True">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </dx:ASPxComboBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem Caption="HTML">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxHtmlEditor runat="server" ID="HtmlEditor" ClientInstanceName="HtmlEditor">
                                                                <SettingsValidation ValidationGroup="html">
                                                                    <RequiredField IsRequired="true" />
                                                                </SettingsValidation>
                                                                <SettingsDialogs>
                                                                    <InsertImageDialog>
                                                                        <SettingsImageUpload>
                                                                            <FileSystemSettings UploadFolder="~\uploadfolder\images" GenerateUniqueFileNamePrefix="true" />
                                                                        </SettingsImageUpload>
                                                                    </InsertImageDialog>
                                                                    <InsertAudioDialog>
                                                                        <SettingsAudioUpload>
                                                                            <FileSystemSettings UploadFolder="~\uploadfolder\audios" GenerateUniqueFileNamePrefix="true" />
                                                                        </SettingsAudioUpload>
                                                                    </InsertAudioDialog>
                                                                    <InsertFlashDialog>
                                                                        <SettingsFlashUpload>
                                                                            <FileSystemSettings UploadFolder="~\uploadfolder\flashs" GenerateUniqueFileNamePrefix="true" />
                                                                        </SettingsFlashUpload>
                                                                    </InsertFlashDialog>
                                                                    <InsertVideoDialog>
                                                                        <SettingsVideoUpload>
                                                                            <FileSystemSettings UploadFolder="~\uploadfolder\videos" GenerateUniqueFileNamePrefix="true" />
                                                                        </SettingsVideoUpload>
                                                                    </InsertVideoDialog>
                                                                </SettingsDialogs>
                                                                <Toolbars>
                                                                    <dx:HtmlEditorToolbar>
                                                                        <Items>
                                                                            <dx:ToolbarSelectAllButton></dx:ToolbarSelectAllButton>
                                                                            <dx:ToolbarCutButton>
                                                                            </dx:ToolbarCutButton>
                                                                            <dx:ToolbarCopyButton>
                                                                            </dx:ToolbarCopyButton>
                                                                            <dx:ToolbarPasteButton>
                                                                            </dx:ToolbarPasteButton>
                                                                            <dx:ToolbarPasteFromWordButton>
                                                                            </dx:ToolbarPasteFromWordButton>
                                                                            <dx:ToolbarUndoButton BeginGroup="True">
                                                                            </dx:ToolbarUndoButton>
                                                                            <dx:ToolbarRedoButton>
                                                                            </dx:ToolbarRedoButton>
                                                                            <dx:ToolbarRemoveFormatButton BeginGroup="True">
                                                                            </dx:ToolbarRemoveFormatButton>
                                                                            <dx:ToolbarBoldButton>
                                                                            </dx:ToolbarBoldButton>
                                                                            <dx:ToolbarItalicButton>
                                                                            </dx:ToolbarItalicButton>
                                                                            <dx:ToolbarUnderlineButton>
                                                                            </dx:ToolbarUnderlineButton>
                                                                            <dx:ToolbarStrikethroughButton>
                                                                            </dx:ToolbarStrikethroughButton>
                                                                            <dx:ToolbarSuperscriptButton>
                                                                            </dx:ToolbarSuperscriptButton>
                                                                            <dx:ToolbarSubscriptButton>
                                                                            </dx:ToolbarSubscriptButton>
                                                                            <dx:ToolbarPrintButton BeginGroup="True">
                                                                            </dx:ToolbarPrintButton>
                                                                            <dx:ToolbarExportDropDownButton>
                                                                                <Items>
                                                                                    <dx:ToolbarExportDropDownItem>
                                                                                    </dx:ToolbarExportDropDownItem>
                                                                                    <dx:ToolbarExportDropDownItem Format="Pdf">
                                                                                    </dx:ToolbarExportDropDownItem>
                                                                                    <dx:ToolbarExportDropDownItem Format="Txt">
                                                                                    </dx:ToolbarExportDropDownItem>
                                                                                    <dx:ToolbarExportDropDownItem Format="Docx">
                                                                                    </dx:ToolbarExportDropDownItem>
                                                                                    <dx:ToolbarExportDropDownItem Format="Odt">
                                                                                    </dx:ToolbarExportDropDownItem>
                                                                                    <dx:ToolbarExportDropDownItem Format="Mht">
                                                                                    </dx:ToolbarExportDropDownItem>
                                                                                </Items>
                                                                            </dx:ToolbarExportDropDownButton>
                                                                            <dx:ToolbarFindAndReplaceDialogButton BeginGroup="True">
                                                                            </dx:ToolbarFindAndReplaceDialogButton>
                                                                            <dx:ToolbarCheckSpellingButton></dx:ToolbarCheckSpellingButton>
                                                                            <dx:ToolbarFullscreenButton BeginGroup="True" Text="Full Screen Mode" ViewStyle="ImageAndText">
                                                                            </dx:ToolbarFullscreenButton>
                                                                        </Items>
                                                                    </dx:HtmlEditorToolbar>
                                                                    <dx:HtmlEditorToolbar>
                                                                        <Items>
                                                                            <dx:ToolbarInsertOrderedListButton>
                                                                            </dx:ToolbarInsertOrderedListButton>
                                                                            <dx:ToolbarInsertUnorderedListButton>
                                                                            </dx:ToolbarInsertUnorderedListButton>
                                                                            <dx:ToolbarIndentButton>
                                                                            </dx:ToolbarIndentButton>
                                                                            <dx:ToolbarOutdentButton>
                                                                            </dx:ToolbarOutdentButton>
                                                                            <dx:ToolbarJustifyLeftButton>
                                                                            </dx:ToolbarJustifyLeftButton>
                                                                            <dx:ToolbarJustifyCenterButton>
                                                                            </dx:ToolbarJustifyCenterButton>
                                                                            <dx:ToolbarJustifyRightButton>
                                                                            </dx:ToolbarJustifyRightButton>
                                                                            <dx:ToolbarJustifyFullButton>
                                                                            </dx:ToolbarJustifyFullButton>
                                                                            <dx:ToolbarTableOperationsDropDownButton BeginGroup="True">
                                                                                <Items>
                                                                                    <dx:ToolbarInsertTableDialogButton BeginGroup="True" Text="Insert Table..." ToolTip="Insert Table...">
                                                                                    </dx:ToolbarInsertTableDialogButton>
                                                                                    <dx:ToolbarTablePropertiesDialogButton BeginGroup="True">
                                                                                    </dx:ToolbarTablePropertiesDialogButton>
                                                                                    <dx:ToolbarTableRowPropertiesDialogButton>
                                                                                    </dx:ToolbarTableRowPropertiesDialogButton>
                                                                                    <dx:ToolbarTableColumnPropertiesDialogButton>
                                                                                    </dx:ToolbarTableColumnPropertiesDialogButton>
                                                                                    <dx:ToolbarTableCellPropertiesDialogButton>
                                                                                    </dx:ToolbarTableCellPropertiesDialogButton>
                                                                                    <dx:ToolbarInsertTableRowAboveButton BeginGroup="True">
                                                                                    </dx:ToolbarInsertTableRowAboveButton>
                                                                                    <dx:ToolbarInsertTableRowBelowButton>
                                                                                    </dx:ToolbarInsertTableRowBelowButton>
                                                                                    <dx:ToolbarInsertTableColumnToLeftButton>
                                                                                    </dx:ToolbarInsertTableColumnToLeftButton>
                                                                                    <dx:ToolbarInsertTableColumnToRightButton>
                                                                                    </dx:ToolbarInsertTableColumnToRightButton>
                                                                                    <dx:ToolbarSplitTableCellHorizontallyButton BeginGroup="True">
                                                                                    </dx:ToolbarSplitTableCellHorizontallyButton>
                                                                                    <dx:ToolbarSplitTableCellVerticallyButton>
                                                                                    </dx:ToolbarSplitTableCellVerticallyButton>
                                                                                    <dx:ToolbarMergeTableCellRightButton>
                                                                                    </dx:ToolbarMergeTableCellRightButton>
                                                                                    <dx:ToolbarMergeTableCellDownButton>
                                                                                    </dx:ToolbarMergeTableCellDownButton>
                                                                                    <dx:ToolbarDeleteTableButton BeginGroup="True">
                                                                                    </dx:ToolbarDeleteTableButton>
                                                                                    <dx:ToolbarDeleteTableRowButton>
                                                                                    </dx:ToolbarDeleteTableRowButton>
                                                                                    <dx:ToolbarDeleteTableColumnButton>
                                                                                    </dx:ToolbarDeleteTableColumnButton>
                                                                                </Items>
                                                                            </dx:ToolbarTableOperationsDropDownButton>
                                                                            <dx:ToolbarInsertPlaceholderDialogButton>
                                                                            </dx:ToolbarInsertPlaceholderDialogButton>
                                                                            <dx:ToolbarInsertLinkDialogButton>
                                                                            </dx:ToolbarInsertLinkDialogButton>
                                                                            <dx:ToolbarUnlinkButton>
                                                                            </dx:ToolbarUnlinkButton>
                                                                            <dx:ToolbarInsertFlashDialogButton BeginGroup="True">
                                                                            </dx:ToolbarInsertFlashDialogButton>
                                                                            <dx:ToolbarInsertAudioDialogButton>
                                                                            </dx:ToolbarInsertAudioDialogButton>
                                                                            <dx:ToolbarInsertVideoDialogButton>
                                                                            </dx:ToolbarInsertVideoDialogButton>
                                                                            <dx:ToolbarInsertImageDialogButton>
                                                                            </dx:ToolbarInsertImageDialogButton>
                                                                            <dx:ToolbarInsertYouTubeVideoDialogButton>
                                                                            </dx:ToolbarInsertYouTubeVideoDialogButton>
                                                                        </Items>
                                                                    </dx:HtmlEditorToolbar>
                                                                    <dx:HtmlEditorToolbar>
                                                                        <Items>
                                                                            <dx:ToolbarCustomCssEdit>
                                                                                <Items>
                                                                                    <dx:ToolbarCustomCssListEditItem TagName="" Text="Clear Style" CssClass="" />
                                                                                    <dx:ToolbarCustomCssListEditItem TagName="H1" Text="Title" CssClass="CommonTitle">
                                                                                        <PreviewStyle CssClass="CommonTitlePreview" />
                                                                                    </dx:ToolbarCustomCssListEditItem>
                                                                                    <dx:ToolbarCustomCssListEditItem TagName="H3" Text="Header1" CssClass="CommonHeader1">
                                                                                        <PreviewStyle CssClass="CommonHeader1Preview" />
                                                                                    </dx:ToolbarCustomCssListEditItem>
                                                                                    <dx:ToolbarCustomCssListEditItem TagName="H4" Text="Header2" CssClass="CommonHeader2">
                                                                                        <PreviewStyle CssClass="CommonHeader2Preview" />
                                                                                    </dx:ToolbarCustomCssListEditItem>
                                                                                    <dx:ToolbarCustomCssListEditItem TagName="Div" Text="Content" CssClass="CommonContent">
                                                                                        <PreviewStyle CssClass="CommonContentPreview" />
                                                                                    </dx:ToolbarCustomCssListEditItem>
                                                                                    <dx:ToolbarCustomCssListEditItem TagName="Strong" Text="Features" CssClass="CommonFeatures">
                                                                                        <PreviewStyle CssClass="CommonFeaturesPreview" />
                                                                                    </dx:ToolbarCustomCssListEditItem>
                                                                                    <dx:ToolbarCustomCssListEditItem TagName="Div" Text="Footer" CssClass="CommonFooter">
                                                                                        <PreviewStyle CssClass="CommonFooterPreview" />
                                                                                    </dx:ToolbarCustomCssListEditItem>
                                                                                    <dx:ToolbarCustomCssListEditItem TagName="" Text="Link" CssClass="Link">
                                                                                        <PreviewStyle CssClass="LinkPreview" />
                                                                                    </dx:ToolbarCustomCssListEditItem>
                                                                                    <dx:ToolbarCustomCssListEditItem TagName="EM" Text="ImageTitle" CssClass="ImageTitle">
                                                                                        <PreviewStyle CssClass="ImageTitlePreview" />
                                                                                    </dx:ToolbarCustomCssListEditItem>
                                                                                    <dx:ToolbarCustomCssListEditItem TagName="" Text="ImageMargin" CssClass="ImageMargin">
                                                                                        <PreviewStyle CssClass="ImageMarginPreview" />
                                                                                    </dx:ToolbarCustomCssListEditItem>
                                                                                </Items>
                                                                            </dx:ToolbarCustomCssEdit>
                                                                            <dx:ToolbarParagraphFormattingEdit Width="120px">
                                                                                <Items>
                                                                                    <dx:ToolbarListEditItem Text="Normal" Value="p" />
                                                                                    <dx:ToolbarListEditItem Text="Heading 1" Value="h1" />
                                                                                    <dx:ToolbarListEditItem Text="Heading 2" Value="h2" />
                                                                                    <dx:ToolbarListEditItem Text="Heading 3" Value="h3" />
                                                                                    <dx:ToolbarListEditItem Text="Heading 4" Value="h4" />
                                                                                    <dx:ToolbarListEditItem Text="Heading 5" Value="h5" />
                                                                                    <dx:ToolbarListEditItem Text="Heading 6" Value="h6" />
                                                                                    <dx:ToolbarListEditItem Text="Address" Value="address" />
                                                                                    <dx:ToolbarListEditItem Text="Normal (DIV)" Value="div" />
                                                                                </Items>
                                                                            </dx:ToolbarParagraphFormattingEdit>
                                                                            <dx:ToolbarFontNameEdit>
                                                                                <Items>
                                                                                    <dx:ToolbarListEditItem Text="Times New Roman" Value="Times New Roman" />
                                                                                    <dx:ToolbarListEditItem Text="Tahoma" Value="Tahoma" />
                                                                                    <dx:ToolbarListEditItem Text="Verdana" Value="Verdana" />
                                                                                    <dx:ToolbarListEditItem Text="Arial" Value="Arial" />
                                                                                    <dx:ToolbarListEditItem Text="MS Sans Serif" Value="MS Sans Serif" />
                                                                                    <dx:ToolbarListEditItem Text="Courier" Value="Courier" />
                                                                                    <dx:ToolbarListEditItem Text="Segoe UI" Value="Segoe UI" />
                                                                                </Items>
                                                                            </dx:ToolbarFontNameEdit>
                                                                            <dx:ToolbarFontSizeEdit>
                                                                                <Items>
                                                                                    <dx:ToolbarListEditItem Text="1 (8pt)" Value="1" />
                                                                                    <dx:ToolbarListEditItem Text="2 (10pt)" Value="2" />
                                                                                    <dx:ToolbarListEditItem Text="3 (12pt)" Value="3" />
                                                                                    <dx:ToolbarListEditItem Text="4 (14pt)" Value="4" />
                                                                                    <dx:ToolbarListEditItem Text="5 (18pt)" Value="5" />
                                                                                    <dx:ToolbarListEditItem Text="6 (24pt)" Value="6" />
                                                                                    <dx:ToolbarListEditItem Text="7 (36pt)" Value="7" />
                                                                                </Items>
                                                                            </dx:ToolbarFontSizeEdit>
                                                                            <dx:ToolbarBackColorButton BeginGroup="True">
                                                                            </dx:ToolbarBackColorButton>
                                                                            <dx:ToolbarFontColorButton>
                                                                            </dx:ToolbarFontColorButton>
                                                                        </Items>
                                                                    </dx:HtmlEditorToolbar>
                                                                </Toolbars>
                                                                <Placeholders>
                                                                    <dx:HtmlEditorPlaceholderItem Value="Placeholder1" />
                                                                    <dx:HtmlEditorPlaceholderItem Value="Placeholder2" />
                                                                    <dx:HtmlEditorPlaceholderItem Value="Placeholder3" />
                                                                </Placeholders>
                                                                <Settings AllowCustomColorsInColorPickers="True" ShowTagInspector="True">
                                                                    <SettingsHtmlView EnableAutoCompletion="True" HighlightActiveLine="True" HighlightMatchingTags="True" ShowCollapseTagButtons="True" ShowLineNumbers="True" />
                                                                </Settings>
                                                                <SettingsHtmlEditing AllowEditFullDocument="True" AllowFormElements="True" AllowHTML5MediaElements="True" AllowIFrames="True" AllowObjectAndEmbedElements="True"
                                                                    AllowScripts="True" AllowYouTubeVideoIFrames="True" EnablePasteOptions="True" EnterMode="BR" PasteMode="MergeFormatting" ResourcePathMode="RootRelative">
                                                                </SettingsHtmlEditing>
                                                                <SettingsResize AllowResize="True" />
                                                            </dx:ASPxHtmlEditor>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem ShowCaption="False" Paddings-PaddingTop="19">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxButton ValidationGroup="html" ID="btSave" ClientInstanceName="btSave" runat="server" Text="Save" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px" OnClick="btSave_Click">
                                                                <ClientSideEvents Click="function(s, e) { if(ASPxClientEdit.ValidateGroup('html')) {pcHTMLEditor.Hide();}}" />
                                                            </dx:ASPxButton>
                                                            <dx:ASPxButton ID="btCancel" runat="server" Text="Cancel" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                                <ClientSideEvents Click="function(s, e) {   pcHTMLEditor.Hide(); document.getElementById('selectedAuto').value=0; txtConcepto.SetText(''); HtmlEditor.Html =''; }" />
                                                            </dx:ASPxButton>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                    <Paddings PaddingTop="19px" />
                                                </dx:LayoutItem>
                                            </Items>
                                        </dx:ASPxFormLayout>
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
    </form>
</body>
</html>
