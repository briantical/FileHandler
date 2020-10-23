pageextension 50102 SalesOrderExt extends "Sales Order"
{
    actions
    {
        addlast(Processing)
        {
            action(CreateXML)
            {
                Caption = 'Create XML File';
                ToolTip = 'Create an XML file of the sales order';
                ApplicationArea = All;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Formatter.XMLDocumentCreation(Rec);
                    // Formatter.ImportXMLs();
                end;
            }

            action(CreateJSON)
            {
                Caption = 'Create JSON File';
                ToolTip = 'Create an JSON file of the sales order';
                ApplicationArea = All;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Formatter.CreateJsonOrder(Rec."No.");
                end;
            }
        }
    }
    var
        Formatter: Codeunit Formatter;
}