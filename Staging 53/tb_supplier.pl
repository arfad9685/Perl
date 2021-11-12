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

 $str= qq~ [\n~; 
 $tbl_brg=$dbh->prepare("select trim(vendor_id), iif(char_length(replace(vendor_name, '\"', ''))>15 and replace(vendor_name, '\"', '') != '', substring(replace(vendor_name, '\"', '') from 1 for 15) || '...', replace(vendor_name, '\"', '')), vendor_tipe, terms_id, cara_byr, istax, isaktif, isall, iif(char_length(trim(kontak))>15 and kontak != '', substring(trim(kontak) from 1 for 15) || '...', trim(kontak)), iif(char_length(phone)>15 and phone != '', substring(phone from 1 for 15) || '...', phone) from m_supplier");
$tbl_brg->execute();

@cols = ("Vendor ID", "Vendor Name", "Vendor Tipe", "Terms ID", "Cara Bayar", "Is Tax", "Is Aktif", "Is All", "Kontak", "Phone");

while (@rec=$tbl_brg->fetchrow())
{
   $str.= qq( {);
   for($i=0; $i<scalar(@cols); $i++){
    $str.= qq("c$i" : "$rec[$i]");
     
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