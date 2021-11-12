sub mkt_comp_sal {
 &get_access;  #$rws = R=Read, W=Write, S=Supervisory
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/functions/select_module.pl";
  
style_module::use_calendar();
if (!$in{tgl1}) {
   $in{tgl1}=$tt;$in{tgl2}=$tt;
   $in{tgl3}=$tt;$in{tgl4}=$tt;   
}

 $strv="ss=$in{ss}&tgl1=$in{tgl1}&tgl2=$in{tgl2}&tgl3=$in{tgl3}&tgl4=$in{tgl4}";
 xml_module::view_table("ho/tb_mkt_comp1","$strv",1); #(script_view.pl, params, table cnt)
 $str="ss=$in{ss}&sup=";
 
  print qq~
  <form method=GET>
  <input name="pages" type="hidden" value=mkt_comp_sal>
  <input name="ss" type="hidden" value="$in{ss}">
  <input name="lok_prg" type="hidden" value="$in{lok_prg}">
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
   
  <table width=800>
    <tr><td width=100%>
            <table width=100%>           
              <tr>
                <td height=30 width=100% colspan=5 bgcolor=#0 class="hurufcol" align=center>SEARCH :</td> 
              </tr>
             <tr>
                <td align="right" bgcolor=$colcolor class="hurufcol">&nbsp;Tanggal :</td>
                <td class=hurufcol width=40>~;
                style_module::input_calendar('tgl1',$in{tgl1},1);print qq~</td><td class="hurufcol"> s.d ~;style_module::input_calendar('tgl2',$in{tgl2},2);  
                print qq~</td><td>&nbsp</td>                
              </tr>
              <tr>
                <td align="right" bgcolor=$colcolor class="hurufcol">&nbsp;Compare to :</td>
                <td class=hurufcol width=40>~;
                style_module::input_calendar('tgl3',$in{tgl3},3);print qq~</td><td class="hurufcol"> s.d ~;style_module::input_calendar('tgl4',$in{tgl4},4);  
                print qq~</td><td align=right><input type=submit class="button button_grey" name=cari value="Cari"></td>                
              </tr>                            
            </table>
     </td></tr>
  </table>
 </form>
 
   <script type="text/javascript">
   function tab_view1(data) {
      var x, txt=" ";
      txt += "<table id='main-table' class='main-table mobile-optimised'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += "<th rowspan=2 align='center'>Kode</th>";
      txt += "<th rowspan=2 align='center'>Nama Store</th>";
      txt += "<th colspan=8 align='center'>Amount</th>";
      txt += "<th colspan=8 align='center'>TC</th>";
      txt += "</tr><tr>";
      txt += "<th align='center'>Sales All</th>";
      txt += "<th align='center'>WI</th>";
      txt += "<th align='center'>DL</th>";
      txt += "<th align='center'>TK</th>";
      txt += "<th align='center'>DT</th>";
      txt += "<th align='center'>FDS</th>";      
      txt += "<th align='center'>BM</th>";
      txt += "<th align='center'>%</th>";            
      txt += "<th align='center'>All TC</th>";      
      txt += "<th align='center'>WI</th>";
      txt += "<th align='center'>DL</th>";
      txt += "<th align='center'>TK</th>";
      txt += "<th align='center'>DT</th>";
      txt += "<th align='center'>FDS</th>";      
      txt += "<th align='center'>BM</th>";
      txt += "<th align='center'>%</th>";                  
      txt += "</tr>";
      txt += "</thead>";
      txt += "<tbody>";
      var y=0;totalall=0;totalold=0; tcall=0;tcold=0;
      for (x in data) {
          totalall = totalall + data[x].salall;
          totalold = totalold + data[x].sallold;
          tcall = tcall + data[x].tcall;
          tcold = tcold + data[x].tcold;
          
          if (data[x].sallold>0) {
             var bm1=(data[x].salall*100/data[x].sallold).toFixed(2);
          } else  { var bm1=1}
          if (data[x].tcold>0) {
             var bm2=(data[x].tcall*100/data[x].tcold).toFixed(2);
          } else  { var bm2=1}
          
          txt +="<tr>";
          txt +="<td align=left class=huruf2>&nbsp;"+data[x].kode+"</td>";           
          txt +="<td align=left class=huruf2>&nbsp;"+data[x].nama+"</td>";
     		   txt +="<td align=right class=huruf2>"+data[x].salall.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2>"+data[x].sal_wi.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2>"+data[x].sal_dl.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2>"+data[x].sal_tk.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2>"+data[x].sal_dt.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2>"+data[x].sal_fds.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2 style='background-color:yellow'>"+data[x].sallold.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2 style='background-color:aqua'>"+bm1+"&nbsp;</td>";          
     		   txt +="<td align=right class=huruf2>"+data[x].tcall.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2>"+data[x].tc_wi.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2>"+data[x].tc_dl.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2>"+data[x].tc_tk.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2>"+data[x].tc_dt.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2>"+data[x].tc_fds.toLocaleString('en')+"&nbsp;</td>";
     		   txt +="<td align=right class=huruf2 style='background-color:yellow'>"+data[x].tcold.toLocaleString('en')+"&nbsp;</td>";          
     		   txt +="<td align=right class=huruf2 style='background-color:aqua'>"+bm2+"&nbsp;</td>";                    
          txt +="</tr>";
     }
      var bmsal=(totalall*100/totalold).toFixed(2);
      var bmtc=(tcall*100/tcold).toFixed(2);            
      txt +="</tbody><tfoot><tr>";
      txt += "<td colspan=2>&nbsp</td>";
      txt += "<td>"+totalall.toLocaleString('en')+"</td>";
      txt += "<td colspan=5>&nbsp;</td>";
      txt += "<td>"+totalold.toLocaleString('en')+"</td>";
      txt += "<td>"+bmsal+"</td>";            
      txt += "<td>"+tcall.toLocaleString('en')+"</td>";      
      txt += "<td colspan=5>&nbsp;</td>";
      txt += "<td>"+tcold.toLocaleString('en')+"</td>";
      txt += "<td>"+bmtc+"</td>";                  
      txt += "</tr>";
      txt += "</tfoot>";          
     txt +="</table>";
     document.getElementById("tb-lokasi").innerHTML = txt;               
   }  
  </script>
  
  <div id="tb-lokasi" class="table-scroll tb_1000" style='width:1100px;font-size:10px'>&nbsp;  
  </div>
   <p>
    <hr width="100" />
 </center>
~;   
 
}

1


