#include<bits/stdc++.h>
using namespace std;
#define pi (2.0*acos(0.0))
#define eps 1e-6
#define ll long long
#define inf (1<<29)
#define vi vector<int>
#define vll vector<ll>
#define sc(x) scanf("%d",&x)
#define scl(x) scanf("%lld",&x)
#define all(v) v.begin() , v.end()
#define me(a,val) memset( a , val ,sizeof(a) )
#define pb(x) push_back(x)
#define pii pair<int,int> 
#define mp(a,b) make_pair(a,b)
#define L(x) ((x<<1) + 1)
#define R(x) ((x<<1) + 2)
#define M(x,y) ((x+y)>>1)
#define fi first
#define se second
#define MOD 1000000007
#define ios ios::sync_with_stdio(0)
#define N 100
#define D 48
#define Q 100
#define BL 32//threadsPerBlock -> como son 2 dimensiones el maximo de threadsPerBlock debe ser calculado con BL * BL, por eso no puede ser muy grande, creo xD -->
//deje paginas abiertas: https://devtalk.nvidia.com/default/topic/523694/question-about-grid-block-thread-sizes/
//http://stackoverflow.com/questions/9985912/how-do-i-choose-grid-and-block-dimensions-for-cuda-kernels

double getRand(){
	int r = rand();
	return 100.0 * r / INT_MAX;
}

int main(){
	srand(time(NULL));
	printf("%d %d\n" , N , D );
	for(int i = 0 ; i < N ; i++){
		for(int j = 0 ; j < D ; j++)
			printf("%.3lf ", getRand() );
		printf("\n");
	}
	
	printf("%d\n",Q);
	
	for(int i = 0 ; i < Q ; i++){
		for(int j = 0 ; j < D ; j++)
			printf("%.3lf ", getRand() );
		
		printf(" 5\n");
	}
	
	return 0;
}
