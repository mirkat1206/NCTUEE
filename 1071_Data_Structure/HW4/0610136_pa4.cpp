#include <fstream>
using std::endl;
using std::ifstream;
using std::ofstream;

const int NOT_FOUND = -1 ;

class Tree;

class TreeNode{
	// 使Tree可以直接使用TreeNode
	friend class Tree;
public:
	TreeNode(int x=0) : key(x), leftsize(1) {};
	~TreeNode(){};

	int get_key(){	return key ; };
private:
	int key;
	int leftsize;
	TreeNode *lt = NULL ;	// 左子樹
	TreeNode *rt = NULL ;	// 右子樹
	TreeNode *pt = NULL ;	// 母樹
};

class Tree
{
public:
	Tree(){};
	~Tree(){};

	void Inorder_show(ofstream &);				// 左中右輸出
	void Insert(int);							// 插入新值
	void Delete(ofstream &, int);				// 刪除舊值
	TreeNode* Search(int);						// 尋找	// 回傳後須再檢查
	TreeNode* Search(int, int&);	
	TreeNode* SearchByRank(ofstream &, int);	// 尋找第k大的數	
private:
	TreeNode *rt = NULL ;	// 樹根

	void Inorder_show(ofstream &, TreeNode*);
	void AddLeftSize(TreeNode*, TreeNode*);
	void CutLeftSize(ofstream &, TreeNode*, TreeNode*);
};

int main(int argc, char *argv[])
{
	ifstream cin( argv[1] );
	ofstream cout( argv[2] );

	Tree T;

	int op, n;
	while( cin>> op >> n )
	{
		bool end_flag = 0 ;
		switch(op){
			case 1 :
				T.Insert(n);
				break;
			case 2 :
				T.Delete(cout,n);
				break;
			case 3 :
			{
				int lvl = 0 ;
				TreeNode *t = T.Search( n , lvl ) ;
				if( t->get_key()==n )
					cout<< lvl << endl;
				else
					cout<< NOT_FOUND << endl;
				break;
			}
			case 4 :
			{
				TreeNode *t = T.SearchByRank(cout,n) ;
				if( t!=NULL ){
					int lvl = 0 ;
					T.Search( t->get_key() , lvl );
					cout<< t->get_key() <<" "<< lvl << endl;
				}
				break;
			}

			case 0 :
				T.Inorder_show(cout);
				break;
			default:
				end_flag = 1 ;
		}

		if( end_flag )
			break;
	}
	return 0 ;
}

void Tree::Inorder_show(ofstream &out){
	Inorder_show( out , rt );
	out<< endl << endl;;
}

void Tree::Inorder_show(ofstream &out, TreeNode *cur){
	if( cur )
	{
		Inorder_show( out , cur->lt );

		int lvl = 0;
		Search( cur->key , lvl );
		if( cur!=rt )
			out<<"(\t"<< cur->key <<",\t"<< lvl <<",\t"<< cur->leftsize <<",\t"<< cur->pt->key <<"\t)\n";
		else
			out<<"(\t"<< cur->key <<",\t"<< lvl <<",\t"<< cur->leftsize <<",\t"<<"NULL"<<"\t)\n";

		// out<< cur->key <<" ";
		Inorder_show( out , cur->rt );
	}
}

void Tree::Insert(int x){
	if( rt==NULL )
		rt = new TreeNode(x) ;
	else
	{
		TreeNode *cur = Search(x) ;	
		// Search回傳檢查 : 沒找到 --> 須Insert
		if( cur->key != x )						
		{
			TreeNode *t = new TreeNode(x) ;
			// 找到的節點的值 大於 插入的值 --> 放入左子樹
			if( cur->key > x ){
				cur->lt = t ;
				t->pt = cur ;
			}
			// 找到的節點的值 小於 插入的值 --> 放入右子樹
			else{
				cur->rt = t ;
				t->pt = cur ;
			}
			// 處理leftsize
			AddLeftSize( cur , t );
		}
	}
}

void Tree::AddLeftSize(TreeNode *parent, TreeNode *child){
	// 一直往上處理，直到child==root
	while( parent!=NULL )
	{
		// child是parent的左子樹 --> leftsize+1
		if( child==parent->lt )
			parent->leftsize++ ;
		// child是parent的右子樹 --> 不動作
		else;

		child = parent ;
		parent = parent->pt ;
	}
}

void Tree::Delete(ofstream &out, int z){
	TreeNode* cur = Search(z) ;

	// 沒找到z值 --> 不須動作
	if( cur->key != z )		return ;

	// 刪z的值 --> 以y值取代
	TreeNode *y;
	// 刪y的節點 --> 以x節點取代
	TreeNode *x ;

	// 找y
	// 最多一小孩 --> 可直接刪節點
	if( cur->lt==NULL || cur->rt==NULL )
		y = cur ;
	// 有兩子樹 --> 找左子樹最大的數
	else{
		// 例外處理leftsize
			// cur->leftsize-- ;

		y = cur->lt ;
		while( y->rt != NULL )		y = y->rt ;
	}

	// 找x
	// 非左子樹最大的數 --> 只有右子樹
	if( y->rt != NULL )
		x = y->rt ;
	// 只有左子樹or沒有子樹(NULL)or有兩子樹(左子樹最大的數的左子樹)
	else
		x = y->lt ;

	// 處理leftsize
	// out<<"delete y = "<< y->key << endl;
	CutLeftSize( out , y->pt , y );
/*
	out<<"z = "<< z <<"\ty = "<< y->key ;
	if( x!=NULL )
		out<<"\tx = "<< x->key << endl;
	else
		out<< endl;
*/
	// 把y的父母在刪除y之前傳給x
	if( x!=NULL )
		x->pt = y->pt ;
	
	// 把x在刪除y之前傳給y的父母
	// 要刪除的點y是root
	if( y->pt==NULL )
		rt = x ;
	// y是左子樹 : 把y的父母的lt，在刪除y之前指向x
	else if( y==y->pt->lt )
		y->pt->lt = x ;
	// y是右子樹 : 把y的父母的rt，在刪除y之前指向x
	else
		y->pt->rt = x ;

	// 有兩子樹的特殊案例及處理 : 刪z的值-->以y值取代
	if( y->key != z )
		cur->key = y->key ;

	delete y ;
}

void Tree::CutLeftSize(ofstream &out, TreeNode *parent, TreeNode *child){
	// 一直往上處理，直到child==root，parent==NULL
	while( parent!=NULL )
	{
		// child是parent的左子樹 --> leftsize+1
		if( child==parent->lt )
		{
			// out<<"child = "<< child->key <<"\tparent = "<< parent->key << endl;
			parent->leftsize-- ;
		}
		// child是parent的右子樹 --> 不動作

		child = parent ;
		parent = parent->pt ;
	}
}

TreeNode* Tree::Search(int x){
	TreeNode *cur = rt, *not_found;
	while( cur )
	{
		if( cur->key==x )	return cur ;

		not_found = cur ;
		if( cur->key>x )	cur = cur->lt ;
		else				cur = cur->rt ;
	}
	return not_found ;
}

// 回傳後須再檢查
TreeNode* Tree::Search(int x, int &cnt){
	TreeNode *cur = rt, *not_found;
	while( cur )
	{
		if( cur->key==x )	return cur ;

		not_found = cur ;	
		cnt++ ;
		if( cur->key>x )	cur = cur->lt ;
		else				cur = cur->rt ;
	}
	return not_found ;
}

TreeNode* Tree::SearchByRank(ofstream &out, int k){
	TreeNode *cur = rt ;
	while( cur )
	{
		if( k==cur->leftsize )	return cur ;
		if( k<cur->leftsize )
			cur = cur->lt ;
		else{
			k -= cur->leftsize ;
			cur = cur->rt ;
		}
	}
	return NULL ;
}
