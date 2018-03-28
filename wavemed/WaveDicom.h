//---------------------------------------------------------------------------

#ifndef WaveDicomH
#define WaveDicomH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Menus.hpp>
#include <Dialogs.hpp>
#include <ExtCtrls.hpp>
#include <Graphics.hpp>
#include <ComCtrls.hpp>
#include <FileCtrl.hpp>
#include <Buttons.hpp>

#include <gbdi/image.h>

#include <gbdi/streams.h>
#include <gbdi/dicom.h>
#include <gbdi/gbdifile.h>

#include "Matrix.h"
#include "GaborFeat.h"
#include "GaborDlg.h"

#include "Auxiliar.h"
#include "Feature.h"
#include "Wavelet.h"

using namespace GBDI;

//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TMainMenu *MainMenu1;
        TMenuItem *File1;
        TMenuItem *Abrir1;
        TMenuItem *N1;
        TMenuItem *Escolha;
        TMenuItem *Options1;
        TMenuItem *AutoLevelOption;
        TOpenDialog *OpenDialog;
        TMenuItem *Miscelaneas1;
        TMenuItem *Help1;
        TMenuItem *About1;
        TMenuItem *GeraVetordeCaractersticas1;
        TMenuItem *Sair1;
        TMenuItem *Sair;
        TOpenDialog *OpenFeatureFile;
    TMenuItem *GeraGaborFeatures1;
    TMenuItem *AbrirJanelaGabor1;
    TMenuItem *DicomImage1;
   TGroupBox *GroupBox1;
   TImage *Imagem;
   TButton *Button1;
   TLabel *Label1;
   TLabel *Label2;
   TLabel *Label3;
   TComboBox *ComboBox1;
   TComboBox *ComboBox2;
   TComboBox *ComboBox3;
   TProgressBar *ProgressBar1;
   TEdit *Edit1;
   TLabel *Label4;
   TMenuItem *NovaConsulta1;
   TLabel *Label5;
   TLabel *Label6;
   TEdit *EditEscalas;
   TEdit *EditOrientacoes;
        TFileListBox *FileListBox2;
    TLabel *Label7;
    TLabel *Label8;
        void __fastcall Abrir1Click(TObject *Sender);
        void __fastcall AutoLevelOptionClick(TObject *Sender);
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall GeraVetordeCaractersticas1Click(TObject *Sender);
        void __fastcall EscolhaClick(TObject *Sender);
//        void __fastcall DriveComboBox1Change(TObject *Sender);
//        void __fastcall DirectoryListBox1Change(TObject *Sender);
//        void __fastcall BitBtn1Click(TObject *Sender);
//        void __fastcall BitBtn2Click(TObject *Sender);
    void __fastcall GeraGaborFeatures1Click(TObject *Sender);
    void __fastcall AbrirJanelaGabor1Click(TObject *Sender);
    void __fastcall DicomImage1Click(TObject *Sender);
   void __fastcall FileListBox2Click(TObject *Sender);
   void __fastcall Button2Click(TObject *Sender);
   void __fastcall FormCloseQuery(TObject *Sender, bool &CanClose);
   void __fastcall NovaConsulta1Click(TObject *Sender);

private:	// User declarations
        int ene;
        int niveis;
        double VetorMedia[9];
        Graphics::TBitmap *pBitmap;
        tSlice * slice;
        AnsiString ArquivoName;

        void __fastcall FormAcceptFiles(TWMDropFiles & msg);
        void __fastcall OpenDicom(const AnsiString fname);
        void __fastcall OpenGBDI(const AnsiString fname);
        void CreateImageWindow(tSlice * image, const AnsiString title);
        void carregaPBitMap();
//        float *VetorCaracteristica;

public:		// User declarations

        __fastcall TForm1(TComponent* Owner);

        BEGIN_MESSAGE_MAP
        MESSAGE_HANDLER(WM_DROPFILES, TWMDropFiles, FormAcceptFiles)
        END_MESSAGE_MAP(TForm);
//        void __fastcall ShowSlide(tSlice *slice, double ValorDist, const AnsiString fname);
};

//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------

#endif
