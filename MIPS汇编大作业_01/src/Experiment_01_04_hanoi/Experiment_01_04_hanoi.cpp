#include "stdio.h"
int hanoi(int n){
    if (n==1){
        return 1;
    }
    else{
        return 2*hanoi(n-1)+1;
    }
}
int main(){
    int n;
    scanf("please input n: %d",&n);
    int result = hanoi(n);
    printf("the result is %d",result);
    return 0;
}
