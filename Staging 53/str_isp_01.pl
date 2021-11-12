sub str_isp_01 { 
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl"; 
 require "/opt/sarirasa/core/chk_login.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/history_module.pl";
 
 history_tab ('str_isp_01',$in{ss},$in{lok_prg});
 if (!$in{hist}) { 
  xml_module::edit_table("900 px","85%","/cgi-bin/colorbox.cgi?ss=$in{ss}&lok_prg=$in{lok_prg}");
  xml_module::add_table("900 px","85%","/cgi-bin/colorbox.cgi?pages=str_isp_01a&ss=$in{ss}&lok_prg=$in{lok_prg}");  
  style_module::use_warning();
  xml_module::view_table("store/tb_ispstr","ss=$in{ss}&cab=$s3s[4]",1);
   
  print qq~    
  <br>
  <script type="text/javascript">  
  
   function tab_view1(data) {
      var txt=" ";
      var x=0;y=0;
      txt += "<table id='main-table' class='main-table mobile-optimised'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += "<th align='center' width=25>No.</th>";
      txt += "<th align='center' width=100>No. SPK</th>";            
      txt += "<th align='center' width=100>Tanggal</th>";
      txt += "<th align='center' width=50>Items</th>";
      txt += "<th align='center' width=75>Operator</th>";
      txt += "<th align='center' width=100>Actions</th>";      
      txt += "</tr>";
      txt += "</thead>";
      txt += "<tbody>";
      
      for (x in data) {
           y = y +1;
           txt += "<tr class=huruf2><td align=right>"+y+".&nbsp;</td>";
           txt +="<td align=center>&nbsp;"+data[x].nospk+"</td><td align=center>"+data[x].tanggal+"</td>";
           txt += "<td align=right>"+data[x].jml+"&nbsp;</td><td align=center>"+data[x].opr+"</td>";
           txt +="<td align=center><input type='image' src='/images/edit.png' onclick=edit('pages=str_isp_01d&noisp="+data[x].nospk+"')>&nbsp;";
           txt +="<input type='image' src='/images/del.png' onclick=edit('pages=str_isp_01b&del=Y&noisp="+data[x].nospk+"')>&nbsp;";
           txt += "<input type='image' src='/images/print-20.png' onclick=edit('pages=str_isp_01b&noisp="+data[x].nospk+"')></td></tr>";
     }
     txt +="</tbody>";
     if (y==0) {
        txt +="<tr><td colspan=6 align=left><button class='button button_green' onclick=add()>Tambah</button></td></tr>";
     }    
     txt +="</table>";
     document.getElementById("list-isp").innerHTML = txt;               
   }
 </script>  
  <div id="list-isp" class="table-scroll tb_800">&nbsp;  
  </div>~;
 } else {
   print qq~
    <div style='width:810px; background-color:#a6a6a6;border-radius : 5px' ><center>&nbsp;~;
    history_by_store ('800','str_isp_01',$in{ss},$in{lok_prg},$in{tgl1},$in{tgl2},$in{cab}) ;
    xml_module::edit_table("900 px","85%","/cgi-bin/colorbox.cgi?ss=$in{ss}&lok_prg=$in{lok_prg}");    
    if ($in{cari}) {
      xml_module::view_table("store/tb_isp_his","ss=$in{ss}&cab=$s3s[4]&tgl1=$in{tgl1}&tgl2=$in{tgl2}",1);
    }  
    print qq~
    <script type="text/javascript"> 
    function tab_view1(data) {
      var txt=" ";
      var x=0;y=0;
      txt += "<table id='main-table' class='main-table mobile-optimised'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += "<th align='center'>No.</th>";
      txt += "<th align='center'>Tanggal</th>";            
      txt += "<th align='center'>No.Reff</th>";
      txt += "<th align='center'>Items</th>";
      txt += "<th align='center'>Prep</th>";
      txt += "<th align='center'>Status</th>";      
      txt += "<th align='center'>Operator</th>";              
      txt += "</tr>";
      txt += "</thead>";
      txt += "<tbody>";
      
      for (x in data) {
           y = y +1;
           if (data[x].proses=='Y') {
             status='PROSES';
           } else if (data[x].proses=='B') {
             status='BATAL';
           } else {
             status='INPUT';            
           }
           
           txt += "<tr class=huruf2><td align=right>"+y+".&nbsp;</td>";
           txt +="<td align=center>&nbsp;"+data[x].tgl+"</td>";
           txt +="<td align=center>&nbsp;<span onclick=edit('noisp="+data[x].noreff+"&pages=str_isp_01v') style='cursor:pointer'><u>"+data[x].noreff+"</u></span></td>";
           txt += "<td align=right>"+data[x].jml+"&nbsp;</td><td align=center>"+data[x].prep+"</td>";                          
           txt +="<td align=center>&nbsp;"+status+"</td><td align=left>&nbsp;"+data[x].operator+"</td></tr>";
     }
     txt +="</tbody></table>";        
     document.getElementById("tab-his").innerHTML = txt;               
    }
    </script>  
    <div id="tab-his" class="table-scroll tb_800" style='height:70%;'>&nbsp;  
    </div>~;    
 }
 print qq~
 <p><hr width="100" />
</center>
~;
}

#-- Section Pages End here --->
1


