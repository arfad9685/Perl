sub at008e {

genfuncast::view_header($in{ss}, $s3s[2], 'Edit Jenis Inv');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');

if ($in{simpan})
{  $in{namajenis}=~ s/\'/\ /g;
   $in{namajenis}=~ s/\"/\ /g;
   $in{namajenis}= uc($in{namajenis});
   if ($in{kd} and $in{namajenis})
   {
        $postall = $dba1->do("
            UPDATE JENISINV SET namajenis='$in{namajenis}', klpjenis='$in{kat}',oprupdate='$in{oprupdate}'
            WHERE jenis='$in{kd}';");
        #$dba1->commit;
        $warning = "<div class='warning_ok'>Sukses Edit Menu</div><br/> ";

   }
   else { $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan benar </div><br/> "; }
}

print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=at008>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">EDIT JENIS INV</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;
$query = $dba1->prepare("select jenis, namajenis, klpjenis from  jenisinv  WHERE  jenis='$in{kd}' ");
$query->execute();
@record = $query->fetchrow_array();
if ($record[2] eq 'W') { $record[2]='Y'; }
print qq~
$warning
<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at008e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=kd value=$in{kd}>
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Kode Jenis Inventori </td>
    <td class="hurufcol" >$in{kd}
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> Kelompok Jenis </td>
    <td class="hurufcol" ><select name="kat" class="huruf1" id="kat">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT klpjenis,namaklp FROM KLPJENISINV ORDER BY klpjenis");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($record[2] eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[1] </option>~;
}
print qq~
    </select>
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Nama Jenis Inv </td>
    <td class="hurufcol" ><input type=text name=namajenis value='$record[1]' class=huruf1 maxlength="30" size=35  style="text-transform: uppercase">
    </td>
  </tr>

</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>
    <hr width="100" />
</center>~;
}


1

