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

$kartustok = 't_kartustok_'.$in{cab} ;

#$str= qq~ [\n~; 
# $tbl_brg=$dbh->prepare("select k.store_id,c.store_nama from $kartustok k
#  left outer join m_cab c on c.store_id=k.store_id
#  WHERE c.isaktif='Y' 
#  ORDER BY c.store_id");
# 
#$tbl_brg->execute();
#while (@rec=$tbl_brg->fetchrow())
#{
#   $str.= qq~ { "kode" : "$rec[0]", "nama" : "$rec[1]"},~ ;
#}
# $n = length($str) - 1;
# $str = substr $str,0,$n;
# $str .=  qq~\n~; 
# $str .= qq~]~; 
# print $str;
# 
#}

$cond="";
#if ($in{cab}) {
#   $cond=" AND $kartustok=$in{cab} ";
# }
 if ($in{tgl1}) {
   $cond=$cond." AND k.tanggal =$in{tgl1} ";
 }
 
 if ($in{tgl2}) {
   $cond=$cond." AND k.tanggal <=$in{tgl2} ";
 }
 
 #left outer join t_waste w on w.brg_id=a.brg_id and w.store_id=a.store_id and w.tgl_waste
$str= qq~ [\n~; 
 $tbl_brg=$dbh->prepare("select pg.group_nama,a.brg_id, p.brg_nama, a.satuan,a.opn_date,a.opname as awal,
						sum(k.jml_masuk) masuk,sum(k.jml_beli) beli,sum(k.jml_kirim) kirim,sum(k.jml_waste) waste,sum(k.jml_waste) wasteWIP,
						sum(k.jml_waste) wasteFG, '' as returWIP,'' as returFG,'' as wastenon,w.qty_waste as autowaste,sum(k.jml_nonsal) as nonsal,
						sum(k.jml_jual) as jual,
						(a.opname)+k.jml_masuk+k.jml_beli-k.jml_kirim - (k.jml_waste)- (k.jml_nonsal) - k.jml_jual as saldoHit,
						a.oh as saldokom,a.opname as hasilso, a.opname - a.oh as devaskhir,a.opn_adj adjus,(a.opname - a.oh) as devasli
from t_opn_audit a
inner join m_produk_all p on p.brg_id=a.brg_id
inner join m_produk_grp pg on pg.group_id=p.brg_group
inner join $kartustok k on  k.brg_id=a.brg_id and k.store_id=a.store_id and a.opn_date=k.tanggal
left join t_waste w on w.brg_id=k.brg_id and w.recid=k.recid
where 
a.isvalid='Y'  and k.jenis='MASUK' 
$cond
group by a.brg_id, p.brg_nama ,a.satuan,a.opn_date,pg.group_nama,k.jml_masuk,k.jml_beli,k.jml_kirim,a.opname,a.oh,a.koreksi,
k.jml_waste,k.jml_nonsal, k.jml_jual ,w.qty_waste,k.tanggal,a.opn_adj
order by k.tanggal desc");
 
$tbl_brg->execute();

#@cols = ("group_nama", "brg_id", "brg_nama","satuan", "opn_date","awal","jml_masuk","jml_beli","jml_kirim","waste","","","","","","","","","","","","","");
 
while (@rec=$tbl_brg->fetchrow())
{
   #$str.= qq( {);
   #for($i=0; $i<scalar(@cols); $i++){
   # $str1.= qq("c$i" : "$rec[$i]");
   #  
   # if($i<scalar(@cols)-1){
   #  $str.= qq(,);
   # }
   #}
   #$str.= qq( },) ;
   
   
  $rec[0] =~ s/ //g;
   $rec[1] =~ s/'/ /g;
   $rec[1] =~ s/"/ /g;
   $now[1]=0;$now[2]=0;
   if (!$tbl_now) {
    $tbl_now=$dbh1->prepare("select p.brg_id, coalesce(get_saldo(?,?,?-1),0),coalesce(opn.koreksi,0) from m_produk_all p
    # left outer join 
     #(select brg_id,sum(koreksi) koreksi from t_opn_str
    # where store_id=? and opn_date-1<=? and isvalid='Y' group by brg_id) opn on opn.brg_id=p.brg_id
    # where p.brg_id=?");
   }
   $tbl_now->execute($rec[0],$in{cab},$in{tgl1},$in{cab},$in{tgl2},$rec[0]);
   @now=$tbl_now->fetchrow();
  
  
   if ($rec[5] !=0) {$rec[5] = style_module::skkkff($rec[5]) } else { $rec[5]=''};
   if ($rec[6] !=0) {$rec[6] = style_module::skkkff($rec[6]) } else { $rec[6]=''};
   if ($rec[7] !=0) {$rec[7] = style_module::skkkff($rec[7]) } else { $rec[7]=''};
   if ($rec[8] !=0) {$rec[8] = style_module::skkkff($rec[8]) } else { $rec[8]=''};
   if ($rec[9] !=0) {$rec[9] = style_module::skkkff($rec[9]) } else { $rec[9]=''};
   if ($rec[10] !=0) {$rec[10] = style_module::skkkff($rec[10]) } else { $rec[10]=''};
   if ($rec[11] !=0) {$rec[11] = style_module::skkkff($rec[11]) } else { $rec[11]=''};
   if ($rec[12] !=0) {$rec[12] = style_module::skkkff($rec[12]) } else { $rec[12]=''};
   if ($rec[13] !=0) {$rec[13] = style_module::skkkff($rec[13]) } else { $rec[13]=''};
   if ($rec[14] !=0) {$rec[14] = style_module::skkkff($rec[14]) } else { $rec[14]=''};
   if ($rec[15] !=0) {$rec[15] = style_module::skkkff($rec[15]) } else { $rec[15]=''};
   if ($rec[16] !=0) {$rec[16] = style_module::skkkff($rec[16]) } else { $rec[16]=''};
   if ($rec[17] !=0) {$rec[17] = style_module::skkkff($rec[17]) } else { $rec[17]=''};
   if ($rec[18] !=0) {$rec[18] = style_module::skkkff($rec[18]) } else { $rec[18]=''};
   if ($rec[19] !=0) {$rec[19] = style_module::skkkff($rec[19]) } else { $rec[19]=''};
   if ($rec[20] !=0) {$rec[20] = style_module::skkkff($rec[20]) } else { $rec[20]=''};
   if ($rec[21] !=0) {$rec[21] = style_module::skkkff($rec[21]) } else { $rec[21]=''};
   if ($rec[22] !=0) {$rec[22] = style_module::skkkff($rec[22]) } else { $rec[22]=''};
   if ($rec[23] !=0) {$rec[23] = style_module::skkkff($rec[23]) } else { $rec[23]=''};
   
   $str.= qq~ { "group_nama" : "$rec[0]", "brg_id" : "$rec[1]", "brg_nama" : "$rec[2]", "satuan" : "$rec[3]","opn_date" : "$rec[4]","awal" : "$rec[5]","jml_masuk" : "$rec[6]","jml_beli" : "$rec[7]","jml_kirim" : "$rec[8]","waste" : "$rec[9]","wasteWIP" : "$rec[10]","wasteFG" : "$rec[11]","returWIP" : "$rec[12]","returFG" : "$rec[13]","wastenon" : "$rec[14]","autowaste" : "$rec[15]","nonsal" : "$rec[16]","jual" : "$rec[17]","saldoHit" : "$rec[18]","saldokom" : "$rec[19]","hasilso" : "$rec[20]","devaskhir" : "$rec[21]","adjus" : "$rec[22]","devasli" : "$rec[23]"},~ ;

}
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str1.=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
 
}