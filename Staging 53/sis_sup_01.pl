sub sis_sup_01 {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 
  xml_module::edit_table("800 px", "70%","/cgi-bin/colorbox.cgi?ss=$in{ss}&lok_prg=$in{lok_prg}");
  xml_module::add_table("800 px", "70%","/cgi-bin/colorbox.cgi?pages=sis_sup_01a&ss=$in{ss}&lok_prg=$in{lok_prg}"); 
 xml_module::konfirm();
 if ($in{nama} || $in{kat}) {
   xml_module::view_table("ho/tb_sup_01","ss=$in{ss}&kat=$in{kat}&nama=$in{nama}",1); #(script_view.pl, params, table cnt)
 }   
 
 #if ($in{del} eq 'Y') {
 # $errormsg = delete_dbh('M_SUPPLIER','VENDOR_ID', $in{id});
 # $url = "/cgi-bin/store.cgi?pages=sis_supplier&ss=$in{ss}&lok_prg=$in{lok_prg}";
 # print qq~
 #  <script>
 #  window.location.replace("$url");
 #  </script>
 # ~;
 #}
 
  print qq~
  <table width=1000>
    <tr><td width=100%>
            <table width=100%>           
             <form method=GET>
             <input name="pages" type="hidden" value=sis_sup_01>
             <input name="ss" type="hidden" value="$in{ss}">
             <input name="lok_prg" type="hidden" value="$in{lok_prg}">
             <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
             <tr>
               <td height=30 width=100% colspan=2 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
             </tr>             
            <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol" width=40>&nbsp;Kategori</td>
             <td align="left" class="huruf1"><select name="kat" class="huruf1" id="kat">
             <option>--- ALL --- </option>~;
             drop_down_1($dbh,'m_supplier_tipe','tipe_nama','tipe_id','','tipe_nama',$in{kat});                                                      
             print qq~                                       
             </select></td>
            </tr>
            <tr>              
              <td width=120 align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Nama Supplier</td>
              <td align="left" class="huruf1"><input type=text size=35 name="nama" value="$in{nama}" class="huruf1" maxlength=40  style='text-transform:uppercase' placeholder="Ketik nama supplier...">
              <input type=submit class="button button_grey" name=cari value="Cari"></td>
            </tr>                       
            </table>
         </td>
      </tr></form>
      <tr><td colspan=2><button class='button button_green' onclick=add()>Tambah</button></td></tr>
  </table>

 <script type="text/javascript"> 
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised' style='width:1000px'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += "<th align='center' width=30>Kode</th>";
      txt += "<th align='center' >Nama</th>";            
      txt += "<th align='center' width=125>Kategori</th>";
      txt += "<th align='center' width=150>Telp / Email</th>";
      txt += "<th align='center' width=30>Top</th>";
      txt += "<th align='center' width=30>Byr</th>";
      txt += "<th align='center' width=30>Tax</th>";~;
      if (index($rws,'W') ne (-1)) {
        print qq~ 
        txt += "<th align='center' width=30>Action</th>";~;
      }
      print qq~
      txt += "</tr>";
      txt += "</thead>";     
      txt += "<tbody>";
      
      for (x in data) {
           txt += "<tr class=huruf2><td align=center>&nbsp;"+data[x].c0+"&nbsp;</td>";~;
           if (index($rws,'W') ne (-1)) {
             print qq~            
             txt +="<td align=left>&nbsp;<span onclick=edit('id="+data[x].c0+"&pages=sis_sup_01s&jns="+data[x].c8+"') style='cursor:pointer'><u>"+data[x].c1+"</u></span></td>";~;
           } else {
             print qq~            
             txt +="<td align=left>&nbsp;"+data[x].c1+"</td>";~;            
           }
           print qq~
           txt +="<td align=left>&nbsp;"+data[x].c2+"</td>";
           txt += "<td align=left>&nbsp;"+data[x].c3+" / "+data[x].c4+"</td><td align=right>"+data[x].c5+"&nbsp;</td>";
           txt += "<td align=center>&nbsp;"+data[x].c6+"</td><td align=center>"+data[x].c7+"&nbsp;</td>"; 
           ~;
           if (index($rws,'W') ne (-1)) {
             print qq~
              txt += "<td align=center width=50>&nbsp;<input type='image' src='/images/edit.png' onclick=edit('id="+data[x].c0+"&pages=sis_sup_01e')></td>";~;
           }
           print qq~
           txt +="</tr>";     
      }
      txt +="</tbody></table>";        
      document.getElementById("tb-lokasi").innerHTML = txt;               
   }
 </script>  
  
    <div id="tb-lokasi" class="table-scroll tb_800" style='width:1000px; height:70%;font-size:10px'>&nbsp;  
    </div>
    <p>
    <hr width="100" />~.
    $errormsg .
    qq~
</center>
~; 
 
}

1


