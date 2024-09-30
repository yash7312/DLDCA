#include <iostream>
using namespace std;

// You must follow the MIPS coding conventions in terms of caller and callee saved registers and other register usage. 
// You can define and use your own stack frame format though. 
// Specify your stack frame format in the answers text file.

// return index, else return -1
int check(int* A, int len, int start, int end, int val){
    int mid = (end + start)/2;
    if(start >= end) return -1;
    if(A[mid] == val ) return mid;
    if(A[mid] > val) return check(A, len,start,mid,val);
    if(A[mid] < val) return check(A, len,mid+1,end,val);

    return -1;
}

int main(){
    int a[5] = {1,2,3,4,5};
    int len = 5;
    int start = 0;
    int end = 5;
    int val; cin >> val;

    cout << check(a,len,0,len,val) << endl;

}