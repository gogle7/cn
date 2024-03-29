set ns [new Simulator]
$ns color 1 red
$ns color 2 blue
set tf [open ex2.tr w]
$ns trace-all $tf

set nf [open ex2.nam w]
$ns namtrace-all $nf

set cwind [open win2.tr w]
set cwind1 [open win3.tr w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 5Mb 2ms DropTail
$ns duplex-link $n1 $n2 5Mb 2ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 1ms DropTail
$ns queue-limit $n0 $n2 3
$ns duplex-link-op $n0 $n2 color green
$ns duplex-link-op $n2 $n3 color green
$ns duplex-link-op $n1 $n2 color red

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0
$ns connect $tcp0 $sink0
set ftp [new Application/FTP]
$ftp attach-agent $tcp0
$tcp0 set fid_ 1

$ns at 1.2 "$ftp start"

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $sink1
$ns connect $tcp1 $sink1
set telnet [new Application/Telnet]
$telnet attach-agent $tcp1
$tcp1 set fid_ 2

$ns at 1.5 "$telnet start"

$ns at 10.0 "finish"

proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file" }
$ns at 2.0 "plotWindow $tcp0 $cwind"
$ns at 5.5 "plotWindow $tcp1 $cwind1"


proc finish {} {
global ns tf nf cwind
$ns flush-trace
close $tf
close $nf

puts "running nam..."
puts "FTP PACKETS"
puts "Telnet packets"
exec nam ex2.nam &
exec xgraph win2.tr &
exec xgraph win3.tr &
exit 0
}
$ns run
}


