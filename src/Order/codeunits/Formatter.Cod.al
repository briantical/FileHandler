codeunit 50101 Formatter
{
    procedure ImportXMLs()
    var
        TempBlob: Codeunit "Temp Blob";
        TargetXmlDoc: XmlDocument;
        XmlDec: XmlDeclaration;
        Instr: InStream;
        OutStr: OutStream;
        filename: Text;
    begin
        // Create the Xml Document
        TargetXmlDoc := XmlDocument.Create;
        xmlDec := xmlDeclaration.Create('1.0', 'UTF-8', '');
        TargetXmlDoc.SetDeclaration(xmlDec);
        // Create an Instream object & upload the XML file into it
        TempBlob.CreateInStream(Instr);
        // filename := 'data.xml';
        UploadIntoStream('Import XML', '', '', filename, Instr);
        // Read stream into new xml document
        Xmldocument.ReadFrom(Instr, TargetXmlDoc);
        DownloadFromStream(InStr, '', '', '', filename);


    end;

    procedure XMLDocumentCreation()
    var
        xmlDoc: XmlDocument;
        xmlDec: XmlDeclaration;
        xmlElem: XmlElement;
        xmlElem2: XmlElement;
        TempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        TempFile: File;
        fileName: Text;
    begin
        xmlDoc := xmlDocument.Create();
        xmlDec := xmlDeclaration.Create('1.0', 'UTF-8', '');
        xmlDoc.SetDeclaration(xmlDec);

        xmlElem := xmlElement.Create('root');
        xmlElem.SetAttribute('release', '2.1');

        xmlElem2 := XmlElement.Create('FirstName');
        xmlElem2.Add(xmlText.Create('Max'));

        xmlElem.Add(xmlElem2);
        xmlDoc.Add(xmlElem);

        fileName := 'handler.xml';

        // Create an outStream from the Blob, notice the encoding.
        TempBlob.CreateOutStream(outStr, TextEncoding::UTF8);

        // Write the contents of the doc to the stream
        xmlDoc.WriteTo(outStr);

        // From the same Blob, that now contains the XML document, create an inStr
        TempBlob.CreateInStream(inStr, TextEncoding::UTF8);

        // Save the data of the InStream as a file.
        DownloadFromStream(inStr, 'Export', '', '', fileName);
    end;

    procedure CreateJsonOrder(OrderNo: Code[20])
    var
        JsonObjectHeader: JsonObject;
        JsonObjectLines: JsonObject;
        JsonOrderArray: JsonArray;
        JsonArrayLines: JsonArray;
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";
    begin
        //Retrieves the Sales Header
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        //Creates the JSON header details
        JsonObjectHeader.Add('sales_order_no', SalesHeader."No.");
        JsonObjectHeader.Add(' bill_to_customer_no',
       SalesHeader."Bill-to Customer No.");
        JsonObjectHeader.Add('bill_to_name', SalesHeader."Bill-to Name");
        JsonObjectHeader.Add('order_date', SalesHeader."Order Date");
        JsonOrderArray.Add(JsonObjectHeader);
        //Retrieves the Sales Lines
        SalesLines.SetRange("Document Type", SalesLines."Document Type"::Order);
        SalesLines.SetRange("Document No.", SalesHeader."No.");
        if SalesLines.FindSet then
            // JsonObject Init
            JsonObjectLines.Add('line_no', '');
        JsonObjectLines.Add('item_no', '');
        JsonObjectLines.Add('description', '');
        JsonObjectLines.Add('location_code', '');
        JsonObjectLines.Add('quantity', '');
        repeat
            JsonObjectLines.Replace('line_no', SalesLines."Line No.");
            JsonObjectLines.Replace('item_no', SalesLines."No.");
            JsonObjectLines.Replace('description',
           SalesLines.Description);
            JsonObjectLines.Replace('location_code',
           SalesLines."Location Code");
            JsonObjectLines.Replace('quantity', SalesLines.Quantity);
            JsonArrayLines.Add(JsonObjectLines);
        until SalesLines.Next() = 0;
        JsonOrderArray.Add(JsonArrayLines);
    end;

}