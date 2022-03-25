#!/usr/bin/perl
use strict;
use Net::DNS::Nslookup;
use Net::Telnet;
 
my $notFound = 0;
my $found = 0;
my $noConnect = 0;
my $verbose = 1

while (<>) {
   my $line = $_;
   if (/"(.*)","(.*)","(.*)","(.*)"/) {
      my $name = $1;
      my $hostname = $2;
      my $port = $3;
      my $type = $4;
      if ($hostname =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/){
      } else {
         my $nslookup = Net::DNS::Nslookup->get_ips($hostname);
         if (length($nslookup) == 0){
            chop $line;
            print "$line,\"Not Found\"\n";
            $notFound++;
            next;
         }
      }
      $found++;
      # If we are still here, the host/IP is valid so check if we can connect
      print "Connecting to $hostname:$port\n" if $verbose;
      my $port1 = Net::Telnet->new( Host=>$hostname,Port=>$port, Timeout => 10, Errmode => 'return');
      if ($port1) {
         print $line
      } else {
         chop $line;
         print "$line,\"No connect\"\n";
         $noConnect++
      }
   }
}

print "#Not found = $notFound\n";
print "#Found = $found\n";
print "#No connect = $noConnect\n";
