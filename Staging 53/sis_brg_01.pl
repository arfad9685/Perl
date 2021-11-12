sub sis_brg_01 {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 
 if (!$in{retur}) {
   $in{retur}='-';
 }
 $div=substr($s3s[10],0,6); 
 xml_module::edit_table("800 px", "80%","/cgi-bin/colorbox.cgi?pages=sis_brg_01a&ss=$in{ss}&lok_prg=$in{lok_prg}&div=$div");
 #xml_module::add_table("800 px", "60%","/cgi-bin/colorbox.cgi?pages=sis_supplier_a&ss=$in{ss}&lok_prg=$in{lok_prg}&menuid=$menu[0]"); 
 xml_module::konfirm();
 xml_module::view_table("ho/tb_brg_01","div=$div&ss=$in{ss}&jenis=$in{jenis}&nama=$in{nama}&aktif=$in{aktif}&sch=$in{sch}&retur=$in{retur}&kat=$in{kat}&pch=$in{pchid}",1); #(script_view.pl, params, table cnt)
 
 #if ($in{del} eq 'Y') {
 # $errormsg = delete_dbh('M_SUPPLIER','VENDOR_ID', $in{id});
 # $url = "/cgi-bin/store.cgi?pages=sis_supplier&ss=$in{ss}&lok_prg=$in{lok_prg}";
 # print qq~
 #  <script>
 #  window.location.replace("$url");
 #  </script>
 # ~;
 #}
 
  if (index($rws,'W') ne (-1)) {
  print qq~
  <table width=1000>
    <tr><td width=100%>
            <table width=100%>           
             <form method=GET>
             <input name="pages" type="hidden" value=sis_brg_01>
             <input name="ss" type="hidden" value="$in{ss}">
             <input name="lok_prg" type="hidden" value="$in{lok_prg}">
             <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
             <tr>
               <td height=30 width=100% colspan=6 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
             </tr>             
            <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol" width=40>&nbsp;Jenis</td>
             <td align="left" class="huruf1"><select name="jenis" class="huruf1" id="jenis">~;
             @jenis_brg=('RM','WIP','FG','ISP','NF');
             for($i = 0; $i < scalar(@jenis_brg); $i++) {
               $selected[$i]=""; 
               if ($in{jenis} eq $jenis_brg[$i]) {
                      $selected[$i]='selected';
               }
               print qq~<option $selected[$i]>$jenis_brg[$i]</option>~;
             }  
             print qq~                                       
             </select></td>
             <td align="left" bgcolor=$colcolor class="hurufcol" width=40>&nbsp;Kategori</td>
             <td align="left" class="huruf1"><select name="kat" class="huruf1" id="kat">
             <option value=''>--- ALL ---</option>~;
             drop_down_1($dbh,'m_produk_grp','group_nama','group_id','','group_nama',$in{kat});                                       
             print qq~                                       
             </select></td>
             <td align="left" bgcolor=$colcolor class="hurufcol" width=40>&nbsp;Aktif Only</td>
             <td align="left" class="huruf1"><select name="aktif" class="huruf1" id="aktif">~;
             @aktif=('Y','N');
             for($i = 0; $i < scalar(@aktif); $i++) {
               $selected[$i]=""; 
               if ($in{aktif} eq $aktif[$i]) {
                      $selected[$i]='selected';
               }
               print qq~<option $selected[$i]>$aktif[$i]</option>~;
             }  
             print qq~                                       
             </select></td>             
            </tr>
            <tr>
             <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Schedule Kirim</td>
             <td align="left" class="huruf1"><select name="sch" class="huruf1" id="sch">
             <option value=''>--- ALL ---</option>~;
             drop_down_1($dbh,'m_produk_schkrm','sch_nama','sch_id','','sch_nama',$in{sch});                          
             print qq~                                       
             </select></td>
             <td align="left" bgcolor=$colcolor class="hurufcol" width=100>&nbsp;Purchaser </td>
             <td align="left" class="huruf1"><select name="pchid" class="huruf1" id="pchid">
             <option value=''>--- ALL ---</option>~;
             drop_down_1($dbh,'m_produk_puch','purchaser_nama','purchaser_id','','purchaser_nama',$in{pchid});                                       
             print qq~                                       
             </select></td>
             <td align="left" bgcolor=$colcolor class="hurufcol" width=100>&nbsp;Waste Retur</td>
             <td align="left" class="huruf1"><select name="retur" class="huruf1" id="retur">~;
             @retur=('-','Y','N');
             for($i = 0; $i < scalar(@retur); $i++) {
               $selected[$i]=""; 
               if ($in{retur} eq $retur[$i]) {
                      $selected[$i]='selected';
               }
               print qq~<option $selected[$i]>$retur[$i]</option>~;
             }  
             print qq~                                       
             </select></td>                          
            </tr>               
            <tr>              
              <td width=120 align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Nama Barang</td>
              <td align="left" class="huruf1" width=150><input type=text size=35 name="nama" value="$in{nama}" class="huruf1" maxlength=40  placeholder="Ketik nama barang..."></td>
              <td align="left" class="huruf1" colspan=4><input type=submit class="button button_grey" name=cari value="Cari"></td>
            </tr>                       
            </table>
         </td>
      </tr></form> 
  </table>~;
  }
print qq~

<script type="text/javascript"> 
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised' style='width:1000px'>";
      txt += "<thead>";
      txt += "<tr>";
      ~;
  
      @cols = ("AKT","KODE", "NAMA", "SATUAN","SATPO","SATKRM", "STR", "SCH", "WST/DP", "PACK", "BRAND", "PPUC", "FZ", "PURCH");
      @align = ("center","center", "left", "left","left","left",  "center", "center", "center", "left", "center", "center", "center", "left");
      @length = ("20","40", "", "50","50","50", "25", "25", "40", "", "60", "25", "25", "");
      
      for($i=0;$i<scalar(@cols);$i++){
        if ($length[$i]) {
           print "txt += \"<th align='center' width=$length[$i]>".$cols[$i]."</th>\";\n\t";
        } else {
           print "txt += \"<th align='center'>".$cols[$i]."</th>\";\n\t";         
        } 
      }
      
      if (index($rws,'W') ne (-1)) {
        print qq~ 
        txt += "<th align='center' width=50>Action</th>";~;
      }
      
      print qq~
     txt += "</tr>";
     txt += "</thead>";
     txt += "<tbody>";
      
     for (x in data) {
           if (data[x].c0=='N') {
              batal=" style='color:red' ";
           } else {
              batal='';
           }
           txt += "<tr class=huruf2"+batal+">"
           txt += "<td align=center width=50>&nbsp;"+data[x].c0+"</td>"
           ~;
           
          for($i=1;$i<scalar(@cols);$i++){
           print qq~ txt += "<td align=$align[$i] width=$length[$i]>&nbsp;"+data[x].c~ . $i . qq~ +"</td>"\n\t~;
          }
          
           if (index($rws,'W') ne (-1)) {
             print qq~
              txt += "<td align=center width=50>&nbsp;<i class='far fa-edit fa-2x' style='cursor:pointer' onclick=edit('id="+data[x].c1+"&jenis=$in{jenis}')></i></td>";
              //txt +="&nbsp;<a href=/cgi-bin/store.cgi?pages=sis_brg_01&ss=$in{ss}&lok_prg=$in{lok_prg}&del=Y&id="+data[x].c1+"><input type='image' src='/images/del.png' onclick=konfirm('Hapus','"+data[x].c0+"')></a></td>";~;
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


