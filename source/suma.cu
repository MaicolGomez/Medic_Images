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
#define BL 32

#define NA 20

__global__ void suma(int *A, int *S){
	
	S[0] = S[0] + A[threadIdx.x];
	printf("A[t]: %d S[0]: %d\n",A[threadIdx.x], S[0]);
	
	__syncthreads();
}

int main(){

	int *a = new int[NA];	
	
	for(int i = 0; i < NA; i++) a[i] = 1;
	
	int *A;
	
	cudaMalloc(&A, NA * sizeof(int));
	cudaMemcpy(A, a, NA * sizeof(int), cudaMemcpyHostToDevice);
	
	int *s = new int[1];
	s[0] = 0;
	int *S;
	
	cudaMalloc(&S, sizeof(int));
	cudaMemcpy(S, s, sizeof(int), cudaMemcpyHostToDevice);
	
	
	suma<<<1,NA>>>(A, S);
	
	cout<<"llego"<<endl;
	
	cudaMemcpy(s, S, sizeof(int), cudaMemcpyDeviceToHost);
	
	
	
	cout<<s[0]<<endl;
	
	cudaFree(A);
	cudaFree(S);
	
	return 0;
}
