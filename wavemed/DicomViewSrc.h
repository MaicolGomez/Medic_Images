//---------------------------------------------------------------------------

#ifndef DicomViewSrcH
#define DicomViewSrcH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Menus.hpp>

#include <gbdi/image.h>
#include <gbdi/cbi.h>
#include "segmentationutil.h"
using namespace GBDI;

//---------------------------------------------------------------------------
class TDicomView : public TForm{
   __published:	// IDE-managed Components
      TImage *Image;
      TShape *X1;
      TShape *X2;
      TShape *Y1;
      TShape *Y2;
      void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
      void __fastcall ImageMouseMove(TObject *Sender, TShiftState Shift,
            int X, int Y);
      void __fastcall ImageMouseDown(TObject *Sender, TMouseButton Button,
            TShiftState Shift, int X, int Y);
      void __fastcall ImageMouseUp(TObject *Sender, TMouseButton Button,
            TShiftState Shift, int X, int Y);
      void __fastcall FormResize(TObject *Sender);
      void __fastcall FormDestroy(TObject *Sender);
   private:	// User declarations
      enum {BORDERNONE = 0, BORDERX1 = 1, BORDERX2 = 2,
            BORDERY1 = 3, BORDERY2 = 4, BORDERDISABLED = -1};
      tSlice * slice;
      AnsiString filename;
      int viewmode;
      int SelectionMode;
      TSelection Selection;
      float XScale;
      float YScale;
      tCBISlice2TImage * CBISlice2TImage;

      void __fastcall DrawSlice();
      void UpdateSelection();
   public:		// User declarations
      __fastcall TDicomView(TComponent* Owner);

      // Retorna a fatia atribuída a esta instância.
      tSlice * __fastcall GetSlice(){
         return slice;
      }//end GetSlice

      // Determina a fatia a ser mostrada por esta instância
      void __fastcall SetSlice(tSlice * slice);

      //
      AnsiString & __fastcall GetFileName(){
         return filename;
      }//end GetFileName

      void __fastcall SetFileName(const AnsiString filename);

      void __fastcall ApplyAutoLevels(){
         if (slice != NULL){
            slice->AutoLevels();
            DrawSlice();
         }//end if
      }//end ApplyAutoLevels

      void __fastcall ChangeViewMode();
      void __fastcall EnableBorderMark(bool v);
      bool __fastcall IsBorderMarkEnabled(){
         return (SelectionMode != BORDERDISABLED);
      }//end IsBorderMarkEnabled

      void __fastcall BorderToClipboard();
};
#endif
