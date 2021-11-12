sub sis_insentif_01 {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 
 style_module::use_calendar();
 if (!$in{tgl1}) {
    $in{tgl1}=$tt;
    $in{tgl2}=$tt;
 } 
 xml_module::konfirm();
 xml_module::view_table("ho/tb_insentif_01","ss=$in{ss}&kat=$in{kat}&brand=$in{brand}&tgl1=$in{tgl1}&tgl2=$in{tgl2}",1); #(script_view.pl, params, table cnt)
 $str="ss=$in{ss}"; 
 xml_module::json_list("ho/json_menu","$str","",1); #(script_view.pl, params, table cnt)
 
 if (!$in{tgl1}) {
    $in{tgl1}=$tt;
    $in{tgl2}=$tt;
 }
 if ($in{ubah} eq 'ADD') {
      $up_menu=$dbh->do("INSERT INTO M_INSENTIF_MENU (MENU_ID, BRAND, INSENTIF, D_BERLAKU, D_END, OPR_CREATED) VALUES ('$in{idbrg}', '$in{brandmenu}',$in{kat1}, '$in{dmulai}','$in{dend}','$s3s[0]')");
      if ($up_menu==0) {
            style_module::use_chkerror($dbh);
            $errormsg='Error. Cancel Proses. Hubungi MIS '.$up_menu;
      } else {
            $errormsg='Data berhasil diubah.';
      }
 # $url = "/cgi-bin/store.cgi?pages=sis_supplier&ss=$in{ss}&lok_prg=$in{lok_prg}";
 # print qq~
 #  <script>
 #  window.location.replace("$url");
 #  </script>
 # ~;
 }
 
 if ($in{ubah} eq 'DEL') {
    $up_menu=$dbh->do("DELETE FROM M_INSENTIF_MENU WHERE RECID=$in{recid}");  
 } 
 
print qq~
<script type='text/javascript' src='/js/jquery-ui.js'></script>
<link rel="stylesheet" href="/css/jquery-ui.css">
<script type="text/javascript">  
function search_view1(arr) {
     \$( "#namabrg" ).autocomplete({      
       minLength: 2,    
       delay: 0,
       source: arr,
       select : function(e, ui) {
          e.preventDefault ()       
          \$("#idbrg").val(ui.item.value);
          \$("#brandmenu").val(ui.item.brand);          
          \$(this).val(ui.item.label);
      }
    });
}

function button_click(update,id)
{
      if (update == 'ADD') {
        document.getElementById("ubah").value=update;
      }
      if (update == 'DEL') {
        document.getElementById("ubah").value=update;
        document.getElementById("recid").value=id;        
      }      
      submit();       
}    
</script>  
  <table width=800 border=0>
    <tr><td width=100%>
            <table width=100% border=0>           
             <form method=GET>
             <input name="pages" type="hidden" value=sis_insentif_01>
             <input name="ss" type="hidden" value="$in{ss}">
             <input name="lok_prg" type="hidden" value="$in{lok_prg}">
             <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
             <tr>
               <td height=30 width=100% colspan=5 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
             </tr>             
            <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol" width=40>&nbsp;Kategori</td>
             <td align="left" class="huruf1" colspan=4><select name="kat" class="huruf1" id="kat">
             <option value=''>--- ALL --- </option>~;
             drop_down_1($dbh,'m_insentif_kat','KETERANGAN','recid','','KETERANGAN',$in{kat});                                                      
             print qq~                                       
             </select></td>
            </tr>
            <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol" width=40>&nbsp;Brand</td>
             <td align="left" class="huruf1" colspan=4><select name="brand" class="huruf1" id="brand">
             <option value=''>--- ALL --- </option>~;
             $whr="isaktif='Y' and isopr='Y'";
             drop_down_1($dbh,'m_cab_brand','brand_nama','brand_id',$whr,'Brand_nama',$in{brand});                                                      
             print qq~                                       
             </select></td>
            </tr>            
            <tr>              
              <td width=120 align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Berlaku Mulai</td>
              <td align="left" class="huruf1" width=75>~;
               style_module::input_calendar('tgl1',$in{tgl1},1);
              print qq~
              </td><td align=left class=hurufcol width=30>&nbsp;s.d&nbsp</td><td align="left" class="huruf1" width=75>~;
              style_module::input_calendar('tgl2',$in{tgl2},2);
              print qq~
              </td><td align=left width=200>
              <input type=submit class="button button_grey" name=cari value="Cari"></td>
            </tr>                       
            </table>
         </td>
      </tr></form>      
  </table>

 <script type="text/javascript"> 
   function tab_view1(data) {
      var x, txt=" ";      
      txt += "<table id='main-table' class='main-table mobile-optimised' style='width:800px'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += "<th align='center' width=50>Kode</th>";
      txt += "<th align='center' >Nama</th>";            
      txt += "<th align='center' width=50>Kategori</th>";
      txt += "<th align='center' width=50>Brand</th>";
      txt += "<th align='center' width=75>Berlaku</th>";
      txt += "<th align='center' width=75>Expired</th>";~;
      if (index($rws,'W') ne (-1)) {
        print qq~ 
        txt += "<th align='center' width=50>Action</th>";~;
      }
      print qq~
      txt += "</tr>";
      txt += "</thead>";     
      txt += "<tbody>";~;
      if (index($rws,'W') ne (-1)) {
       $sel[$in{kat}]='selected';
       print qq~
       txt +="<tr class='huruf2' bgcolor=#f6f7cd>";
       txt +="<td align=left class=huruf1 width=50><input id='idbrg' name='idbrg' style='width: 100%;margin: 0px;border: 1px solid #CCC;' readonly=readonly></td>";
       txt +="<td align=left ><input name='namabrg' id='namabrg' style='width: 100%;margin: 0px;border: 1px solid #CCC;'></td>";~;
       print qq~ txt +="<td align=left class=huruf1 width=50><select name='kat1'><option value=1 $sel[1]>MERAH</option><option value=2 $sel[2]>KUNING</option><option value=3 $sel[3]>HIJAU</option>~;           
       print qq~</select></td>";~;
       print qq~
       txt +="<td align=left width=50><input id='brandmenu' name='brandmenu' style='width: 100%;margin: 0px;border: 1px solid #CCC;' readonly=readonly></td>";
       txt +="<td align=center width=75><input name='dmulai' style='width: 100%;margin: 0px;border: 1px solid #CCC;' value=$in{tgl1}></td>";
       txt +="<td align=center width=75><input name='dend'  style='width: 100%;margin: 0px;border: 1px solid #CCC;' value=$in{tgl2}></td>";       
       txt +="<td align=center><input type=image src='/images/add.png' onclick=button_click('ADD',0,0)></td>";
       txt +="</tr>";~;
      }
      print qq~            
      for (x in data) {
           txt += "<tr class=huruf2 style='background-color:#"+data[x].warna+"'><td align=center>&nbsp;"+data[x].kode+"&nbsp;</td>";
           txt +="<td align=left>&nbsp;"+data[x].nama+"</td>";
           txt += "<td align=center>&nbsp;"+data[x].insentif+"</td><td align=center>"+data[x].brand+"&nbsp;</td>";
           txt += "<td align=center>&nbsp;"+data[x].berlaku+"</td><td align=center>"+data[x].expired+"&nbsp;</td>"; 
           ~;
           if (index($rws,'W') ne (-1)) {
             print qq~
              txt += "<td align=center width=50>&nbsp;<input type='image' src='/images/del.png' onclick=button_click('DEL',"+data[x].recid+")></td>";~;
           }
           print qq~
           txt +="</tr>";     
      }
      txt +="</tbody></table>";        
      document.getElementById("tb-lokasi").innerHTML = txt;               
   }
  </script>
  
     <form method=POST onsubmit="return warning('Update')">
     <input name="pages" type="hidden" value=sis_insentif_01>
     <input name="ss" type="hidden" value="$in{ss}">
     <input name="brand" type="hidden" value="$in{brand}">
     <input name="kat" type="hidden" value="$in{kat}">
     <input name="tgl1" type="hidden" value="$in{tgl1}">
     <input name="tgl2" type="hidden" value="$in{tgl2}">          
     <input name="lok_prg" type="hidden" value="$in{lok_prg}">
     <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
     <input id=recid name="recid" type="hidden" value=0>
     <input id=ubah name="ubah" type="hidden" value=''>           
    <div id="tb-lokasi" class="table-scroll tb_800" style='width:800px; height:70vh;font-size:10px'>&nbsp;  
    </div>
    </form>
    <p>
    <hr width="100" />~.
    $errormsg .
    qq~
</center>
 <script language="javascript">       
  window.onload = create_json();
</script>          
~;   
 
}

1


