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
  opn_akhir.oh
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
   #if ($rec[5] !=0) {$rec[5] = style_module::skkkff($rec[5]) } else { $rec[5]=''};
    $tbl_brg2=$dbh2->prepare("select brg_id,sum(jml_beli) beli, sum(jml_masuk) masuk, sum(jml_kirim) kirim,
 sum(jml_jual) jual, sum(jml_waste) waste, sum(jml_nonsal) nonsal
 from $kartustok where tanggal>='$rec[5]'
 and tanggal<'$tgl1' and brg_id='$rec[3]' group by brg_id");
    $tbl_brg2->execute();
    @rsdet=$tbl_brg2->fetchrow();
    
   $str.= qq~ {"group_nama" : "$rec[0]", "brg_id" : "$rec[3]", "brg_nama" : "$rec[1]", "satuan" : "$rec[2]","opn_date" : "$rec[4]",
   "beli" : "$rsdet[2]"},~ ;

}
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str.=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
 
}