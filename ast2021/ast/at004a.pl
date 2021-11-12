sub at004a {

genfuncast::view_header($in{ss}, $s3s[2], 'Add Menu');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');
if (!$in{visib}) { $in{visib}='Y'; }

if ($in{simpan})
{  $in{nmprog}=~ s/\'/\ /g;
   $in{nmprog}=~ s/\"/\ /g;
   $in{nmmenu}=~ s/\'/\ /g;
   $in{nmmenu}=~ s/\"/\ /g;
   if ($in{nmprog} and $in{nmmenu} and $in{visib} and $in{kat}>=0)
   {    if ($in{visib} eq 'Y') { $in{visib}='W'; }
        else { $in{visib}=''; }
        
        $query = $dba1->prepare("select namaexe, namaprog from X0000002 where namaexe='$in{nmprog}' OR namaprog='$in{nmmenu}' ");
        $query->execute();
        @row = $query->fetchrow_array();
        if ($row[0]) { $warning = "<div class='warning_not_ok'>Nama Program '$in{nmprog}' / Nama Menu '$in{nmmenu}' sudah ada</div><br/> "; }
        else
        {  $q1 = $dba1->do("
            INSERT INTO X0000002 (NAMAEXE, XID, NAMAPROG, EX_IN,   UPDATED, LASTPRG) VALUES
            ('$in{nmprog}', '$in{kat}', '$in{nmmenu}', '$in{visib}',
            current_timestamp, '$s3s[0]');");

           if ($s3s[0] ne 'XTIN')
           {
             $q2 = $dba1->do("
            INSERT INTO X0000004 (NAMAUSR, EXEID, XID, HREAD, HWRITE, EX_IN, BC, OPRCREATE) VALUES
            ('$s3s[0]', '$in{nmprog}', $in{kat}, '', 'S', 'W', NULL, '$s3s[0]'); ");
           }
           $q3 = $dba1->do("
            INSERT INTO X0000004 (NAMAUSR, EXEID, XID, HREAD, HWRITE, EX_IN, BC,  OPRCREATE) VALUES
            ('XTIN', '$in{nmprog}', $in{kat}, '', 'S', 'W', NULL, '$s3s[0]'); ");
           $q4 = $dba1->do("
            INSERT INTO X0000005 (PARENT, CHILD, KETCHILD, oprcreate) VALUES ('$in{nmprog}', '$in{nmprog}', '$in{nmmenu}','$s3s[0]'); ");
           #$dba1->commit;
           if($q1!=0 and $q3!=0 and $q4!=0)
           { $warning = "<div class='warning_ok'>Sukses Add Menu</div><br/> ";}
           else { $warning = "<div class='warning_not_ok'>Gagal Add Menu</div><br/> ";}

           $in{nmprog}='';
           $in{nmmenu}='';
           $in{kat}='';
           $in{visib}='';
        }
   }
   else { $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan benar </div><br/> "; }
}

print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Master Menu" class="huruf1"/>
      <input name="pages" type="hidden" value=at004>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">ADD MENU</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;
print qq~
$warning
<script type="text/javascript" src="/keyboard.js" charset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="/keyboard.css">
<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at004a>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> Kategori Menu </td>
    <td class="hurufcol" ><select name="kat" class="huruf1" id="kat">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT recid, namamenu FROM  X0000001  ORDER BY urutan ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{kat} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[1] </option>~;
}
print qq~
    </select>
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Nama Menu </td>
    <td class="hurufcol" ><input type=text name=nmmenu value='$in{nmmenu}' class= keyboardInput maxlength="20">
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Nama Program </td>
    <td class="hurufcol" ><input type=text name=nmprog value='$in{nmprog}' class=huruf1 maxlength="12">
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Visibility </td>
    </td>
    <td class="hurufcol">    ~;
for ($i=0; $i<@yn; $i++)
{ $checked="";
  if ($in{visib} eq  $yn[$i]) { $checked="checked";}
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

