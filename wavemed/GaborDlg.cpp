//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "GaborDlg.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TGaborForm *GaborForm;
//---------------------------------------------------------------------------
__fastcall TGaborForm::TGaborForm(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------
// Execute this dialog
bool __fastcall TGaborForm::Execute(){

   Cancel = false;
   ShowModal();
   return Cancel;
}//end TGaborForm::Execute
//---------------------------------------------------------------------------

void __fastcall TGaborForm::Button1Click(TObject *Sender)
{
    Close();
}
//---------------------------------------------------------------------------

