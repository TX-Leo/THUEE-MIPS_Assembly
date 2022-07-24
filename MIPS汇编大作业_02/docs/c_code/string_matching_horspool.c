#include <stdio.h>

int horspool(int len_str, char* str, int len_pattern, char* pattern);

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
    cnt = horspool(len_str, str, len_pattern, pattern);
    //prinf
    printf("%d\n", cnt);
    return 0;
}

int horspool(int len_str, char* str, int len_pattern, char* pattern) {
    int cnt = 0, i, j;
    int table[256];

    //generate table
    for(i = 0; i < 256; ++i) table[i] = -1;
    for(i = 0; i < len_pattern; ++i) table[pattern[i]] = i;

    //matching
    i = len_pattern - 1;
    while(i < len_str) {
        j = 0;
        while(j < len_pattern && pattern[len_pattern - 1 - j] == str[i - j]) j += 1;
        if(j == len_pattern){
            cnt += 1;
        }
        if(table[str[i]] + 1 <= len_pattern - 1 - j) i += len_pattern - 1 - table[str[i]];
        else i += 1;
    }
    return cnt;
}
