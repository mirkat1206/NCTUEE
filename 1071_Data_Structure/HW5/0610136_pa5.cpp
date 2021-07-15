// Data Structure Program 5
#include <fstream>
using std::ifstream;
using std::ofstream;
using std::endl;
#include <iomanip>
using std::setw;
#include <vector>
using std::vector;

// #define DEBUG_MODE
int debug ;

// priority : lt=0 --> up=1 --> rt=2 --> dn=3
enum direction{	lt=0 , up=1 , rt=2 , dn=3 };
const int x_dir[] = { -1 , 0 , 1 , 0 };
const int y_dir[] = { 0 , 1 , 0 , -1 };

// the values
// the lower the value is, the higher the priority is.
const int WALL = 444 ;		// the wall
const int START = 443 ;		// the starting point
const int PRIORITY = -1 ;	// points which have the highest priority
const int FINISHED = 888 ;	// finished points

class vertice;
void initialize(ifstream&, ofstream&);
void show_map(ofstream&);
void find_path(ofstream&, int, int, bool);
void find_next(ofstream&, int&, int&, int&);
void baku(ofstream&);

int m, n;							// n*m map
int x_start = 0, y_start = 0 ;		// the starting point
int cnt = 0 ;						// how many point should be made FINISHED = 888
vector< vector<vertice> > v_map;	// n*m map of vectice
vector< vertice* > ans;

class vertice{
	friend ofstream& operator<<(ofstream&, vertice&);
public:
	int baku;

	vertice(){
		// default : all edges canNOT be passed
		for( int i=0 ; i<4 ; i++ )	edge[i] = 'X' ;
		baku = 0 ;
	}
	~vertice(){}

	void set_v(int v)	{	value = v ;		}
	void set_v(int i, int j, int v)	{	
		y = i ;		x = j ;
		value = v ;		
	}
	int  get_v()		{	return value ;	}
	void set_e(int i){
		if( edge[i]=='X' )		edge[i] = '=' ;
		else/* '='or'-' */		edge[i] = '-' ;
	}
	char get_e(int i)	{	return edge[i] ;}
	void kil_v()		{	value-- ;		}
	int  get_x()		{	return x ;		}
	int  get_y()		{ 	return y ;		}

	bool operator==(vertice &r){
		if( this->x!=r.x || this->y!=r.y)
			return false ;
		return true;
	}
private:
	int x, y;			// coordinate of this vertice
	int value;			// value = priority
	// "X": edge canNOT be passed
	// "=": edge can be passed and haveN'T been passed
	// "-": edge can be passed and HAVE been passed
	char edge[4];	// lt=0 , up=1 , rt=2 , dn=3
};

ofstream& operator<<(ofstream &out, vertice &v){
	out<< v.x <<" "<< v.y ;
	// out<<"( "<< v.x <<" , "<< v.y <<")";
	return out ;		// enable cascading
}


int main(int argc, char *argv[])
{
	ifstream in ( argv[1] );
	ofstream out( argv[2] );

	initialize( in , out );
	// show_map(out);

	cnt-- ;
	find_path( out , x_start , y_start , 0 );

	int size = ans.size() ;
	// out<<"size = "<< size << endl;
	for( int i=0 ; i<size ; i++ )
		out<< *ans[i] << endl;
	if( ans[size-1]!=ans[0] )
		out<< *ans[0] << endl;

	// show_map(out);

	return 0; 
}

int steps = -1 ;
void find_path(ofstream &out, int x, int y, bool is_baku)
{
	if( !is_baku )
	{
		++steps ;
		ans.push_back( &v_map[y][x] );
	}	
#ifdef DEBUG_MODE
	if( steps==debug ){
		out<< endl <<"debug : "<< endl;
		show_map( out );
		return ;
	}
#endif
	if( cnt==0 ){
		// out<< endl <<"FINISHED : "<< endl;
		// show_map(out);
		return ;
	}

	int next = -1 ;
	find_next( out , next , x , y );
	if( next==-1 ){
		v_map[y][x].set_v(FINISHED);
		cnt-- ;
		/*if( y==y_start && x==x_start )
		{
			out<<"ohoh"<< endl;
			show_map(out);
		}*/
		baku(out);		
		return ;
	}

	// if the taken edge hasn't been passed
	if( v_map[y][x].get_e(next)=='=' ){
		// change the value of two vertices
		v_map[ y ][ x ].kil_v();
		v_map[ y+y_dir[next] ][ x+x_dir[next] ].kil_v();
		// change the status of the edge
		v_map[ y ][ x ].set_e( next );
		v_map[ y+y_dir[next] ][ x+x_dir[next] ].set_e( (next+2)%4 );
	}
	// if the vertice is FINISHED
	if( v_map[y][x].get_v()==0 || v_map[y][x].get_v()==-2 )
	{
		// out<<"0or-1 : "<< x << y << endl;
		v_map[y][x].set_v(FINISHED);
		cnt-- ;
	}
	// recursive
	find_path( out , x+x_dir[next] , y+y_dir[next] , 0 );
}

void find_next(ofstream &out, int &next, int &x, int &y)
{
	// out<<"steps : "<< steps <<"\tcnt :"<< cnt << endl;
	// show_map(out);

	int min = WALL ; 
	// 找還未走過的edge('=')，且edge另一頭的vertice權值最低的
	for( int i=0 ; i<4 ; i++ )
	{
		if( v_map[y][x].get_e(i)=='=' && v_map[ y+y_dir[i] ][ x+x_dir[i]].get_v()<min )
		{
			next = i ;	
			min = v_map[ y+y_dir[i] ][ x+x_dir[i] ].get_v() ;
		}
	}
	// 盡量不往起點走
	if( (x+x_dir[next])==x_start && (y+y_dir[next])==y_start );
		// out<<"\tskip\t";
	else if( next!=-1 )
		return ;

	// 找所有已經走過的edge中('-')，另一頭的vertice權值最低的
	for( int i=0 ; i<4 ; i++ )
		if( v_map[y][x].get_e(i)=='-' && v_map[ y+y_dir[i] ][ x+x_dir[i]].get_v()<min )
		{
			next = i ;		
			min = v_map[ y+y_dir[i] ][ x+x_dir[i] ].get_v() ;
		}
	if( next!=-1 )	return ;

	// 所有周圍的edge都已經 FINISHED = 888
	// 往回走，直到回到 vertice != FINISHED 的點
	// baku(out);
	return ;
}

void baku(ofstream &out)
{
	int size = ans.size() ;

	bool is_start = (ans[size-1]->get_x()==x_start)&&(ans[size-1]->get_y()==y_start) ;

	for( int i=size-1 ; ans[i]->get_v()==FINISHED ; i-- )
		ans[i]->baku++ ;
/*
	for( int i=0 ; i<size ; i++ )
		out<< *ans[i] <<" : "<< ans[i]->baku << endl; 
	out<< endl;
*/
	bool flag = true ;
	for( int i=size-1 ; ans[i]->get_v()==FINISHED ; i-- )
	{
		if( ans[i]->baku>1 )
		{
			vertice *p = ans[i] ;
			while( p->baku>1 )
			{
				ans[i]->baku-- ;
				while( ans[--i]!=p )
					ans[i]->baku-- ;
			}
		}
		// out<< i <<"\t";
		if( ans[i]==ans[size-1] )
			ans[i]->baku-- ;
		else if( ans[i]->baku==1 )
		{
			ans.push_back( ans[i] );
			ans[i]->baku-- ;
		}
	}
	size = ans.size();

	if( is_start ){
		cnt++ ;
		v_map[y_start][x_start].set_v(START) ;
	}

	find_path( out , ans[size-1]->get_x() , ans[size-1]->get_y() , 1 );
}

void initialize(ifstream &in, ofstream &out)
{
#ifdef DEBUG_MODE
	in>> debug ;
#endif
	in>> m >> n;

	int buf;

	// input the initial map
	v_map.resize( n+1 );
	for( int i=n-1 ; i>=0 ; i-- )
	{
		v_map[i].resize( m+1 );
		for( int j=0 ; j<m ; j++ )
		{
			in>> buf ;
			if( buf==1 )	buf = WALL ;
			v_map[i][j].set_v( i , j , buf );
		}
	}

	// find the starting point and count the value of each vertice
	int max_value = 0 ;
	for( int i=n-2 ; i>0 ; i-- )
		for( int j=1 ; j<m-1 ; j++ )
		{
			if( v_map[i][j].get_v()==WALL )		continue;

			cnt++ ;
			buf = 0 ;
			// order : lt=0 --> up=1 --> rt=2 --> dn=3
			for( int k=0 ; k<4 ; k++ )
				if( v_map[ i+y_dir[k] ][ j+x_dir[k] ].get_v()!=WALL )
				{
					buf++ ;
					v_map[i][j].set_e( k );
				}

			// buf = how many edges can/should be passed around this vertice
			if( buf==1 )
				v_map[i][j].set_v( i , j , buf=PRIORITY );
			else 
				v_map[i][j].set_v( i , j , buf );

			if( buf>max_value )
			{
				max_value = buf ;
				y_start = i ;		x_start = j ;
			}
		}

	v_map[y_start][x_start].set_v( START );
	// show_map( out );
}

void show_map(ofstream &out)
{
	for( int i=n-1 ; i>=0 ; i-- )
	{
		// upper edge
		out << setw(6) << v_map[i][0].get_e( up );
		for( int j=1 ; j<m ; j++ )
			out << setw(9) << v_map[i][j].get_e( up );
		out << endl;
		// the value and left/right edge
		for( int j=0 ; j<m ; j++ )
			out << v_map[i][j].get_e( lt )
				<< setw(5) << v_map[i][j].get_v()
				<< setw(3) << v_map[i][j].get_e( rt );
		out << endl;
		// downward edge
		out << setw(6) << v_map[i][0].get_e( dn );
		for( int j=1 ; j<m ; j++ )
			out << setw(9) << v_map[i][j].get_e( dn );
		out << endl;
	}
	out << endl;
}
