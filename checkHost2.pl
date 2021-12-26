#!/usr/bin/perl
use strict;
use Net::DNS::Nslookup;
use Net::Telnet;
 
my $notFound = 0;
my $found = 0;
my $noConnect = 0;

while (<>) {
   my $line = $_;
   if (/(.*)[: ]{1}(\d{1,5}).*/) {
      my $hostname = $1;
      my $port = $2;
      if ($hostname =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/){
      } else {
         my $nslookup = Net::DNS::Nslookup->get_ips($hostname);
         if (length($nslookup) == 0){
            $notFound++;
            next;
         }
      }
      $found++;
      # If we are still here, the host/IP is valid so check if we can connect
      my $port1 = Net::Telnet->new( Host=>$hostname,Port=>$port, Timeout => 10, Errmode => 'return');
      if ($port1) {
         print $line
      } else {
         $noConnect++
      }
   }
}

print "#Not found = $notFound\n";
print "#Found = $found\n";
print "#No connect = $noConnect\n";
