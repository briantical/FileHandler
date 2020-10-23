codeunit 50102 Uploader
{
    procedure ImportXML()
    var
        XMLInStream: InStream;
        UploadResult: Boolean;
        TempBlob: Codeunit "Temp Blob";
        DialogCaption: Text;
        XMLFileName: Text;
        XMLBuffer: Record "XML Buffer";
        Item: Record Item;
    begin
        UploadResult := UploadIntoStream(DialogCaption, '', '', XMLFileName, XMLInStream);
        XMLBuffer.DeleteAll;
        XMLBuffer.LoadFromStream(XMLInStream);
        if XMLBuffer.FindSet() then
            repeat
                if (XMLBuffer.FieldNo(Code) = 1) then
                    Item.Init();
                case XMLBuffer.FieldNo(Code) of
                    1:
                        Item.Validate("No.", XMLBuffer.Value);
                    2:
                        Item.Validate(Description, XMLBuffer.Value);
                    3:
                        Item.Validate("Item Category Code", XMLBuffer.Value);
                    4:
                        if not Item.Insert() then
                            Item.Modify();
                end;
            until XMLBuffer.Next() = 0;
    end;
}