sub acct_jur_kop {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/control/c_acct_jur_kop.pl"; 
 
 style_module::use_warning();
 style_module::use_calendar();
 &con_pyr0;
 xml_module::view_nsubtable("ho/tb_acct_jur_kop2","ss=$in{ss}","nostb",1);

 if ($in{cari} ) {
   xml_module::view_table("ho/tb_acct_jur_kop","ss=$in{ss}&periode=$in{periode}",1); #(script_view.pl, params, table cnt)
 }
 
 
 if ($in{post}) {
    $in{post} ='';
    #print $in{cab}.$in{tgl1};
    #$errormsg = add_jurnal_pos ($in{cab},$in{tgl1}) ; 	
 }

  print qq~
  <font color=yellow>$errormsg</font>
  <table width=1000>
    <tr>
    <td width=500 align=left>
            <table width=100%>           
             <form method=GET>
             <input name="pages" type="hidden" value=acct_jur_kop>
             <input name="ss" type="hidden" value="$in{ss}">
             <input name="lok_prg" type="hidden" value="$in{lok_prg}">
             <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
             <tr>
               <td height=30 width=100% colspan=2 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
             </tr>             
            <tr>
                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Search</td>
                <td class=hurufcol>
                <!--<select name="periode" class="huruf1" id="cab">~;
                #$where="";
                #drop_down_1($dbpyr,'periodsc','dtstart','recid',$where,'recid desc','','first 4 recid,');
                print qq~                                       
                </select>-->
                <br>
                <input type=submit class="button button_grey" name=cari value="Cari"></td>
            </tr>
            <!--<tr>              
              <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Tanggal </td>
                <td class=hurufcol>~;style_module::input_calendar('tgl1',$in{tgl1},3);print qq~
                <input type=submit class="button button_grey" name=cari value="Cari"></td>
            </tr>    -->                   
            </table></form>
            <div id="cabang" class="table-scroll tb_800" style='width:490px; height:70%;font-size:10px'>&nbsp;  
    </div>
         </td>
         <td width=500 align=right valign=top>~;
         #if ($in{nostb}) {
         print qq~   
         <form method=post onsubmit="return warning('Proses')"> 
         <input name="pages" type="hidden" value=acct_jur_kop>
         <input name="tgl1" type="hidden" value="$in{tgl1}">
         <input name="post" type="hidden" value="post">
         <input name="ss" type="hidden" value="$in{ss}">
         <input name="resto" id="resto" type="hidden" value="$s3s[5]">    
         <input name="lok_prg" type="hidden" value="$in{lok_prg}">
         <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
         <div id="cabang3" class="table-scroll tb_800" style='width:500px; height:70%;font-size:10px'>&nbsp;</div>
         </form>~;          
         #} 
         print qq~
         </td>
      </tr>
      
  </table>

 <script type="text/javascript"> 
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised' style='width:500px'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += "<th align='center' width=100%>Tanggal</th>";

      txt += "</tr>";
      txt += "</thead>";     
      txt += "<tbody>";
      
      for (x in data) {
           txt += "<tr class=huruf2 >";
           txt +="<td align=left>&nbsp<a href=# onClick=subtable1('"+data[x].tgljur+"','') style='cursor: pointer; cursor: hand;'>"+data[x].tgljur+"</a><td>";
           txt +="</tr>";
           txt +="<input name=noreff"+x+" type=hidden value="+data[x].tgljur+">";
      }
      txt +="</tbody></table>";        
      document.getElementById("cabang").innerHTML = txt;               
   }
   
   function tab_views1(datas) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised' style='width:500px'>";
      txt += "<thead>";
      
      txt += "<tr>";
      txt += "<th align='center' colspan='4'>"+datas[0].tglacc+"</th>";
      txt += "</tr>";
      txt += "<tr>";
      txt += "<th align='center' width=40%>Keterangan</th>";
      txt += "<th align='center' width=10%>No Coa</th>";
      txt += "<th align='center' width=25%>Debit</th>";
      txt += "<th align='center' >Kredit</th>";
      txt += "</tr>";
      txt += "</thead>";     
      txt += "<tbody>";
      
      for (x in datas) {
           txt += "<tr class=huruf2 ><td align=left>&nbsp;"+datas[x].ketacc+"</td>";
           txt += "<td align=left>&nbsp;"+datas[x].noacc+"&nbsp;</td>";
           txt += "<td align=right>&nbsp;"+datas[x].nomdeb+"&nbsp;</td>";
           txt += "<td align=right>&nbsp;"+datas[x].nomkre+"&nbsp;</td>";
           txt +="</tr>";     
      }
      txt += "<tr class=huruf2 style='background-color:grey;color:white' ><td align=left colspan=2 >Total</td>";
      txt += "<td align=right>&nbsp;"+datas[x].totdeb1+"&nbsp;</td>";
      txt += "<td align=right>&nbsp;"+datas[x].totkre1+"&nbsp;</td>";
      if (datas[x].totdeb == datas[x].totkre){
      txt += "<tr><td colspan='4' align=right><input type=submit name=appv class='button button_green' value='Post Jurnal'></td></tr>";
      } else {
      txt += "<tr class=huruf2><td colspan='4' align=center>Jurnal Tidak Seimbang</td></tr>"; 
      }
      txt +="</tbody></table>";
      
      document.getElementById("cabang3").innerHTML = txt;               
   }
 </script>  
  
    
    <p>
    <hr width="100" />~.
    
    qq~
</center>
~; 
 
}

1


