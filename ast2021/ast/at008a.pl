sub at008a {

genfuncast::view_header($in{ss}, $s3s[2], 'Tambah Jenis Inv');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');
if (!$in{visib}) { $in{visib}='Y'; }

if ($in{simpan})
{  $in{jenis}=~ s/\'/\ /g;
   $in{jenis}=~ s/\"/\ /g;
   $in{jenis}=~ s/\-/\_/g;
   $in{namajenis}=~ s/\'/\ /g;
   $in{namajenis}=~ s/\"/\ /g;
   $in{namajenis}= uc($in{namajenis});
   $in{jenis} = uc $in{jenis};

   if (!$in{jenis} or !$in{namajenis})
   { { $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan benar </div><br/> "; }
   }
   else
   {
#        print("select jenis, namajenis from jenisinv where jenis='$in{jenis}' OR namajenis='$in{namajenis}' ");
        
        $query = $dba1->prepare("select jenis, namajenis from jenisinv where jenis='$in{jenis}' OR namajenis='$in{namajenis}' ");
        $query->execute();
        @row = $query->fetchrow_array();
        
#       print(" INSERT INTO JENISINV (JENIS, NAMAJENIS, OPRCREATE,KLPJENIS) VALUES
#            ('$in{jenis}', '$in{namajenis}', '$s3s[0]', '$in{kat}');");
        $len = length($in{kat});
        if($len==2){ $in{jenis}=$in{kat}."_".$in{jenis}; }
        else { $in{jenis}=$in{kat}.$in{jenis}; }
        
        if ($row[0]) { $warning = "<div class='warning_not_ok'>Jenis Inv '$in{jenis}' / Nama Jenis '$in{namajenis}' sudah ada</div><br/> "; }
        else
        {  $q1 = $dba1->do("
            INSERT INTO JENISINV (JENIS, NAMAJENIS, OPRCREATE,KLPJENIS) VALUES
            ('$in{jenis}', '$in{namajenis}', '$s3s[0]', '$in{kat}');");
           $q2 = $dba1->do("
            INSERT INTO STOK (JENISINV, STOKAWAL, OPRCREATE) VALUES
            ('$in{jenis}', '0', '$s3s[0]');");

           #$dba1->commit;
           if($q1!=0 and $q2!=0)
           { $warning = "<div class='warning_ok'>Sukses Add Jenis Inv</div><br/> ";}
           else { $warning = "<div class='warning_not_ok'>Gagal Add Jenis Inv (1=$q1 2=$q2)</div><br/> ";}

           $in{jenis}='';
           $in{namajenis}='';
           $in{klpjenis}='';

        }
   }
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
     <td align=center> <h2 class="hurufcol">TAMBAH JENIS INV</h2> </td>
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
  <input type=hidden name=pages value=at008a>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> Kelompok Jenis </td>
    <td class="hurufcol" ><select name="kat" class="huruf1" id="kat">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT klpjenis,namaklp FROM KLPJENISINV ORDER BY klpjenis");
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
    <td class="hurufcol" width=150>Kode Jenis Inventori </td>
    <td class="hurufcol" ><input type=text name=jenis value='$in{jenis}' maxlength="3" size=5> <i>*Max 3 Karakter </i>
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Nama Jenis Inventori </td>
    <td class="hurufcol" ><input type=text name=namajenis value='$in{namajenis}' class=huruf1 maxlength="30" size=35 style="text-transform: uppercase">
    </td>
  </tr>

</table>
 <input type=submit value='Simpan' name="simpan" class="huruf1">
</form>
    <hr width="100" />
</center>~;
}


1

