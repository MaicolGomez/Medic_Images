//---------------------------------------------------------------------------

#ifndef ViewDicomSrcH
#define ViewDicomSrcH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>

#include <gbdi/image.h>
#include <gbdi/cbi.h>

using namespace GBDI;
//---------------------------------------------------------------------------
class TViewDicom : public TForm
{
__published:	// IDE-managed Components
        TImage *Image1;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
private:	// User declarations
        tSlice * slice;
        AnsiString filename;

        bool viewmode;

        void __fastcall DrawSlice();

public:		// User declarations
        __fastcall TViewDicom(TComponent* Owner);
        __fastcall ~TViewDicom(){
                if (slice != NULL)
                    delete slice;
        }

        void __fastcall SetSlice(tSlice * slice);
        void __fastcall SetFileName(const AnsiString filename);
};
//---------------------------------------------------------------------------
//extern PACKAGE TViewDicom *ViewDicom;
//---------------------------------------------------------------------------
#endif
