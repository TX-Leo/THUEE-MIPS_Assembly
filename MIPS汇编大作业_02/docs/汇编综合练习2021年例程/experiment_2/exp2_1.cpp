#include <stdio.h>

typedef struct{
    int weight;
    int value;
}Item;

int knapsack_dp_loop(int item_num, Item* item_list, int knapsack_capacity);

int main(){
    FILE* infile;
    int in_buffer[512], item_num, knapsack_capacity;
    infile = fopen("test.dat", "rb");
    fread(in_buffer, sizeof(int), 512, infile);
    fclose(infile);
    knapsack_capacity = in_buffer[0];
    item_num = in_buffer[1];
    Item* item_list = (Item*)(in_buffer + 2);
    printf("%d\n", knapsack_dp_loop(item_num, item_list, knapsack_capacity));
    return 0;
}

#define MAX_CAPACITY 63

int knapsack_dp_loop(int item_num, Item* item_list, int knapsack_capacity){
    int cache_ptr[MAX_CAPACITY + 1] = {0};
    for(int i = 0; i < item_num; ++i){
        int weight = item_list[i].weight;
        int val = item_list[i].value;
        for(int j = knapsack_capacity; j >= 0; --j){
            if(j >= weight){
                cache_ptr[j] = 
                    (cache_ptr[j] > cache_ptr[j - weight] + val)? 
                    cache_ptr[j]: 
                    cache_ptr[j - weight] + val;
            }
        }
    }
    return cache_ptr[knapsack_capacity];
}
