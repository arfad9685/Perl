#!/usr/bin/perl
require "/opt/sarirasa/cgi-bin/date.pl";
require "/opt/sarirasa/cgi-bin/cgi-lib.pl";
use Date::Calc qw(Delta_Days);
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
 
$qrdt1=$dbh->prepare("select max(opn_date) from t_opn_audit where opn_date<='$in{tgl1}' and store_id='$in{cab}'");
  $qrdt1->execute();
  @rsdt=$qrdt1->fetchrow();
  $tgl1=$rsdt[0];
  
$qtoleransi=$dbh->prepare("select a.toleransi from m_toleransi a,m_cab c
							where a.skala= c.store_skala
							and a.brand=c.store_brand
							and c.store_id='$in{cab}'");
$qtoleransi->execute();
@rect=$qtoleransi->fetchrow();
$rtoleransi=$rect[0]; 
 
  
 if ($in{jenis} eq 'Dinnerware') {
  $query=" and p.brg_group='15'"
  
 } else {
  $query=" and p.brg_group <> '15'"  
 } 

  
 #$tbl_brg=$dbh->prepare("select brg_id, brg_id, brg_id, brg_id, brg_id, brg_id from t_opn_audit where store_id='C01' and opn_date='2/9/2021'"); 
  
 $tbl_brg=$dbh->prepare("select p.brg_tabid, p.brg_nama, opn_akhir.satuan, opn_akhir.brg_id, opn_akhir.opn_date,
                        get_tglawal_aud(opn_akhir.store_id, opn_akhir.brg_id,'$tgl1'),
  opn_awal.opname awal,
  opn_akhir.opname akhir,
  opn_akhir.oh,
  '' wasteWIP,'' wasteFG,'' returWIP,'' returFG,'' wastenon,'' autowaste,
  opn_akhir.opn_adj, opn_akhir.recid,
  last_price/get_konv(opn_akhir.brg_id,p.brg_satpo,p.brg_satstore) hrg,p.brg_jenis,
  avr_price/get_konv(opn_akhir.brg_id,p.brg_satpo,p.brg_satstore) hrg2,
  opn_akhir.fc_adj,p.toleransi_dev
  from t_opn_audit opn_akhir
  left outer join (
   select o2.store_id, o2.brg_id,o2.opname from t_opn_audit o2
   where o2.opn_date=get_tglawal_aud(o2.store_id, o2.brg_id,'$tgl1')
  ) as opn_awal on opn_awal.brg_id=opn_akhir.brg_id and opn_awal.store_id=opn_akhir.store_id
  left outer join m_produk_all p on p.brg_id=opn_akhir.brg_id
  where opn_akhir.store_id='$in{cab}' and opn_akhir.opn_date='$tgl1' $query
  order by 1,2 asc");

$tbl_brg->execute();
while (@rec=$tbl_brg->fetchrow())
{   
   if ($rec[5])
	   {
   
  $tbl_brg2=$dbh2->prepare("select brg_id,sum(jml_beli) beli, sum(jml_masuk) masuk, sum(jml_kirim) kirim,
   sum(jml_jual) jual, sum(jml_waste) waste, sum(jml_nonsal) nonsal
   from $kartustok where tanggal>='$rec[5]'
   and tanggal<'$tgl1' and brg_id='$rec[3]' group by brg_id");
 $tbl_brg2->execute();
 @rsdet=$tbl_brg2->fetchrow();
		
 $autofc=$dbh2->prepare("select  sum(b.QTY_KOREKSI) , sum(b.qty_waste)
from $kartustok a, t_waste b, m_waste_reason c
where a.tanggal>='$rec[5]' and a.tanggal<'$tgl1'
and a.jenis='WASTE'
and b.isauto='Y'
and a.reff_id=b.recid
and c.recid=b.alasan_id
and a.brg_id='$rsdet[0]'");
    $autofc->execute();
    @autostorefc=$autofc->fetchrow();
	$autostore=$autostorefc[0];
	
$wastekry=$dbh2->prepare("select sum(a.jml_waste*c.penalti), sum(a.jml_waste)
from $kartustok a, t_waste b, m_waste_reason c
where a.tanggal>='$rec[5]' and a.tanggal<'$tgl1'
and a.jenis='WASTE'
and b.alasan_id='9'
and a.reff_id=b.recid
and c.recid=b.alasan_id
and a.brg_id='$rsdet[0]'");
    $wastekry->execute();
    @wstkry=$wastekry->fetchrow();
	$wstkrystore=$wstkry[0];

	
$wastegumpil=$dbh2->prepare("select sum(a.jml_waste*c.penalti), sum(a.jml_waste)
from $kartustok a, t_waste b, m_waste_reason c
where a.tanggal>='$rec[5]' and a.tanggal<'$tgl1'
and a.jenis='WASTE'
and b.alasan_id='13'
and a.reff_id=b.recid
and c.recid=b.alasan_id
and a.brg_id='$rsdet[0]' ");
    $wastegumpil->execute();
    @wstgumpil=$wastegumpil->fetchrow();
	$wstgumpilstore=$wstgumpil[0];
	
$wastewipxfc=$dbh2->prepare("select sum(a.jml_waste*c.penalti), sum(a.jml_waste)
from $kartustok a, t_waste b, m_waste_reason c
where a.tanggal>='$rec[5]' and a.tanggal<'$tgl1'
and a.jenis='WASTE'
and b.alasan_id not in ('9','13','27')
and a.brg_id='$rsdet[0]'
and a.reff_id=b.recid and a.brg_id=b.brg_id
and c.recid=b.alasan_id
and a.menu_id is null 
and b.isauto='N'");
    $wastewipxfc->execute();
    @wstwipxfc=$wastewipxfc->fetchrow();
	$wstwipstore=$wstwipxfc[0];
	
$wastefgxfc=$dbh2->prepare("select sum(a.jml_waste*c.penalti), sum(a.jml_waste)
from $kartustok a, t_waste b, m_waste_reason c
where a.tanggal>='$rec[5]' and a.tanggal<'$tgl1'
and a.jenis='WASTE'
and b.alasan_id not in ('9','13','27')
and a.brg_id='$rsdet[0]'
and a.reff_id=b.recid and a.brg_id<>b.brg_id
and c.recid=b.alasan_id
and a.menu_id is not null");
    $wastefgxfc->execute();
    @wstfgxfc=$wastefgxfc->fetchrow();
	$wstfgstore=$wstfgxfc[0];
		
	
	#$saldohit=opn_awal.opname + mutasi.masuk + mutasi.beli- mutasi.kirim - mutasi.jual - mutasi.waste - mutasi.nonsal saldohit,
	$saldohit=($rec[6]+$rsdet[2]+$rsdet[1])-$rsdet[3]-$rsdet[4]-$rsdet[5]-$rsdet[6];
	$devakhir=$rec[7] - $rec[8];
	$devasli=$devakhir + $rec[15];
	
 if ($rec[18] eq 'RM') {} else { $rec[17]=$rec[19]; }
 
	$devxfc=0;
	if($devasli<0) {	
	$devxfc=$devasli*$rec[17]*-1;
                }
		
	$total=$devxfc+$autostore+$wstkrystore+$wstgumpilstore+$wstwipstore+$wstfgstore - $rec[20] ; 
	
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
	
	$wstkrystore=$wstkrystore*$rec[17];
	
	$wastekrytotal=$wastekrytotal+$wstkrystore;
	$totalwastekry=$wastekrytotal;
	
	$wstgumpilstore=$wstgumpilstore*$rec[17];
	
	$wastegumpiltotal=$wastegumpiltotal+$wstgumpilstore;
	$totalwastegumpil=$wastegumpiltotal;
	
	$wstwipstore=$wstwipstore*$rec[17];
	
	$wastewiptotal=$wastewiptotal+$wstwipstore;
	$totalwastewip=$wastewiptotal;
	
	$wstfgstore=$wstfgstore*$rec[17];
	
	$wastefgtotal=$wastefgtotal+$wstfgstore;
	$totalwastefg=$wastefgtotal;
	
	#$returwiptotal=$returwiptotal+$returwip;
	#$totalreturwip=$returwiptotal;	
	
	$autostore=$autostore*$rec[17];
	
	$autowsttotal=$autowsttotal+$autostorefc;
	$totalauto=$autowsttotal;
	
	$totalall=$totalall+$total;
	$totaljml=$totalall;
	
	$totaladj=$totaladj+$rec[20];
	$ttladj=$totaladj;
	
	$toleransidev=$rec[21]*$rec[17]/100;
	$toledev=$toleransidev;
	
	$totaltoldv=$totaltoldv+$toleransidev;
	$ttltoldev=$totaltoldv;
	
	if ($toledev > $total){
		$total=0;
	} elsif ($toledev < $total) {
		$total=$total - $toledev;
	}
		
	
	
	
	
	
@dtawal= split(/\//,$rec[5]);
@dtakhir= split(/\//,$tgl1);
$days = Delta_Days($dtawal[2], $dtawal[0],$dtawal[1],$dtakhir[2], $dtakhir[0],$dtakhir[1]);
#print $days+1;
$days=$days+1;

$toleransi=$days*$rtoleransi/30;
$toldays=$toleransi;
$totalfinal=$totaljml - $toleransi;
$ttlfinal=$totalfinal;
	
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
	if ($rec[20] !=0) {$rec[20] = style_module::skkkff($rec[20]) } else { $rec[20]='0'};
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
	if ($wstgumpilstore !=0) {$wstgumpilstore = style_module::skkkff($wstgumpilstore) } else {$wstgumpilstore='0'};
	if ($totalwastegumpil !=0) {$totalwastegumpil = style_module::skkkff($totalwastegumpil) } else {$totalwastegumpil='0'};
	if ($wstkrystore !=0) {$wstkrystore = style_module::skkkff($wstkrystore) } else {$wstkrystore='0'};
	if ($totalwastekry !=0) {$totalwastekry = style_module::skkkff($totalwastekry) } else {$totalwastekry='0'};
	if ($wstwipstore !=0) {$wstwipstore = style_module::skkkff($wstwipstore) } else {$wstwipstore='0'};
	if ($totalwastewip !=0) {$totalwastewip = style_module::skkkff($totalwastewip) } else {$totalwastewip='0'};
	if ($wstfgstore !=0) {$wstfgstore = style_module::skkkff($wstfgstore) } else {$wstfgstore='0'};
	if ($totalwastefg !=0) {$totalwastefg = style_module::skkkff($totalwastefg) } else {$totalwastefg='0'};
	if ($autostore !=0) {$autostore = style_module::skkkff($autostore) } else {$autostore='0'};
	#if ($totalfinal !=0) {$totalfinal = style_module::skkkff($totalfinal) } else {$totalfinal='0'};
	if ($totaljml !=0) {$totaljml = style_module::skkkff($totaljml) } else {$totaljml='0'};
	if ($toldays !=0) {$toldays = style_module::skkkff($toldays) } else {$toldays='0'};
	if ($toldays !=0) {$toldays = style_module::skkkff($toldays) } else {$toldays='0'};
	if ($ttlfinal !=0) {$ttlfinal = style_module::skkkff($ttlfinal) } else {$ttlfinal='0'};
	if ($toledev !=0) {$toledev = style_module::skkkff($toledev) } else {$toledev='0'};
	if ($ttltoldev !=0) {$ttltoldev = style_module::skkkff($ttltoldev) } else {$ttltoldev='0'};
	if ($rec[19] !=0) {$rec[19] = style_module::skkkff($rec[19]) } else { $rec[19]='0'};
	
	
	if ($rec[0]==1) {
   $kat='FOOD'; 
 } elsif ($rec[0]==2) {
   $kat='NON FOOD';
 } else {
   $kat='ISP';
 }
 


  
   $str.= qq~ {"brg_id" : "$rec[3]", "brg_nama" : "$rec[1]", "satuan" : "$rec[2]","opn_date" : "$rec[4]",
   "tglopnawal" : "$rec[5]","FC" : "$rec[17]","devasli" : "$devasli","devxfc" : "$devxfc",
   "kodetotal" : "$kodetotal","autowaste" : "$autostore","total" : "$total","totaljml" : "$totaljml","adjust" : "$rec[20]","totaladjust" : "$ttladj",
   "wastegumpil" : "$wstgumpilstore","wastekry" : "$wstkrystore","wastewipxfc" : "$wstwipstore","wastefgxfc" : "$wstfgstore","namatotal" : "$namatotal","sattotal" : "$sattotal","tgltotal" : "$tgltotal","tglopn1" : "$tglopn1","totalfc" : "$totalfc","totaldev" : "$totaldev","totaldevxfc" : "$totaldevxfc","totalauto" : "$totalauto","recid" : "$rec[16]","totalall" : "$totalall","totalgumpil" : "$totalwastegumpil","totalkry" : "$totalwastekry",
   "totalwip" : "$totalwastewip","totalfg" : "$totalwastefg","jns" : "$rec[18]",
   "kategori" : "$kat", "jenis" : "$rec[18]","days" : "$days","toleransi" : "$toldays","totalfinal" : "$ttlfinal","totfinal" : "$totalfinal","toleransidev" : "$toledev","totaltoleransidev" : "$ttltoldev"},~ ;
   }
   
}




 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str.=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
 
}