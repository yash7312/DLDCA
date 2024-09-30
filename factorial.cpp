#include <iostream>

int factorial(int n){
    if(n == 0) return 1;
    return n*factorial(n-1);
}

int main(){
    int a = 5;
    std::cout << factorial(a) << std::endl;
}