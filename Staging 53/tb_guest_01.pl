#!/usr/bin/perl
require "/opt/sarirasa/cgi-bin/date.pl";
require "/opt/sarirasa/cgi-bin/cgi-lib.pl";
use CGI;
use DBI;
&ReadParse(*in);

require "/opt/sarirasa/cgi-bin/assets/functions/style_module.pl";
$base_path="/opt/sarirasa/cgi-bin/tmp/$in{ss}";
if ((-e $base_path) && ($in{ss})) {

print "Content-type: application/json; charset=iso-8859-1\n\n";
require "/opt/sarirasa/core/koneksi_str.pl";

&con_png0;
 
  $str= qq~ [\n~;
 if ($in{all} eq 'Y') {
   $tbl_brg=$dbg->prepare("select t.nama, t.hp, t.ktp, t.rombongan, t.datang from t_guestbook t
   where t.store_id=? and cast(t.datang as date)>=? and cast(t.datang as date)<=? order by t.datang"); 
   $tbl_brg->execute($in{cab},$in{tgl1},$in{tgl2});  
 } else {
   $tbl_brg=$dbg->prepare("select substring(t.nama from 1 for 4)||'xxxx', substring(t.hp from 1 for 5)||'xxx' HP, substring(t.ktp from 1 for 2)||'xx'||substring(t.ktp from 5 for 2), t.rombongan, t.datang from t_guestbook t
   where t.store_id=? and cast(t.datang as date)>=? and cast(t.datang as date)<=? order by t.datang"); 
   $tbl_brg->execute($in{cab},$in{tgl1},$in{tgl2});
 }  
@cols = ("nama","hp", "ktp", "orang","jam");
@tipe = ("c","c", "c", "n","c");

while (@rec=$tbl_brg->fetchrow())
{
   $rec[5]=style_module::skkkdd($rec[5]);
   $rec[7]=style_module::skkkdd($rec[7]);   
   $str.= qq( {);
   for($i=0; $i<scalar(@cols); $i++){
     if ($tipe[$i] eq 'n') {
       $str.= qq("c$i" : $rec[$i]);
     } else {
       $str.= qq("c$i" : "$rec[$i]");     
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