pageextension 50102 SalesOrderCard extends "Sales Orders"
{
    trigger OnOpenPage();
    var
        Formatter: Codeunit Formatter;
    begin
        Formatter.CreateJsonOrder(Rec."No.");
    end;
}