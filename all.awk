BEGIN{
	revdsize=0
	starttime=400
	stoptime=0
}
{
	event=$1
	time=$2
	level=$4
	pkt_size=$8
	if(level="AGT" && event="s" && pkt_size>=512)
	{
		if(time<starttime)
			starttime=time
	}
	if(level="AGT" && event="r" && pkt_size>=512)
	{
		if(time>stoptime)
			stoptime=time
		hdr_size=pkt_size%512
		pkt_size-=hdr_size
		revdsize+=pkt_size
	}
}
END{
	printf("Average Goodput[kbps]=%.2f",(revdsize/(stoptime-starttime))*(8/1000));
}