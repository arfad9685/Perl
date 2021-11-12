sub str_guest_01 {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
require "/opt/sarirasa/cgi-bin/assets/control/tab_purchase.pl"; 
 
 style_module::use_calendar();
 xml_module::konfirm();
 xml_module::edit_table("950 px","85%","/cgi-bin/colorbox.cgi?pages=pdf_view&ss=$in{ss}&lok_prg=$in{lok_prg}&parent=str_guest_01");  
 xml_module::create_pdf("store/pdf_guest");  
 
 if (!$in{cab}) {
   $in{cab}=$s3s[4];
 }
 if (!$in{tgl1}) {
    $in{tgl1}=$tt;
    $in{tgl2}=$tt;  
 }
 
 $strv="ss=$in{ss}&cab=$in{cab}&tgl1=$in{tgl1}&tgl2=$in{tgl2}";
 if (index($rws,'S') ne (-1)) {
   $strv.="&all=Y";
 }
 xml_module::view_table("store/tb_guest_01","$strv",1); #(script_view.pl, params, table cnt)
  
  print qq~
  <script type='text/javascript' src='/js/jquery-ui.js'></script> 
  <link rel="stylesheet" href="/css/jquery-ui.css">
  
 <script type="text/javascript">
 
  function search_view1(arr) {
     \$( "#namasup" ).autocomplete({      
       minLength: 2,    
       delay: 0,
       source: arr,
       select : function(e, ui) {
          e.preventDefault ()       
          \$("#kodesup").val(ui.item.value);
          \$(this).val(ui.item.label);
      }
    });
  }
  function clearjson() {
     document.getElementById('namasup').value = '';
     document.getElementById('kodesup').value = '';     
  }
  
  </script>
  <form method=GET>
  <input name="pages" type="hidden" value=str_guest_01>
  <input name="ss" type="hidden" value="$in{ss}">
  <input name="lok_prg" type="hidden" value="$in{lok_prg}">
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
   
  <table width=800>
    <tr><td width=100%>
            <table width=100%>           
              <tr>
                <td height=30 width=100% colspan=4 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
              </tr>
              <tr>
                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Lokasi</td>
                <td class=hurufcol colspan=2><select name="cab" class="huruf1" id="cab">~;
                $where="isaktif='Y' and store_bagian in ('STORE')";
                if (index($rws,'W') ne (-1)) {
                   $readonly="";
                } else {
                   $readonly="readonly";
                }
                drop_down_1($dbh,'m_cab','store_nama','store_id',$where,'store_nama',$in{cab},'',$readonly);
                print qq~                                       
                </select></td><td rowspan=2 valign=bottom align=right><input type=submit class="button button_green" name=cari value="Cari"></td>
               </tr>
               <tr>
                 <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Tanggal</td>
                 <td class=hurufcol width=40>~;
                 if (index($rws,'W') ne (-1)) {                 
                   style_module::input_calendar('tgl1',$in{tgl1},1);
                 } else {
                   print qq~$in{tgl1}~;
                 } 
                 print qq~</td><td class="hurufcol" align=left> s.d ~;
                 if (index($rws,'W') ne (-1)) {                                  
                  style_module::input_calendar('tgl2',$in{tgl2},2);
                 } else {
                    print qq~$in{tgl2}~;
                 }
                 print qq~</td>
               </tr>                            
            </table>
     </td></tr>
  </table></form>

<script type="text/javascript"> 
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised'>";
      txt += "<thead>";
      txt += "<tr>";
      ~;
  
      @cols = ("Nama","No. HP", "No.KTP", "Orang","Jam");
      @align = ("left","center", "center", "center","center");
      @length = ("","120", "120", "100","200");
      
      for($i=0;$i<scalar(@cols);$i++){
        if ($length[$i]) {           
           print "txt += \"<th align='center' width=$length[$i]>".$cols[$i]."</th>\";\n\t";
        } else {
           print "txt += \"<th align='center'>".$cols[$i]."</th>\";\n\t";         
        } 
      }
           
      print qq~
     txt += "</tr>";
     txt += "</thead>";
     txt += "<tbody>";
      
     for (x in data) {
           txt += "<tr class=huruf2>"
            ~;          
           for($i=0;$i<scalar(@cols);$i++){
               print qq~ txt += "<td align=$align[$i] width=$length[$i]>&nbsp;"+data[x].c$i+"&nbsp;</td>"\n\t~;
           }
         
           print qq~
           txt +="</tr>";
     }
     txt +="</tbody><tfoot><tr><th colspan=5 style='text-align:left'><span id=btnedit align=left>&nbsp;</span></th></tr></foot></table>";       
     document.getElementById("tb-lokasi").innerHTML = txt;~;
     if (index($rws,'S') ne (-1)) {
       print qq~
       txt1 ="<button class='button button_green' onClick=print_pdf()>PRINT</button>";
       txt1 +="<button id='GoToPdf' style='display:none' onclick=edit('file=GB$in{ss}.pdf')></button>";
       document.getElementById("btnedit").innerHTML = txt1;~;
     }  
     print qq~         
   }
   
   function print_pdf () {
       create_pdf('cab=$in{cab}&tgl1=$in{tgl1}&tgl2=$in{tgl2}&ss=$in{ss}');
   }   
   
  </script>  
  <div id="tb-lokasi" class="table-scroll tb_800" style='height:70%;font-size:10px'>&nbsp;  
  </div>
      <p>
    $errormsg
    <hr width="100" />
 </center>
 
~;   
 
}

1


