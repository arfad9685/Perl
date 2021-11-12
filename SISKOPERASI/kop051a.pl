sub kop051a {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Tambah Master', $s3s[17]);
#genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;




if ($in{action} eq 'add')

{  
   if ($in{namabar}  )
   {
	  
	   $query = $dbk->prepare("select brg_id, brg_nama from getproduk where brg_id='$in{namabar}' ");
        $query->execute();
        @row = $query->fetchrow_array(); 
	   $kodebar=$row[0];
	   $in{namabar}=$row[1];
	  }
     else { $kodebar="0"; }
 
	 
#print "insert into m_produk_kop (brg_id, brg_nama,harga,isaktif, oprcreate) values
#            ('$kodebar','$in{namabar}','$in{nominal}','Y','$s3s[0]' );<br/> ";
 
        $flag = $dbk->do("
        INSERT INTO M_PRODUK_KOP (BRG_ID,BRG_NAMA,HARGA,ISAKTIF,OPRCREATE ) VALUES
            ('$kodebar','$in{namabar}','$in{nominal}','Y','$s3s[0]' );");

		 if($flag!=0)
           { $warning = "<div class='warning_ok'>Sukses Add Master</div><br/> ";}
           else { $warning = "<div class='warning_not_ok'>Gagal Add Master (1=$flag)</div><br/> ";}

                  
}


print qq~
<script type="text/javascript">
function toSubmit()
{  var result = confirm("Yakin Simpan Master?");
        if (result==true) {
         with(document.add)
          { action.value='add';
            submit();
          }
         }
}
</script>
~;


print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/siskop.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=kop051>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">Tambah Master Barang</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;


print qq~
$warning
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<form action="/cgi-bin/siskop.cgi" method="get" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value='kop051a'>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input name="action" type="hidden" value=''>
  
  <table width='580px' border='0' cellspacing='2' cellpadding='2'>~;
print qq~    
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> Nama Barang </td>
    <td class="hurufcol" ><select name="namabar" class="huruf1" id="namabar">
    <option value=''>-</option>~;
$query = $dbk->prepare("select brg_id,brg_nama,brg_jenis from getproduk where brg_jenis in ('RM','WIP') and isaktif ='Y' order by brg_nama");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{namabar} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected>$rec[1] </option>~;
}
print qq~
    </select>
    </td>
  </tr>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150>&nbsp;Harga</td>
    <td class="hurufcol" bgcolor=$colcolor><input type=text name=nominal value='$in{nominal}' class= keyboardInput maxlength="15">
    </td>
  </tr>

</table>

 <input type=button value='Simpan' name="simpan" class="huruf1" onClick="toSubmit();">
</form>
    <hr width="100" />
</center>~;
}

1
