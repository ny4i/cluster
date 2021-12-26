#!/usr/bin/perl
use strict;
use Net::DNS::Nslookup;
use Net::Telnet;
use POSIX qw(strftime);

 
my $recCount = 0;
my $good = 0;
my $notFound = 0;
my $found = 0;
my $noConnect = 0;
my $verbose = 0;
my $date = strftime "%Y-%m-%d", localtime;

my $dxFileName = "N1MMCLUSTERS.DAT.$date";

# Check canary hosts to verify DNS resolution is working
my $nslookup = Net::DNS::Nslookup->get_ips("ve7cc.net");
printf("%s\n", $nslookup);
if (length($nslookup) == 0){
   die "Cannot resolve known host ve7cc.net - Check DNS functionality\n";
}

$nslookup = Net::DNS::Nslookup->get_ips("dx.k3lr.com");
printf("%s\n", $nslookup);
if (length($nslookup) == 0){
   die "Cannot resolve known host dx.k3lr.com - Check DNS functionality\n";
}

print "Opening output files...\n" if $verbose;
open (DXFILE, ">> $dxFileName") || die "problem opening $dxFileName\n";

print "Entering file loop...\n" if $verbose;
while (<>) {
   my $addedPort = 0;
   $recCount++;
   my $line = $_;
   if (/(.*),([0-9.a-zA-Z_\-]*)(?::(\d+))?/) {
      my $name = $1;
      my $hostname = $2;
      
      my $port = $3;
      if (length($port) == 0){
         $port = 23;
         $addedPort = 1;
      }
      print "$name,$hostname,$port\n" if $verbose;
      if ($hostname =~ /VERSION/){
         next;
      } 
      
      if ($hostname =~ / /){
         print "Invalid hostname;$name;$hostname;$port\n";
         $notFound++;
         next;
      }
      
      if ($hostname =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/){ # Check for an IP address so we do not do an nslookup
      } else {
         my $nslookup = Net::DNS::Nslookup->get_ips($hostname);
         if (length($nslookup) == 0){
            print "Invalid Host;$name;$hostname;$port\n";
            $notFound++;
            next;
         }
      }
     
      $found++;
      # If we are still here, the host/IP is valid so check if we can connect
      print "Connecting to $hostname:$port\n" if $verbose;
      my $port1 = Net::Telnet->new( Host=>$hostname,Port=>$port, Timeout => 5, Errmode => 'return');
      if ($port1) {
         print DXFILE $name,$hostname;
         if (!$addedPort){
            print DXFILE ":$port";
         }
         print DXFILE "\n";
         $good++;
      } else {
         print "Connect Error;$name;$hostname;$port\n";
         #print DXFILE "\"$name\",\"$hostname\",\"$port\"\n";
         $noConnect++
      }
   } else {
      print "#$line did not match regex\n";
   }
}

print "#Not found = $notFound\n";
print "#Found = $found\n";
print "#No connect = $noConnect\n";
print "#Found = $good\n";
print "total records = $recCount\n";

if ($recCount > 0) {
   print "# % bad hostnames = " . (($notFound / $recCount) * 100) . " % \n";
   print "#    % No connect = "    . (($noConnect / $recCount) * 100) . " % \n";
   print "#          % good = "    . (($good / $recCount) * 100) . " % \n";
}