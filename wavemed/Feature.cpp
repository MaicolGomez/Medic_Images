//---------------------------------------------------------------------------

#include <vcl.h>
#include <FileCtrl.hpp>
#pragma hdrstop

#include "math.h"
#include "Feature.h"


using namespace GBDI;

#pragma package(smart_init)


int __fastcall GBDI::DadosImagemComparisonFunction(void *Item1, void *Item2){
    TDadosImagem *diTemp1 = (TDadosImagem *)Item1;
    TDadosImagem *diTemp2 = (TDadosImagem *)Item2;

    if (diTemp1->Distancia > diTemp2->Distancia)
        return 1;
    else if (diTemp1->Distancia < diTemp2->Distancia)
        return -1;
    else return 0;
}


//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------
__fastcall TFeature::TFeature(void){
        lResultados = new TList();
        VetorCaracteristica = new double[iNroFeatures];
        VetorTemporal = new double[iNroFeatures];
}
//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------
__fastcall TFeature::~TFeature(void){
        lResultados->Free();
}
//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

void TFeature::CalculaFeature(TWavelet *a, int niveis, int Caracteristica)
{
        switch(Caracteristica){

            case 0 : Media(a,niveis); break;
            case 1 : Energia(a,niveis); break;
            case 2 : Entropia(a,niveis); break;

        };
}
//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------
void TFeature::Media(TWavelet *a, int niveis)
{
        int mit1,mit2,cont,dif;
        double media,soma;
        mit1 = a->ImageWidth;
        mit2 = a->ImageHeight;

        cont=0;

        while( cont<3*(niveis))
        {
           VetorCaracteristica[cont]=0;
           soma = 0;
           dif = mit1-mit1/2;
           for(int i = mit1; i>mit1/2; i--)
             for(int j = mit2; j>mit2/2; j--)
             {
                   soma += a->AuxMatrix[i][j];
             }

           media = soma/(dif*dif);
           soma=0;
           for(int i = mit1; i>mit1/2; i--)
             for(int j = mit2; j>mit2/2; j--)
                   soma += (a->AuxMatrix[i][j]-media)*(a->AuxMatrix[i][j]-media);
           VetorCaracteristica[cont]=sqrt(soma/(dif*dif));

           cont++;

           VetorCaracteristica[cont]=0;
           soma=0;
           for(int i = mit1/2; i>0; i--)
             for(int j = mit2; j>mit2/2; j--)
             {
                 soma += a->AuxMatrix[i][j];
             }
           media=soma/(dif*dif);

           soma=0;
           for(int i = mit1/2; i>0; i--)
             for(int j = mit2; j>mit2/2; j--)
                   soma += (a->AuxMatrix[i][j]-media)*(a->AuxMatrix[i][j]-media);
           VetorCaracteristica[cont]=sqrt(soma/(dif*dif));

           cont++;

           VetorCaracteristica[cont]=0;
           soma=0;
           for(int i = mit1; i>mit1/2; i--)
             for(int j = mit2/2; j>0; j--)
             {
               soma += a->AuxMatrix[i][j];
             };
           media=soma/(dif*dif);
           soma=0;
           for(int i = mit1; i>mit1/2; i--)
             for(int j = mit2/2; j>0; j--)
                   soma += (a->AuxMatrix[i][j]-media)*(a->AuxMatrix[i][j]-media);
           VetorCaracteristica[cont]=sqrt(soma/(dif*dif));

           cont++;

           mit1=mit1/2; mit2=mit2/2;
        }
}
//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------
void TFeature::Energia(TWavelet *a, int niveis)
{
        int mit1,mit2,cont;
        mit1 = a->ImageWidth;
        mit2 = a->ImageHeight;

        cont=0;

        while( cont<3*(niveis))
        {
           VetorCaracteristica[cont]=0;
           for(int i = mit1; i>mit1/2; i--)
             for(int j = mit2; j>mit2/2; j--)
             {
                   VetorCaracteristica[cont] += a->AuxMatrix[i][j]*a->AuxMatrix[i][j];
             }

           cont++;

           VetorCaracteristica[cont]=0;
           for(int i = mit1/2; i>0; i--)
             for(int j = mit2; j>mit2/2; j--)
             {
                 VetorCaracteristica[cont] += a->AuxMatrix[i][j]*a->AuxMatrix[i][j];
             }

           cont++;

           VetorCaracteristica[cont]=0;
           for(int i = mit1; i>mit1/2; i--)
             for(int j = mit2/2; j>0; j--)
             {
               VetorCaracteristica[cont] += a->AuxMatrix[i][j]*a->AuxMatrix[i][j];
             };
           cont++;
           mit1=mit1/2; mit2=mit2/2;
        }
}
//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------
void TFeature::Entropia(TWavelet *a, int niveis)
{
        int mit1,mit2,cont;
        mit1 = a->ImageWidth;
        mit2 = a->ImageHeight;

        cont=0;

        while( cont<3*(niveis))
        {
           VetorCaracteristica[cont]=0;
           for(int i = mit1; i>mit1/2; i--)
             for(int j = mit2; j>mit2/2; j--)
             {
                   if(a->AuxMatrix[i][j]>0)
                       VetorCaracteristica[cont]+=a->AuxMatrix[i][j]*log(a->AuxMatrix[i][j])/log(2);
             }

           cont++;

           VetorCaracteristica[cont]=0;
           for(int i = mit1/2; i>0; i--)
             for(int j = mit2; j>mit2/2; j--)
             {
                   if(a->AuxMatrix[i][j]>0)
                       VetorCaracteristica[cont]+=a->AuxMatrix[i][j]*log(a->AuxMatrix[i][j])/log(2);
             }

           cont++;

           VetorCaracteristica[cont]=0;
           for(int i = mit1; i>mit1/2; i--)
             for(int j = mit2/2; j>0; j--)
             {
                   if(a->AuxMatrix[i][j]>0)
                       VetorCaracteristica[cont]+=a->AuxMatrix[i][j]*log(a->AuxMatrix[i][j])/log(2);
             };
           cont++;
           mit1=mit1/2; mit2=mit2/2;
        }
}
//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------
void TFeature::ArmazenaDados(String Arquivo, FILE * stream2)
{
    String sDirPath;
    ProcessPath(Arquivo, NULL, sDirPath, NULL);

    int iSomaLexicograficaDoNomeDoArquivo = 0;
    for(int iCounter = 1; iCounter <= sDirPath.Length(); iCounter++){
        iSomaLexicograficaDoNomeDoArquivo += sDirPath[iCounter];
    }
     fprintf(stream2, "%s", Arquivo);


    for(int i = 0; i < iNroFeatures; i++)
    {
            fprintf(stream2, "%20.10f", VetorCaracteristica[i]);
    }
    fprintf(stream2, "   %s", IntToStr(iSomaLexicograficaDoNomeDoArquivo));

    fprintf(stream2, "\n");

}
//---------------------------------------------------------------------------
// Load distance values to auxiliar array
//---------------------------------------------------------------------------
void TFeature::CarregaFeatures(AnsiString ArquivoFeature, double *VetorBusca)
{
    TDadosImagem *diTemp;
    FILE *stream;
    int NroGrupo;
    int i,j;
    char ArquivoNome_Aux[200];
    double Distancia_Aux;
    int FeaturesNumber;

        if ((stream = fopen(ArquivoFeature.c_str(), "a+")) == NULL)
        {
             ShowMessage("Erro...  Selecione arquivo de Características");

        }
        else
        {
            fscanf(stream,"%d%d",&exemplos,&FeaturesNumber);
        // Primeiro campo corresponde ao número que identifica grupo da imagem
            FeaturesNumber--;
            for(i = 0; i < exemplos; i++)
            {
                VetorTemporal = new double[FeaturesNumber];
                fscanf(stream,"%s", &ArquivoNome_Aux);
                for(j = 0; j < FeaturesNumber; j++)
                {
                    fscanf(stream,"%lf", &VetorTemporal[j]);
                }
                Distancia_Aux = CalculaDistanciaEuclideana(VetorBusca, VetorTemporal, FeaturesNumber);
                delete[] VetorTemporal;
                diTemp = new TDadosImagem();
                diTemp->Distancia = Distancia_Aux;
                strcpy(diTemp->ArquivoNome,ArquivoNome_Aux);
//                diTemp->ArquivoNome = ArquivoNome_Aux;
                lResultados->Add(diTemp);
                fscanf(stream,"%d", &NroGrupo);
            }
        }
        fclose(stream);
        lResultados->Sort(DadosImagemComparisonFunction); // sort distances values
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------
double TFeature::CalculaDistanciaEuclideana(double *VetorBusca, double *VetorTemporal, int FeaturesNumber)
{
  double soma=0;
     for(int x=0; x < FeaturesNumber; x++)
     {
        soma += (VetorBusca[x]-VetorTemporal[x])*(VetorBusca[x]-VetorTemporal[x]);
     }
  return (sqrt(soma));
}

void TFeature::DistanciaManju(AnsiString ArquivoFeature, double *VetorBusca)
{
    TDadosImagem *diTemp;
    FILE *stream;
    int NroGrupo;
    int i,j;
    char ArquivoNome_Aux[200];
    double Distancia_Aux;
    int FeaturesNumber;
    double *VetorMedias, *VetorDesvios;
    double ValorDado, MediaGeral, DesvioGeral;

    // Cálculo de media Geral

        if ((stream = fopen(ArquivoFeature.c_str(), "a+")) == NULL){
             ShowMessage("Erro...  Selecione arquivo de Características"); }
        else {
            fscanf(stream,"%d%d",&exemplos,&FeaturesNumber);
            FeaturesNumber--;
            VetorMedias = new double[FeaturesNumber];          // Define Vetor de Medias
            for(i=0; i<FeaturesNumber;i++) VetorMedias[i] = 0;  // Inicializa Vetor

            for(i = 0; i < exemplos; i++){
               fscanf(stream, "%s", &ArquivoNome_Aux);
               for(j = 0; j < FeaturesNumber; j++){
                  fscanf(stream,"%lf", &ValorDado);
                  VetorMedias[j] += ValorDado;
               }
               fscanf(stream, "%s", &ArquivoNome_Aux);
            }
            for(i=0; i<FeaturesNumber;i++)
               VetorMedias[i] = VetorMedias[i]/exemplos;
            fclose(stream);
        }  // Final de cálculo de media geral

    // Cálculo de Desvio Padrão geral

        if ((stream = fopen(ArquivoFeature.c_str(), "a+")) == NULL){
             ShowMessage("Erro...  Selecione arquivo de Características"); }
        else {
            fscanf(stream,"%d%d",&exemplos,&FeaturesNumber);
            FeaturesNumber--;
            VetorDesvios = new double[FeaturesNumber];          // Define Vetor de Desvios
            for(i=0; i<FeaturesNumber;i++) VetorDesvios[i] = 0;  // Inicializa Vetor

            for(i = 0; i < exemplos; i++){
               fscanf(stream, "%s", &ArquivoNome_Aux);
               for(j = 0; j < FeaturesNumber; j++){
                  fscanf(stream,"%lf", &ValorDado);
                  VetorDesvios[j] = VetorDesvios[j] + (ValorDado - VetorMedias[j])*(ValorDado - VetorMedias[j]);
               }
               fscanf(stream, "%s", &ArquivoNome_Aux);
            }
            for (i=0; i<FeaturesNumber; i++)
               VetorDesvios[i] = VetorDesvios[i]/exemplos;
            fclose(stream);
        }  // Final de cálculo de Desvio Padrão geral

    // cálculo de Distâncias
        if ((stream = fopen(ArquivoFeature.c_str(), "a+")) == NULL){
             ShowMessage("Erro...  Selecione arquivo de Características"); }
        else {
            fscanf(stream,"%d%d",&exemplos,&FeaturesNumber);
            FeaturesNumber--;
            for(i = 0; i < exemplos; i++)
            {
                VetorTemporal = new double[FeaturesNumber];
                fscanf(stream,"%s", &ArquivoNome_Aux);
                for(j = 0; j < FeaturesNumber; j++) {
                    fscanf(stream,"%lf", &VetorTemporal[j]);
                }
                Distancia_Aux = CalculaDistanciaManju(VetorBusca, VetorTemporal, VetorMedias, VetorDesvios, FeaturesNumber);
                delete[] VetorTemporal;
                diTemp = new TDadosImagem();
                diTemp->Distancia = Distancia_Aux;
                strcpy(diTemp->ArquivoNome,ArquivoNome_Aux);
//                diTemp->ArquivoNome = ArquivoNome_Aux;
                lResultados->Add(diTemp);
                fscanf(stream,"%d", &NroGrupo);
            }
        }
        if(VetorMedias != NULL)
            delete[] VetorMedias;
        if(VetorDesvios != NULL)
            delete[] VetorDesvios;
        fclose(stream);
        lResultados->Sort(DadosImagemComparisonFunction); // sort distances values

}
double TFeature::CalculaDistanciaManju(double *VetorBusca, double *VetorTemporal, double *VetorMedias, double *VetorDesvios, int FeaturesNumber)
{

      double DistanciaFinal;

      DistanciaFinal = 0;

      for(int i=0; i<FeaturesNumber; i++){
            DistanciaFinal += fabs((VetorBusca[i]-VetorTemporal[i])/VetorMedias[i]);
            i++;
            DistanciaFinal += fabs((VetorBusca[i]-VetorTemporal[i])/VetorDesvios[i]);
      }
      return (DistanciaFinal);
}

//---------------------------------------------------------------------------

