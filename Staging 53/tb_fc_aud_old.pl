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
&con_inv2;
&con_ass0;

$kartustok = 't_kartustok_'.$in{cab} ;
  
 $str= qq~ [\n~;
 
 $qrdt1=$dbh->prepare("select opn_date from t_opn_audit where opn_date<='$in{tgl1}' and store_id='$in{cab}'
                       group by opn_date
                       order by opn_date desc");
  $qrdt1->execute();
  @rsdt=$qrdt1->fetchrow();
  $tgl1=$rsdt[0];
  
 #$tbl_brg=$dbh->prepare("select brg_id, brg_id, brg_id, brg_id, brg_id, brg_id from t_opn_audit where store_id='C01' and opn_date='2/9/2021'"); 
  
 $tbl_brg=$dbh->prepare("select pg.group_nama, p.brg_nama, opn_akhir.satuan, opn_akhir.brg_id, opn_akhir.opn_date,
                        get_tglawal_aud(opn_akhir.store_id, opn_akhir.brg_id,'$tgl1'),
  opn_awal.opname awal,
  opn_akhir.opname akhir,
  opn_akhir.oh,
  '' wasteWIP,'' wasteFG,'' returWIP,'' returFG,'' wastenon,'' autowaste,
  opn_akhir.opn_adj, opn_akhir.recid,
  last_price/get_konv(opn_akhir.brg_id,p.brg_satpo,p.brg_satstore) hrg
 from t_opn_audit opn_akhir
left outer join (
  select o2.store_id, o2.brg_id,o2.opname from t_opn_audit o2
  where o2.opn_date=get_tglawal_aud(o2.store_id, o2.brg_id,'$tgl1')
) as opn_awal on opn_awal.brg_id=opn_akhir.brg_id and opn_awal.store_id=opn_akhir.store_id
left outer join m_produk_all p on p.brg_id=opn_akhir.brg_id
left outer join m_produk_grp pg on pg.group_id=p.brg_group
where opn_akhir.store_id='$in{cab}' and opn_akhir.opn_date='$tgl1'");

$tbl_brg->execute();
while (@rec=$tbl_brg->fetchrow())
{   
   
    $tbl_brg2=$dbh2->prepare("select brg_id,sum(jml_beli) beli, sum(jml_masuk) masuk, sum(jml_kirim) kirim,
 sum(jml_jual) jual, sum(jml_waste) waste, sum(jml_nonsal) nonsal
 from $kartustok where tanggal>='$rec[5]'
 and tanggal<'$tgl1' and brg_id='$rec[3]' group by brg_id");
    $tbl_brg2->execute();
    @rsdet=$tbl_brg2->fetchrow();
	
	
$wastefc=$dbh2->prepare("select sum(ks.jml_waste) waste from $kartustok ks
  inner join t_waste w on w.brg_id=ks.brg_id and w.store_id=ks.store_id  and w.tgl_waste=ks.tanggal
   where ks.tanggal>='$rec[5]'
 and ks.tanggal<'$tgl1' and ks.brg_id='$rsdet[0]' 
 and ks.jenis='WASTE'
 and w.isretur='N' ");
    $wastefc->execute();
    @wastewipxfc=$wastefc->fetchrow();
	
	$wastewip=$wastewipxfc[0]*$rec[17];
	
$returfc=$dbh2->prepare("select sum(ks.jml_waste) waste from $kartustok ks
  inner join t_waste w on w.brg_id=ks.brg_id and w.store_id=ks.store_id  and w.tgl_waste=ks.tanggal
   where ks.tanggal>='$rec[5]'
 and ks.tanggal<'$tgl1' and ks.brg_id='$rsdet[0]' 
 and ks.jenis='WASTE'
 and w.isretur='Y' ");
    $returfc->execute();
    @returwipxfc=$returfc->fetchrow();

	$returwip=$returwipxfc[0]*$rec[17];
	
	
$autofc=$dbh2->prepare("select w.qty_koreksi from t_waste w where w.alasan_id='27'
						 and w.brg_id='$rsdet[0]'
						 and w.qty_koreksi>0");
    $autofc->execute();
    @autostorefc=$autofc->fetchrow();
	$autostorefc=$autostorefc[0];
	
	
	#$saldohit=opn_awal.opname + mutasi.masuk + mutasi.beli- mutasi.kirim - mutasi.jual - mutasi.waste - mutasi.nonsal saldohit,
	$saldohit=($rec[6]+$rsdet[2]+$rsdet[1])-$rsdet[3]-$rsdet[4]-$rsdet[5]-$rsdet[6];
	$devakhir=$rec[7] - $rec[8];
	$devasli=$devakhir + $rec[15];
	
	$devxfc=0;
	if($devasli<0) {	
	$devxfc=$devasli*$rec[17]*-1;
                }
		
	$total=$devxfc+$wastewip+$wastefgxfc+$returwip+$returfgxfc - $rec[15]+$rsdet[5] ; 
	$kodetotal='';
	$namatotal='';
	$sattotal='';
	$tgltotal=$rec[4];
	$tglopn1=$rec[5];
	
	$fctotal=$fctotal+$rec[17];
	$totalfc=$fctotal;
	
	$devtotal=$devtotal+$devasli;
	$totaldev=$devtotal;
	
	$devxfctotal=$devxfctotal+$devxfc;
	$totaldevxfc=$devxfctotal;
	
	$wastewiptotal=$wastewiptotal+$wastewip;
	$totalwastewip=$wastewiptotal;
	
	$returwiptotal=$returwiptotal+$returwip;
	$totalreturwip=$returwiptotal;	
	
	$autowsttotal=$autowsttotal+$autostorefc;
	$totalauto=$autowsttotal;
	
	$totalall=$totalall+$total;
	$totaljml=$totalall;
	
	
	if ($rec[6] !=0) {$rec[6] = style_module::skkkff($rec[6]) } else { $rec[6]='0'};
	if ($rec[7] !=0) {$rec[7] = style_module::skkkff($rec[7]) } else { $rec[7]='0'};
	if ($rec[8] !=0) {$rec[8] = style_module::skkkff($rec[8]) } else { $rec[8]='0'};
	if ($rec[9] !=0) {$rec[9] = style_module::skkkff($rec[9]) } else { $rec[9]='0'};
	if ($rec[10] !=0) {$rec[10] = style_module::skkkff($rec[10]) } else { $rec[10]='0'};
	if ($rec[11] !=0) {$rec[11] = style_module::skkkff($rec[11]) } else { $rec[11]='0'};
	if ($wastewip !=0) {$wastewip = style_module::skkkff($wastewip) } else { $wastewip='0'};
	if ($returwip !=0) {$returwip = style_module::skkkff($returwip) } else { $returwip='0'};
	if ($rec[12] !=0) {$rec[12] = style_module::skkkff($rec[12]) } else { $rec[12]='0'};
	if ($rec[13] !=0) {$rec[13] = style_module::skkkff($rec[13]) } else { $rec[13]='0'};
	if ($rec[14] !=0) {$rec[14] = style_module::skkkff($rec[14]) } else { $rec[14]='0'};
	if ($rec[15] !=0) {$rec[15] = style_module::skkkff($rec[15]) } else { $rec[15]='0'};
	#if ($rec[15] !=0) {$rec[15] = style_module::skkkff($rec[15]) } else { $rec[15]=''};
	if ($rec[17] !=0) {$rec[17] = style_module::skkkff($rec[17]) } else { $rec[17]='0'};
	if ($rsdet[1] !=0) {$rsdet[1] = style_module::skkkff($rsdet[1]) } else {$rsdet[1]='0'};
	if ($rsdet[2] !=0) {$rsdet[2] = style_module::skkkff($rsdet[2]) } else {$rsdet[2]='0'};
	if ($rsdet[3] !=0) {$rsdet[3] = style_module::skkkff($rsdet[3]) } else {$rsdet[3]='0'};
	if ($rsdet[4] !=0) {$rsdet[4] = style_module::skkkff($rsdet[4]) } else {$rsdet[4]='0'};
	if ($rsdet[5] !=0) {$rsdet[5] = style_module::skkkff($rsdet[5]) } else {$rsdet[5]='0'};
	if ($rsdet[6] !=0) {$rsdet[6] = style_module::skkkff($rsdet[6]) } else {$rsdet[6]='0'};
	if ($saldohit !=0) {$saldohit = style_module::skkkff($saldohit) } else {$saldohit='0'};
	if ($devakhir !=0) {$devakhir = style_module::skkkff($devakhir) } else {$devakhir='0'};
	if ($devasli !=0) {$devasli = style_module::skkkff($devasli) } else {$devasli='0'};
	if ($devxfc !=0) {$devxfc = style_module::skkkff($devxfc) } else {$devxfc='0'};
	if ($totalfc !=0) {$totalfc = style_module::skkkff($totalfc) } else {$totalfc='0'};
	if ($totaldev !=0) {$totaldev = style_module::skkkff($totaldev) } else {$totaldev='0'};
	if ($totaldevxfc !=0) {$totaldevxfc = style_module::skkkff($totaldevxfc) } else {$totaldevxfc='0'};
	if ($totalauto !=0) {$totalauto = style_module::skkkff($totalauto) } else {$totalauto='0'};
	if ($totalwastewip !=0) {$totalwastewip = style_module::skkkff($totalwastewip) } else {$totalwastewip='0'};
	if ($totalreturwip !=0) {$totalreturwip = style_module::skkkff($totalreturwip) } else {$totalreturwip='0'};
	if ($autostorefc !=0) {$autostorefc = style_module::skkkff($autostorefc) } else {$autostorefc='0'};
	if ($total !=0) {$total = style_module::skkkff($total) } else {$total='0'};
	if ($totaljml !=0) {$totaljml = style_module::skkkff($totaljml) } else {$totaljml='0'};
	
    
   $str.= qq~ {"group_nama" : "$rec[0]", "brg_id" : "$rec[3]", "brg_nama" : "$rec[1]", "satuan" : "$rec[2]","opn_date" : "$rec[4]",
   "tglopnawal" : "$rec[5]","FC" : "$rec[17]","devasli" : "$devasli","devxfc" : "$devxfc","wastekry" : "$rec[9]",
   "wastegumpil" : "$rec[10]","wastewipxfc" : "$wastewip","wastefgxfc" : "$rec[11]","returwipxfc" : "$returwip","returfgxfc" : "$rec[12]",
   "autowaste" : "$autostorefc","total" : "$total","totaljml" : "$totaljml","cab" : "$in{cab}","kodetotal" : "$kodetotal",
   "namatotal" : "$namatotal","sattotal" : "$sattotal","tgltotal" : "$tgltotal","tglopn1" : "$tglopn1","totalfc" : "$totalfc",
   "totaldev" : "$totaldev","totaldevxfc" : "$totaldevxfc","totalauto" : "$totalauto","totalwastewip" : "$totalwastewip","totalreturwip" : "$totalreturwip","recid" : "$rec[16]","totalall" : "$devxfctotal"},~ ;

}
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str.=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
 
}