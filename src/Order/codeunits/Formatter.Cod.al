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

    procedure XMLDocumentCreation(var SalesHeader: Record "Sales Header")
    var
        xmlDoc: XmlDocument;
        xmlDec: XmlDeclaration;
        root: XmlElement;
        Comment: XmlComment;
        // Customer details
        Customer: XmlElement;
        Name: XmlElement;
        Address: XmlElement;
        City: XmlElement;
        Contact: XmlElement;
        // Item details
        itemNo: XmlElement;
        Amount: XmlElement;
        Description: XmlElement;
        Quantity: XmlElement;
        SalesItems: XmlElement;
        SalesItem: XmlElement;

        TempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        TempFile: File;
        fileName: Text;
        SalesLine: Record "Sales Line";

    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);

        xmlDoc := xmlDocument.Create();
        xmlDec := xmlDeclaration.Create('1.0', 'UTF-8', '');
        xmlDoc.SetDeclaration(xmlDec);

        root := xmlElement.Create('root');
        root.SetAttribute('release', '2.1');
        Comment := XmlComment.Create('This is an auto generated file. Dont edit');
        root.Add(Comment);

        // Add the customer name
        Name := XmlElement.Create('CustomerName');
        Name.Add(xmlText.Create(SalesHeader."Bill-to Name"));

        // Add the customer address
        Address := XmlElement.Create('Address');
        Address.Add(xmlText.Create(SalesHeader."Bill-to Address"));

        // Add customer city
        City := XmlElement.Create('City');
        City.Add(xmlText.Create(SalesHeader."Bill-to City"));

        // Add customer contact
        Contact := XmlElement.Create('Contact');
        Contact.Add(xmlText.Create(SalesHeader."Bill-to Contact"));

        // Create the customer items
        Customer := XmlElement.Create('Customer');
        SalesItems := XmlElement.Create('Items');

        // Add all the customer details
        Customer.Add(Name);
        Customer.Add(Address);
        Customer.Add(City);
        Customer.Add(Contact);

        if SalesLine.FindSet() then
            repeat
                // Create the item
                SalesItem := XmlElement.Create('Item');

                // Add Item code
                itemNo := XmlElement.Create('Code');
                itemNo.Add(XmlText.Create(SalesLine."No."));
                // Add the item amount
                Amount := XmlElement.Create('Amount');
                Amount.Add(XmlText.Create(System.Format(SalesLine.Amount)));
                // Add the item description
                Description := XmlElement.Create('Description');
                Description.Add(XmlText.Create(SalesLine.Description));
                // Add the item Quantity
                Quantity := XmlElement.Create('Quantity');
                Quantity.Add(XmlText.Create(System.Format(SalesLine.Quantity)));

                SalesItem.Add(itemNo);
                SalesItem.Add(Amount);
                SalesItem.Add(Description);
                SalesItem.Add(Quantity);

                SalesItems.Add(SalesItem);

            until SalesLine.Next() = 0;

        root.Add(Customer);
        root.Add(SalesItems);
        xmlDoc.Add(root);

        fileName := 'sales.xml';

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
        JsonObjectContainer: JsonObject;
        JsonObjectHeader: JsonObject;
        JsonObjectLines: JsonObject;
        JsonOrderArray: JsonArray;
        JsonArrayLines: JsonArray;
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";

        TempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        TempFile: File;
        fileName: Text;
    begin
        //Retrieves the Sales Header
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        //Creates the JSON header details
        JsonObjectHeader.Add('sales_order_no', SalesHeader."No.");
        JsonObjectHeader.Add(' bill_to_customer_no', SalesHeader."Bill-to Customer No.");
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
            JsonObjectLines.Replace('description', SalesLines.Description);
            JsonObjectLines.Replace('location_code', SalesLines."Location Code");
            JsonObjectLines.Replace('quantity', SalesLines.Quantity);
            JsonArrayLines.Add(JsonObjectLines);
        until SalesLines.Next() = 0;
        JsonOrderArray.Add(JsonArrayLines);
        JsonObjectContainer.Add('sales', JsonOrderArray);

        fileName := 'sales.json';

        // Create an outStream from the Blob, notice the encoding.
        TempBlob.CreateOutStream(outStr, TextEncoding::UTF8);

        // Write the contents of the doc to the stream
        JsonObjectContainer.WriteTo(outStr);

        // From the same Blob, that now contains the XML document, create an inStr
        TempBlob.CreateInStream(inStr, TextEncoding::UTF8);

        // Save the data of the InStream as a file.
        DownloadFromStream(inStr, 'Export', '', '', fileName);
    end;
}