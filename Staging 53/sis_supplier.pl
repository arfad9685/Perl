sub sis_supplier {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 
 xml_module::edit_table("800 px", "60%","/cgi-bin/colorbox.cgi?pages=sis_supplier_e&ss=$in{ss}&lok_prg=$in{lok_prg}");
 xml_module::add_table("800 px", "60%","/cgi-bin/colorbox.cgi?pages=sis_supplier_a&ss=$in{ss}&lok_prg=$in{lok_prg}&menuid=$menu[0]"); 
 xml_module::konfirm();
 xml_module::view_table("ho/tb_supplier","ss=$in{ss}",1); #(script_view.pl, params, table cnt)
 
 if ($in{del} eq 'Y') {
  $errormsg = delete_dbh('M_SUPPLIER','VENDOR_ID', $in{id});
  $url = "/cgi-bin/store.cgi?pages=sis_supplier&ss=$in{ss}&lok_prg=$in{lok_prg}";
  print qq~
   <script>
   window.location.replace("$url");
   </script>
  ~;
 }
 
  if (index($rws,'W') ne (-1)) {
  print qq~
  <table width=1000>
    <tr><td width=100%>
    <button class="button button_green" onclick=add()>Tambah</button>
    </td></tr>
  </table>~;
  }
print qq~

<script type="text/javascript"> 
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised'>";
      txt += "<thead>";
      txt += "<tr>";
      ~;
  
      @cols = ("ID", "Vendor Name", "Tipe", "Terms", "Byr", "Is Tax", "Is Aktif", "Is All", "Kontak", "Phone");
      @align = ("center", "left", "center", "center", "center", "center", "center", "center", "left", "left");
      @length = ("50", "150", "50", "50", "50", "50", "50", "50", "200", "200");
      
      for($i=0;$i<scalar(@cols);$i++){
       print "txt += \"<th align=center width=$length[$i]>".$cols[$i]."</th>\";\n\t";
      }
      
      if (index($rws,'W') ne (-1)) {
        print qq~ 
        txt += "<th align='center'>Action</th>";~;
      }
      
      print qq~
     txt += "</tr>";
     txt += "</thead>";
     txt += "<tbody>";
      
     for (x in data) {
           txt += "<tr class=huruf2> "
           txt += "<td align=center width=$length[0]>&nbsp;"+data[x].c0+"</td>"
           ~;
           
          for($i=1;$i<scalar(@cols);$i++){
           print qq~ txt += "<td align=$align[$i] width=$length[$i]>&nbsp;"+data[x].c~ . $i . qq~ +"</td>"\n\t~;
          }
          
           if (index($rws,'W') ne (-1)) {
             print qq~
              txt += "<td align=center width=100>&nbsp;<input type='image' src='/images/edit.png' onclick=edit('id="+data[x].c0+"')>";
              txt +="&nbsp;<a href=/cgi-bin/store.cgi?pages=sis_supplier&ss=$in{ss}&lok_prg=$in{lok_prg}&del=Y&id="+data[x].c0+"><input type='image' src='/images/del.png' onclick=konfirm('Hapus','"+data[x].c0+"')></a></td>";~;
            }
           print qq~
           txt +="</tr>";
     }
     txt +="</tbody></table>";        
     document.getElementById("tb-lokasi").innerHTML = txt;               
   }
 </script>  
  
    <div id="tb-lokasi" class="table-scroll tb_800" style='width:1000px; height:70%'>&nbsp;  
    </div>
    <p>
    <hr width="100" />~.
    $errormsg .
    qq~
</center>
~; 
 
}

1


