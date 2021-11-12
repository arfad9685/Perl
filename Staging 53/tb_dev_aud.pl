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

 $str= qq~ [\n~; 
 $tbl_brg=$dbh->prepare("select c.group_nama,a.brg_id, b.brg_nama, a.satuan,a.opn_date,sum(a.opname) as awal,sum(a.oh) as masuk,sum(a.koreksi) as koreksi --,b.deviasi_fg
from t_opn_audit a, m_produk b, m_produk_grp c
where opn_date='2/9/2021' and store_id='C01' 
and a.brg_id=b.brg_id and b.brg_group=c.group_id
--and c.group_id in ('15','21')
--and a.brg_id='6224'
   group by a.brg_id, b.brg_nama, b.brg_group,a.satuan,c.group_nama,a.opn_date order by b.brg_nama");
$tbl_brg->execute();

@cols = ("group_nama", "brg_id", "brg_nama", "satuan", "opn_date", "saldo awal", "masuk");

while (@rec=$tbl_brg->fetchrow())
{
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