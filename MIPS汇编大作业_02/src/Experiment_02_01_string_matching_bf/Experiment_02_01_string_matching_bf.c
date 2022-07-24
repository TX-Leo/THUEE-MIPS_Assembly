#include <stdio.h>

int brute_force(int len_str, char* str, int len_pattern, char* pattern);

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
    cnt = brute_force(len_str, str, len_pattern, pattern);
    //prinf
    printf("%d\n", cnt);
    return 0;
}

int brute_force(int len_str, char* str, int len_pattern, char* pattern) {
    int i, j, cnt = 0;
    for(i = 0; i <= len_str - len_pattern; i += 1) {
        for(j = 0; j < len_pattern; j += 1) {
            if(str[i + j] != pattern[j]) break;
        }
        if(j == len_pattern) cnt += 1;
    }
    return cnt;
}
    
