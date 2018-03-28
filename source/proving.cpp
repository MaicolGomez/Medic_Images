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

int main(){

	int nrl = 2, nrh = 5, ncl = 1, nch = 5;
	
	//scanf("%d%d%d%d", &nrl, &nrh, &ncl, &nch);

	double **m;
	m = (double **) calloc((unsigned) (nrh-nrl+1), sizeof(double*));
	if (!m) printf("allocation failure 1 in dmatrix()\n");
	m -= nrl;
	
	for(int i = nrl ; i <= nrh ; i++){
		m[i] = (double *) calloc((unsigned) (nch-ncl+1), sizeof(double));
		if (!m[i]) printf("allocation failure 2 in dmatrix()\n");
		m[i] -= ncl;
	}
	
	cout<<"llego"<<endl;
	
	for(int i = nrl; i <= nrh; i++){
		for(int j = ncl; j <= nch; j++) cout<<m[i - |][j - ncl]<<" ";
		cout<<endl;
	}
	
	return 0;
}
