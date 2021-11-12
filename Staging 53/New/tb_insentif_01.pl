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

&con_inv0;
 $brand="";$kat="";
 if ($in{brand}) {
   $brand="AND c.brand_id='$in{brand}'";
 }
 if ($in{kat}) {
   $kat=" AND k.recid=$in{kat}";
 } 
 
 
 $str= qq~ [\n~; 
 $tbl_brg=$dbh->prepare("select m.recid, m.menu_id,p.menu_name, c.brand_init, k.keterangan, m.d_berlaku, m.d_end, k.warna from m_insentif_menu m
 inner join m_menu_pos p on p.menu_id=m.menu_id
 inner join m_insentif_kat k on k.recid=m.insentif $kat
 inner join m_cab_brand c on c.brand_id=m.brand $brand order by 4,5");
 
$tbl_brg->execute();

@cols = ("recid", "kode", "nama", "brand","insentif","berlaku","expired","warna");
@type = ("n", "c", "c", "c","c","c","c","c");
while (@rec=$tbl_brg->fetchrow())
{
   $str.= qq( {);
   for($i=0; $i<scalar(@cols); $i++){
    if ($type[$i] eq "c") {
      $str.= qq("$cols[$i]" : "$rec[$i]");
    } else {
      $str.= qq("$cols[$i]" : $rec[$i]);     
    }      
    if($i<scalar(@cols)-1){
     $str.= qq(,);
    }
   }
   $str.= qq( },) ;     
}
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str .=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
}