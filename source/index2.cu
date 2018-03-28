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
#define N 100000


__global__ void f(double *A,double *B,double *ans,int n,int d,int need){
	
	int i = threadIdx.x;
	while( i < n ){
		
		
		__syncthreads();
		i += blockDim.x * gridDim.x;
	}
	
}

int main(){
	int n , d , need;
	scanf("%d%d%d",&n,&d,&need);
	double C[d];
	for(int j = 0 ; j < d ; j++)
		scanf("%lf",&C[j]);
		
	double A[d] , *B;
	cudaMalloc( (void **)&B , sizeof(double) * d );
	
	for(int i = 0 ; i < n ; i++){
		double dis = 0;
		for(int j = 0 ; j < d ; j++)
			scanf("%lf",&A[j]);
		
		cudaMemcpy( B , A , sizeof(double) * n * d , cudaMemcpyHostToDevice );
		
	}
	
	f<<< 1 , 1000 >>>( B , D , ans , n , d , need );
	
	cudaFree( B );
	cudaFree( D );
	return 0;
}
