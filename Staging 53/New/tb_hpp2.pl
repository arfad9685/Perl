#!/usr/bin/perl
require "/opt/sarirasa/cgi-bin/date.pl";
require "/opt/sarirasa/cgi-bin/cgi-lib.pl";
use CGI;
use DBI;
&ReadParse(*in);


$base_path="/opt/sarirasa/cgi-bin/tmp/$in{ss}";
#if ((-e $base_path) && ($in{ss})) {

print "Content-type: application/json; charset=iso-8859-1\n\n";
require "/opt/sarirasa/core/koneksi_str.pl";
require "/opt/sarirasa/cgi-bin/assets/functions/style_module.pl";
&con_inv0;

 $str= qq~ [\n~;
 if ($in{jenis} eq 'FG') {
  $tbl_brg=$dbh->prepare("SELECT menu_id, menu_name, menu_kategori, menu_harga, hpp.hpp,'PORSI' satuan
   from m_menu_pos p inner join sp_menu_hpp(get_list_active(?)) hpp on hpp.menuid=p.menu_id
   where isaktif='Y' and menu_brand containing '$in{resto}' order by menu_kategori, menu_name");
 } else {
  $tbl_brg=$dbh->prepare("SELECT brg_id, brg_nama, pg.group_nama, hpp.hpp, hpp.hpp,p.brg_satuan
   from m_produk p inner join sp_menu_hpp(get_list_active(?)) hpp on hpp.menuid=p.brg_id
   inner join m_produk_grp pg on pg.group_id=p.brg_group
   where isaktif='Y' and brg_brand containing '$in{resto}' and brg_jenis='$in{jenis}'
   and pg.isfood='Y'
   order by group_nama, brg_nama");  
 } 
$tbl_brg->execute($in{tgl});
while (@rec=$tbl_brg->fetchrow())
{
   $pros=0;
   $rec[1] =~ s/\'/ /g;
   $rec[1] =~ s/\"/ /g;
   if ($rec[3]>0) {
      $pros=style_module::skkkdd($rec[4]*100/$rec[3]);      
   }   
   $rec[3] = style_module::skkkdd($rec[3]);
   $rec[4] = style_module::skkkdd($rec[4]);
   $str.= qq~ { "kode" : "$rec[0]","nama" : "$rec[1]","kat" : "$rec[2]","harga" : "$rec[3]","hpp" : "$rec[4]","prosen" : "$pros","satuan" : "$rec[5]"},~ ;
 }
 $n = length($str) - 1;
 $str = substr $str,0,$n;
 $str .=  qq~\n~; 
 $str .= qq~]~; 
 print $str;
 
#}