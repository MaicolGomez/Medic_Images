//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("WaveMed.res");
USEFORM("WaveDicom.cpp", Form1);
USEUNIT("Wavelet.cpp");
USEUNIT("Feature.cpp");
USEUNIT("Auxiliar.cpp");
USEUNIT("Matrix.cpp");
USEUNIT("GaborFeat.cpp");
USEFORM("GaborDlg.cpp", GaborForm);
USELIB("..\dicomlib\lib\dicomlibcbi.lib");
USELIB("..\dicomlib\lib\dicomlib.lib");
USEFORM("DicomViewSrc.cpp", DicomView);
USEUNIT("SegmentationUtil.cpp");
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->CreateForm(__classid(TForm1), &Form1);
       Application->CreateForm(__classid(TGaborForm), &GaborForm);
       Application->Run();
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
