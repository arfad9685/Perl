sub sis_hpp_01d {
     
print qq~
<center><br><br>

  <div id="table-scroll" class="table-scroll tb_600" style='height:90%;width:700px;background-color:#808080;'>
  <table id="main-table" class="main-table mobile-optimised">
  <thead>
  <tr height=20 bgcolor=maroon class=hurufcol>
    <th align=center>Kode Bahan</th>
    <th align=center>Nama Bahan</th>
    <th align=center>Qty</th>
    <th align=center>Satuan</th>
    <th align=center>Harga Sat</th>
    <th align=center>HPP</th>        
  </tr></thead><tbody>~;

  $sth_resep=$dbh->prepare("select ba.bhn_id, ba.bhn_qty*ba.bhn_konv,ba.bhn_satuan,
    case when ba.bhn_tingkat>=2 then get_nama_brg(ba.resep_id1) else '' end as resep1,
    case when ba.bhn_tingkat>=3 then '--> '||get_nama_brg(ba.resep_id2) else '' end as resep2,
    case when ba.bhn_tingkat>=4 then '--> --> '||get_nama_brg(ba.resep_id3) else '' end as resep3,
    case ba.bhn_tingkat 
       when 1 then get_nama_brg(ba.bhn_id)
       when 2 then '--> '||get_nama_brg(ba.bhn_id)
       when 3 then '--> --> '||get_nama_brg(ba.bhn_id)
       when 4 then '--> --> --> '||get_nama_brg(ba.bhn_id)
       when 5 then '--> --> --> --> '||get_nama_brg(ba.bhn_id) end as namabrg, ba.bhn_tingkat,
   ba.resep_id1, ba.resep_qty1, ba.resep_sat1,
   ba.resep_id2, ba.resep_qty2, ba.resep_sat2,
   ba.resep_id3, ba.resep_qty3, ba.resep_sat3,
    get_price_rm(ba.bhn_id,ba.bhn_satuan)    
    from m_bahan_active ba
    where resep_id=? and resep_listid=get_list_active(?) and isresep='N'
    order by resep_id1,ba.bhn_tingkat,resep_id2,resep_id3,resep_id4,2");
 $sth_resep->execute($in{kodebrg},$tt);
 $head='';
 while (@resep=$sth_resep->fetchrow_array())  {
   $namabrg=$resep[6];
   $hargasat = style_module::skkkdd($resep[17]);      
   $harga = style_module::skkkdd($resep[17]*$resep[1]);   
   $resep[1]=style_module::skkkdd($resep[1]);
   if  ($resep[3].$resep[4].$resep[5] ne $head) {
      $head=$resep[3].$resep[4].$resep[5];
      if ($resep[7]==2) {
          $nama_head=$resep[3];
          $id_head=$resep[8];
          $qty_head=style_module::skkkdd($resep[9]);
          $sat_head=$resep[10];          
      } elsif ($resep[7]==3) {
          $nama_head=$resep[4];
          $id_head=$resep[11];
          $qty_head=style_module::skkkdd($resep[12]);
          $sat_head=$resep[13];                    
      } elsif ($resep[7]==4) {
          $nama_head=$resep[5];
          $id_head=$resep[14];
          $qty_head=style_module::skkkdd($resep[15]);
          $sat_head=$resep[16];                    
      }
      print qq~
      <tr class=huruf10b style='background-color:yellow;'>
       <td align=center width=50>$id_head</td>
       <td align=left >&nbsp;$nama_head</td>
       <td align=right width=75>$qty_head&nbsp;</td>
       <td align=left width=50>&nbsp;$sat_head</td>
       <td align=left width=70>&nbsp;</td>
       <td align=left width=70>&nbsp;</td>              
      </tr>      
      ~;
   }
   print qq~
      <tr class=huruf10b>
      <td align=center width=50>&nbsp;$resep[0]</td>
      <td align=left >&nbsp;$namabrg</td>
      <td align=right width=75>$resep[1]&nbsp;</td>
      <td align=left width=50>&nbsp;$resep[2]</td>
      <td align=right width=75>$hargasat&nbsp;</td>            
      <td align=right width=75>$harga&nbsp;</td>      
      </tr>
      ~;
 }
print qq~
 </tbody></table></div>
 <hr width="100" />
<br>
</center>
~;
}

1


