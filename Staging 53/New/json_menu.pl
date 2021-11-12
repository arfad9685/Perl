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

if ($in{resto}) {
  $cond = " and brand_id='$in{resto}'";
} else {
  $cond="";
}

 $str= qq~ [\n~; 
 $tbl_brg=$dbh->prepare("select menu_id,menu_name,'PORSI', b.brand_init, b.brand_id from m_menu_pos  p
inner join m_cab_brand b on b.brand_id=p.menu_brand
where p.isaktif='Y' $cond");
$tbl_brg->execute();
while (@rec=$tbl_brg->fetchrow())
{
   $str.= qq~ { "label" : "$rec[3] - $rec[1]", "value" : "$rec[0]", "sat" : "$rec[2]", "brand" : "$rec[4]"},~ ;
}
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str .=  qq~\n~; 
 $str .= qq~]~; 
 print $str;

}