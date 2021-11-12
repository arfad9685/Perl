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

&con_fin0;
&con_fin1;

$str= qq~ [\n~; 
$mst_pph = $dbfin->prepare("select a.jenis_pph,a.jns_biaya,a.jns_usaha,a.jns_pajak,a.tarif_npwp,a.tarif_nonpwp,a.jenis_print,a.no_acc,''
from m_tarif_pph a
left outer join  m_pph b on b.recid = a.jenis_pph 
order by 1");

$mst_pph->execute();
while(@row=$mst_pph->fetchrow())
{
    $str.= qq~ { "jnspph" : "$row[0]","jnsbiaya" : "$row[1]", "jnsush" : "$row[2]", "jnspjk" : "$row[3]", "tarifnpwp" : "$row[4]", "tarifnon" : "$row[5]","jnsprint" : "$row[6]","noacc" : "$row[7]","action" : "$row[8]"},~ ;
}

 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str .=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
}





