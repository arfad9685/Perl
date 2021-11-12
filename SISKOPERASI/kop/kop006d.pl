sub kop006d {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Hapus Akses User', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss},'S');

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     <form method=post action="/cgi-bin/siskop.cgi" >
      <input name="btn" type="submit" value="Back" class=huruf1>
      <input name="pages" type="hidden" value=kop006>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol"> HAPUS AKSES USER</h2> </td>
     <td align=left width=150>
      &nbsp;</td>
     </tr>
     </table>
~;

if ($in{go})
{
$dbk->do ("delete from  X0000004 where namausr='$in{usr}';");
print qq~
<div class=warning_ok>Sukses Hapus Akses User '$in{usr}'</div>~;
}

print qq~<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop006d>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;User </td>
    <td class="hurufcol" ><select name="usr" class="huruf1" id="usr">
    <option value=''>-</option>~;
$query = $dbp->prepare("SELECT namausr from X0000003A   ORDER BY namausr ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{usr} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[0]  </option>~;
}
print qq~
    </select>
    </td>
   <td><input type='submit' name='go' value='Hapus'> </td>
  </tr>
</table>
</form>    ~;


print qq ~
    <hr width="100" />
</center>
~;
}

;
1

