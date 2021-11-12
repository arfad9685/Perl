sub kop005e {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Edit Menu', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');

if ($in{simpan})
{  $in{nmmenu}=~ s/\'/\ /g;
   $in{nmmenu}=~ s/\"/\ /g;
   if ($in{kd} and $in{nmmenu})
   {    if ($in{visib} eq 'Y') { $in{visib}='W'; }
        else { $in{visib}=''; }
        
        $postall = $dbk->do("
            UPDATE X0000002 SET XID='$in{kat}', namaprog='$in{nmmenu}', ex_in='$in{visib}', updated=current_timestamp
            WHERE namaexe='$in{kd}';");
        $postall = $dbk->do("
            UPDATE X0000005 SET ketchild='$in{nmmenu}' WHERE parent='$in{kd}' and child='$in{kd}';");
        #$dbk->commit;
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
      <input type="submit" name="back" value="Master Menu" class="huruf1"/>
      <input name="pages" type="hidden" value=kop005>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">EDIT MENU</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;
$query = $dbk->prepare("select xid,  namaprog, ex_in from  X0000002  WHERE  namaexe='$in{kd}' ");
$query->execute();
@record = $query->fetchrow_array();
if ($record[2] eq 'W') { $record[2]='Y'; }
print qq~
$warning
<form action="/cgi-bin/siskop.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop005e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=kd value=$in{kd}>
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Nama Program </td>
    <td class="hurufcol" >$in{kd}
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> Kategori Menu </td>
    <td class="hurufcol" ><select name="kat" class="huruf1" id="kat">
    <option value=''>-</option>~;
$query = $dbk->prepare("SELECT recid, namamenu FROM  X0000001  ORDER BY urutan ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($record[0] eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[1] </option>~;
}
print qq~
    </select>
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Nama Menu </td>
    <td class="hurufcol" ><input type=text name=nmmenu value='$record[1]' class=huruf1 maxlength="20">
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Visibility </td>
    </td>
    <td class="hurufcol">    ~;
for ($i=0; $i<@yn; $i++)
{ $checked="";
  if ($record[2] eq  $yn[$i]) { $checked="checked";}
  print qq~<input type=radio name=visib value='$yn[$i]' class=huruf1 $checked> $yn[$i] &nbsp; &nbsp; &nbsp; ~;
}
print qq~
    </td>
  </tr>
</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>
    <hr width="100" />
</center>~;
}


1

