//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include <math.h>
#include "SegmentationUtil.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
void TSelection::SetPoint1(int x, int y){

   SetX1(x);
   SetY1(y);
}//end TSelection::SetPoint1
//---------------------------------------------------------------------------
void TSelection::SetPoint2(int x, int y){

   SetX2(x);
   SetY2(y);
}//end TSelection::SetPoint1
//---------------------------------------------------------------------------
void TSelection::SetX1(int x){

   // Clipping
   if (x < minx){
      x1 = minx;
   }else if (x > maxx){
      x1 = maxx;
   }else{
      x1 = x;
   }//end if
}//end TSelection::SetX1

//---------------------------------------------------------------------------
void TSelection::SetX2(int x){
   // Clipping
   if (x < minx){
      x2 = minx;
   }else if (x > maxx){
      x2 = maxx;
   }else{
      x2 = x;
   }//end if
}//end TSelection::
//---------------------------------------------------------------------------
void TSelection::SetY1(int y){

   if (y < miny){
      y1 = miny;
   }else if (y > maxy){
      y1 = maxy;
   }else{
      y1 = y;
   }//end if
}//end TSelection::
//---------------------------------------------------------------------------
void TSelection::SetY2(int y){

   if (y < miny){
      y2 = miny;
   }else if (y > maxy){
      y2 = maxy;
   }else{
      y2 = y;
   }//end if
}//end TSelection::
//---------------------------------------------------------------------------
int TSelection::GetTop(){

   return (y1 < y2)? y1 : y2;
}//end TSelection::GetTop
//---------------------------------------------------------------------------
int TSelection::GetLeft(){

   return (x1 < x2)? x1 : x2;
}//end TSelection::GetLeft
//---------------------------------------------------------------------------
int TSelection::GetWidth(){

   return abs(x1 - x2);
}//end TSelection::GetWidth
//---------------------------------------------------------------------------
int TSelection::GetHeight(){

   return abs(y1 - y2);
}//end TSelection::GetHeight
//---------------------------------------------------------------------------
void TSelection::Reset(){
   x1 = 0;
   x2 = 0;
   y1 = 0;
   y2 = 0;
   maxx = 0;
   maxy = 0;
   minx = 0;
   miny = 0;
}//end TSelection::Reset
//---------------------------------------------------------------------------

