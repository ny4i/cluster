#!/usr/bin/perl

use lib qw( ..); 
use strict;
use warnings;
use LWP::UserAgent;

use HTML::TableExtract; 
#use LWP::RobotUA;
use Data::Dumper; 

my $ua = LWP::UserAgent->new();
my $url = 'http://www.dxcluster.info/telnet/index.php';

#$ua->agent("Mozilla/5.0");  # set user agent
my $res = $ua->get($url);   # send request

# check the outcome
if ($res->is_success) 
{   
   #my $te = HTML::TableExtract->new();
   my $te = HTML::TableExtract->new( headers => ["NODECALL & IP", "NOTES/SOFTWARE"] );
   $te->parse($res->content);
   foreach my $ts ($te->tables) {
      print "Table found at ", join(',', $ts->coords), ":\n";
      foreach my $row ($ts->rows) {
         $row =~ s/\r//;
         print "   ", join(',', @$row), "\n";
         last;
      }
   }

   
   
}
else {
   # ko
   print "Error: ", $res->status_line, "\n";
}


