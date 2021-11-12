sub str_isp_01d {
         
 use Date::Calc qw(Add_Delta_Days);
 
 style_module::use_warning();
 style_module::use_calendar();
 require "/opt/sarirasa/cgi-bin/assets/functions/xml_module.pl";
 require "/opt/sarirasa/cgi-bin/assets/control/tab_isp.pl";  
 require "/opt/sarirasa/cgi-bin/assets/functions/style_module.pl";
 &con_inv0; 
 
if (!$s3s[7] && $in{save}) {
     for ($a=0;$a<=$in{baris};$a++) {
         $in{idisp}=$in{"idisp$a"};
         $in{hasil}=$in{"hasil$a"};
         $in{hasil} =~ s/,//g;
         $errormsg = update_stat_isp ($in{idisp},'Y',$in{hasil}) ;                                    
     }     
}
 
# <---- Section Process  Start Here

$str="ss=$in{ss}&cab=$s3s[4]&resto=$s3s[5]&nospk=$in{noisp}";
  xml_module::view_table("store/tb_prepstr2",$str,1);
   
#---- Section Process End Here---> 
  
 #<---- Section Pages Start Here
 @tglNow=split(/\//,$tt);
 ($y0, $m0, $d0) = Add_Delta_Days($tglNow[2],$tglNow[0],$tglNow[1],1);
 ($y1, $m1, $d1) = Add_Delta_Days($tglNow[2],$tglNow[0],$tglNow[1],2);
  $besok=$m0.'/'.$d0.'/'.$y0;
  $lusa=$m1.'/'.$d1.'/'.$y1;
  
print qq~

<script type='text/javascript' src='/js/jquery-ui.js'></script>
<link rel="stylesheet" href="/css/jquery-ui.css">
<script type="text/javascript">
  function chkmax (i)
  {
     var target = document.getElementById("target"+i).value;
     var hasil = document.getElementById("hasil"+i).value;
     if (hasil>target*1.5)
     {
       max = target*1.5;
       document.getElementById("hasil"+i).value=max;       
       alert('Max :'+max);       
     }
  }
        
   function tab_view1(data) {
      var txt=" ";
      var x=0;y=0;need=0;      
      txt += "<table id='main-table' class='main-table mobile-optimised'>";
      txt += "<thead>";
      txt += "<tr>";
      txt += "<th align=center class='hurufcol' width=50>Kode</th>";
      txt += "<th align=center class='hurufcol'> Produk</th>";
      txt += "<th align=center class='hurufcol'> Handling</th>";
      txt += "<th align=center class='hurufcol' width=50>Unit</th>";
      txt += "<th align=center class='hurufcol' width=40>HT</th>";
      txt += "<th align=center class='hurufcol' width=50>Target</th>";
      txt += "<th align=center class='hurufcol' width=50>Make</th>";        
      txt += "<th align=center class='hurufcol' width=50>Batch</th>";              
      txt += "<th align=center class='hurufcol' width=50>Add</th>";
      txt += "<th align=center class='hurufcol' width=50>Hasil</th>";              
      txt += "</tr>";
      txt += "</thead>";
      txt += "<tbody>";
      var head1='';
      var head2='';
      for (x in data) {
          if (head1+head2 != data[x].dapur+data[x].area) {
            if (head1 != data[x].dapur) {
               txt += "<tr class=hurufcol><td align=center colspan=10 bgcolor=#808080>"+data[x].dapur+"</td></tr>";
            }
            if (head2 != data[x].area) {
               txt += "<tr class=huruf2><td align=center colspan=10 bgcolor=yellow>"+data[x].area+"</td></tr>";
            }            
            head1 = data[x].dapur;
            head2 = data[x].area;           
          }
          txt +="<input id=target"+x+" name=target"+x+" type=hidden value="+data[x].target+">";
          txt +="<input name=idisp"+x+" type=hidden value="+data[x].recid+">";                    
          txt += "<tr class=huruf2><td align=center>"+data[x].brgid+"</td>";
          txt += "<td align=left>&nbsp;"+data[x].brgnama+"</td><td>&nbsp"+data[x].addwork+"</td><td align=left>&nbsp;"+data[x].satstk+"</td>";
          txt += "<td align=right>"+data[x].ht+"&nbsp;</td><td align=right>"+data[x].target+"&nbsp;</td>";
          txt += "<td align=right>"+data[x].make.toFixed(2)+"&nbsp;</td><td align=right>"+data[x].batch+"&nbsp;</td>";
          txt += "<td align=right>"+data[x].target+"&nbsp;</td>";
          txt += "<td align=right><input style='width:100%' name=hasil"+x+" size=3 class='input-qty' maxlength=5 id=hasil"+x+" value="+data[x].target+" onchange='chkmax("+x+")'></td>";          
          txt += "</tr>";
     }
     txt +="<input name=baris type='hidden' value="+x+">";     
     txt +="<tr><td colspan=10 width=100% align=left><input type=submit name=save class='button button_green' value=Save></td></tr>";
     txt +="</tbody>";
     txt +="</table>";        
     document.getElementById("list-isp").innerHTML = txt;               
   }      
 </script>  

<p><br>
   <table width=800 border="0" cellspacing="1" cellpadding="1">
   <tr height="30" bgcolor=#0>
     <td colspan=3 align=center class="hurufcol"><strong>Hasil In Store Production : $in{noisp}</strong></td>
   </tr>
     <tr height=25>
      <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;Tanggal</td>
      <td align="left" class="huruf1">:</td>
      <td align="left" class="huruf1">&nbsp;$tt</td>
     </tr>
   </table>~;
   if (!$errormsg) {
    print qq~
    <form method=post action="/cgi-bin/colorbox.cgi" onsubmit="return warning('Proses')">   
    <input name="pages" type="hidden" value=str_isp_01d>
    <input name="ss" type="hidden" value="$in{ss}">
    <input name="resto" id="resto" type="hidden" value="$s3s[5]">    
    <input name="lok_prg" type="hidden" value="$in{lok_prg}">
    <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
    <input name="noisp" type="hidden" value='$in{noisp}'>    
    <div id="list-isp" class="table-scroll tb_800" style='height:80%;background-color:#808080;'>&nbsp;</div></form>~;
   } else {
    print qq~ $errormsg ~;
   }  
 
style_module::use_numeral();     
  
}

1


