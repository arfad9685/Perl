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

 $str= qq~ [\n~;
 if ($in{jenis} ne 'FG') {
   $tbl_brg=$dbh->prepare("SELECT brg_id, brg_nama, brg_satuan, g.group_nama, brg_holdtime, brg_satkirim, brg_satstore,
                         get_konv(brg_id,brg_satuan,brg_satkirim) konv1, get_konv(brg_id,brg_satuan,brg_satstore) konv2 from m_produk p
                        inner join m_produk_grp g on g.group_id=p.brg_group
    where isaktif='Y' and isstok='Y' and brg_brand containing '$in{resto}' and brg_jenis='$in{jenis}'
   and upper(brg_nama) like '%$in{nama}%' order by brg_nama");
 } else {   
   $tbl_brg=$dbh->prepare("SELECT menu_id, menu_name, menu_dapur, menu_kategori, menu_harga, tgl_berlaku, tgl_expired
  from m_menu_pos p
  where isaktif='Y' and menu_brand containing '$in{resto}'
  and upper(menu_name) like '%$in{nama}%' order by menu_name");   
 }  
$tbl_brg->execute();
while (@rec=$tbl_brg->fetchrow())
{
   $rec[1] =~ s/\'/ /g;
   $rec[1] =~ s/\"/ /g;
   $rec[4] = style_module::skkkdd($rec[4]);
   if ($in{jenis} ne 'FG') {
     $rec[7] = style_module::skkkdd($rec[7]);
     $rec[8] = style_module::skkkdd($rec[8]);
     $str.= qq~ { "kode" : "$rec[0]","nama" : "$rec[1]","satuan" : "$rec[2]","konv1" : "$rec[7]","satkrm" : "$rec[5]","konv2" : "$rec[8]","satstr" : "$rec[6]"},~ ;     
   } else {       
     $str.= qq~ { "kode" : "$rec[0]","nama" : "$rec[1]","satuan" : "$rec[2]","kat" : "$rec[3]","ht" : "$rec[4]","satkrm" : "$rec[5]","satstr" : "$rec[6]"},~ ;
   }  
}
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str .=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
}