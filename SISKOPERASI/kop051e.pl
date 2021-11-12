subkop051e {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Edit Barang', $s3s[17]);
#genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;

if ($in{simpan})
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
	 
	 
 #print qq~ UPDATE M_PRODUK_KOP SET harga='$in{nominal}',oprupdate='$s3s[0]'
 #          WHERE recid='$in{kd}';~; 
			
   if ($in{kd})
   {

		$postall = $dbk->do("UPDATE M_PRODUK_KOP SET harga='$in{nominal}',oprupdate='$s3s[0]'
            WHERE recid='$in{kd}';");
        
        $warning = "<div class='warning_ok'>Sukses Edit Master</div><br/> ";

   }
   else { $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan benar </div><br/> "; }
}


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
    <td align=center> <h2 class="hurufcol"></h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;

#print ("select brg_id,brg_nama,harga,recid from m_produk_kop where isaktif='Y' and recid='$in{kd}' order by 2 asc  ");

$query = $dbk->prepare("select brg_id,brg_nama,harga,recid from m_produk_kop
where isaktif='Y' and recid='$in{kd}' order by 2 asc ");
$query->execute();
@record = $query->fetchrow_array();

if ($record[0] eq 'W') { $record[0]='Y'; }

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>


$warning
<form action="/cgi-bin/siskop.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop051e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=kd value=$in{kd}>  
  <table width='500px' border='0' cellspacing='1' cellpadding='1'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Nama Barang </td>
    <td class="hurufcol" >$record[0] - $record[1]  </td>
  </tr>
  
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Harga </td>
    <td class="hurufcol" ><input type=text name=nominal value='$record[2]' class=huruf1 maxlength="30" size=35  style="text-transform: uppercase">
    </td>
  </tr>

</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>
    <hr width="100" />
</center>~;
}


1

