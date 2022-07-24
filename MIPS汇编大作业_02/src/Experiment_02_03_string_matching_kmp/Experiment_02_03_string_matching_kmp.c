#include <stdio.h>
#include <stdlib.h>

int kmp(int len_str, char* str, int len_pattern, char* pattern);
int generateNext(int* next, int len_pattern, char* pattern);

int main() {
    FILE* f;
    int len_str, len_pattern, cnt;
    char str[512], pattern[512];

    //read two lines from file    
    f = fopen("test.dat", "rb");
    for(len_str = 0; len_str < 512; len_str += 1) {
        str[len_str] = fgetc(f);
        if(str[len_str] == '\n') break;
    }
    for(len_pattern = 0; len_pattern < 512; len_pattern += 1) {
        pattern[len_pattern] = fgetc(f);
        if(pattern[len_pattern] == '\n') break;
    }
    fclose(f);

    //string matching
    cnt = kmp(len_str, str, len_pattern, pattern);
    //prinf
    printf("%d\n", cnt);
    return 0;
}

int kmp(int len_str, char* str, int len_pattern, char* pattern) {
    int cnt = 0, i = 0, j = 0;
    int *next = (int*)malloc(len_pattern * 4);

    generateNext(next, len_pattern, pattern);

    //matching
    while(i < len_str) {
        if(pattern[j] == str[i]) {
            if(j == len_pattern - 1) {
                cnt += 1;
                j = next[len_pattern - 1];
                i += 1;
            }
            else {
                i += 1;
                j += 1;
            }
        }
        else {
            if(j > 0) j = next[j - 1];
            else i += 1;
        }
    }

    free(next);
    return cnt;
}

int generateNext(int *next, int len_pattern, char* pattern) {
    int i = 1, j = 0;
    if(len_pattern == 0) return 1;
    next[0] = 0;
    while(i < len_pattern) {
        if(pattern[i] == pattern[j]) {
            next[i] = j + 1;
            i += 1;
            j += 1;
        }
        else if(j > 0) j = next[j - 1];
        else next[i++] = 0;
    }
    return 0;
}
