pageextension 50101 OrderExtension extends "Sales Order List"
{
    trigger OnOpenPage();
    var
        Formatter: Codeunit Formatter;
    begin
        Formatter.ImportXMLs();
    end;
}