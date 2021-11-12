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
&con_inv1;

if ($in{nama}) {
  $in{nama} = uc ($in{nama});
  $cond = "and p.brg_nama containing '$in{nama}'";
}

 $str= qq~ [\n~;
 if ($in{jenis} eq 'ISP') {
   if ($in{all} eq 'Y') {
     $tbl_brg=$dbh->prepare("select p.brg_id, p.brg_nama,p.brg_satstore, sum(ks.jml_audit) audit,
      sum(ks.jml_beli) beli, sum(ks.jml_masuk) masuk,sum(ks.jml_kirim) kirim,
      sum(ks.jml_jual) jual, sum(ks.jml_waste) waste,sum(ks.jml_nonsal) nonsal
      from m_produk_all p  left outer join T_kartustok_$in{cab} ks on p.brg_id=ks.brg_id and ks.store_id=? and ks.tanggal>=? and ks.tanggal<=?
      where p.brg_jenis='ISP'  and p.isaktif='Y' $cond group by 1,2,3 order by 2");    
   } else {
     $tbl_brg=$dbh->prepare("select ks.brg_id, p.brg_nama,ks.satuan,sum(ks.jml_audit) audit,
      sum(ks.jml_beli) beli, sum(ks.jml_masuk) masuk,sum(ks.jml_kirim) kirim,
      sum(ks.jml_jual) jual, sum(ks.jml_waste) waste,sum(ks.jml_nonsal) nonsal
      from T_kartustok_$in{cab} ks inner join m_produk_all p on p.brg_id=ks.brg_id
      where ks.store_id=? and ks.tanggal>=? and ks.tanggal<=? and p.brg_jenis='ISP' $cond group by 1,2,3 order by 2");
   } 
 } elsif ($in{jenis} eq 'NF') {
   if ($in{all} eq 'Y') {
    $tbl_brg=$dbh->prepare("select p.brg_id, p.brg_nama,p.brg_satstore,sum(ks.jml_audit) audit,
     sum(ks.jml_beli) beli, sum(ks.jml_masuk) masuk,sum(ks.jml_kirim) kirim,
     sum(ks.jml_jual) jual, sum(ks.jml_waste) waste,sum(ks.jml_nonsal) nonsal
     from m_produk_all p left outer join T_kartustok_$in{cab} ks on p.brg_id=ks.brg_id and store_id=? and ks.tanggal>=? and ks.tanggal<=?
     where brg_tabid=2 and p.brg_brand containing '$in{brand}' and p.isaktif='Y' $cond group by 1,2,3 order by 2");
   } else { 
    $tbl_brg=$dbh->prepare("select ks.brg_id, p.brg_nama,ks.satuan,sum(ks.jml_audit) audit,
     sum(ks.jml_beli) beli, sum(ks.jml_masuk) masuk,sum(ks.jml_kirim) kirim,
     sum(ks.jml_jual) jual, sum(ks.jml_waste) waste,sum(ks.jml_nonsal) nonsal
     from T_kartustok_$in{cab} ks inner join m_produk_all p on p.brg_id=ks.brg_id 
     where store_id=? and brg_tabid=2 and ks.tanggal>=? and ks.tanggal<=? $cond group by 1,2,3 order by 2");
   } 
 } else {
   if ($in{all}) {
    $tbl_brg=$dbh->prepare("select p.brg_id, p.brg_nama,p.brg_satstore,sum(ks.jml_audit) audit,
     sum(ks.jml_beli) beli, sum(ks.jml_masuk) masuk,sum(ks.jml_kirim) kirim,
     sum(ks.jml_jual) jual, sum(ks.jml_waste) waste,sum(ks.jml_nonsal) nonsal
     from m_produk_all p left outer join T_kartustok_$in{cab} ks on p.brg_id=ks.brg_id and store_id=?
     and ks.tanggal>=? and ks.tanggal<=? where p.brg_tabid=1 and brg_jenis
     in ('RM','WIP') and p.brg_brand containing '$in{brand}' and p.isaktif='Y'
     and p.isstore='Y'  $cond group by 1,2,3 order by 2");    
   } else {
    $tbl_brg=$dbh->prepare("select ks.brg_id, p.brg_nama,ks.satuan,sum(ks.jml_audit) audit,
     sum(ks.jml_beli) beli, sum(ks.jml_masuk) masuk,sum(ks.jml_kirim) kirim,
     sum(ks.jml_jual) jual, sum(ks.jml_waste) waste,sum(ks.jml_nonsal) nonsal
     from T_kartustok_$in{cab} ks inner join m_produk_all p on p.brg_id=ks.brg_id 
     where store_id=? and ks.tanggal>=? and ks.tanggal<=? $cond and brg_tabid=1 and brg_jenis in ('RM','WIP')
     group by 1,2,3 order by 2 ");
   } 
 }  
$tbl_brg->execute($in{cab},$in{tgl1},$in{tgl2});
while (@rec=$tbl_brg->fetchrow())
{
   $rec[0] =~ s/ //g;
   $rec[1] =~ s/'/ /g;
   $rec[1] =~ s/"/ /g;
   $now[1]=0;$now[2]=0;
   if (!$tbl_now) {
    $tbl_now=$dbh1->prepare("select p.brg_id, coalesce(get_saldo(?,?,?-1),0),coalesce(opn.koreksi,0) from m_produk_all p
     left outer join 
     (select brg_id,sum(koreksi) koreksi from t_opn_str
     where store_id=? and opn_date-1<=? and isvalid='Y' group by brg_id) opn on opn.brg_id=p.brg_id
     where p.brg_id=?");
   }
   $tbl_now->execute($rec[0],$in{cab},$in{tgl1},$in{cab},$in{tgl2},$rec[0]);
   @now=$tbl_now->fetchrow();
    
   $akhir=($now[1]+$rec[3]+$rec[4]+$rec[5]) - $rec[6] - $rec[7] - $rec[8] - $rec[9];
   $oh=$akhir + $now[2];   
   if ($akhir !=0) {$akhir = style_module::skkkff($akhir) } else { $akhir=''};
   if ($oh !=0) {$oh = style_module::skkkff($oh) } else { $oh=''};      
   if ($now[1] !=0) {$now[1] = style_module::skkkff($now[1]) } else { $now[1]=''};
   if ($rec[3] !=0) {$rec[3] = style_module::skkkff($rec[3]) } else { $rec[3]=''};
   if ($rec[4] !=0) {$rec[4] = style_module::skkkff($rec[4]) } else { $rec[4]=''};
   if ($rec[5] !=0) {$rec[5] = style_module::skkkff($rec[5]) } else { $rec[5]=''};
   if ($rec[6] !=0) {$rec[6] = style_module::skkkff($rec[6]) } else { $rec[6]=''};
   if ($rec[7] !=0) {$rec[7] = style_module::skkkff($rec[7]) } else { $rec[7]=''};
   if ($rec[8] !=0) {$rec[8] = style_module::skkkff($rec[8]) } else { $rec[8]=''};
   if ($rec[9] !=0) {$rec[9] = style_module::skkkff($rec[9]) } else { $rec[9]=''};
   if ($now[2] !=0) {$now[2] = style_module::skkkff($now[2]) } else { $now[2]=''};
   if ($now[1] || $rec[3] || $rec[4] || $rec[5] || $rec[6] || $rec[7] || $rec[8] || $rec[9]|| $akhir || $now[2] || $oh) {
     $str.= qq~ {"kode" : "$rec[0]", "nama" : "$rec[1]","satuan" : "$rec[2]","awal" : "$now[1]","audit" : "$rec[3]","beli" : "$rec[4]","masuk" : "$rec[5]",
     "kirim" : "$rec[6]","sales" : "$rec[7]","waste" : "$rec[8]","nonsales" : "$rec[9]","akhir" : "$akhir","opm":"$now[2]","oh":"$oh"},~ ;
   }  
 }
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str .=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
}