//---------------------------------------------------------------------------

#ifndef GaborDlgH
#define GaborDlgH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TGaborForm : public TForm
{
__published:	// IDE-managed Components
    TLabel *Label1;
    TLabel *Label2;
    TEdit *Edit1;
    TEdit *Edit2;
    TButton *Button1;
    void __fastcall Button1Click(TObject *Sender);
private:	// User declarations
    bool Cancel;
public:		// User declarations
    __fastcall TGaborForm(TComponent* Owner);
    
    bool __fastcall Execute();
};
//---------------------------------------------------------------------------
extern PACKAGE TGaborForm *GaborForm;
//---------------------------------------------------------------------------
#endif
