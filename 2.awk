BEGIN {
size=0;
tcp=0;
time=0;
throughput=0;
size2=0;
size3=0;
}
{
size+=$6
  if($1=="r" && $5=="tcp")
   tcp++; 
   if($1=="r" && $4=="3") {
   size2+=$6
   time=$2;
    }  
   if($1=="r" && $4=="0") {
   size3+=$6
   time=$2;
    }
}
END{
printf("Total size =%f\n",size*8/1000000);
printf("TCP packets=%f\n",tcp);
printf("Throughput for FTP=%f mbps\n",((size2/time)*(8/1000000)));
printf("Throughput for TELNET=%f mbps\n",((size3/time)*(8/1000000)));

}
