//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ViewDicomSrc.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TViewDicom *ViewDicom;
//---------------------------------------------------------------------------
__fastcall TViewDicom::TViewDicom(TComponent* Owner)
        : TForm(Owner)
{
    this->slice = NULL;
    viewmode = false;

}
//---------------------------------------------------------------------------

void __fastcall TViewDicom::SetSlice(tSlice * slice){
   AnsiString newhint;

   this->slice = slice;
   if (slice != NULL){
      // Convert the image

      DrawSlice();


      // Setup Interface
      this->ClientWidth = slice->GetWidth();
      this->ClientHeight = slice->GetHeight();
      newhint.printf("(%d x %d)",
            slice->GetWidth(),
            slice->GetHeight());
      this->Image1->Hint = newhint;

      this->Image1->Align = alClient; // Align para zoom

      this->SetFocus();
   }//end if
}//end TViewDicom::SetSlice

//---------------------------------------------------------------------------
void __fastcall TViewDicom::DrawSlice()
{
     tSlice2TImageConverter * converter;

     if(slice != NULL)
     {
//        this->Hide();

        converter = new tSlice2TImageConverter();
        converter->Convert(slice, Image1);
        delete converter;
     }

}

//---------------------------------------------------------------------------

void __fastcall TViewDicom::SetFileName(const AnsiString filename)
{
        this->Caption = filename;
        this->filename = filename;
}

//---------------------------------------------------------------------------
void __fastcall TViewDicom::FormClose(TObject *Sender,
      TCloseAction &Action)
{
        Action = caFree;
}
//---------------------------------------------------------------------------

