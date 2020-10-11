codeunit 50101 Formatter
{
    local procedure ImportXML()
    var
        TempBlob: Codeunit "Temp Blob";
        TargetXmlDoc: XmlDocument;
        XmlDec: XmlDeclaration;
        Instr: InStream;
        filename: Text;
    begin
        // Create the Xml Document
        TargetXmlDoc := XmlDocument.Create;
        xmlDec := xmlDeclaration.Create('1.0', 'UTF-8', '');
        TargetXmlDoc.SetDeclaration(xmlDec);
        // Create an Instream object & upload the XML file into it
        TempBlob.CreateInStream(Instr);
        filename := 'data.xml';
        UploadIntoStream('Import XML', '', '', filename, Instr);
        // Read stream into new xml document
        Xmldocument.ReadFrom(Instr, TargetXmlDoc);
    end;

    local procedure XMLDocumentCreation()
    var
        xmldoc: XmlDocument;
        xmlDec: XmlDeclaration;
        node1: XmlElement;
        node2: XmlElement;
    begin
        xmldoc := XmlDocument.Create();
        xmlDec := xmlDeclaration.Create('1.0', 'UTF-8', '');
        xmlDoc.SetDeclaration(xmlDec);
        node1 := XmlElement.Create('node1');
        xmldoc.Add(node1);
        node2 := XmlElement.Create('node2');
        node2.SetAttribute('ID', '3');
        node1.Add(node2);
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