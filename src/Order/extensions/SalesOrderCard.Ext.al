pageextension 50102 SalesOrderExt extends "Sales Order"
{
    actions
    {
        addlast(Processing)
        {
            action(AddFreeGifts)
            {
                Caption = 'Create XML File';
                ToolTip = 'Create an XML file of the sales order';
                ApplicationArea = All;
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Formatter.XMLDocumentCreation();
                end;
            }
        }
    }
    var
        Formatter: Codeunit Formatter;
}