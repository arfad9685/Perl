sub rep_pch_01 {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
require "/opt/sarirasa/cgi-bin/assets/control/tab_purchase.pl"; 
 
 style_module::use_calendar();
 xml_module::edit_table("800 px", "60%","/cgi-bin/colorbox.cgi?pages=rep_pch_01e&ss=$in{ss}&lok_prg=$in{lok_prg}");
 xml_module::konfirm();
 $strv="ss=$in{ss}&cab=$in{cab}&kat=$in{kat}&pchid=$in{pchid}&sup=$in{kodesup}&brg=$in{namabrg}";
 if (!$in{tglpo1}) {
     $in{tglpo1}=$tt;
     $in{tglpo2}=$tt;     
 }
 if (!$in{tglkrm1}) {
     $in{tglkrm1}=$tt;
     $in{tglkrm2}=$tt;     
 }
 if ($in{tglpo}) {
    $strv.="&tglpo1=$in{tglpo1}&tglpo2=$in{tglpo2}";  
 } 
 if ($in{tglkrm}) {
    $strv.="&tglkrm1=$in{tglkrm1}&tglkrm2=$in{tglkrm2}";  
 }
if ($in{selesai}) {
    $strv.="&selesai=$in{selesai}";  
 }

if  ($in{delpo}) {
  $errormsg=close_po($in{idpo})
}

if  ($in{lama}>0) {
  $errormsg=extend_po($in{idpo},$in{lama});
}

 
 xml_module::view_table("ho/tb_porep_01","$strv",1); #(script_view.pl, params, table cnt)
 $str="ss=$in{ss}&sup=";
 xml_module::json_list("ho/json_sup","$str","kodesup",1); #(script_view.pl, params, table,cnt)
 
  print qq~
  <script type='text/javascript' src='/js/jquery-ui.js'></script> 
  <link rel="stylesheet" href="/css/jquery-ui.css">
  
 <script type="text/javascript">
 function button_click(update,id)
 {
    if (update == 'DEL') {    
      var r = confirm("Closed PO  ?");
      if (r == true) {
         document.getElementById("idpo").value=id;
         document.getElementById("delpo").value='DEL';
         formpo.submit();                  
      } 
    }
    if (update == 'EXT') {    
      var r = confirm("Extend PO  ?");
      if (r == true) {
         lama=prompt("Extend (Hari) :",30);
         document.getElementById('lama').value = lama;      
         document.getElementById("idpo").value=id;
         formpo.submit();                  
      } 
    }    
  }
 
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
  
  </script>
  <form method=post action="/cgi-bin/store.cgi" id=formpo>
  <input name="pages" type="hidden" value=rep_pch_01>
  <input name="ss" type="hidden" value="$in{ss}">
  <input name="lok_prg" type="hidden" value="$in{lok_prg}">
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input name='idpo' id=idpo type=hidden value=0>
  <input name='lama' id=lama type=hidden value=0>  
  <input name='delpo' id=delpo type=hidden value=''>
   
  <table width=1100>
    <tr><td width=100%>
            <table width=100% >           
              <tr>
                <td height=30 width=100% colspan=6 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
              </tr>
              <tr>
                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Supplier</td>
                <td><input id="kodesup" name="kodesup" type=hidden>
                <input name="namasup" id="namasup" style="width: 100%;margin: 0px;border: 1px solid #CCC;" value='$in{namasup}'>                                                
                </td>~;
                if ($in{tglpo} eq 'Y') {
                   $sel='checked';
                } else {
                   $sel='';
                }
                print qq~                
                <td align="left" bgcolor=$colcolor class="hurufcol"><input type=checkbox name="tglpo" value=Y $sel>&nbsp;Periode PO</td>
                <td class="hurufcol" width=50>~;style_module::input_calendar('tglpo1',$in{tglpo1},1);print qq~</td><td class="hurufcol"> s.d ~;style_module::input_calendar('tglpo2',$in{tglpo2},2);                
                print qq~</td>                
              </tr>
              <tr>
                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Tujuan Kirim</td>
                <td><select name="cab" class="huruf1" id="cab">
                <option value=''>--- ALL ---</option>~;
                $where="isaktif='Y' and store_bagian in ('STORE','PUSAT')";
                drop_down_1($dbh,'m_cab','store_nama','store_id',$where,'store_nama',$in{cab});
                if ($in{tglkrm} eq 'Y') {
                   $sel='checked';
                } else {
                   $sel='';
                }                
                print qq~                                       
                </select></td>
                <td align="left" bgcolor=$colcolor class="hurufcol"><input type=checkbox name="tglkrm" value=Y $sel>&nbsp;Periode Kirim</td>
                <td class=hurufcol>~;style_module::input_calendar('tglkrm1',$in{tglkrm1},3);print qq~</td><td class="hurufcol"> s.d ~;style_module::input_calendar('tglkrm2',$in{tglkrm2},4);                
                print qq~</td>                
              </tr>
              <tr>
                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Kategori</td>
                <td><select name="kat" class="huruf1" id="kat">
                <option value=''>--- ALL ---</option>~;
                drop_down_1($dbh,'m_produk_grp','group_nama','group_id','','group_nama',$in{kat});                                       
                print qq~                                       
                </select></td>
                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Barang</td>
                <td colspan=2><input name="namabrg" id="namabrg" style="width: 100%;margin: 0px;border: 1px solid #CCC;text-transform: uppercase" value=$in{namabrg}></td>                
              </tr>
              <tr>
                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Purchaser</td>
                <td><select name="pchid" class="huruf1" id="pchid">
                <option value=''>--- ALL ---</option>~;
                drop_down_1($dbh,'m_produk_puch','purchaser_nama','purchaser_id','','purchaser_nama',$in{pchid});
                if ($in{selesai} eq 'Y') {
                   $sel='checked';
                } else {
                   $sel='';
                }
                print qq~                                       
                </select></td>
                <td align="left" bgcolor=$colcolor class="hurufcol"><input type=checkbox name="selesai" value=Y $sel>&nbsp;Include Closed</td>
                <td colspan=2><input type=submit class="button button_grey" name=cari value="Cari"></td>                
              </tr>              
            </table>
     </td></tr>
  </table>

<script type="text/javascript"> 
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised' style='width:1100px'>";
      txt += "<thead>";
      txt += "<tr>";
      ~;
  
      @cols = ("No.PO","Tgl PO", "Tgl Krm", "Supplier","Barang","Order", "Terima", "Satuan", "Harga", "Tujuan");
      @align = ("center","center", "center", "left","left","right",  "right", "left", "right", "left");
      @length = ("20","20", "20", "","","25", "25", "25", "25", "");
      
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
           if (data[x].c11=='X') {
              batal=" style='background-color:silver' ";
           } else {
              batal='';
           }           
           txt += "<tr class=huruf2"+batal+">"
           txt += "<td align=center width=50>&nbsp;"+data[x].c0+"&nbsp;</td>"
           ~;
           
          for($i=1;$i<scalar(@cols);$i++){
             if ((index($rws,'W') ne (-1)) && $i==2)  {
               print qq~
                 if (data[x].c11 != 'X') {
                    txt += "<td align=$align[$i] width=$length[$i] onclick=button_click('EXT',"+data[x].c10+") style='cursor:pointer'>&nbsp;<u>"+data[x].c~ . $i . qq~ +"</u>&nbsp;</td>"
                 } else {
                    txt += "<td align=$align[$i] width=$length[$i]>&nbsp;"+data[x].c~ . $i . qq~ +"&nbsp;</td>";
                 }~;
             } else {
               print qq~ txt += "<td align=$align[$i] width=$length[$i]>&nbsp;"+data[x].c~ . $i . qq~ +"&nbsp;</td>"\n\t~;
             }  
          }
          
           if (index($rws,'W') ne (-1)) {
             print qq~
              if (data[x].c11=='X') {
                txt += "<td align=center width=50>&nbsp;<img src='/images/lock-20.png'></td>";               
              } else {
                txt += "<td align=center width=50>&nbsp;<input type='image' src='/images/padlock-20.png' onclick=button_click('DEL',"+data[x].c10+")></td>";
              }                  
              ~;
            }
           print qq~
           txt +="</tr>";
     }
     txt +="</tbody></table>";        
     document.getElementById("tb-lokasi").innerHTML = txt;               
   }
  </script>  
  <div id="tb-lokasi" class="table-scroll tb_800" style='width:1100px; height:70%;font-size:10px'>&nbsp;  
  </div>
  </form>
    <p>
    $errormsg
    <hr width="100" />
 </center>
 <script language="javascript">       
  window.onload = create_json();
</script>          
~;   
 
}

1


