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
 $cond="";
 if ($in{kat}) {
   $cond="AND s.vendor_tipe=$in{kat}";
 }
 if ($in{nama}) {
   $in{nama}=uc($in{nama});  
   $cond=" AND s.vendor_name like '%$in{nama}%'";
 } 
 
 
 $str= qq~ [\n~; 
 $tbl_brg=$dbh->prepare("select s.vendor_id, replace(s.vendor_name,'\"',''), sk.tipe_nama,s.phone_1, s.email_1,
  st.top_hari, s.cara_byr, s.istax,sk.kat_tipe from M_SUPPLIER S
  inner join m_supplier_top st on st.top_id=s.terms_id
  inner join m_supplier_tipe sk on sk.tipe_id=s.vendor_tipe
  WHERE s.isaktif='Y' $cond
  ORDER BY s.vendor_name");
 
$tbl_brg->execute();

@cols = ("KODE", "NAMA", "KATEGORI","TELP","EMAIL","TOP", "CR BAYAR", "TAX","JNS");

while (@rec=$tbl_brg->fetchrow())
{
   $rec[4] =~ s/@/\@/;
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