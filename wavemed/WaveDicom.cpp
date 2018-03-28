//---------------------------------------------------------------------------

#include <vcl.h>
#include <Clipbrd.hpp>
#pragma hdrstop

#include <gbdi/streams.h>
#include <gbdi/dicom.h>
#include <gbdi/gbdifile.h>

#include "dir.h"
#include "WaveDicom.h"

#include "DicomViewSrc.h"
#include "Clipbrd.hpp"
#include "systdate.h"
#include "time.h"

using namespace GBDI;
using namespace std;
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
//Program initialization
//---------------------------------------------------------------------------

String GetGroupNumber(String sFileName){
   String sGroupNumber = NULL;
   sFileName = sFileName.SubString(sFileName.LastDelimiter("\\")+1,sFileName.Length());
   for(int iCounter = 1; iCounter < sFileName.Length(); iCounter++){
        if(sFileName[iCounter] == '.')
                break;
        sGroupNumber += sFileName[iCounter];
   }
   return sGroupNumber;
}
//---------------------------------------------------------------------------
int GetFileNumber(String sFileName){
   String sFileNumber;
   for(int iCounter = sFileName.LastDelimiter(".")+1; iCounter <= sFileName.Length(); iCounter++){
      sFileNumber += sFileName[iCounter];
   }
   return StrToInt(sFileNumber);
}
//---------------------------------------------------------------------------

void ImprimeImagem(Matrix *img)
{
   FILE *stream2;
   int x,y;

   if ((stream2 = fopen("ImagenText.txt", "w+")) == NULL)
   {
        ShowMessage("Erro...  Selecione arquivo de Características");
        return;
   }

   for(x=0; x<256; x++){
        for(y=0; y<256; y++){
           fprintf(stream2, "%10.5f    ", img->lData[x][y]);
        }
        fprintf(stream2, "\n");
   }
   fclose(stream2);
}

__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
        ene = 0;                            // Image number
        niveis = 3;                         // Nivel number
        pBitmap = new Graphics::TBitmap();  // Bitmap image for store input image

        this->AutoLevelOption->Checked = true;  // Autolevel visualization on
        ComboBox1->ItemIndex = 0;
        ComboBox2->ItemIndex = 0;
        ComboBox3->ItemIndex = 0;

        FileListBox2->Clear();
}

//---------------------------------------------------------------------------
void __fastcall TForm1::FormAcceptFiles(TWMDropFiles & msg){
   int fcount;
   char fname[MAX_PATH + 1];
   WORD size;
   int w;

   // Número de entradas
   fcount = DragQueryFile((HDROP) msg.Drop, 0xFFFFFFFF, NULL, 0);

   // Nomes dos arquivos
   for (w = 0; w < fcount; w++){
      size = DragQueryFile((HDROP) msg.Drop, w, fname, MAX_PATH);
      fname[size] = '\0';

      OpenDicom(fname);
   }//end for

   // Notificando fim do evento
   DragFinish ((HDROP) msg.Drop);
}//end TDicomViewerMainWindow::FormAcceptFiles

// Carrega PBitMap com imagem de Slice
void TForm1::carregaPBitMap()
{
   HPALETTE Palette;
   THandle AHandle;
//      Graphics::TBitmap *pBitmap = new Graphics::TBitmap();

       Clipboard()->Open();
	    Clipboard()->Assign(Imagem->Picture->Bitmap);

        int bmp;

        bmp = Clipboard()->GetAsHandle(CF_BITMAP);
        pBitmap->LoadFromClipboardFormat(CF_BITMAP,bmp,0);

        Clipboard()->Close();
}

//---------------------------------------------------------------------------
// Open a DICOM format file
//---------------------------------------------------------------------------
void __fastcall TForm1::OpenDicom(const AnsiString fname){
   tDataInputStream * in;
   tDicomExplicitFileLoader * dicomfile;
//   tSlice * slice;
   AnsiString errmsg;
        HPALETTE Palette;
        THandle AHandle;

   // User Interface
   Cursor = crHourGlass;

   // Open File
   in = new tDataInputStream(
         new tBufferedInputStream(
         new tFileInputStream(fname.c_str())),
         LittleEndian);

   dicomfile = new tDicomExplicitFileLoader(in);
   slice = dicomfile->LoadSlice();

   if (slice != NULL){
      // Options
      if (this->AutoLevelOption->Checked){
         slice->AutoLevels();
      }//end if
      //------------------------------------------------------------
      //copy Tslice to TImage

      tSlice2TImageConverter * conversor= new tSlice2TImageConverter;
      conversor->Convert(slice,Imagem);
      Imagem->Width = 256;
      Imagem->Height = 256;
      Imagem->Stretch = true;

      carregaPBitMap();

      delete conversor;
   }else{
      errmsg = fname + " não é um arquivo DICOM suportado!";
      MessageBox(this->Handle, errmsg.c_str(), "Dicom Viewer", MB_ICONERROR);
   }//end if

   delete dicomfile;
   delete in;

   // User Interface
   Cursor = crDefault;
}//end OpenDicom

//---------------------------------------------------------------------------
// Open a GBDI format file
//---------------------------------------------------------------------------
void __fastcall TForm1::OpenGBDI(const AnsiString fname)
{
   tDataInputStream * in;
   tGBDIFileLoader * gbdifile;
   AnsiString errmsg, arquivonome;
        HPALETTE Palette;
        THandle AHandle;
   Cursor = crHourGlass;

   // Open File
   in = new tDataInputStream(
        new tBufferedInputStream(
        new tFileInputStream(fname.c_str())),
        LittleEndian);/**/

   gbdifile = new tGBDIFileLoader(in);
   slice = gbdifile->LoadSlice();

   if (slice != NULL){
      // Options
        if (this->AutoLevelOption->Checked){
           slice->AutoLevels();
        }//end if

      //*********************************************************************
      //copy Tslice to TImage

        tSlice2TImageConverter * conversor = new tSlice2TImageConverter;
        conversor->Convert(slice, Imagem);
        Imagem->Width = 256;
        Imagem->Height = 256;
        Imagem->Stretch = true;

        carregaPBitMap();

        delete conversor;
   }else{
      errmsg = fname + " não é um arquivo GBDI suportado!";
      MessageBox(this->Handle, errmsg.c_str(), "Dicom Viewer", MB_ICONERROR);
   }//end if
   delete gbdifile;
   delete in;

   // User Interface
   Cursor = crDefault;
}//end DoOpen

//---------------------------------------------------------------------------
// display images into Panel view
//---------------------------------------------------------------------------
void TForm1::CreateImageWindow(tSlice * image, const AnsiString title){
   TDicomView * view;

   if (image == NULL){
      return;
   }//end if

   // Create View
   view = new TDicomView(NULL);
   view->SetFileName(title);

//   if (this->ColorMappingViewOption->Checked){
//      view->ChangeViewMode();
//   }//end if

   view->SetSlice(image);
//******************************** my code
   int ubix,ubiy;
   view->Height = 179;
   view->Width = 179;
   ubix = 180*((this->MDIChildCount-1) % 4);
   ubiy = int((this->MDIChildCount-1)/4);
   ubiy*=180;
   view->Top = ubiy;
   view->Left = ubix;

//*************************************

   view->Visible = true;
}//end TDicomViewerMainWindow::CreateImageWindow

//---------------------------------------------------------------------------
// Open a image by a OpenDialog
//---------------------------------------------------------------------------
void __fastcall TForm1::Abrir1Click(TObject *Sender)
{
    int w;
    AnsiString NomeAux;

   // Setup Open Dialog
   OpenDialog->Filter = "Arquivos GBDI|*.*|Arquivos DICOM|*.*";
   OpenDialog->Title = "Abrir...";
   if (OpenDialog->Execute()){
      switch (OpenDialog->FilterIndex){
         case 1:
            // DICOM file
            for (w = 0; w < OpenDialog->Files->Count; w++){
                NomeAux = OpenDialog->Files->Strings[w];
               OpenGBDI(OpenDialog->Files->Strings[w]);
            }//end for
            break;
         case 2:
            // GBDI file
            for (w = 0; w < OpenDialog->Files->Count; w++){
                NomeAux = OpenDialog->Files->Strings[w];
               OpenDicom(OpenDialog->Files->Strings[w]);
            }//end for
            break;
      }//end switch
      Label8->Caption = NomeAux;
   }//end if
}//end TDicomViewerMainWindow::OpenMenuItemClick


//---------------------------------------------------------------------------

void __fastcall TForm1::AutoLevelOptionClick(TObject *Sender)
{
   this->AutoLevelOption->Checked = !this->AutoLevelOption->Checked;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FormCreate(TObject *Sender)
{
        DragAcceptFiles(Handle, True);
}

//---------------------------------------------------------------------------
// Search the most similar set of images into Image data base
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
    clock_t start, end;
    float tempinho;

    HPALETTE Palette;
    TFeature * Vetor = new TFeature();
    double *Vetor_Img;

    int bmp;

    if(slice == NULL){
         ShowMessage("Escolha uma imagem");
         return;
    }

    if (ComboBox1->ItemIndex == 2)
    // if the Gabor wavelet feature is choiced
    //
    {
            Matrix *subimg;
            int side,scale, orientation, flag, s, n;
            double Ul, Uh;
            WORD ValorPixel;
            DWORD TheRGBValue;
            int RR, GG, BB;
            int k,l, dimension, vHeight, vWidth;

            Ul = 0.05;          //lower frequency
            Uh = 0.4;           //upper frequency
            scale = StrToInt(EditEscalas->Text);              //number of scales in generation filters
            orientation = StrToInt(EditOrientacoes->Text);    //number of orientations in generating filters
            flag = 1;           //remove de DC
            side = 40;          // filter msk = 2*side+1 x 2*side+1

            iNroFeatures = scale*orientation*2;
            Vetor_Img = new double[iNroFeatures];

            vWidth = slice->GetWidth(); vHeight = slice->GetHeight();

            CreateMatrix(&subimg,slice->GetWidth(),slice->GetHeight());

            for(k=0;k<slice->GetHeight();k++)
                for(l=0;l<slice->GetWidth();l++)
                {
                        ValorPixel = slice->GetPixel(k,l);
                        ValorPixel = ValorPixel >> 8;
                        subimg->lData[k][l] = ValorPixel;
                }

//            ImprimeImagem(subimg);

            GaborFeature(Vetor_Img, subimg, side,Ul, Uh, scale,orientation,flag);

            FreeMatrix(subimg);
    }
    else
    // if the Haar or Daubechies wavelet feature is choiced
    {
        iNroFeatures = 9;
        TWavelet * Onda2 = new TWavelet();

        Vetor_Img = new double[iNroFeatures];

        Onda2->CalculaWavelet(pBitmap, niveis,ComboBox1->ItemIndex);
        Vetor->CalculaFeature(Onda2, niveis, ComboBox2->ItemIndex);

        delete Onda2;

     }
//---------------------------------------------------
//Busca do vetor de Características no banco de dados

    start = clock();

    if (ComboBox1->ItemIndex == 2){             // In case the features are Gabor
        Vetor->VetorCaracteristica = Vetor_Img;
    }

    if (ComboBox3->ItemIndex == 0){             //Calcula distância Euclideana
         Vetor->CarregaFeatures(Edit1->Text,Vetor->VetorCaracteristica);
    }
    if (ComboBox3->ItemIndex == 1){             //Calcula distância Euclideana Normalizada
         Vetor->DistanciaManju(Edit1->Text, Vetor->VetorCaracteristica);
    }

     ene=0;

     end = clock();

     tempinho = (float)((end - start) / CLK_TCK);

        ShowMessage("Tempo de matching" + FloatToStr(tempinho));

//---------------------------------------------------
//Shows results into panel
     int iRelevanceImagesCounter = 0;

     TDadosImagem *diTemp;

     for(int x = 0; x<20; x++)
     {
         tDataInputStream * in;
         tDicomExplicitFileLoader * dicomfile;

         diTemp = (TDadosImagem *)Vetor->lResultados->Items[x];

         in = new tDataInputStream( new tBufferedInputStream(new tFileInputStream(diTemp->ArquivoNome)), LittleEndian);

         if (this->DicomImage1->Checked){
                dicomfile = new tDicomExplicitFileLoader(in);
                slice = dicomfile->LoadSlice();
         }
         else {
               ShowMessage("Formato ainda não implementado");
               return;
//                gbdifile = new tGBDIFileLoader(in);
//                slice = gbdifile->LoadSlice();
         };

         if (this->AutoLevelOption->Checked)
             slice->AutoLevels();
/*
         if(GetGroupNumber(OpenDialog->FileName) == GetGroupNumber(diTemp->ArquivoNome)){
            if(GetFileNumber(diTemp->ArquivoNome) <= 10){
                iRelevanceImagesCounter++;
                String sTemp = " - "+IntToStr(iRelevanceImagesCounter)+"/"+IntToStr(x+1);
                StrCat(diTemp->ArquivoNome,sTemp.c_str());
            }
         }
         FileListBox2->Items->Strings[x] = IntToStr(iRelevanceImagesCounter);
*/

//         F(slice,diTemp->ArquivoNome);    //Visualiza com nome de arquivo
         CreateImageWindow(slice,FloatToStr(diTemp->Distancia));      //Visualiza com distância

         FileListBox2->Items->Strings[x] = diTemp->ArquivoNome;
        delete in;
        delete dicomfile;
//        delete gbdifile;
     }
//     delete diTemp;
     delete Vetor;
     delete []Vetor_Img;
}
//---------------------------------------------------------------------------
// Generates feature vectors
//---------------------------------------------------------------------------
void __fastcall TForm1::GeraVetordeCaractersticas1Click(TObject *Sender)
{
        int w;
        TDateTime Time1, Time2, Time3;
        FILE *stream2;

        ArquivoName = Edit1->Text;

        if ((stream2 = fopen(ArquivoName.c_str(), "w+")) == NULL)
        {
             ShowMessage("Erro...  Selecione arquivo de Características");
             return;
        }

        if (FileListBox2->Items->Count > 0){
            // GBDI file
                   ProgressBar1->Enabled=true;
                   ProgressBar1->Min = 0;
                   ProgressBar1->Max = FileListBox2->Items->Count;
                   ProgressBar1->Position=0;

                   //-----------------------------------------------
                   // Print head file
                   //--------------------------------
                   fprintf(stream2, "%d     %d", FileListBox2->Items->Count, 10);
                   fprintf(stream2, "\n");

                   Time1 = Time();

                   for (w = 0; w < FileListBox2->Items->Count; w++){
                        TWavelet * Onda2 = new TWavelet();
                        TFeature * Vetor = new TFeature();

                        if(this->DicomImage1->Checked)
                            OpenDicom(FileListBox2->Items->Strings[w]);
                        else
                            OpenGBDI(FileListBox2->Items->Strings[w]);

                        Onda2->CalculaWavelet(pBitmap, niveis,ComboBox1->ItemIndex);
                        Vetor->CalculaFeature(Onda2, niveis,ComboBox2->ItemIndex);
                        Vetor->ArmazenaDados(FileListBox2->Items->Strings[w], stream2);

                        ProgressBar1->Position++;

                        delete Onda2;
                        delete Vetor;

                   }//end for
                    Time2 = Time();
                    Time3 = Time2 - Time1;

                   ShowMessage("Final da geração dos Vetores de Característica" + TimeToStr(Time3));
                   ProgressBar1->Enabled=false;
        }
        else
        {
                ShowMessage("Precisa escolher os arquivos para gerar seus vetores de característica");
        }
        fclose(stream2);
//        OpenDialog->Options << ofAllowMultiSelect;
}
//---------------------------------------------------------------------------
// Select a file with feature vectors
//---------------------------------------------------------------------------

void __fastcall TForm1::EscolhaClick(TObject *Sender)
{

   // Setup Open Dialog
   OpenDialog->Filter = "Arquivos de Características|*.txt";
   OpenDialog->Title = "Abrir/Criar Arquivo de Características...";
   if (OpenFeatureFile->Execute()){
               ArquivoName = OpenFeatureFile->Files->Strings[0];
               Edit1->Text = ArquivoName;
   }
}
//---------------------------------------------------------------------------
//Select files for feature vectors generation
//---------------------------------------------------------------------------

/*void __fastcall TForm1::DriveComboBox1Change(TObject *Sender)
{
  if(DriveComboBox1->Drive != '\0'){
      FileListBox1->Drive = DriveComboBox1->Drive;
      DirectoryListBox1->Drive = DriveComboBox1->Drive;
      FileListBox1->Directory = DirectoryListBox1->Directory;
  }
} */
//---------------------------------------------------------------------------

/*void __fastcall TForm1::DirectoryListBox1Change(TObject *Sender)
{
  FileListBox1->Directory = DirectoryListBox1->Directory;

} */
//---------------------------------------------------------------------------
// send a file to select area
//---------------------------------------------------------------------------
/* void __fastcall TForm1::BitBtn1Click(TObject *Sender)
{
        for(int x=0; x<FileListBox1->Items->Count; x++){

            if( FileListBox1->Items->Strings[x].Pos(".txt") == 0){
                FileListBox2->Items->Append(DirectoryListBox1->Directory +"\\"+ FileListBox1->Items->Strings[x]);
            }
        }
        FileListBox1->Clear();
}
*/
//---------------------------------------------------------------------------
// send a group file selected to select area
//---------------------------------------------------------------------------
/*
void __fastcall TForm1::BitBtn2Click(TObject *Sender)
{
    int Aux_count = FileListBox1->SelCount;

     for(int x = 0; x<Aux_count; x++)
     {
        FileListBox2->Items->Append(DirectoryListBox1->Directory +"\\"+ FileListBox1->Items->Strings[FileListBox1->ItemIndex]);
        FileListBox1->Items->Delete(FileListBox1->ItemIndex);
     }
}
*/
//---------------------------------------------------------------------------
// Feature vector generation based on Gabor wavelet
//---------------------------------------------------------------------------
void __fastcall TForm1::GeraGaborFeatures1Click(TObject *Sender)
{
    WORD ValorDePixel1;
    Matrix *subimg;
    int side,scale, orientation, flag, s, n;
    double Ul, Uh;
    double *feature_tmp;
    FILE *fp;
    DWORD TheRGBValue;
    int RR, GG, BB;
    int i,j,k,l, dimension;

    Ul = 0.05;          //lower frequency
    Uh = 0.4;           //upper frequency
    scale = 2;          //number of scales in generation filters
    orientation = 6;    //number of orientations in generating filters
    flag = 1;           //remove de DC
    side = 40;          // filter msk = 2*side+1 x 2*side+1
//---------------------------------------------------------------------------

    dimension = scale*orientation*2;
    feature_tmp = new double[dimension];

    ProgressBar1->Enabled=true;
    ProgressBar1->Min = 0;
    ProgressBar1->Max = FileListBox2->Items->Count;
    ProgressBar1->Position=0;

    ArquivoName = Edit1->Text;

    if ((fp = fopen(ArquivoName.c_str(), "w+")) == NULL)
    {
         ShowMessage("Erro...  Selecione arquivo de Características");
         return;
    }

    fprintf(fp, "%d     %d", FileListBox2->Items->Count, dimension+1);
    fprintf(fp, "\n");

    for (int m = 0; m < FileListBox2->Items->Count; m++)
    {
            if(this->DicomImage1->Checked)
                OpenDicom(FileListBox2->Items->Strings[m]);
            else
                OpenGBDI(FileListBox2->Items->Strings[m]);

            CreateMatrix(&subimg,slice->GetWidth(), slice->GetHeight());

//          ShowMessage("processing image "+ IntToStr(i)+IntToStr(j));
//          geração de sub-imagem a partir da imagem de entrada

            for(k=0;k<slice->GetHeight();k++)
                for(l=0;l<slice->GetWidth();l++)
                {
                        ValorDePixel1 = slice->GetPixel(k,l);
                        ValorDePixel1 = ValorDePixel1 >> 8;
                        subimg->lData[k][l] = ValorDePixel1;

                }
            //Extração das características de textura de cada subimagem
            GaborFeature(feature_tmp, subimg, side,Ul, Uh, scale,orientation,flag);
            fprintf(fp, "%s  ",FileListBox2->Items->Strings[m]);
            for(k=0;k<dimension;k++)
            {
                fprintf(fp, "%12.8f", feature_tmp[k]);
            }
//----------------------------------------
// Processa Path para colocar como última característica
/*          String sDirPath;
            ProcessPath(FileListBox2->Items->Strings[m], NULL, sDirPath, NULL);
            int iSomaLexicograficaDoNomeDoArquivo = 0;

            for(int iCounter = 1; iCounter <= FileListBox2->Items->Strings[m].Length(); iCounter++){
               iSomaLexicograficaDoNomeDoArquivo += sDirPath[iCounter]; }
            fprintf(fp, "   %s", IntToStr(iSomaLexicograficaDoNomeDoArquivo));
*/
//-----------------------------------------
            fprintf(fp, "\n");
            ProgressBar1->Position++;
            FreeMatrix(subimg);
}
//Salva  os vetores de características
    ProgressBar1->Enabled = false;
    fclose(fp);
    delete feature_tmp;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::AbrirJanelaGabor1Click(TObject *Sender)
{
      GaborForm->Execute();
}
//---------------------------------------------------------------------------



void __fastcall TForm1::DicomImage1Click(TObject *Sender)
{
    DicomImage1->Checked = !DicomImage1->Checked;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FileListBox2Click(TObject *Sender)
{

   TClipboard *cbTemp = Clipboard();

   cbTemp->AsText = FileListBox2->Items->Text;
}
//---------------------------------------------------------------------------


void __fastcall TForm1::Button2Click(TObject *Sender)
{
     int Aux_count = FileListBox2->SelCount;

     for(int x = 0; x<Aux_count; x++)
     {
        FileListBox2->Items->Delete(FileListBox2->ItemIndex);
     }
}
//---------------------------------------------------------------------------



void __fastcall TForm1::FormCloseQuery(TObject *Sender, bool &CanClose)
{
   CanClose = true;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::NovaConsulta1Click(TObject *Sender)
{
    int janelas;
    janelas = this->MDIChildCount;

    for (int ww = 0; ww < janelas; ww++){
//      this->MDIChildren[w]->Close();
        delete this->MDIChildren[0];
   }//end for

   slice = NULL;


}
//---------------------------------------------------------------------------


