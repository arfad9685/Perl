sub kop050e {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Edit Beli', $s3s[17]);
#genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;

if ($in{simpan})
{  

if  ($in{currkry})
   {
   @kry=split(/\-/,$in{currkry});
   $nik = $kry[0];
   $query = $dbk->prepare("select nik, kodecabang from getkry where nik='$nik'");
       $query->execute();
       @row = $query->fetchrow_array();
       $idlama=$row[0];
       $in{cabang}=$row[1];
     }
     else { $idlama="0"; }
	 
	 
 print qq~ UPDATE t_trans_h SET TGL_ORDER='$in{dtbeli}', TGL_TERIMA='$in{dtbeli2}',NOMINAL='$in{nominal}',oprupdate='$s3s[0]'
           WHERE recid='$in{kd}';~; 
			
   if ($in{kd})
   {

		$postall = $dbk->do("UPDATE t_trans_h SET TGL_ORDER='$in{dtbeli}', TGL_TERIMA='$in{dtbeli2}',NOMINAL='$in{nominal}',oprupdate='$s3s[0]'
            WHERE recid='$in{kd}';");
        
        $warning = "<div class='warning_ok'>Sukses Edit Menu</div><br/> ";

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
      <input name="pages" type="hidden" value=kop050>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">Edit Beli</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;

#print ("select h.nik,g.nlengkap,h.kodestore,g.namastore,h.nominal,h.tgl_order,h.tgl_terima,h.recid
#from t_trans_h h
 #left join getkry g on g.nik=h.nik
 #left join anggota a on a.idlama=g.idlama
 #where h.recid='$in{kd}'  order by g.nlengkap desc ");
$query = $dbk->prepare("select h.nik,g.nlengkap,h.kodestore,g.namastore,h.nominal,h.tgl_order,h.tgl_terima,h.recid
 from t_trans_h h
 left join getkry g on g.nik=h.nik
 left join anggota a on a.idlama=g.idlama
 where h.recid='$in{kd}' order by g.nlengkap desc ");
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
  <input type=hidden name=pages value=kop050e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=kd value=$in{kd}>  
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Karyawan </td>
    <td class="hurufcol" >$record[0] - $record[1]  </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> Tanggal Order </td>
    <td class="hurufcol" >
     <input name="dtbeli" type="text" id="dtbeli" size="12" maxlength="12" class="huruf1" value="$record[5]" />
        <img src="/jscalendar/img.gif" id="trigger1" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtbeli",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger1"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>
</td>
</tr>

<tr bgcolor=$colcolor height=20>
<td class="hurufcol"> Tanggal Terima </td>
<td class="hurufcol" bgcolor=$colcolor2> 
<input name="dtbeli2" type="text" id="dtbeli2" size="12" maxlength="12" class="huruf1" value="$record[6]" />
        <img src="/jscalendar/img.gif" id="trigger2" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtbeli2",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger2"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>
</td>
</tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Nominal </td>
    <td class="hurufcol" ><input type=text name=nominal value='$record[4]' class=huruf1 maxlength="30" size=35  style="text-transform: uppercase">
    </td>
  </tr>

</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>
    <hr width="100" />
</center>~;
}


1

