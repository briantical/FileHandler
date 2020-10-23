pageextension 50103 ItemCardExt extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addfirst(processing)
        {
            action(EditItem)
            {
                Caption = 'Upload and Edit';
                ToolTip = 'Upload XML file and Update the item';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Uploader.ImportXML();
                end;
            }
        }
    }

    var
        Uploader: Codeunit Uploader;
}