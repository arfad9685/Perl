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
 if ($in{aktif} eq 'Y') {
   $aktif='Y';
 } else {
   $aktif='%';  
 }
 $cond="";
 if ($in{sch}) {
   $cond="AND BRG_SCHKIRIM='$in{sch}'";
 }
 if ($in{pch}) {
   $cond="AND BRG_PURCH_ID='$in{pch}'";
 }
 if ($in{kat}) {
   $cond=" AND BRG_GROUP=$in{kat}";
 } 
 if ($in{retur} ne '-') {
   $cond=" AND ISRETUR='$in{retur}'";
 }
 
if (substr($in{div},1,2) eq 'OP') {
   $opronly=" AND ISSTORE='Y'";
} else {
  $opronly="";
}
	
 
 
 $str= qq~ [\n~;
 if ($in{jenis} eq 'ISP') {
   $tbl_brg=$dbh->prepare("select ISAKTIF,trim(p.BRG_ID), BRG_NAMA,BRG_SATUAN,BRG_SATPO,BRG_SATKIRIM,ISSTORE, BRG_SCHKIRIM,
                        ISWASTE||'/'||ISRETUR,
   PACK_NAMA, BRG_BRAND, ISPPUC,'N' ISFRZ, pc.purchaser_nama, isretur from M_PRODUK_ALL p
   inner join m_produk_isp f on f.brg_id=p.brg_id
   left join M_PRODUK_PACKING on BRG_PACKING=PACK_ID
   left join m_produk_puch pc on pc.purchaser_id=p.brg_purch_id
   WHERE BRG_JENIS = '$in{jenis}' AND UPPER(BRG_NAMA) like UPPER('%$in{nama}%')  $opronly
   and p.isaktif like '$aktif' $cond 
   ORDER BY BRG_NAMA");  
 } elsif ($in{jenis} eq 'NF') {
   $tbl_brg=$dbh->prepare("select ISAKTIF,trim(p.BRG_ID), BRG_NAMA,BRG_SATUAN,BRG_SATPO,BRG_SATKIRIM,ISSTORE, BRG_SCHKIRIM,
                        '-' ISWASTE,
   PACK_NAMA, BRG_BRAND, ISPPUC,'N' ISFRZ, pc.purchaser_nama,'-' isretur from M_PRODUK_ALL p
   inner join m_produk_nonfood f on f.brg_id=p.brg_id
   left join M_PRODUK_PACKING on BRG_PACKING=PACK_ID
   left join m_produk_puch pc on pc.purchaser_id=p.brg_purch_id
   WHERE BRG_JENIS = 'RM' AND UPPER(BRG_NAMA) like UPPER('%$in{nama}%')  
   and p.isaktif like '$aktif' 
   ORDER BY BRG_NAMA");    
 } elsif ($in{jenis} eq 'FG') {
  
 } else {  
   $tbl_brg=$dbh->prepare("select ISAKTIF,trim(p.BRG_ID), BRG_NAMA,BRG_SATUAN,BRG_SATPO,BRG_SATKIRIM,ISSTORE, BRG_SCHKIRIM,
                        ISWASTE||'/'||ISRETUR,
   PACK_NAMA, BRG_BRAND, ISPPUC, ISFRZ, pc.purchaser_nama, isretur from M_PRODUK_ALL p
   inner join m_produk_food f on f.brg_id=p.brg_id
   left join M_PRODUK_PACKING on BRG_PACKING=PACK_ID
   left join m_produk_puch pc on pc.purchaser_id=p.brg_purch_id
   WHERE BRG_JENIS = '$in{jenis}' AND UPPER(BRG_NAMA) like UPPER('%$in{nama}%')  $opronly
   and p.isaktif like '$aktif' $cond 
   ORDER BY BRG_NAMA");
 } 
$tbl_brg->execute();

@cols = ("AKTIF","KODE", "NAMA", "SATUAN","SATPO","SATKIRIM","STR", "SCH", "WST", "PACK", "JNSRES", "PPUC", "FZ", "PURCH");

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