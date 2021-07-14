#define LOCAL

#include <cstdio>
#include <vector>
#include <ctime>
using namespace std;

const int maxn = 65535 ;

// the table
vector<int> v_prime;
vector<int>::iterator it;
bool b_prime[maxn] = {0} ;

bool is_prime(int x)
{
	for( it=v_prime.begin() ; it!=v_prime.end() ; it++ )
		if( x%(*it)==0 )
			return 0 ;
	return 1 ;
}

int main(int argc, char *argv[])
{
//	printf("%s\n%s\n", argv[1] , argv[2] );
#ifdef LOCAL
	freopen( argv[1] ,"r",stdin);
	freopen( argv[2] ,"w",stdout);
#endif
	
	// make the table
	v_prime.push_back(2);
	b_prime[2] = 1 ;
	for( int i=3 ; i<maxn ; i+=2 )
		if( is_prime(i) )
		{
			v_prime.push_back(i);	
			b_prime[i] = 1 ;
		}
	// to see the table
//	for( it=v_prime.begin() ; it!=v_prime.end() ; it++ )
//		printf("%d\n", *it );
	
	int input;	
	while( scanf("%d", &input )!=EOF )
	{
		if( input<maxn )	
			printf("%d\n", b_prime[input] );
		else
			printf("%d\n", (bool) is_prime(input) );	
	}
	
//	printf("Time used = %.6lf\n", (double)clock()/CLOCKS_PER_SEC );
	return 0;
}	
