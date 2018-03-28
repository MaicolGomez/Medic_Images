#include<bits/stdc++.h>
using namespace std;
int main( void ) {
 cudaDeviceProp prop;
 int count;
 cudaGetDeviceCount( &count );
 
 cout<<"count: "<<count<<endl;
 
 for (int i=0; i< count; i++) {
 cudaGetDeviceProperties( &prop, i );
 //Do something with our device's properties
 }
}
