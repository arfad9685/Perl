#!/usr/bin/perl
require "/home/sisasset/cgi-bin/cgi-lib.pl";
require "/home/sisasset/cgi-bin/date.pl";
$attach_dir  = "/home/sisasset/htdocs/tmpast/";
require "/home/sisasset/cgi-bin/genfuncast.pl";
require "/home/sisasset/cgi-bin/koneksi_asset.pl";
use CGI;
use DBI;
&ReadParse(*in);

print "Content-type: text/html\n";
print "Cache-Control: no-store\n";

#print qq~
#<!DOCTYPE >
#<html>
#<head>
#<title>Sari Rasa Grup - Sate Khas Senayan, Tesate, Call Aja</title>
#<link rel="SHORTCUT ICON" href="http://www.sarirasagrup.com/images/sate.ico" />
#</head>
#<body>~;
&koneksi_ast1;

$menucolor="#FFFFFF";
$divheader="#CCCCCC";
$footer="#333333";
$datacolor="#FFFFFF";
$dark = "#FFCC66";
$colcolor="#FFFFCC";
$colcolor2="#FFFF99";
$colcolor3="#FFFF66";

$in{item} = substr $in{item},0,14;
$huruf6itemid = substr $in{item},0,6;
if($huruf6itemid eq 'PCDSKT')
{
  $query = $dba1->prepare("select currcabang, curridlama, kondisi, keterangan, kode from inventori where kode!='$in{item}' and groupkode='$in{item}' ");
  $query->execute();
  while (@rec = $query->fetchrow_array())
  {  print qq~$rec[4],~;
  }
}

#print qq~
#</body>
#</html>
#~;


1
