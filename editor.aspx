<%@ Page Language="c#" AutoEventWireup="true" CodeFile="editor.aspx.cs" Inherits="editor" %>

<%@ Register Assembly="DevExpress.Web.ASPxHtmlEditor.v17.1, Version=17.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHtmlEditor" TagPrefix="dx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0" />
    <title>Web Central</title>
    <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro" rel="stylesheet" />
    <script type="text/javascript" src="/Scripts/jquery-1.12.2.min.js"></script>
    <script type="text/javascript">
        function onInit(s, e) {
            s.SetHeight(document.getElementById("form1").offsetHeight);
            s.ExecuteCommand(ASPxClientCommandConsts.FULLSCREEN_COMMAND);
            imageiframe();
        }

        function imageiframe() {
            var swidth = '80%';
            $('#htmlEditor_PreviewIFrame').contents().find('img').css({ width: swidth });
        }

    </script>
    <style type="text/css">
        img, .imgcls {
            width: 80% !important;
        }

        .imgcls {width: 80% !important;}</style>
</head>
<body>

    <form id="form1" runat="server">
        <div>
            <dx:ASPxHtmlEditor ID="htmlEditor" runat="server" ClientInstanceName="htmlEditor" Width="100%">
                <ClientSideEvents Init="onInit" />
                <Settings AllowHtmlView="False" AllowPreview="True" AllowDesignView="false" />
                <Settings>
                    <SettingsHtmlView EnableAutoCompletion="True" HighlightActiveLine="True" HighlightMatchingTags="True" ShowCollapseTagButtons="True" ShowLineNumbers="True" />
                </Settings>
                <SettingsHtmlEditing AllowEditFullDocument="True" AllowFormElements="True" AllowHTML5MediaElements="True" AllowIFrames="True" AllowObjectAndEmbedElements="True"
                    AllowScripts="True" AllowYouTubeVideoIFrames="True" EnablePasteOptions="True" EnterMode="BR" PasteMode="MergeFormatting" ResourcePathMode="RootRelative">
                </SettingsHtmlEditing>
                <SettingsResize AllowResize="True" />
            </dx:ASPxHtmlEditor>
        </div>
    </form>
</body>
</html>
