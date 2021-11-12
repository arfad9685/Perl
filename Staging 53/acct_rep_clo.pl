sub acct_rep_clo {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/control/c_acct_rep_clo.pl"; 
 
 style_module::use_warning();
 style_module::use_calendar();
 
 #xml_module::view_nsubtable("ho/tb_acct_jur_pes2","ss=$in{ss}","nostb",1);
 if ($in{konfirm}) {
    $in{konfirm} ='';

    $errormsg = confirm_closing($in{cab},$in{tgl1},$in{tgl2}) ; 	
 }
 
 if ($in{tgl1} ) {

   xml_module::view_table("ho/tb_acct_rep_clo","ss=$in{ss}&tgl1=$in{tgl1}&cab=$in{cab}&tgl2=$in{tgl2}",1); #(script_view.pl, params, table cnt)
   #xml_module::view_table("ho/tb_acc_pos2","ss=$in{ss}&tgl1=$in{tgl1}",2); #(script_view.pl, params, table cnt)
 }
 
 if (!$in{tgl1}) {
    $in{tgl1}=$tt;    
 }
 
 if (!$in{tgl2}) {
    $in{tgl2}=$tt;    
 }
 
 

  print qq~
  <font color=yellow>$errormsg</font>
  <table width=1000>
    <tr>
    <td width=1000 align=left>
            <table width=100%>           
             <form method=GET>
             <input name="pages" type="hidden" value=acct_rep_clo>
             <input name="ss" type="hidden" value="$in{ss}">
             <input name="lok_prg" type="hidden" value="$in{lok_prg}">
             <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
             <tr>
               <td height=30 width=100% colspan=2 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
             </tr>             
            <tr>
                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Lokasi</td>
                <td class=hurufcol><select name="cab" class="huruf1" id="cab">
                <option value=''>--- ALL ---</option>
                ~;
                $where="isaktif='Y' and store_bagian in ('STORE','PUSAT')";
                drop_down_1($dbh,'m_cab','store_nama','store_id',$where,'store_nama',$in{cab});
                print qq~                                       
                </select></td>
            </tr>
            <tr>              
              <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Tanggal </td>
                <td class=hurufcol>~;style_module::input_calendar('tgl1',$in{tgl1},3);print qq~</td>
            </tr>
            <tr>
                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;To </td>
                <td class=hurufcol>~;style_module::input_calendar2('tgl2',$in{tgl2},4);print qq~
                <input type=submit class="button button_grey" name=cari value="Cari"></td>
            </tr>                       
            </table></form>
            <form method=post onsubmit="return warning('Confirm?')"> 
         <input name="pages" type="hidden" value=acct_rep_clo>
         <input name="tgl1" type="hidden" value="$in{tgl1}">
         <input name="tgl2" type="hidden" value="$in{tgl2}">
         <input name="cab" type="hidden" value="$in{cab}">
         <input name="ss" type="hidden" value="$in{ss}">
             <input name="lok_prg" type="hidden" value="$in{lok_prg}">
             <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
         <input name="konfirm" type="hidden" value="konfirm">
            <div id="cabang" class="table-scroll tb_800" style='width:1000px; height:70%;font-size:10px'>&nbsp;</div>
            </form>
         </td>
        
      </tr>
      
  </table>

 <script type="text/javascript"> 
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised' style='width:1000px'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += "<th align='center' width=5%>Store</th>";
      txt += "<th align='center' width=10%>Tanggal</th>";
      txt += "<th align='center' width=10%>Saldo Awal</th>";
      txt += "<th align='center' width=10%>Saldo AKhir</th>";
      txt += "<th align='center' width=5%>ID Kasir</th>";
      txt += "<th align='center' width=30%>Nama Kasir</th>";
      txt += "<th align='center' width=10%>Closing</th>";
      txt += "<th align='center' width=10%>Sales</th>";
      txt += "<th align='center' width=10%>Deviasi</th>";
      txt += "<th align='center' width=10%>Confirm</th>";
      txt += "</tr>";
      txt += "</thead>";     
      txt += "<tbody>";
      
      for (x in data) {
           txt += "<tr class=huruf2 >";
           txt += "<td align=left>&nbsp;"+data[x].store+"</td>";
           txt += "<td align=left>&nbsp;"+data[x].tgl+"</td><td align=right>"+data[x].sawal+"</td>";
           txt += "<td align=right>"+data[x].sahir+"</td>";
           txt += "<td align=left>&nbsp;"+data[x].kasir+"</td>";
           txt += "<td align=left>&nbsp;"+data[x].namakasir+"</td>";
           txt += "<td align=right>"+data[x].closing+"</td>";
           txt += "<td align=right>"+data[x].sales+"</td>";
           txt += "<td align=right>"+data[x].dev+"</td>";
           txt += "<td align=center>"+data[x].konfirm+"</td>";
           txt += "</tr>";
      }
      txt += "<tr><td colspan='10' align=right><input type=submit name=conf class='button button_green' value='Confirm'></td></tr>";
      txt +="</tbody></table>";        
      document.getElementById("cabang").innerHTML = txt;               
   }
   
   
 </script>  
     
    <p>
    <hr width="100" />~.
    
    qq~
</center>
~; 
 
}

1


