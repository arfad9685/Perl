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
&con_pos0;
 $str= qq~ [\n~; 
 $tbl_brg=$dbh->prepare("select trim(store_id), store_nama, b.brand_nama,store_bagian,get_nama_usr(am.area_nik), c.isaktif from m_cab c
   inner join m_cab_brand b on c.store_brand=b.brand_id
   inner join m_cab_areamgr am on am.area_id=c.store_mgrarea   
   where c.isaktif like '$in{aktif}' and store_bagian='STORE' order by store_bagian,b.brand_nama, store_id");
 $tbl_brg=$dbp->prepare("select a.kodestore, b.namastore,a.kodestore, b.namastore,a.kodestore, b.namastore from t_order0 a left outer join m_info b on (a.kodestore=b.kodestore)
  where a.tanggal='3/1/2021' and nojurnal is null group by a.kodestore, b.namastore order by a.kodestore");
$tbl_brg->execute();
while (@rec=$tbl_brg->fetchrow())
{
   $str.= qq~ { "kode" : "$rec[0]", "nama" : "$rec[1]", "brand" : "$rec[2]", "bagian" : "$rec[3]","areamgr" : "$rec[4]","isaktif" : "$rec[5]"},~ ;
}
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str .=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
}