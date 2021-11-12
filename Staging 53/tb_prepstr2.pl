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
 $thnbln=substr($in{nospk},0,6);
 $str= qq~ [\n~; 
 $tbl_brg=$dbh->prepare("select brg_prep,pa.areaprd_nama, si.spk_brgid,p.brg_nama,si.spk_satpro,p.brg_ht_str,si.recid,
   si.spk_target, si.stk_oh,get_konv(si.spk_brgid,si.spk_satprod,si.spk_satpro) batch,si.spk_satprod, si.spk_addwork, si.spk_hasil from t_spkisp_$thnbln si
   inner join m_produk p on p.brg_id=si.spk_brgid
   inner join m_produk_areaprd pa on pa.areaprd_id=brg_area_prd
   where si.spk_order=? and si.spk_storeid=?
   order by si.recid");
 $tbl_brg->execute($in{nospk},$in{cab});
 while (@lpr=$tbl_brg->fetchrow())
 {
#   $lpr[0] = ~ s/ //g;
#   $lpr[1] = ~ s/ //g;
   if ($lpr[9]>0) {
      $make=$lpr[7]/$lpr[9];
   } else {
      $make=0;
   } 
   $str.= qq~ { "dapur" : "$lpr[0]","area" : "$lpr[1]","brgid" : "$lpr[2]","brgnama" : "$lpr[3]","satstk" : "$lpr[4]","satprod" : "$lpr[10]",
   "addwork" : "$lpr[11]", "ht" : $lpr[5],"target" : $lpr[7],"oh" : $lpr[8], "batch" : $lpr[9],"recid" : $lpr[6],"hasil" : $lpr[12],"make" : $make},~ ;   
 }
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str .=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
}