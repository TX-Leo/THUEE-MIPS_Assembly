#include <stdio.h>

typedef struct{
    int weight;
    int value;
}Item;

int knapsack_search(int item_num, Item* item_list, int knapsack_capacity);

int main(){
    FILE* infile;
    int in_buffer[512], item_num, knapsack_capacity;
    infile = fopen("test.dat", "rb");
    fread(in_buffer, sizeof(int), 512, infile);
    fclose(infile);
    knapsack_capacity = in_buffer[0];
    item_num = in_buffer[1];
    Item* item_list = (Item*)(in_buffer + 2);
    printf("%d\n", knapsack_search(item_num, item_list, knapsack_capacity));
    return 0;
}

int knapsack_search(int item_num, Item* item_list, int knapsack_capacity){
    int val_max = 0;
    for(int state_cnt = 0; state_cnt < (0x1 << item_num); ++state_cnt){
        int weight = 0;
        int val = 0;
        for(int i = 0; i < item_num; ++i){
            int flag = (state_cnt >> i) & 0x1;
            weight = flag? (weight + item_list[i].weight): weight;
            val = flag? (val + item_list[i].value): val;
        }
        if(weight <= knapsack_capacity && val > val_max)val_max = val;
    }
    return val_max;
}
