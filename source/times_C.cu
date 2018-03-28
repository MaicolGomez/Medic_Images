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
#define Q(x) (x) * (x)
#define L(x) ((x<<1) + 1)
#define R(x) ((x<<1) + 2)
#define M(x,y) ((x+y)>>1)
#define fi first
#define se second
#define MOD 1000000007
#define ios ios::sync_with_stdio(0)
#define N 1024
#define TB 32


int main(){

	clock_t tStart = clock();

	int *a , *b , *c;
	size_t size = N * N * sizeof(int) ;
	a = (int *)malloc( size );
	b = (int *)malloc( size );
	c = (int *)malloc( size );
	
	for(int i = 0; i < N; i++)
		for(int j = 0; j < N; j++)
			a[i * N + j] = i + j;
			

	for(int i = 0; i < N; i++)
		for(int j = 0; j < N; j++)
			b[i * N + j] = 1;
	
	for(int i = 0; i < N; i++)
		for(int j = 0; j < N; j++)
			c[i * N + j] = a[i * N + j] * b[i * N + j];
	
	printf("Time taken: %.2fms\n", 1000.0 * (double)(clock() - tStart)/CLOCKS_PER_SEC);
	
	return 0;
	
}
