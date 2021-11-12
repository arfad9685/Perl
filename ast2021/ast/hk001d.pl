sub hk001d {

genfuncast::view_header($in{ss}, $s3s[2], 'Hapus Akses User');
genfuncast::validasi_akses($s3s[11], $in{ss});

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input name="btn" type="submit" value="Back" class=huruf1>
      <input name="pages" type="hidden" value=hk001>
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
#hapus dari sisasset :   X0000003 namausr, X0000004 namausr, update status = 0 di X0000003A
#hapus dari sishrd :   X0000003 namausr, X0000003A
$dba1->do ("delete from  X0000003 where namausr='$in{usr}';");
$dba1->do ("delete from  X0000004 where namausr='$in{usr}';");
$dba1->do ("update X0000003 set status='0' where namausr='$in{usr}';");

#print qq~
#delete from  X0000003 where namausr='$in{usr}';    <br/>
#delete from  X0000004 where namausr='$in{usr}';          <br/>
#update X0000003A set status='0' where namausr='$in{usr}';<br/>  <br/>

#delete from  X0000003 where namausr='$in{usr}'; <br/>
#delete from  X0000003A where namausr='$in{usr}'; <br/>
#~;
print qq~
<div class=warning_ok>Sukses Hapus User '$in{usr}'</div>~;
}

print qq~<form action="/cgi-bin/sisasset.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=hk001d>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;User </td>
    <td class="hurufcol" ><select name="usr" class="huruf1" id="usr">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT namausr from X0000003 WHERE STATUS='1'  ORDER BY namausr ");
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

