//---------------------------------------------------------------------------
#include <vcl.h>
#include <vcl/Clipbrd.hpp>
#pragma hdrstop
#include "DicomViewSrc.h"
#include <math.h>

#define Round(x) int(floor((x) + 0.5))

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TDicomView *DicomView;

// Static color models
static tCBIColorModel CBIColorModel;
static tCBI16BitColorModel CBI16BitColorModel;
static tCBIColorModel * ColorModel[] = {&CBIColorModel, &CBI16BitColorModel};

//---------------------------------------------------------------------------
__fastcall TDicomView::TDicomView(TComponent* Owner)
   : TForm(Owner){

   this->slice = NULL;
   viewmode = 0;
   CBISlice2TImage = new tCBISlice2TImage(ColorModel[viewmode]);
   SelectionMode = BORDERDISABLED;
}//end TDicomView::TDicomView

//---------------------------------------------------------------------------

void __fastcall TDicomView::FormClose(TObject *Sender,
      TCloseAction &Action){

   // Free converter
   delete CBISlice2TImage;
   Action = caFree;
}//end TDicomView::FormClose
//---------------------------------------------------------------------------

void __fastcall TDicomView::SetSlice(tSlice * slice){
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
      this->Image->Hint = newhint;

      this->Image->Align = alClient; // Align para zoom
      this->SetFocus();
   }//end if
}//end TDicomView::SetSlice

//---------------------------------------------------------------------------
void __fastcall TDicomView::DrawSlice(){

   CBISlice2TImage->DrawSlice(slice, Image, 179, 179);
}//end TDicomView::DrawSlice

//---------------------------------------------------------------------------
void __fastcall TDicomView::SetFileName(const AnsiString filename){
   this->Caption = filename;
   this->filename = filename;
}//end TDicomView::GetFileName
//---------------------------------------------------------------------------

void __fastcall TDicomView::ImageMouseMove(TObject *Sender,
      TShiftState Shift, int X, int Y){

   switch (SelectionMode){
      case BORDERX1:
         Selection.SetX1(X);
         break;
      case BORDERX2:
         Selection.SetX2(X);
         break;
      case BORDERY1:
         Selection.SetY1(Y);
         break;
      case BORDERY2:
         Selection.SetY2(Y);
         break;
   }//end switch
   UpdateSelection();
}//end TDicomView::ImageMouseMove
//---------------------------------------------------------------------------
void __fastcall TDicomView::ImageMouseDown(TObject *Sender,
      TMouseButton Button, TShiftState Shift, int X, int Y){

   if (SelectionMode == BORDERDISABLED){
      return;
   }//end if

   if (Button == mbLeft){
      // X axis
      if (Shift.Contains(ssShift)){
         SelectionMode = BORDERX1;
      }else{
         SelectionMode = BORDERX2;
      }//end if
   }else{
      // Y axis
      // X axis
      if (Shift.Contains(ssShift)){
         SelectionMode = BORDERY1;
      }else{
         SelectionMode = BORDERY2;
      }//end if
   }//end if
   UpdateSelection();
}//end TDicomView::ImageMouseDown
//---------------------------------------------------------------------------

void __fastcall TDicomView::ImageMouseUp(TObject *Sender,
      TMouseButton Button, TShiftState Shift, int X, int Y){

   if (SelectionMode != BORDERDISABLED){
      SelectionMode = BORDERNONE;
   }//end if
}//end TDicomView::ImageMouseUp
//---------------------------------------------------------------------------
void __fastcall TDicomView::FormResize(TObject *Sender){

   Y1->Width = ClientWidth;
   Y2->Width = ClientWidth;
   X1->Height = ClientHeight;
   X2->Height = ClientHeight;
   Selection.SetBounds(0, 0, ClientWidth - 1, ClientHeight - 1);

   // Scale Constant
   XScale = float(slice->GetWidth()) / float(ClientWidth);
   YScale = float(slice->GetHeight()) / float(ClientHeight);
}//end TDicomView::FormResize
//---------------------------------------------------------------------------
void __fastcall TDicomView::EnableBorderMark(bool v){

   if (v){
      X1->Visible = true;
      X2->Visible = true;
      Y1->Visible = true;
      Y2->Visible = true;
      SelectionMode = BORDERNONE;
      UpdateSelection();
   }else{
      X1->Visible = false;
      X2->Visible = false;
      Y1->Visible = false;
      Y2->Visible = false;
      SelectionMode = BORDERDISABLED;
   }//end if
}//end TDicomView::EnableBorderMark
//---------------------------------------------------------------------------
void __fastcall TDicomView::BorderToClipboard(){
   AnsiString s;

   s.printf("%s\t%d\t\%d\t%d\t%d",
      filename.c_str(),
      Round(Selection.GetLeft() * XScale),
      Round(Selection.GetTop() * YScale),
      Round(Selection.GetWidth() * XScale),
      Round(Selection.GetHeight() * YScale));
   Clipboard()->SetTextBuf(s.c_str());   
}//end TDicomView::BorderToClipboard
//---------------------------------------------------------------------------
void TDicomView::UpdateSelection(){

   X1->Left = Selection.GetX1();
   X2->Left = Selection.GetX2();
   Y1->Top = Selection.GetY1();
   Y2->Top = Selection.GetY2();
}//end TDicomView::UpdateSelection
//---------------------------------------------------------------------------

void __fastcall TDicomView::FormDestroy(TObject *Sender){

   if (this->slice != NULL){
      delete slice;
   }//end if
}//end TDicomView::FormDestroy
//---------------------------------------------------------------------------
void __fastcall TDicomView::ChangeViewMode(){
   viewmode = (viewmode + 1) % 2;
   CBISlice2TImage->SetColorModel(ColorModel[viewmode]);
   DrawSlice();
}//end TDicomView::ChangeViewMode
//---------------------------------------------------------------------------

