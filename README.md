# cluster
Utilities to validate DXCLUSTERS file

To use, do the following:

```
wget http://www.dxcluster.info/telnet/DXCLUSTERS.DAT
./checkHostNew.pl DXCLUSTERS.DAT
```

Three files are produced:
* DXCLUSTERS.DAT.YYYY-MM-DD
* N1MMClusters.txt.YYYY-MM-DD
* trcluster.dat.YYYY-MM-DD

Note to run it, you need Perl dependencicies:

* use Net::DNS::Nslookup;
* use Net::DNS::Resolver;
* use Net::Telnet;
* use POSIX qw(strftime);
* use Socket;
