sub at005a {

genfuncast::view_header($in{ss}, $s3s[2], 'Tambah Merek');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@yn = ('Y','N');
if (!$in{visib}) { $in{visib}='Y'; }

if ($in{simpan})
{  $in{merek}=~ s/\'/\ /g;
   $in{merek}=~ s/\"/\ /g;
   $in{namamerek}=~ s/\'/\ /g;
   $in{namamerek}=~ s/\"/\ /g;
   $in{namamerek}= uc($in{namamerek});
   if ($in{merek} and $in{namamerek})
   {
        
        $query = $dba1->prepare("select merek, namamerek from merek where merek='$in{merek}' OR namamerek='$in{namamerek}' ");
        $query->execute();
        @row = $query->fetchrow_array();
        if ($row[0]) { $warning = "<div class='warning_not_ok'>Merek '$in{merek}' / Nama Merek '$in{namamerek}' sudah ada</div><br/> "; }
        else
        {  $q1 = $dba1->do("
            INSERT INTO MEREK (MEREK, NAMAMEREK, OPRCREATE) VALUES
            ('$in{merek}', '$in{namamerek}', '$s3s[0]');");
           #$dba1->commit;
           if($q1!=0)
           { $warning = "<div class='warning_ok'>Sukses Add Merek</div><br/> ";}
           else { $warning = "<div class='warning_not_ok'>Gagal Add Merek</div><br/> ";}

           $in{merek}='';
           $in{namamerek}='';

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
      <input type="submit" name="back" value="Back" class="huruf1"/>
      <input name="pages" type="hidden" value=at005>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">TAMBAH MEREK</h2> </td>
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
  <input type=hidden name=pages value=at005a>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <table width='400px' border='0' cellspacing='1' cellpadding='1'>
    <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> Kode Merek </td>
    <td class="hurufcol" ><input type=text name=merek value='$in{merek}' maxlength="6" size=10>
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> Nama Merek </td>
    <td class="hurufcol" ><input type=text name=namamerek value='$in{namamerek}' class=huruf1 maxlength="20" size=25 style="text-transform: uppercase">
    </td>
  </tr>
     ~;


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

