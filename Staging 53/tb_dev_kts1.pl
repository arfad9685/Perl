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

$kartustok = 't_kartustok_'.$in{cab} ;

$str= qq~ [\n~; 
 $tbl_brg=$dbh->prepare("select k.store_id,c.store_nama from $kartustok k
  left outer join m_cab c on c.store_id=k.store_id
  WHERE c.isaktif='Y' 
  ORDER BY c.store_id");
 
$tbl_brg->execute();
while (@rec=$tbl_brg->fetchrow())
{
   $str.= qq~ { "kode" : "$rec[0]", "nama" : "$rec[1]"},~ ;
}
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str .=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
}

$cond="";
if ($in{cab}) {
   $cond="AND $kartustok=$in{cab}";
 }
 if ($in{tgl1}) {
   $cond="AND a.opn_date=$in{tgl1}";
 }
 
 
$str= qq~ [\n~; 
 $tbl_brg=$dbh->prepare("select pg.group_nama,a.brg_id, p.brg_nama, a.satuan,a.opn_date,sum(a.opname) as awal,
						k.jml_masuk,k.jml_beli,k.jml_kirim,sum(k.jml_waste) as waste
from t_opn_audit a
left outer join m_produk p on p.brg_id=a.brg_id
left outer join m_produk_grp pg on pg.group_id=p.brg_group
left outer join $kartustok k on  k.brg_id=a.brg_id and k.store_id=a.store_id and a.opn_date=k.tanggal
--left outer join t_waste w on w.brg_id=a.brg_id and w.store_id=a.store_id and w.tgl_waste
where 
a.isvalid='Y'  and k.jenis='MASUK' $cond
group by a.brg_id, p.brg_nama ,a.satuan,a.opn_date,pg.group_nama,k.jml_masuk,k.jml_beli,k.jml_kirim
order by p.brg_nama");
 
$tbl_brg1->execute();

@cols = ("group_nama", "brg_id", "brg_nama","satuan", "opn_date","awal","jml_masuk","jml_beli","jml_kirim","waste","","","","","","","","","","","","","");
 
while (@rec=$tbl_brg->fetchrow())
{
   $str.= qq( {);
   for($i=0; $i<scalar(@cols); $i++){
    $str1.= qq("c$i" : "$rec[$i]");
     
    if($i<scalar(@cols)-1){
     $str.= qq(,);
    }
   }
   $str.= qq( },) ;     
}
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str1.=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
 
}