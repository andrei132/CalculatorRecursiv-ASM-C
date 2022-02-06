#include <stdio.h>
#include <stdlib.h>
#define MAX_LINE 100001

int expressionC(char *p, int *i);
int termC(char *p, int *i);
int factorC(char *p, int *i);

int expressionC(char *p, int *i){

    int res = termC(p,i);
    char semn = p[(*i)];

    while (semn == '+'|| semn == '-'){
        
        (*i)++;
        if(semn == '+') res += termC(p,i);
        else if(semn == '-') res -= termC(p,i);
        semn = p[(*i)];

    }
    
    return res;
}

int termC(char *p, int *i){

    int res = factorC(p,i);
    char semn = p[(*i)];

    while (semn == '*'|| semn == '/'){

        (*i)++;
        if(semn == '*') res *= factorC(p,i);
        else if(semn == '/') res /= factorC(p,i);
        semn = p[(*i)];

    }
    
    return res;

}

int factorC(char *p, int *i){
    int res = 0;
    char semn = p[(*i)];

    if(semn == '('){

        (*i)++;
        res += expressionC(p,i);
        (*i)++;

    } else while(p[(*i)]>='0' && p[(*i)]<='9'){

        (*i)++;
        res = res * 10 + semn - '0';   
        semn = p[(*i)]; 
    
    }
    
    return res;
}

int main()
{
    char s[MAX_LINE];
    char *p;
    int i = 0;  
    scanf("%s", s);
    p = s;
    printf("%d\n", expressionC(p, &i));
    return 0;
}
