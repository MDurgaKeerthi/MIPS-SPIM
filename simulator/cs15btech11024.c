/*
MIPS simple simulator
*/
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

long registervalues[32] = {0};      //arrays for registers
char *registernames[32] = {"$0", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra" };

void print(int [][30]);
int add(FILE *);                 //declaration of function
int addi(FILE *);
int sub(FILE *);
int mul(FILE *);
int and(FILE *);
int andi(FILE *);
int or(FILE *);
int ori(FILE *);
int nor(FILE *);
int slt(FILE *);
int slti(FILE *);
int la(FILE *, char [][25], int [][30]);
int lw(FILE *);
int sw(FILE *);
int beq(FILE *);
int bne(FILE *);
int jump(FILE *);


char *functionNames[17] = {"add", "addi", "sub", "mul", "and", "andi", "or", "ori", "nor", "slt", "slti","beq", "bne", "lw", "sw", "la","j"}; 
int (*functions[15])(FILE *) = {add, addi, sub, mul, and, andi, or, ori, nor, slt, slti,beq, bne,lw,sw}; 
//using function pointers

char fnname[10], rs[6], rt[6], rd[4], offset;   //some required global variables
int reg1;
long offsetArray[20];
static char loopnames[10][10];
int loopcount = -1;
int arrayindex[5];
int a=0;

int main() {
   char line[40], f1[25];
   int linecount=0;
   printf("enter input file name: ");                               //input of file names from user
   scanf("%s",f1);
   FILE *fp1;
      fp1=fopen(f1,"r"); 
   if(fp1 == NULL){
      printf("%s file can not be opened ", f1);
      return 0;
      }

   char colonstring[5];

   while(!feof(fp1)){               //getting loopnames
      fscanf(fp1,"%s",line);
      if(!strcmp(line,".data")){                                  //line == ".data" 
         while(strcmp(line,".text"))                               //line != ".text"   
            fscanf(fp1,"%s",line);
      }
      fscanf(fp1,"%s",line);                 //line gets .main
      if(!strcmp(line,".main:")){            //line == ".main"
         fscanf(fp1,"%s",line);
         while(strcmp(line,"halt")){ 
            int fgt = strlen(line);
            loopcount++;   
            if(line[fgt-1] == ':'){            //colonstring == ":"  
               int mi = 0;
               offsetArray[loopcount] = ftell(fp1);
               while(line[mi] != '\0'){
                  loopnames[loopcount][mi] = line[mi];
                  mi++;
               } mi--;
               loopnames[loopcount][mi--] = '\0';
               
            }
            
            fscanf(fp1,"%s",line);  
      }
   }
}        //completeed getting loopnames

   rewind(fp1);         //setting again to the start
   
   static int mode;
   printf("Select the mode\n 1. Execution Mode\t 2. Step-by-Step Mode\nEnter:");
   scanf("%d", &mode);
   if(mode < 1 || mode > 2){
      printf("Not available choice.\n");     //getting the mode
      return 0;
      }

printf("%s", loopnames[0]);

   char arraynames[5][25];
   int arrays[5][30];          //5arrays of max size 100
   int Arrays[3] = {5, 6, 9};
   char element[5], colonchar[1], arraytype[8];

   while(!feof(fp1)){
      fscanf(fp1,"%s",line);
      if(!strcmp(line,".data")){                               //line == ".data"
         while(strcmp(line,".text")){                               //line != ".text"   
            fscanf(fp1, "%s", arraynames[a]);
            fscanf(fp1,"%s",colonchar);
            if(!strcmp(colonchar,":")){                        //colonchar == :
               fscanf(fp1,"%s",arraytype);
               if(!strcmp(arraytype,".word")){     
                  fscanf(fp1,"%s",element);
                  while(strcmp(element, "end")){
                     arrays[a][arrayindex[a]++] = atoi(element); 
                     fscanf(fp1,"%s",element);
                  }
               }
               else {
                  printf("\nNot supportable format of array declaration");
                  return 0;
                  }               
               }
            else{
               printf("\nERROR at line: %s",line);
               printf("\n2.Not supportable mips format. Input proper code");      
               return 0;
               } 
            a++;
            fscanf(fp1,"%s",line);
            if(strcmp(line,".text"))            //line != ".text"
               fseek(fp1,-4, SEEK_CUR);         //fp1--;
            }
         }

      if(!strcmp(line,".text")){                             //line == ".text"
         fscanf(fp1,"%s",line);
         if(!strcmp(line,".main:")){                          //line == .main
            fscanf(fp1,"%s",fnname);
            while(strcmp(fnname,"halt")){                      //line != halt   
               int m=0, flag = 0, check, vc = 0, flag2 = 0; 
               while(vc < loopcount){
                  if(!strcmp(fnname,loopnames[vc]))
                     flag2 = 1;
                  vc++;
                  }
               if(flag2 == 1) 
                  fscanf(fp1,"%s",fnname);
               if(flag2 != 1)    { 
               while(m<17){
                  if(!strcmp(functionNames[m],fnname)){        //comparing the function names
                     flag++;
                     break;
                     }
                  m++;
               }
                  
               if(flag == 0)
                  break;
               else {
                  if(m != 16){
                     fscanf(fp1,"%s",rd);
                    //rd[3] = '\0';
                     reg1 = regnumerical(rd);
                     
                     if(m<15){
                        check = (*functions[m])(fp1);    //callfunctions(   fp1);
                        if(mode == 2){
                           printf("After execution of function %s\n",functionNames[m]);      
                           print(arrays);    
                           /*int dec = 0;
                           for(; dec < arrayindex[0]; dec++)
                              printf("%d", arrays[0][dec]);*/
                           }
                        }
                     else if(m== 15){
                          check = la(fp1, arraynames, arrays);       //valling functions
                          if(mode == 2){
                              printf("After execution of function %s\n",functionNames[m]);      
                              print(arrays); 
                              }
                        }
                     }
                  else
                     check = jump(fp1); 
                  if(check!=0) 
                     break;
                  }}
               fscanf(fp1,"%s",fnname);
               }
            }
         }
      if( (!strcmp(fnname,"halt")) || (!strcmp(line,"halt")) ){
         print(arrays);//////end of the program
         printf("Program ended.");
         return 0;   
         }
      else{
         printf("\nERROR at : %s--%s", line,fnname);
         printf("\nNot supportable mips format. Input proper code");
         return 0;
         }   
   }
}


void print(int arrays[][30]){          //printing
   int index = 0;
   for(; index < 32; index++){
         printf("%s:::%x\n",registernames[index], registervalues[index]);
   }
   int dec = 0;
   printf("Memory status");
   for(; dec < arrayindex[0] ; dec++)
      printf("%d ", arrays[0][dec]);
   //printf("%s:::%p\n",registernames[21], registervalues[21]);
   return ;
}
 
int regnumerical(char *registername){        //for getting register index
   int regvalue = -1;
   if(registername[0] == '$'){
      if(registername[1] == '0' || (!strcmp(registername,"$zero")))
         return 0;
   if(isdigit(registername[3]))
      return 0;
      switch(registername[1]){
      case 't':{ 
                  if(isdigit(registername[2])){
                     regvalue = atoi(&registername[2]);
                     if(regvalue<=7 && regvalue>=0 )
                        regvalue = 8 + regvalue;
                     else if(regvalue==8 || regvalue==9 )
                        regvalue = 16 + regvalue;
                     }
                  break;
                  }
      case 's':{
                  if(isdigit(registername[2])) {
                     regvalue = atoi(&registername[2]);
                     if(regvalue<=7 && regvalue>=0 )
                        regvalue = 16 + regvalue;
                     }
                  else if(registername[2] == 'p')
                        regvalue = 29;   
                  break;
               }   
      case 'v':{ 
                  if(isdigit(registername[2])){
                     regvalue = atoi(&registername[2]);
                     if(regvalue==0 || regvalue==1 )
                        regvalue = 2 + regvalue;
                     }
                  break;
                  }
      case 'a':{
                  if(isdigit(registername[2])) {
                     regvalue = atoi(&registername[2]);
                     if(regvalue<=3 && regvalue>=0 )
                        regvalue = 4 + regvalue;
                     }
                  else if(registername[2] == 't')
                        regvalue = 1;   
                  break;
               } 
      case 'k':{
                  if(isdigit(registername[2])){
                     regvalue = atoi(&registername[2]);
                     if(regvalue==0 || regvalue==1 )
                        regvalue = 26 + regvalue;
                     }
                  break;
                  }
      }
   if(!strcmp(registername, "$ra"))
      regvalue = 31;
   else if(!strcmp(registername, "$gp"))
      regvalue = 28;
   else if(!strcmp(registername, "$fp"))
      regvalue = 30;
   }
   if(regvalue < 32)
      return regvalue;
}
      //add funtion
int add(FILE *pointer){
   fscanf(pointer,"%s",rs);
   fscanf(pointer,"%s",rt);
   int reg2 = regnumerical(rs);
   int reg3 = regnumerical(rt);
   //printf("in add function");
   if(reg1 >0  && reg2 != -1 && reg3 != -1 ){
      registervalues[reg1] = registervalues[reg2] + registervalues[reg3];
      return 0;
      }
   else
      return 1;
}

int addi(FILE *pointer){         //addi function
   fscanf(pointer,"%s",rs);
   fscanf(pointer,"%s",rt);
   int reg2 = regnumerical(rs);
   //printf("in addi function");
   if(reg1 >0  && reg2 != -1){
      registervalues[reg1] = registervalues[reg2] + atoi(rt);
      return 0;
      }
   else
      return 1;
}

int sub(FILE *pointer){       //sub function
   fscanf(pointer,"%s",rs);
   fscanf(pointer,"%s",rt);
   int reg2 = regnumerical(rs);
   int reg3 = regnumerical(rt);
   //printf("in sub function");
   if(reg1 >0  && reg2 != -1 && reg3 != -1 ){
      registervalues[reg1] = registervalues[reg2] - registervalues[reg3];
      return 0;
      }
   else
      return 1;
}

int mul(FILE *pointer){          //mul functin  
   fscanf(pointer,"%s",rs);
   fscanf(pointer,"%s",rt);
   int reg2 = regnumerical(rs);
   int reg3 = regnumerical(rt);
   //printf("in mul function");
   if(reg1 >0  && reg2 != -1 && reg3 != -1 ){
      registervalues[reg1] = registervalues[reg2] * registervalues[reg3];
      return 0;
      }
   else
      return 1;
}

int and(FILE *pointer){             //and function
   fscanf(pointer,"%s",rs);
   fscanf(pointer,"%s",rt);
   int reg2 = regnumerical(rs);
   int reg3 = regnumerical(rt);
   //printf("in mul function");
   if(reg1 >0  && reg2 != -1 && reg3 != -1 ){
      registervalues[reg1] = registervalues[reg2] & registervalues[reg3];
      return 0;
      }
   else
      return 1;
}

int andi(FILE *pointer){         //andi function
   fscanf(pointer,"%s",rs);
   fscanf(pointer,"%s",rt);
   int reg2 = regnumerical(rs);
   //printf("in addi function");
   if(reg1 >0  && reg2 != -1){
      registervalues[reg1] = registervalues[reg2] & atoi(rt);
      return 0;
      }
   else
      return 1;
}

int or(FILE *pointer){        //or function
   fscanf(pointer,"%s",rs);
   fscanf(pointer,"%s",rt);
   int reg2 = regnumerical(rs);
   int reg3 = regnumerical(rt);
   //printf("in or function");
   if(reg1 >0  && reg2 != -1 && reg3 != -1 ){
      registervalues[reg1] = registervalues[reg2] | registervalues[reg3];
      return 0;
      }
   else
      return 1;
}
      
int ori(FILE *pointer){          //ori function
   fscanf(pointer,"%s",rs);
   fscanf(pointer,"%s",rt);
   int reg2 = regnumerical(rs);
   //printf("in ori function");
   if(reg1 >0  && reg2 != -1){
      registervalues[reg1] = registervalues[reg2] | atoi(rt);
      return 0;
      }
   else
      return 1;
}

int nor(FILE *pointer){             //nor function
   fscanf(pointer,"%s",rs);
   fscanf(pointer,"%s",rt);
   int reg2 = regnumerical(rs);
   int reg3 = regnumerical(rt);
   //printf("in or function");
   if(reg1 >0  && reg2 != -1 && reg3 != -1 ){
      registervalues[reg1] = ~(registervalues[reg2] | registervalues[reg3]);
      return 0;
      }
   else
      return 1;
}

int slt(FILE *pointer){          //slt fucntion
   fscanf(pointer,"%s",rs);
   fscanf(pointer,"%s",rt);
   int reg2 = regnumerical(rs);
   int reg3 = regnumerical(rt);
   //printf("in slt function");
   if(reg1 >0  && reg2 != -1 && reg3 != -1 ){
      if(registervalues[reg2] < registervalues[reg3])
         registervalues[reg1] = 1;
      else 
         registervalues[reg1] = 0;
      return 0;
      }
   else
      return 1;
}

int slti(FILE *pointer){         //slti function
   fscanf(pointer,"%s",rs);
   fscanf(pointer,"%s",rt);
   int reg2 = regnumerical(rs);
   //printf("in slti function");
   if(reg1 >0  && reg2 != -1  ){
      if(registervalues[reg2] < atoi(rt))
         registervalues[reg1] = 1;
      else 
         registervalues[reg1] = 0;
      return 0;
      }
   else
      return 1;
}

int la(FILE *pointer, char nameofArray[][25], int array[][30]){         //la function
   if(reg1 != -1){
      char temparray[25];
      fscanf(pointer, "%s", temparray);
      int y=0;
      for(;y<a;y++){
         if(!strcmp(nameofArray[y],temparray)){
            registervalues[reg1] = array[y];
            return 0;
         }
      }
   }
   return 1;
}
      
int lw(FILE *pointer){        //load function
   char temp[15], nextchar,tempname[15];
   fscanf(pointer,"%s",temp);
   int d =0, indexvalue = 0;
   if(isdigit(temp[0])){
      while(temp[d] != '\0')
         d++;
      fseek(pointer,-d, SEEK_CUR); 
      fscanf(pointer,"%d",&indexvalue);
      fscanf(pointer,"%c",&nextchar);
      if( nextchar == '(' ){
         printf("indexvalue--%d\n", indexvalue);
         fscanf(pointer,"%s",rs);
         rs[3] = '\0';
         int reg2 = regnumerical(rs);
         if(reg1 > 0 && reg2 != -1){
            long *temp =(long *) (registervalues[reg2] + indexvalue);
            registervalues[reg1] = *temp;
            return 0;  
            }
         else
            return 1; 
      }
      
   }
   return 1;
}

int sw(FILE *pointer){        //store word fucntion
   char temp[15], nextchar,tempname[15];
   fscanf(pointer,"%s",temp);
   int d =0, indexvalue = 0;
   if(isdigit(temp[0])){
      while(temp[d] != '\0')
         d++;
      fseek(pointer,-d, SEEK_CUR); 
      fscanf(pointer,"%d",&indexvalue);
      fscanf(pointer,"%c",&nextchar);
      if( nextchar == '(' ){
         fscanf(pointer,"%s",rs);
         rs[3] = '\0';
         int reg2 = regnumerical(rs);
         if(reg1 != -1 && reg2 != -1){
            long temptoget = registervalues[reg2] + indexvalue;
            long *ptr = (long *)temptoget;
            *ptr = registervalues[reg1];
            return 0;  
            }
         }
      }
   
   return 1;
}

int beq(FILE *pointer){          //branch on equal to function
   fscanf(pointer,"%s",rs);
   int reg2 = regnumerical(rs);
   int result;
   if(reg2 != -1 && reg1 != -1){
      if(registervalues[reg1] == registervalues[reg2])
         result = jump(pointer);
      if((registervalues[reg1] != registervalues[reg2]) || result == 0) 
         return 0;
   }
   return 1;
}

int bne(FILE *pointer){          //branch on not equal to function
   fscanf(pointer,"%s",rs);
   int reg2 = regnumerical(rs);
   int result;
   if(reg2 != -1 && reg1 != -1){
      if(registervalues[reg1] != registervalues[reg2])
         result = jump(pointer);
      if((registervalues[reg1] == registervalues[reg2]) || result == 0) 
         return 0;
   }
   return 1;
}

int jump(FILE *pointer){         //jump function
   char temploopname[10];
   fscanf(pointer, "%s", temploopname);
   int zx = 0;
   while(zx < loopcount){
      if(!strcmp(temploopname,loopnames[zx])){
         fseek(pointer, offsetArray[zx], SEEK_SET);
         return 0;
      }
      zx++;
   }
   return 1;
}

