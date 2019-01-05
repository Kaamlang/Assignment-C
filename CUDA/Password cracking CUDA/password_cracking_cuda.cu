#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <cuda_runtime_api.h>
#include <stdio.h>

__device__ int is_a_match(char *attempt) {	// Compares each password attempt.
  char plain_password1[] = "RS0000";
  char plain_password2[] = "SN0003";
  char plain_password3[] = "EH0005";
  char plain_password4[] = "UU0007";


  char *a = attempt;
  char *b = attempt;
  char *c = attempt;
  char *d = attempt;
  char *p1 = plain_password1;
  char *p2 = plain_password2;
  char *p3 = plain_password3;
  char *p4 = plain_password4;

  while(*a == *p1) { 
   if(*a == '\0') 
    {
	printf("Found password: %s\n",plain_password1);
        break;
    }

    a++;
    p1++;
  }
	
  while(*b == *p2) { 
   if(*b == '\0') 
    {
	printf("Found password: %s\n",plain_password2);
        break;
    }

    b++;
    p2++;
  }

  while(*c == *p3) { 
   if(*c == '\0') 
    {
	printf("Found password: %s\n",plain_password3);
        break;
    }

    c++;
    p3++;
  }

  while(*d == *p4) { 
   if(*d == '\0') 
    {
	printf("Found password: %s\n",plain_password4);
        return 1;
    }

    d++;
    p4++;
  }
  return 0;

}

__global__ void kernel() {
  char k,l,m,n;
  
  char password[7];
  password[6] = '\0';

  int i = blockIdx.x+65;
  int j = threadIdx.x+65;
  char firstValue = i; 
  char secondValue = j; 
    
  password[0] = firstValue;
  password[1] = secondValue;
  
  for(k='0'; k<='9'; k++){
    for(l='0'; l<='9'; l++){
      for(m='0'; m<='9'; m++){
        for(n='0'; n<='9'; n++){
          password[2] = k;
	  password[3] = l;
	  password[4] = m;
	  password[5] = n; 
	  
	  if(is_a_match(password)) {
	    //printf("Success");
	  } 
	  else {
	    //printf("tried: %s\n", password);		  
 	  }
        }
      }
    }
  }
}

int time_difference(struct timespec *start, struct timespec *finish, 
                              long long int *difference) {
  long long int ds =  finish->tv_sec - start->tv_sec; 
  long long int dn =  finish->tv_nsec - start->tv_nsec; 

  if(dn < 0 ) {
    ds--;
    dn += 1000000000; 
  } 
  *difference = ds * 1000000000 + dn;
  return !(*difference > 0);
}

int main() {
  struct timespec start, finish;   
  long long int time_elapsed;

  clock_gettime(CLOCK_MONOTONIC, &start);
  kernel <<<26, 26>>>();

  cudaThreadSynchronize();
  clock_gettime(CLOCK_MONOTONIC, &finish);
  time_difference(&start, &finish, &time_elapsed);
  printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed,(time_elapsed/1.0e9));

  return 0;
}
