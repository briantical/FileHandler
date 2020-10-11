pageextension 50100 CustomerCardExt extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        modify(Name)
        {
            trigger OnAfterValidate()
            var
                TranslationManagement: Codeunit TranslationManagement;
            begin
                if Rec.Name.EndsWith('.com') then begin
                    if Confirm('Do you want to retrieve company details?', false) then
                        TranslationManagement.LookupAddressInfo(Rec.Name, Rec);
                end;
            end;
        }
    }
}