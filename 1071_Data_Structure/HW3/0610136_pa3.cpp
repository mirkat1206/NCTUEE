// pa3
// #include <iostream>
#include <fstream>
#include <list>
// using std::cin;
// using std::cout;
using std::endl;
using std::ofstream;
using std::ifstream;
using std::list;

class Term{		// 項
	friend class Polynomial;
private:
	int coeff;	// 係數
	int power;	// 次方數
public:
	Term(int c=0, int p=0): coeff(c), power(p) {}
	~Term(){/* cout<<"bye-bye Term"<< coeff <<" "<< power << endl;	*/	};
	int get_coeff(){	return coeff ;	};
	int get_power(){	return power ;	};
	void negative(){	coeff *= -1 ; 	};
};

class Polynomial{
	friend ifstream &operator>>(ifstream &, Polynomial &);	// polynomial 的輸入
	friend ofstream &operator<<(ofstream &, Polynomial &);	// polynomial 的輸出
private:
	int n;			// 共n項
	list<Term> l;	// 多項式

	void negative();						// 把 polynomial 中所有的係數 * -1
	//static list<Term>::iterator it;
public:
	Polynomial(int x=0): n(x){};
	~Polynomial(){/* cout<<"bye-bye Polynomial"<< endl;	*/	};

	void operator=(Polynomial );			// polynomial 的等號
	Polynomial operator+(Polynomial &);		// polynomial 的加法
	Polynomial operator-(Polynomial &);		// polynomial 的減法
	Polynomial operator*(Polynomial &);		// polynomial 的乘法
};

int main(int argc, char *argv[])
{
	ifstream cin( argv[1] );
	ofstream cout( argv[2] );

	Polynomial ans;
	cin>> ans ;
	
	char op;
	while( cin>> op )
	{
		// cout<< kase+1 <<" left: "<< endl;
		Polynomial a;

		cin>> a ;		
		// cout<<"---"<< endl;
		switch( op )
		{
			case '+':
				ans = ans + a ;
				break;
			case '-':
				ans = ans - a ;
				break;
			case '*':
				ans = ans * a ;
				break;
		}
	}
	// cout<<"answer = "<< endl;
	cout<< ans ;
	return 0;
}

// 把 polynomial 中所有的係數 * -1
void Polynomial::negative(){
	list<Term>::iterator it, end = this->l.end() ;
	for( it=this->l.begin() ; it!=end ; it++ )
		(*it).negative();
}
// polynomial 的等號
void Polynomial::operator=(Polynomial r){
	if( &r != this )		// 若非 p = p 這種愚蠢的等號指令
	{
		this->n = r.n ;

		this->l.clear();
		for( list<Term>::iterator it=r.l.begin() ; it!=r.l.end() ; it++ )
			l.push_back( (*it) );
	}
}
// polynomial 的加法
Polynomial Polynomial::operator+(Polynomial &r){
	int p_n = 0 ;
	Polynomial p;

	list<Term>::iterator 	it_p = this->l.begin(), it_r = r.l.begin(),
							end_p = this->l.end(), end_r = r.l.end() ;
	while( it_p!=end_p && it_r!=end_r )
	{
/*		if( (*it_p).get_coeff()==0 ){
			it_p++ ;
			continue;
		}
		if( (*it_r).get_coeff()==0 ){
			it_r++ ;
			continue;
		}		*/

		p_n++ ;
		if( (*it_p).get_power()>(*it_r).get_power() )			// p的次方數比較大
		{
			p.l.push_back( *it_p );
			it_p++ ;
		}
		else if( (*it_p).get_power()<(*it_r).get_power() )		// r的次方數比較大
		{
			p.l.push_back( *it_r );
			it_r++ ;
		}
		else	// p和r的次方數一樣大
		{
			if( ( (*it_p).get_coeff()+(*it_r).get_coeff() )!=0 )
			{
				Term buf( (*it_p).get_coeff()+(*it_r).get_coeff() , (*it_p).get_power() );
				p.l.push_back( buf );
			}
			else
				p_n-- ;
			
			it_p++ ;
			it_r++ ;
		}
	}
	while( it_p!=end_p )
	{
		if( (*it_p).get_coeff()==0 && (*it_p).get_power()==0 )
		{
			it_p++ ;
			continue;
		}
		p_n++ ;
		p.l.push_back( *it_p );
		it_p++ ;
	}
	while( it_r!=end_r )
	{
		if( (*it_r).get_coeff()==0 && (*it_r).get_power()==0 )
		{
			it_r++ ;
			continue;
		}
		p_n++ ;
		p.l.push_back( *it_r );
		it_r++ ;
	}
	p.n = p_n ;

	return p;
}
// polynomial 的減法
Polynomial Polynomial::operator-(Polynomial &r){
	r.negative();				// 把polynomial中所有的係數 * -1
	return  (*this) + r  ;
}
// polynomial 的乘法
Polynomial Polynomial::operator*(Polynomial &r){
	Polynomial p, q( n );

	list<Term>::iterator it_r, it_this, end_r = r.l.end(), end_this = this->l.end()  ;
	for( it_r=r.l.begin() ; it_r!=end_r ; it_r++ )
	{
		q.l.clear();

		int r_co = (*it_r).get_coeff(), r_po = (*it_r).get_power() ;
		for( it_this=(*this).l.begin() ; it_this!=end_this ; it_this++ )
		{
			/*cout<< r_co <<" * "<< (*it_this).get_coeff() <<"\t"
				<< r_po <<" + "<< (*it_this).get_power() << endl;*/
			Term buf( r_co*(*it_this).get_coeff() , r_po + (*it_this).get_power() );
			q.l.push_back( buf );
		}
		p = p + q ;
	}
	return p ;
}
// polynomial 的輸入
ifstream &operator>>(ifstream &input, Polynomial &p){
	input>> p.n ;

	int buf_co, buf_po;
	for( int i=0 ; i<p.n ; i++ )
	{
		input>> buf_co >> buf_po ;

		if( buf_co==0 )
			continue;

		Term buf( buf_co , buf_po );
		p.l.push_back( buf );
	}

	return input ;		// enable cascading
}
// polynomial 的輸出
ofstream &operator<<(ofstream &output, Polynomial &p){
	if( p.n==0 )
	{
		output<< 1 << endl << 0 <<" "<< 0 << endl;
		return output ;
	}

	output<< p.n << endl;
	list<Term>::iterator it, end = p.l.end() ;
	for( it=p.l.begin() ; it!=end ; it++ )
		output<< (*it).get_coeff() <<" "<< (*it).get_power() << endl;

	return output ;		// enable cascading
}








