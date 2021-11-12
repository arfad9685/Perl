#!/usr/bin/perl
require "/opt/sarirasa/cgi-bin/date.pl";
require "/opt/sarirasa/cgi-bin/cgi-lib.pl";
use CGI;
use DBI;
&ReadParse(*in);


$base_path="/opt/sarirasa/cgi-bin/tmp/$in{ss}";
if ((-e $base_path) && ($in{ss})) {

print "Content-type: application/json; charset=iso-8859-1\n\n";
require "/opt/sarirasa/core/koneksi_str.pl";
require "/opt/sarirasa/cgi-bin/assets/functions/style_module.pl";
&con_inv0;
$thnbln = style_module::thntgl(6);

 $str= qq~ [\n~; 
 $tbl_brg=$dbh->prepare("SELECT i.spk_order,i.spk_tgl,count(i.spk_brgid), i.OPERATOR from t_spkisp_$thnbln i
 where i.spk_proses='N' and i.spk_storeid=? group by spk_order, spk_tgl,operator");
$tbl_brg->execute($in{cab});
while (@lpr=$tbl_brg->fetchrow())
{  
   $tgl=style_module::date_name($lpr[1]);
   $str.= qq~ { "nospk" : "$lpr[0]","tanggal" : "$tgl","jml" : "$lpr[2]","opr" : "$lpr[3]"},~ ;   
}
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str .=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
}