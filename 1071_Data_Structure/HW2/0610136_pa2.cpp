#define FROM_DATA

#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <utility>
#include <ctime>
#include <iomanip>
using namespace std;

const int WALL = -2 ;
const int NOT_ANS = -3 ;
const int START = 0 ;
const int END = -1 ;
const pair<int,int> dir[4] = { make_pair(0,1), make_pair(1,0), make_pair(0,-1), make_pair(-1,0) };

vector< vector<int> > MAP;
vector< vector<int> > Q1;
vector< vector<int> > Q2;
int col, row, ini_y, ini_x, end_y, end_x;

// question 1
bool is_RDLU_path(int,int);
// question 2
void shrtst_path();
void cnt_steps(int,int);
void find_shrtst_path();

void print_MAP(vector< vector<int> > vv, ofstream &out)
{
	for( int i=0 ; i<row ; i++ )
	{
		for( int j=0 ; j<col ; j++ )
		{
			if( vv[i][j]==WALL )
				out<<"2";
			else if( i==ini_y && j==ini_x )
				out<<"S";
			else if( vv[i][j]==END )
				out<<"E";
			else if( vv[i][j]==NOT_ANS )
				out<<"0";
			else 
				out<< vv[i][j];
			out<<" ";
		}
		out<< endl;
	}
//	out<<"Time used = "<< setprecision(6) << (double)clock()/CLOCKS_PER_SEC << endl;
}

// DFS
bool find_RDLU_path(int y, int x)
{
	// check if (y,x) is the END point or not
	if( Q1[y][x]==END )
		return true ;
	
	// assume (y,x) is THE PATH
	Q1[y][x] = 1 ;
	
	// if (y,x) is not the END point, check Right/Down/Left/Up point
	for( int i=0 ; i<4 ; i++ )
	{
		int next_y = y + dir[i].first, next_x = x + dir[i].second ;
		if( Q1[next_y][next_x]==0 || Q1[next_y][next_x]==END )
			if( find_RDLU_path( next_y , next_x )==true )
				return true ;
	}
	// if Right/Down/Left/Up point is not THE PATH, then (y,x) is not THE PATH
	Q1[y][x] = NOT_ANS ;
	return false ;

}

queue< pair<int,int> > cnt_list;
pair<int,int> now;

void shrtst_path()
{
	while( !cnt_list.empty() )
	{
		now = cnt_list.front() ;
		cnt_steps( now.first , now.second );
		cnt_list.pop();
	}
}

// BFS
void cnt_steps(int y, int x)
{
	pair<int,int> buf;
	for( int i=0 ; i<4 ; i++ )
	{
		int next_y = y + dir[i].first , next_x = x + dir[i].second, next_cnt = MAP[y][x] + 1  ;
		if( MAP[next_y][next_x]==0 || MAP[next_y][next_x]>next_cnt )
		{
			MAP[next_y][next_x] = next_cnt ;
			buf = make_pair( next_y , next_x );
			cnt_list.push(buf);
		}
	}
}

const int MAXN = 1000000000 ;

void find_shrtst_path()
{
	int y = end_y, x = end_x ;
	int  last_cnt = MAXN ;
	for( int i=0 ; i<4 ; i++ )
	{
		int last_y = y - dir[i].first, last_x = x - dir[i].second ;
		if( MAP[last_y][last_x]!=WALL && MAP[last_y][last_x]!=START )
			if( MAP[last_y][last_x]<last_cnt )
				last_cnt = MAP[last_y][last_x] ;
	}
	
//	cout<<"last step = "<< last_cnt << endl;
	while(	MAP[y][x]!=START )
	{
		if( MAP[y-1][x]==last_cnt )
			y--;
		else if( MAP[y][x-1]==last_cnt )
			x--;
		else if( MAP[y+1][x]==last_cnt )
			y++;
		else if( MAP[y][x+1]==last_cnt )
			x++;
		Q2[y][x] = 1 ;
		last_cnt-- ;
		
		if( last_cnt<=0 )
			break;
	}
}

int main(int argc, char *argv[])
{
#ifdef FROM_DATA
	ifstream cin( argv[1] );
	ofstream out1( argv[2] );	
	ofstream out2( argv[3] );
#endif
	cin>> col >> row;

	char input;
	vector<int> v;
	for( int i=0 ; i<row ; i++ )
	{
		v.clear();
		for( int j=0 ; j<col ; j++ )
		{
			cin>> input;
			if( input=='2' )
				v.push_back( WALL );
			else if( input=='0' )
				v.push_back( 0 );
			else if( input=='E' )
			{
				end_y = i ;
				end_x = j ;
				v.push_back( END );	
			}
			else	// input=='S'
			{		
				ini_y = i ;	
				ini_x = j ;
				v.push_back( START );
			}
		}
		MAP.push_back(v);
		Q1.push_back(v);
		Q2.push_back(v);
	}

//	cout<<"initial MAP:"<< endl;
//	print_MAP( MAP , out1 );

	// question 1
	find_RDLU_path( ini_y , ini_x );
	
	pair<int,int> ini;
	ini = make_pair( ini_y , ini_x );
	cnt_list.push(ini);
	// question 2
	shrtst_path();
	find_shrtst_path();

	MAP[ini_y][ini_x] = START ;
	Q1[ini_y][ini_x] = START ;	Q2[ini_y][ini_x] = START ;

//	cout<<"final MAP:"<< endl;
//	print_MAP( MAP , out1 );
//	cout<<"Question 1:"<< endl;
	print_MAP( Q1 , out1 );
//	cout<<"Question 2:"<< endl;
	print_MAP( Q2 , out2 );

#ifdef FROM_DATA
	cin.close();
	out1.close();
	out2.close();
#endif
	return 0;
}
